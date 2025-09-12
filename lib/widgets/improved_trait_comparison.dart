import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';
import '../models/biblical_character.dart';
import 'glass_card.dart';

/// Improved trait comparison table with structured layout
class ImprovedTraitComparison extends StatelessWidget {
  final BiblicalCharacter selectedCharacter;
  final BiblicalCharacter matchedCharacter;
  final bool isTabletLandscape;
  
  const ImprovedTraitComparison({
    super.key,
    required this.selectedCharacter,
    required this.matchedCharacter,
    required this.isTabletLandscape,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Find common and unique traits
    final commonTraits = selectedCharacter.traits
        .where((trait) => matchedCharacter.traits.contains(trait))
        .toList();
    
    final selectedUniqueTraits = selectedCharacter.traits
        .where((trait) => !matchedCharacter.traits.contains(trait))
        .toList();
    
    final matchedUniqueTraits = matchedCharacter.traits
        .where((trait) => !selectedCharacter.traits.contains(trait))
        .toList();
    
    return GlassCard(
      width: isTabletLandscape ? screenWidth * 0.7 : screenWidth * 0.9,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(isTabletLandscape ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassLight,
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.star_outline,
                        color: AppColors.textSecondary,
                        size: isTabletLandscape ? 28 : 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedCharacter.name,
                        style: AppTypography.withGlassEffect(
                          AppTypography.getResponsive(
                            AppTypography.h3,
                            isTabletLandscape,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '닮고 싶은 인물',
                        style: AppTypography.withGlassEffect(
                          AppTypography.caption,
                        ).copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // VS Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'VS',
                    style: AppTypography.withGlassEffect(
                      AppTypography.h3,
                    ),
                  ),
                ),
                
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.textSecondary,
                        size: isTabletLandscape ? 28 : 24,
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
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '매칭 결과',
                        style: AppTypography.withGlassEffect(
                          AppTypography.caption,
                        ).copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: EdgeInsets.all(isTabletLandscape ? 24 : 20),
            child: Column(
              children: [
                // Common Traits Section
                if (commonTraits.isNotEmpty) ...[
                  _buildSectionHeader(
                    '공통 특성',
                    Icons.handshake_outlined,
                    AppColors.commonTraits,
                    isTabletLandscape,
                  ),
                  const SizedBox(height: 16),
                  _buildTraitGrid(
                    commonTraits,
                    AppColors.commonTraits,
                    isTabletLandscape,
                    centered: true,
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Unique Traits Comparison
                _buildSectionHeader(
                  '고유 특성',
                  Icons.person_outline,
                  AppColors.glassMedium,
                  isTabletLandscape,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TintedGlassCard(
                        tintColor: const Color(0xFF3B82F6),
                        padding: EdgeInsets.all(isTabletLandscape ? 16 : 12),
                        child: Column(
                          children: [
                            Text(
                              selectedCharacter.name,
                              style: AppTypography.withGlassEffect(
                                AppTypography.bodySmall,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTraitList(
                              selectedUniqueTraits,
                              AppColors.selectedCharacter,
                              isTabletLandscape,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TintedGlassCard(
                        tintColor: const Color(0xFF9333EA),
                        padding: EdgeInsets.all(isTabletLandscape ? 16 : 12),
                        child: Column(
                          children: [
                            Text(
                              matchedCharacter.name,
                              style: AppTypography.withGlassEffect(
                                AppTypography.bodySmall,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTraitList(
                              matchedUniqueTraits,
                              AppColors.matchedCharacter,
                              isTabletLandscape,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(
    String title,
    IconData icon,
    Color tintColor,
    bool isTabletLandscape,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tintColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: isTabletLandscape ? 20 : 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTypography.withGlassEffect(
            AppTypography.getResponsive(
              AppTypography.h3,
              isTabletLandscape,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTraitGrid(
    List<String> traits,
    Color backgroundColor,
    bool isTabletLandscape, {
    bool centered = false,
  }) {
    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 8,
      runSpacing: 8,
      children: traits.map((trait) => _buildTraitChip(
        trait,
        backgroundColor,
        isTabletLandscape,
      )).toList(),
    );
  }
  
  Widget _buildTraitList(
    List<String> traits,
    Color backgroundColor,
    bool isTabletLandscape,
  ) {
    return Column(
      children: traits.map((trait) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: _buildTraitChip(
          trait,
          backgroundColor,
          isTabletLandscape,
          fullWidth: true,
        ),
      )).toList(),
    );
  }
  
  Widget _buildTraitChip(
    String trait,
    Color backgroundColor,
    bool isTabletLandscape, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        horizontal: isTabletLandscape ? 16 : 14,
        vertical: isTabletLandscape ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Text(
        trait,
        style: AppTypography.withGlassEffect(
          AppTypography.getResponsive(
            AppTypography.caption,
            isTabletLandscape,
          ),
        ),
        textAlign: fullWidth ? TextAlign.center : TextAlign.start,
      ),
    );
  }
}