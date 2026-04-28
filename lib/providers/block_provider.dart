import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 차단된 사용자 ID 목록을 관리하는 노티파이어
class BlockListNotifier extends StateNotifier<List<String>> {
  BlockListNotifier() : super([]) {
    _load();
  }

  static const _key = 'blocked_users';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(_key) ?? [];
  }

  Future<void> blockUser(String userId) async {
    if (state.contains(userId)) return;
    
    final newState = [...state, userId];
    state = newState;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, newState);
  }

  bool isBlocked(String userId) => state.contains(userId);
}

final blockListProvider = StateNotifierProvider<BlockListNotifier, List<String>>((ref) {
  return BlockListNotifier();
});
