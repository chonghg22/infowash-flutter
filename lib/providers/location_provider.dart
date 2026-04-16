import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../core/constants/app_constants.dart';

// ── LocationNotifier (AsyncNotifier) ─────────────────────────────────────────
class LocationNotifier extends AsyncNotifier<Position?> {
  bool _isDeniedForever = false;

  /// 위치 권한이 영구 거부 상태인지 여부
  bool get isDeniedForever => _isDeniedForever;

  @override
  Future<Position?> build() => _fetch();

  Future<Position?> _fetch() async {
    _isDeniedForever = false;

    // 위치 서비스 활성화 확인
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // 권한 확인 및 요청
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const PermissionDeniedException('위치 권한이 거부되었습니다.');
    }
    if (permission == LocationPermission.deniedForever) {
      _isDeniedForever = true;
      throw const PermissionDeniedException(
        '위치 권한이 영구적으로 거부되었습니다. 설정에서 직접 허용해주세요.',
      );
    }

    // 마지막으로 알려진 위치가 있으면 즉시 반환 후 백그라운드에서 고정밀 업데이트
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).then((position) {
        state = AsyncData(position);
      }).catchError((_) {});
      return lastKnown;
    }

    // 처음 실행: 저정밀로 빠르게 가져오기
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 10),
    );
  }

  /// 위치 새로고침
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// 앱 설정 화면 열기 (권한 영구 거부 시)
  Future<void> openSettings() => Geolocator.openAppSettings();
}

final locationNotifierProvider =
    AsyncNotifierProvider<LocationNotifier, Position?>(
  () => LocationNotifier(),
);

// ── 위치 스트림 (실시간 추적) ──────────────────────────────────────────────────
final locationStreamProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    ),
  );
});

// ── 기본 좌표 (위치 권한 없을 때 fallback) ────────────────────────────────────
final mapCenterProvider = Provider<({double lat, double lng})>((ref) {
  return (
    lat: AppConstants.defaultLatitude,
    lng: AppConstants.defaultLongitude,
  );
});
