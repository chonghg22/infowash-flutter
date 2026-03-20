import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../core/constants/app_constants.dart';

// ── 현재 위치 ──────────────────────────────────────────────────────────────────
final currentPositionProvider = FutureProvider<Position?>((ref) async {
  final permission = await _checkAndRequestPermission();
  if (!permission) return null;

  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  } catch (_) {
    return null;
  }
});

// ── 위치 스트림 (실시간 추적) ──────────────────────────────────────────────────
final locationStreamProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50, // 50m 이동 시 갱신
    ),
  );
});

// ── 기본 좌표 (위치 권한 없을 때) ─────────────────────────────────────────────
final mapCenterProvider = Provider<({double lat, double lng})>((ref) {
  return (
    lat: AppConstants.defaultLatitude,
    lng: AppConstants.defaultLongitude,
  );
});

// ── Helper ────────────────────────────────────────────────────────────────────
Future<bool> _checkAndRequestPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  if (permission == LocationPermission.deniedForever) return false;

  return true;
}
