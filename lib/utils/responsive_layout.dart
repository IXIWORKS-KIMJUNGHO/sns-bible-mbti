import 'package:flutter/material.dart';

/// 디바이스 타입 정의
enum DeviceType {
  mobilePortrait,   // 모바일 세로 (< 600px, portrait)
  mobileLandscape,  // 모바일 가로 (< 600px, landscape)
  tabletPortrait,   // 태블릿 세로 (600-1500px, portrait)
  tabletLandscape,  // 태블릿 가로 (> 1500px, landscape)
}

/// 반응형 레이아웃 유틸리티
class ResponsiveLayout {
  /// 현재 디바이스 타입 감지
  static DeviceType getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isPortrait = size.height > size.width;

    // 태블릿 가로 (기존 로직)
    if (width > 1500 && !isPortrait) {
      return DeviceType.tabletLandscape;
    }

    // 태블릿 세로
    if (width >= 600 && isPortrait) {
      return DeviceType.tabletPortrait;
    }

    // 모바일 세로
    if (width < 600 && isPortrait) {
      return DeviceType.mobilePortrait;
    }

    // 모바일 가로
    return DeviceType.mobileLandscape;
  }

  /// 디바이스 타입별 패딩 값
  static EdgeInsets getPadding(DeviceType type, {String section = 'default'}) {
    switch (type) {
      case DeviceType.tabletLandscape:
        return section == 'screen'
            ? const EdgeInsets.symmetric(horizontal: 40, vertical: 20)
            : const EdgeInsets.all(32);

      case DeviceType.tabletPortrait:
        return section == 'screen'
            ? const EdgeInsets.symmetric(horizontal: 30, vertical: 16)
            : const EdgeInsets.all(24);

      case DeviceType.mobilePortrait:
        return section == 'screen'
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
            : const EdgeInsets.all(16);

      case DeviceType.mobileLandscape:
        return section == 'screen'
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 10)
            : const EdgeInsets.all(20);
    }
  }

  /// 디바이스 타입별 폰트 크기 배율
  static double getFontScale(DeviceType type) {
    switch (type) {
      case DeviceType.tabletLandscape:
        return 1.2;
      case DeviceType.tabletPortrait:
        return 1.0;
      case DeviceType.mobilePortrait:
        return 0.85;
      case DeviceType.mobileLandscape:
        return 0.9;
    }
  }

  /// 디바이스 타입별 간격 값
  static double getSpacing(DeviceType type, {String size = 'medium'}) {
    final baseSpacing = {
      'small': 8.0,
      'medium': 16.0,
      'large': 24.0,
      'xlarge': 32.0,
    };

    final scale = switch (type) {
      DeviceType.tabletLandscape => 1.5,
      DeviceType.tabletPortrait => 1.2,
      DeviceType.mobilePortrait => 0.8,
      DeviceType.mobileLandscape => 1.0,
    };

    return (baseSpacing[size] ?? 16.0) * scale;
  }

  /// CircularLiquidGlassWidget 크기 계산
  static double getCircularWidgetSize(DeviceType type, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    switch (type) {
      case DeviceType.tabletLandscape:
        return 800;

      case DeviceType.tabletPortrait:
        return screenSize.width * 0.85;

      case DeviceType.mobilePortrait:
        // 화면 너비의 90%, 최대 400
        return (screenSize.width * 0.9).clamp(300, 400);

      case DeviceType.mobileLandscape:
        // 화면 높이의 80%
        return (screenSize.height * 0.8).clamp(300, 500);
    }
  }

  /// CircularLiquidGlassWidget radius 계산
  static double getCircularWidgetRadius(DeviceType type, BuildContext context) {
    return getCircularWidgetSize(type, context) / 2;
  }

  /// 버튼 높이
  static double getButtonHeight(DeviceType type) {
    switch (type) {
      case DeviceType.tabletLandscape:
        return 80;
      case DeviceType.tabletPortrait:
        return 70;
      case DeviceType.mobilePortrait:
        return 60;
      case DeviceType.mobileLandscape:
        return 56;
    }
  }

  /// 특정 타입인지 확인하는 편의 메서드들
  static bool isMobile(DeviceType type) {
    return type == DeviceType.mobilePortrait ||
           type == DeviceType.mobileLandscape;
  }

  static bool isTablet(DeviceType type) {
    return type == DeviceType.tabletPortrait ||
           type == DeviceType.tabletLandscape;
  }

  static bool isPortrait(DeviceType type) {
    return type == DeviceType.mobilePortrait ||
           type == DeviceType.tabletPortrait;
  }

  static bool isLandscape(DeviceType type) {
    return type == DeviceType.mobileLandscape ||
           type == DeviceType.tabletLandscape;
  }
}

/// BuildContext 확장으로 쉽게 사용할 수 있게
extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => ResponsiveLayout.getDeviceType(this);
  bool get isMobile => ResponsiveLayout.isMobile(deviceType);
  bool get isTablet => ResponsiveLayout.isTablet(deviceType);
  bool get isPortrait => ResponsiveLayout.isPortrait(deviceType);
  bool get isLandscape => ResponsiveLayout.isLandscape(deviceType);

  // 기존 코드와의 호환성을 위해
  bool get isTabletLandscape => deviceType == DeviceType.tabletLandscape;
}
