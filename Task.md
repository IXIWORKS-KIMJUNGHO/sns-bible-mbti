# 모바일 세로형 레이아웃 재디자인 태스크

## 프로젝트 개요
현재 앱은 iPad 13인치 가로 모드(1500px 이상, aspectRatio > 1.2)에 최적화되어 있습니다.
모바일 디바이스 세로형 레이아웃을 위한 재디자인이 필요합니다.

## 현재 상태 분석

### 화면 목록
1. `onboarding_screen.dart` - 이름 입력 화면
2. `character_selection_screen.dart` - 캐릭터 선택 화면
3. `questionnaire_screen.dart` - 질문지 화면
4. `result_screen.dart` - 결과 화면
5. `assessment_screen.dart` - 평가 화면 (미확인)

### 현재 레이아웃 감지 로직
```dart
final isTabletLandscape = screenSize.width > 1500 && screenSize.aspectRatio > 1.2;
```

## 재디자인 태스크

### 1. 레이아웃 감지 시스템 개선

#### 1.1 반응형 레이아웃 유틸리티 생성
- [ ] `lib/utils/responsive_layout.dart` 파일 생성
- [ ] 다양한 디바이스 타입 정의:
  - 모바일 세로 (< 600px width, portrait)
  - 모바일 가로 (< 600px width, landscape)
  - 태블릿 세로 (600-1500px, portrait)
  - 태블릿 가로 (> 1500px, landscape)
- [ ] 각 디바이스 타입별 스타일 값 정의 (패딩, 마진, 폰트 크기 등)

#### 1.2 전역 반응형 상수 정의
- [ ] `lib/constants/responsive_constants.dart` 생성
- [ ] 브레이크포인트 정의
- [ ] 각 디바이스 타입별 기본 간격, 크기 상수 정의

### 2. 화면별 세로형 레이아웃 재디자인

#### 2.1 Onboarding Screen (onboarding_screen.dart)
- [ ] 코드 변경 작업
  - [ ] 현재 상태 확인 (이미 비교적 반응형임)
  - [ ] CircularLiquidGlassWidget 크기 조정
    - 모바일 세로: 화면 너비의 85-90%
  - [ ] 패딩 및 간격 최적화
  - [ ] 폰트 크기 재조정
    - 제목: 24-28px (모바일)
    - 설명: 14-16px (모바일)
- [ ] 세로형 모드 테스트
  - [ ] iPhone SE (375 x 667) 시뮬레이터 테스트
  - [ ] iPhone 14 Pro (393 x 852) 시뮬레이터 테스트
  - [ ] 텍스트 가독성 확인
  - [ ] 터치 영역 확인
  - [ ] CircularLiquidGlassWidget 크기 적절성 확인
- [ ] 발견된 문제 수정 및 재테스트
- [ ] 완료 확인 후 다음 화면으로 이동

#### 2.2 Character Selection Screen (character_selection_screen.dart)
- [ ] 코드 변경 작업
  - [ ] 헤더 레이아웃 조정
    - 타이틀 폰트 크기: 18-20px (모바일)
    - 백 버튼 크기 조정
  - [ ] CharacterCarousel 위젯 세로형 최적화
    - 캐러셀 아이템 크기 조정
    - 간격 축소
  - [ ] Continue 버튼 위치 및 크기 조정
    - 하단 고정
    - 너비: 화면의 80%
- [ ] 세로형 모드 테스트
  - [ ] iPhone SE 시뮬레이터 테스트
  - [ ] iPhone 14 Pro 시뮬레이터 테스트
  - [ ] 캐러셀 스와이프 동작 확인
  - [ ] 캐릭터 카드 크기 적절성 확인
  - [ ] Continue 버튼 접근성 확인
- [ ] 발견된 문제 수정 및 재테스트
- [ ] 완료 확인 후 다음 화면으로 이동

#### 2.3 Questionnaire Screen (questionnaire_screen.dart)
- [ ] 코드 변경 작업
  - [ ] 진행바 및 상단 헤더 조정
    - 패딩 축소
    - 폰트 크기: 12-14px
  - [ ] CircularLiquidGlassWidget 크기 조정
    - 모바일: 화면 높이의 60-65%로 조정
    - customRadius: 200-250
  - [ ] 질문 텍스트 크기 조정
    - 모바일: 16-18px
  - [ ] 답변 버튼 최적화
    - 높이: 60px (모바일)
    - 패딩 축소
    - 폰트 크기: 14px
    - 버튼 간 간격 축소: 4px
- [ ] 세로형 모드 테스트
  - [ ] iPhone SE 시뮬레이터 테스트
  - [ ] iPhone 14 Pro 시뮬레이터 테스트
  - [ ] 질문 텍스트 가독성 확인
  - [ ] 5개 답변 버튼이 화면에 모두 표시되는지 확인
  - [ ] 버튼 애니메이션 확인
  - [ ] 진행바 시인성 확인
- [ ] 발견된 문제 수정 및 재테스트
- [ ] 완료 확인 후 다음 화면으로 이동

#### 2.4 Result Screen (result_screen.dart)
- [ ] 코드 변경 작업
  - [ ] 상단 헤더 텍스트 크기 조정
    - 모바일: 20-22px
  - [ ] 비교 섹션 레이아웃 변경
    - 가로 배치 → 세로 스택 배치 고려
    - 캐릭터 카드 크기 축소: 180-200px
    - VS 인디케이터 크기 축소: 50px
  - [ ] GlassCard 너비 조정
    - 모바일: 95% width
    - 패딩 축소: 16-20px
  - [ ] 스크롤 가능 영역 최적화
  - [ ] 액션 버튼 레이아웃
    - 세로 스택 배치로 변경 가능성 검토
    - 버튼 크기 및 패딩 조정
- [ ] 세로형 모드 테스트
  - [ ] iPhone SE 시뮬레이터 테스트
  - [ ] iPhone 14 Pro 시뮬레이터 테스트
  - [ ] 스크롤 동작 확인
  - [ ] 비교 카드들이 적절하게 배치되는지 확인
  - [ ] 모든 콘텐츠가 스크롤로 접근 가능한지 확인
  - [ ] 액션 버튼 접근성 확인
- [ ] 발견된 문제 수정 및 재테스트
- [ ] 완료 확인 후 다음 화면으로 이동

### 3. 공통 위젯 최적화

#### 3.1 CircularLiquidGlassWidget
- [ ] `lib/widgets/circular_liquid_glass_widget.dart` 확인
- [ ] 모바일 세로형에 맞는 크기 파라미터 추가
- [ ] 블러 효과 성능 최적화

#### 3.2 VideoBackground
- [ ] `lib/widgets/video_background.dart` 확인
- [ ] 모바일에서 비디오 성능 최적화
- [ ] 필요 시 이미지 백그라운드 대체 옵션

#### 3.3 HomeButton
- [ ] 크기 및 위치 조정
- [ ] 모바일에서 터치 영역 확보

### 4. 테마 및 스타일 시스템

#### 4.1 AppTypography 확장
- [ ] `lib/theme/app_typography.dart` 확인
- [ ] 모바일 세로형 폰트 크기 추가
- [ ] 반응형 getResponsive 메서드 개선

#### 4.2 AppColors 검토
- [ ] `lib/theme/app_colors.dart` 확인
- [ ] 필요 시 색상 조정

### 5. 전체 통합 테스트 및 검증

#### 5.1 추가 디바이스 크기 테스트
- [ ] iPhone 14 Pro Max (430 x 932)
- [ ] Android 중형 (360 x 800)
- [ ] 태블릿 세로 모드 (iPad 9.7" 등)

#### 5.2 전체 사용자 플로우 테스트
- [ ] Onboarding → Character Selection → Questionnaire → Result 전체 플로우
- [ ] 모든 화면 전환 애니메이션 확인
- [ ] 데이터 유지 확인

#### 5.3 성능 테스트
- [ ] 세로 모드에서 비디오 재생 성능
- [ ] 애니메이션 프레임 드롭 확인
- [ ] 메모리 사용량 확인
- [ ] 저사양 디바이스 테스트

#### 5.4 가로/세로 회전 테스트
- [ ] 화면 회전 시 레이아웃 전환 확인
- [ ] 데이터 손실 없는지 확인

### 6. 문서화

#### 6.1 디자인 가이드라인 작성
- [ ] 각 디바이스 타입별 레이아웃 스펙 문서화
- [ ] 스크린샷 추가

#### 6.2 개발자 가이드
- [ ] 반응형 레이아웃 사용 방법 문서화
- [ ] 새로운 화면 추가 시 가이드라인

## 우선순위

### High Priority
1. 레이아웃 감지 시스템 개선 (1.1, 1.2)
2. Questionnaire Screen 재디자인 (2.3)
3. Result Screen 재디자인 (2.4)

### Medium Priority
4. Character Selection Screen 재디자인 (2.2)
5. 공통 위젯 최적화 (3.1, 3.2, 3.3)

### Low Priority
6. Onboarding Screen 미세 조정 (2.1)
7. 테마 시스템 확장 (4.1, 4.2)
8. 문서화 (6.1, 6.2)

## 예상 소요 시간
- 레이아웃 시스템 구축: 2-3시간
- 화면별 재디자인: 4-6시간
- 공통 위젯 최적화: 2-3시간
- 테스트 및 디버깅: 2-3시간
- **총 예상 시간: 10-15시간**

## 참고 사항
- 기존 가로형 레이아웃은 유지하면서 세로형 추가
- 애니메이션 및 인터랙션은 최대한 유지
- 성능을 우선시하여 모바일에서도 부드러운 경험 제공
