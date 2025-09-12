import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';
import '../models/biblical_character.dart';
import 'glass_card.dart';

/// Side-by-side cards for strengths and growth areas
class StrengthsGrowthCards extends StatelessWidget {
  final BiblicalCharacter matchedCharacter;
  final bool isTabletLandscape;
  
  const StrengthsGrowthCards({
    super.key,
    required this.matchedCharacter,
    required this.isTabletLandscape,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hasStrengths = matchedCharacter.strengths != null && 
                        matchedCharacter.strengths!.isNotEmpty;
    final hasGrowthAreas = matchedCharacter.growthAreas != null && 
                          matchedCharacter.growthAreas!.isNotEmpty;
    
    if (!hasStrengths && !hasGrowthAreas) {
      return const SizedBox.shrink();
    }
    
    return SizedBox(
      width: isTabletLandscape ? screenWidth * 0.7 : screenWidth * 0.9,
      child: Column(
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              '나의 강점과 성장 가능 영역',
              style: AppTypography.withGlassEffect(
                AppTypography.getResponsive(
                  AppTypography.h2,
                  isTabletLandscape,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Cards Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Strengths Card
              if (hasStrengths)
                Expanded(
                  child: _buildCard(
                    title: '당신의 강점',
                    icon: Icons.star_outline,
                    items: matchedCharacter.strengths!,
                    tintColor: const Color(0xFFF59E0B),
                    isTabletLandscape: isTabletLandscape,
                  ),
                ),
              
              if (hasStrengths && hasGrowthAreas)
                const SizedBox(width: 16),
              
              // Growth Areas Card
              if (hasGrowthAreas)
                Expanded(
                  child: _buildCard(
                    title: '성장 가능 영역',
                    icon: Icons.trending_up,
                    items: matchedCharacter.growthAreas!,
                    tintColor: const Color(0xFF0EA5E9),
                    isTabletLandscape: isTabletLandscape,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color tintColor,
    required bool isTabletLandscape,
  }) {
    return TintedGlassCard(
      tintColor: tintColor,
      padding: EdgeInsets.all(isTabletLandscape ? 24 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tintColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.textPrimary,
                  size: isTabletLandscape ? 24 : 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.withGlassEffect(
                    AppTypography.getResponsive(
                      AppTypography.h3,
                      isTabletLandscape,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Items List
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? 12 : 0,
              ),
              child: _buildListItem(
                item,
                tintColor,
                isTabletLandscape,
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildListItem(
    String text,
    Color accentColor,
    bool isTabletLandscape,
  ) {
    return Container(
      padding: EdgeInsets.all(isTabletLandscape ? 14 : 12),
      decoration: BoxDecoration(
        color: AppColors.glassLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.withGlassEffect(
                AppTypography.getResponsive(
                  AppTypography.bodySmall,
                  isTabletLandscape,
                ),
              ).copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}