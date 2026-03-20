import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';

/// ShellRoute용 하단 내비게이션 쉘
///
/// 탭 추가 시 AppConstants.bottomNavTabs 배열만 수정하면 됩니다.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _tabRoutes = [
    AppRoutes.home,
    AppRoutes.list,
    AppRoutes.favorite,
    // TODO v2.0: AppRoutes.market,
  ];

  static const _tabIcons = [
    Icons.map_outlined,
    Icons.list_alt_outlined,
    Icons.favorite_border,
    // TODO v2.0: Icons.store_outlined,
  ];

  static const _tabActiveIcons = [
    Icons.map,
    Icons.list_alt,
    Icons.favorite,
    // TODO v2.0: Icons.store,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final tabs = AppConstants.bottomNavTabs;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            context.go(_tabRoutes[index]);
          }
        },
        items: List.generate(tabs.length, (i) {
          return BottomNavigationBarItem(
            icon: Icon(_tabIcons[i]),
            activeIcon: Icon(_tabActiveIcons[i]),
            label: tabs[i].label,
          );
        }),
      ),
    );
  }
}

// AppRoutes 참조용 (circular import 방지를 위해 여기서 재정의)
class AppRoutes {
  static const home = '/home';
  static const list = '/list';
  static const favorite = '/favorite';
  // TODO v2.0: static const market = '/market';
}
