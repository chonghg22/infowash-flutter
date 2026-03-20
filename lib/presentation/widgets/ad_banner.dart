import 'package:flutter/material.dart';

/// AdMob 배너 광고 위젯 (현재 비활성화)
///
/// TODO: AdMob 활성화 시 아래 순서로 작업
///   1. pubspec.yaml의 google_mobile_ads 주석 해제 후 flutter pub get
///   2. AndroidManifest.xml의 AdMob APPLICATION_ID meta-data 주석 해제
///   3. main.dart의 MobileAds.instance.initialize() 주석 해제
///   4. 이 파일을 원래 구현으로 교체:
///
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdBanner extends StatefulWidget {
//   const AdBanner({super.key});
//   @override
//   State<AdBanner> createState() => _AdBannerState();
// }
//
// class _AdBannerState extends State<AdBanner> {
//   BannerAd? _bannerAd;
//   bool _isLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     BannerAd(
//       adUnitId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) => setState(() {
//           _bannerAd = ad as BannerAd;
//           _isLoaded = true;
//         }),
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           debugPrint('AdBanner failed: $error');
//         },
//       ),
//     ).load();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
//     return SizedBox(
//       width: _bannerAd!.size.width.toDouble(),
//       height: _bannerAd!.size.height.toDouble(),
//       child: AdWidget(ad: _bannerAd!),
//     );
//   }
// }

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
