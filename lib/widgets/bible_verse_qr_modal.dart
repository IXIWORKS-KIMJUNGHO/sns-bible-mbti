import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/biblical_character.dart';
import 'glass_card.dart';

class BibleVerseQRModal extends StatelessWidget {
  final BiblicalCharacter matchedCharacter;
  final String userName;
  
  const BibleVerseQRModal({
    super.key,
    required this.matchedCharacter,
    required this.userName,
  });
  
  String _generateShareUrl() {
    // Firebase에 호스팅된 말씀카드 페이지 URL 생성
    final baseUrl = 'https://sns-rejoice-alliin-project.web.app/verse-card';
    final characterId = matchedCharacter.id;
    final encodedName = Uri.encodeComponent(userName);
    final encodedVerse = Uri.encodeComponent(matchedCharacter.bibleVerse);
    
    return '$baseUrl?character=$characterId&name=$encodedName&verse=$encodedVerse';
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletLandscape = screenSize.width > 1500 && screenSize.aspectRatio > 1.2;
    final shareUrl = _generateShareUrl();
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isTabletLandscape ? 500 : 400,
          maxHeight: isTabletLandscape ? 700 : 600,
        ),
        child: GlassCard(
          padding: EdgeInsets.all(isTabletLandscape ? 32 : 24),
          backgroundColor: AppColors.glassMedium,
          borderRadius: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '말씀카드 받기',
                    style: AppTypography.withGlassEffect(
                      AppTypography.getResponsive(
                        AppTypography.h2,
                        isTabletLandscape,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              
              SizedBox(height: isTabletLandscape ? 24 : 20),
              
              // 설명 텍스트
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
                child: Column(
                  children: [
                    Icon(
                      Icons.phone_iphone,
                      color: AppColors.textPrimary,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'QR 코드를 스캔하여',
                      style: AppTypography.withGlassEffect(
                        AppTypography.body,
                      ),
                    ),
                    Text(
                      '말씀카드를 모바일로 받아보세요',
                      style: AppTypography.withGlassEffect(
                        AppTypography.body,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: isTabletLandscape ? 32 : 24),
              
              // QR 코드
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: shareUrl,
                  version: QrVersions.auto,
                  size: isTabletLandscape ? 250 : 200,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  embeddedImage: null, // 나중에 로고 추가 가능
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                ),
              ),
              
              SizedBox(height: isTabletLandscape ? 24 : 20),
              
              // 매칭된 인물 정보
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.glassLight,
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$userName님의 성경 인물',
                      style: AppTypography.withGlassEffect(
                        AppTypography.caption,
                      ).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      matchedCharacter.name,
                      style: AppTypography.withGlassEffect(
                        AppTypography.getResponsive(
                          AppTypography.h3,
                          isTabletLandscape,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${matchedCharacter.bibleVerse}"',
                      style: AppTypography.withGlassEffect(
                        AppTypography.caption,
                      ).copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}