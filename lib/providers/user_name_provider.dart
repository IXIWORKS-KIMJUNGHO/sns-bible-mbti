import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 사용자 이름 상태 관리
final userNameProvider = StateProvider<String>((ref) => '');

/// 이름 입력 유효성 검사
final isNameValidProvider = Provider<bool>((ref) {
  final name = ref.watch(userNameProvider);
  return name.trim().length >= 2; // 최소 2글자 이상
});