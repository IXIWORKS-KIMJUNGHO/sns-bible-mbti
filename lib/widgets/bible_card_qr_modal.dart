import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'glass_card.dart';
import '../providers/user_name_provider.dart';
import '../providers/character_selection_provider.dart';
import '../providers/questionnaire_provider.dart';

class BibleCardQRModal extends ConsumerStatefulWidget {
  final String downloadUrl;
  final String characterName;
  final String userName;
  
  const BibleCardQRModal({
    super.key,
    required this.downloadUrl,
    required this.characterName,
    required this.userName,
  });
  
  @override
  ConsumerState<BibleCardQRModal> createState() => _BibleCardQRModalState();
}

class _BibleCardQRModalState extends ConsumerState<BibleCardQRModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletLandscape = screenSize.width > 1500 && screenSize.aspectRatio > 1.2;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isTabletLandscape ? 500 : 400,
          maxHeight: screenSize.height * 0.95, // 화면 높이의 95%로 확대
        ),
        child: GlassCard(
          padding: EdgeInsets.all(isTabletLandscape ? 32 : 24),
          backgroundColor: AppColors.glassMedium,
          borderRadius: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 타이틀 (중앙 정렬)
              Text(
                '말씀카드가 준비되었습니다!',
                style: AppTypography.withGlassEffect(
                  AppTypography.getResponsive(
                    AppTypography.h1,
                    isTabletLandscape,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // 서브타이틀 (중앙 정렬)
              Text(
                '${widget.userName}님의 ${widget.characterName} 말씀카드',
                style: AppTypography.withGlassEffect(
                  AppTypography.body,
                ).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: isTabletLandscape ? 32 : 24),
              
              // 간단한 설명 텍스트
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.glassLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  '카메라로 QR 코드를 스캔하세요',
                  style: AppTypography.withGlassEffect(
                    AppTypography.body.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              SizedBox(height: isTabletLandscape ? 24 : 20),
              
              // QR 코드 with 애니메이션 카메라 아이콘
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: widget.downloadUrl,
                      version: QrVersions.auto,
                      size: isTabletLandscape ? 200 : 160,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                  // 애니메이션 카메라 아이콘
                  Positioned(
                    bottom: -20,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isTabletLandscape ? 45 : 35),
              
              // 처음으로 돌아가기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    
                    // 모든 상태 초기화 (홈 버튼과 동일한 로직)
                    ref.read(userNameProvider.notifier).state = '';
                    ref.read(selectedCharacterProvider.notifier).clearSelection();
                    ref.read(questionnaireProvider.notifier).reset();
                    
                    // 모달 닫고 홈으로 이동
                    Navigator.of(context).pop();
                    context.go('/');
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('처음으로 돌아가기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTabletLandscape ? 32 : 24,
                      vertical: isTabletLandscape ? 18 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: AppTypography.body.copyWith(
                      fontSize: isTabletLandscape ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to show the QR modal
void showBibleCardQRModal({
  required BuildContext context,
  required String downloadUrl,
  required String characterName,
  required String userName,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // 배경 클릭으로 닫기 방지
    builder: (context) => BibleCardQRModal(
      downloadUrl: downloadUrl,
      characterName: characterName,
      userName: userName,
    ),
  );
}