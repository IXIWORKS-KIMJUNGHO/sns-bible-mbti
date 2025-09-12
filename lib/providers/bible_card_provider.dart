import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/bible_card_service.dart';

/// BibleCardService Provider
final bibleCardServiceProvider = Provider<BibleCardService>((ref) {
  return BibleCardService();
});

/// 말씀카드 생성 상태 관리
class BibleCardState {
  final bool isLoading;
  final String? downloadUrl;
  final String? error;
  
  const BibleCardState({
    this.isLoading = false,
    this.downloadUrl,
    this.error,
  });
  
  BibleCardState copyWith({
    bool? isLoading,
    String? downloadUrl,
    String? error,
  }) {
    return BibleCardState(
      isLoading: isLoading ?? this.isLoading,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      error: error ?? this.error,
    );
  }
}

/// 말씀카드 생성 상태 Provider
final bibleCardStateProvider = StateNotifierProvider<BibleCardNotifier, BibleCardState>((ref) {
  return BibleCardNotifier(ref);
});

class BibleCardNotifier extends StateNotifier<BibleCardState> {
  final Ref ref;
  
  BibleCardNotifier(this.ref) : super(const BibleCardState());
  
  /// 말씀카드 생성 및 업로드
  Future<void> generateCard({
    required String characterId,
    required String userName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(bibleCardServiceProvider);
      
      final downloadUrl = await service.generateBibleCard(
        characterId: characterId,
        userName: userName,
      );
      
      if (downloadUrl != null) {
        state = state.copyWith(
          isLoading: false,
          downloadUrl: downloadUrl,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '말씀카드 생성에 실패했습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '오류가 발생했습니다: $e',
      );
    }
  }
  
  /// 상태 초기화
  void reset() {
    state = const BibleCardState();
  }
}