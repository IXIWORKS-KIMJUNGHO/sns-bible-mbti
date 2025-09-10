import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/biblical_character.dart';

/// 선택된 성경인물 상태 관리
class SelectedCharacterNotifier extends StateNotifier<BiblicalCharacter?> {
  SelectedCharacterNotifier() : super(null);

  /// 캐릭터 선택
  void selectCharacter(BiblicalCharacter character) {
    state = character;
  }

  /// 선택 해제
  void clearSelection() {
    state = null;
  }

  /// 선택 여부 확인
  bool isSelected(String characterId) {
    return state?.id == characterId;
  }
}

/// 선택된 캐릭터 Provider
final selectedCharacterProvider = StateNotifierProvider<SelectedCharacterNotifier, BiblicalCharacter?>(
  (ref) => SelectedCharacterNotifier(),
);

/// 캐릭터 선택 완료 여부 Provider
final isCharacterSelectedProvider = Provider<bool>((ref) {
  final selectedCharacter = ref.watch(selectedCharacterProvider);
  return selectedCharacter != null;
});