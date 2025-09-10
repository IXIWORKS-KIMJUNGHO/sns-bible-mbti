import 'package:json_annotation/json_annotation.dart';

part 'biblical_character.g.dart';

/// 성경 인물 데이터 모델 - 성경적 사건 기반
/// 
/// MBTI 라벨 제거, 순수 성경적 근거만 사용
/// 각 인물의 실제 성경 기록을 바탕으로 특성 정의
@JsonSerializable()
class BiblicalCharacter {
  /// 한글 이름
  final String name;
  
  /// 영어 이름
  final String englishName;
  
  /// 인물 설명
  final String description;
  
  /// 주요 성경적 사건들
  final List<String> mainEvents;
  
  /// 성경에서 나타난 행동 양식
  final List<String> behaviorPatterns;
  
  /// 성경적 특성들 (성경 사건 기반)
  final List<String> characteristics;
  
  /// 관련 성경 구절들
  final List<String> scriptureReferences;
  
  /// 이미지 경로
  final String imagePath;
  
  /// UI 색상 테마
  final String colorTheme;
  
  /// 핵심 성경 구절
  final String keyVerse;
  
  /// 성경 구절 참조
  final String verseReference;

  const BiblicalCharacter({
    required this.name,
    required this.englishName,
    required this.description,
    required this.mainEvents,
    required this.behaviorPatterns,
    required this.characteristics,
    required this.scriptureReferences,
    required this.imagePath,
    required this.colorTheme,
    required this.keyVerse,
    required this.verseReference,
  });

  factory BiblicalCharacter.fromJson(Map<String, dynamic> json) =>
      _$BiblicalCharacterFromJson(json);

  Map<String, dynamic> toJson() => _$BiblicalCharacterToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BiblicalCharacter && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// 16명의 성경 인물 데이터
class BiblicalCharacters {
  static final List<BiblicalCharacter> characters = [
    // 1. 노아 (Noah)
    BiblicalCharacter(
      name: '노아',
      englishName: 'Noah',
      description: '120년간 방주를 제작하며 하나님께 순종한 인내와 계획의 사람',
      mainEvents: [
        '방주 건설',
        '홍수 심판',
        '무지개 언약'
      ],
      behaviorPatterns: [
        '장기적 계획 수립',
        '하나님 말씀에 정확히 순종',
        '체계적 준비와 실행'
      ],
      characteristics: [
        '장기적 계획',
        '하나님께 순종',
        '체계적 준비',
        '인내',
        '신실함'
      ],
      scriptureReferences: [
        '창세기 6:14-16',
        '창세기 7:1-9',
        '히브리서 11:7'
      ],
      imagePath: 'assets/images/characters/noah.png',
      colorTheme: 'blue',
      keyVerse: '노아가 그와 같이 하되 하나님이 자기에게 명하신 대로 다 준행하였더라',
      verseReference: '창세기 6:22',
    ),

    // 2. 누가 (Luke)
    BiblicalCharacter(
      name: '누가',
      englishName: 'Luke',
      description: '정확한 조사와 기록으로 복음을 체계적으로 전한 의사',
      mainEvents: [
        '복음서 기록',
        '사도행전 기록',
        '바울과 동행'
      ],
      behaviorPatterns: [
        '차근차근 조사하고 기록',
        '체계적 자료 수집',
        '동역자들과 섬김'
      ],
      characteristics: [
        '정확한 기록',
        '체계적 조사',
        '의료 지식',
        '세심함',
        '충실함'
      ],
      scriptureReferences: [
        '누가복음 1:1-4',
        '사도행전 1:1',
        '골로새서 4:14'
      ],
      imagePath: 'assets/images/characters/luke.png',
      colorTheme: 'green',
      keyVerse: '모든 일을 근본부터 자세히 미루어 살핀 나도',
      verseReference: '누가복음 1:3',
    ),

    // 3. 드보라 (Deborah)
    BiblicalCharacter(
      name: '드보라',
      englishName: 'Deborah',
      description: '이스라엘을 이끈 강력한 여성 사사이자 전략적 리더',
      mainEvents: [
        '이스라엘 사사',
        '바락과 함께 가나안족 정복',
        '승리 후 찬양'
      ],
      behaviorPatterns: [
        '백성들의 분쟁 해결',
        '전투 지휘',
        '하나님께 찬양'
      ],
      characteristics: [
        '강력한 리더십',
        '결단력',
        '전략적 사고',
        '공의',
        '용기'
      ],
      scriptureReferences: [
        '사사기 4:4-5',
        '사사기 4:14',
        '사사기 5장'
      ],
      imagePath: 'assets/images/characters/deborah.png',
      colorTheme: 'purple',
      keyVerse: '일어나라 이는 여호와께서 시스라를 네 손에 붙이신 날이라',
      verseReference: '사사기 4:14',
    ),

    // 4. 라반 (Laban)
    BiblicalCharacter(
      name: '라반',
      englishName: 'Laban',
      description: '실용적이고 기회주의적인 야곱의 외삼촌',
      mainEvents: [
        '야곱을 속임',
        '레아와 라헬의 아버지',
        '야곱과의 계약'
      ],
      behaviorPatterns: [
        '이익을 위해 계약 변경',
        '상황에 따라 유연하게 대응',
        '현실적 판단'
      ],
      characteristics: [
        '실용적',
        '기회주의적',
        '상황 판단력',
        '협상력',
        '적응력'
      ],
      scriptureReferences: [
        '창세기 29:15-30',
        '창세기 31:7',
        '창세기 31:44'
      ],
      imagePath: 'assets/images/characters/laban.png',
      colorTheme: 'orange',
      keyVerse: '내가 점을 쳐서 여호와께서 너로 인하여 내게 복 주신 줄을 깨달았노니',
      verseReference: '창세기 30:27',
    ),

    // 5. 리브가 (Rebekah)
    BiblicalCharacter(
      name: '리브가',
      englishName: 'Rebekah',
      description: '즉흥적이고 결단력 있는 이삭의 아내',
      mainEvents: [
        '이삭과 결혼',
        '야곱에게 축복 받게 도움',
        '낙타에게 물을 길어줌'
      ],
      behaviorPatterns: [
        '즉석에서 결정',
        '친절하고 적극적인 행동',
        '가족을 위한 계략'
      ],
      characteristics: [
        '즉흥적 행동',
        '결단력',
        '모험심',
        '직관적 판단',
        '친절함'
      ],
      scriptureReferences: [
        '창세기 24:18-20',
        '창세기 24:58',
        '창세기 27:13-17'
      ],
      imagePath: 'assets/images/characters/rebekah.png',
      colorTheme: 'pink',
      keyVerse: '그가 가로되 내가 가겠나이다',
      verseReference: '창세기 24:58',
    ),

    // 6. 마리아 (Mary)
    BiblicalCharacter(
      name: '마리아',
      englishName: 'Mary',
      description: '하나님께 순종하며 예수님의 어머니가 된 겸손한 여인',
      mainEvents: [
        '예수 탄생',
        '십자가 곁에서 지킴',
        '천사의 소식 수용'
      ],
      behaviorPatterns: [
        '하나님의 뜻에 순종',
        '모든 일을 마음에 새김',
        '조용한 묵상'
      ],
      characteristics: [
        '순종',
        '묵상',
        '겸손',
        '인내',
        '섬김'
      ],
      scriptureReferences: [
        '누가복음 1:38',
        '누가복음 2:19',
        '요한복음 19:25'
      ],
      imagePath: 'assets/images/characters/mary.png',
      colorTheme: 'lightBlue',
      keyVerse: '주의 뜻대로 내게 이루어지이다',
      verseReference: '누가복음 1:38',
    ),

    // 7. 바나바 (Barnabas)
    BiblicalCharacter(
      name: '바나바',
      englishName: 'Barnabas',
      description: '위로의 아들로 불린 격려와 화해의 사람',
      mainEvents: [
        '바울을 사도들에게 소개',
        '선교 여행',
        '재산을 팔아 교회에 헌금'
      ],
      behaviorPatterns: [
        '사람들을 격려',
        '관대한 섬김',
        '갈등 중재'
      ],
      characteristics: [
        '격려',
        '화해',
        '관대함',
        '평화 중재',
        '포용'
      ],
      scriptureReferences: [
        '사도행전 4:36-37',
        '사도행전 9:27',
        '사도행전 15:37-39'
      ],
      imagePath: 'assets/images/characters/barnabas.png',
      colorTheme: 'amber',
      keyVerse: '착한 사람이요 성령과 믿음이 충만한 자라',
      verseReference: '사도행전 11:24',
    ),

    // 8. 바울 (Paul)
    BiblicalCharacter(
      name: '바울',
      englishName: 'Paul',
      description: '강력한 비전으로 체계적 선교를 펼친 이방인의 사도',
      mainEvents: [
        '다메섹 체험',
        '3차 선교여행',
        '로마 감옥'
      ],
      behaviorPatterns: [
        '계획적 선교 전략',
        '서신으로 체계적 가르침',
        '복음을 위한 희생'
      ],
      characteristics: [
        '강력한 비전',
        '체계적 사역',
        '리더십',
        '불굴의 의지',
        '변화'
      ],
      scriptureReferences: [
        '사도행전 9:6',
        '빌립보서 3:14',
        '디모데후서 4:7'
      ],
      imagePath: 'assets/images/characters/paul.png',
      colorTheme: 'red',
      keyVerse: '내가 선한 싸움을 싸우고 나의 달려갈 길을 마치고',
      verseReference: '디모데후서 4:7',
    ),

    // 9. 베드로 (Peter)
    BiblicalCharacter(
      name: '베드로',
      englishName: 'Peter',
      description: '충동적이지만 열정적인 수제자',
      mainEvents: [
        '물 위를 걸음',
        '닭울기 전 부인',
        '오순절 설교'
      ],
      behaviorPatterns: [
        '생각보다 행동이 먼저',
        '감정 표현이 직접적',
        '실수 후 회복'
      ],
      characteristics: [
        '충동적',
        '열정적',
        '실수와 회복',
        '솔직함',
        '용기'
      ],
      scriptureReferences: [
        '마태복음 14:29',
        '마태복음 26:35',
        '사도행전 2:14'
      ],
      imagePath: 'assets/images/characters/peter.png',
      colorTheme: 'cyan',
      keyVerse: '말씀에 의지하여 내가 그물을 내리리이다',
      verseReference: '누가복음 5:5',
    ),

    // 10. 솔로몬 (Solomon)
    BiblicalCharacter(
      name: '솔로몬',
      englishName: 'Solomon',
      description: '하나님께 지혜를 구하여 공정한 판단을 한 지혜의 왕',
      mainEvents: [
        '지혜를 구함',
        '성전 건축',
        '두 여인의 아이 재판'
      ],
      behaviorPatterns: [
        '복잡한 문제를 창의적으로 해결',
        '체계적 건축과 조직',
        '지혜로운 판단'
      ],
      characteristics: [
        '지혜 추구',
        '분석적 사고',
        '공정한 판단',
        '학문적',
        '창의성'
      ],
      scriptureReferences: [
        '열왕기상 3:9',
        '열왕기상 3:25-27',
        '잠언 1:1-6'
      ],
      imagePath: 'assets/images/characters/solomon.png',
      colorTheme: 'yellow',
      keyVerse: '지혜로운 마음을 주사 선악을 분별하게 하옵소서',
      verseReference: '열왕기상 3:9',
    ),

    // 11. 아담 (Adam)
    BiblicalCharacter(
      name: '아담',
      englishName: 'Adam',
      description: '하나님과 직접 교제하며 에덴동산을 관리한 첫 사람',
      mainEvents: [
        '에덴동산 관리',
        '선악과 사건',
        '가인과 아벨의 아버지'
      ],
      behaviorPatterns: [
        '하나님과 직접 소통',
        '자연스러운 관계',
        '단순한 순종'
      ],
      characteristics: [
        '순수함',
        '자연친화적',
        '후회와 성찰',
        '단순함',
        '솔직함'
      ],
      scriptureReferences: [
        '창세기 2:15',
        '창세기 3:8',
        '창세기 3:10-12'
      ],
      imagePath: 'assets/images/characters/adam.png',
      colorTheme: 'brown',
      keyVerse: '여호와 하나님이 그 사람을 이끌어 에덴동산에 두어 그것을 경작하며 지키게 하시고',
      verseReference: '창세기 2:15',
    ),

    // 12. 에스더 (Esther)
    BiblicalCharacter(
      name: '에스더',
      englishName: 'Esther',
      description: '전략적 사고로 민족을 구원한 용감한 왕후',
      mainEvents: [
        '유대인 구원',
        '아하수에로 왕 앞에 나아감',
        '하만 제거 계획'
      ],
      behaviorPatterns: [
        '금식 후 왕 앞에 나아감',
        '잔치를 통한 단계적 접근',
        '위기를 기회로 전환'
      ],
      characteristics: [
        '전략적 사고',
        '용기',
        '기회 포착',
        '창의적 접근',
        '희생정신'
      ],
      scriptureReferences: [
        '에스더 4:14',
        '에스더 4:16',
        '에스더 7:1-6'
      ],
      imagePath: 'assets/images/characters/esther.png',
      colorTheme: 'purple',
      keyVerse: '이 때를 위하여 네가 왕후의 위에 이르렀을지도 모르느니라',
      verseReference: '에스더 4:14',
    ),

    // 13. 예레미야 (Jeremiah)
    BiblicalCharacter(
      name: '예레미야',
      englishName: 'Jeremiah',
      description: '깊은 성찰과 눈물로 민족을 위해 기도한 선지자',
      mainEvents: [
        '유다 멸망 예언',
        '애가 기록',
        '바벨론 포로'
      ],
      behaviorPatterns: [
        '혼자서 깊이 묵상',
        '하나님의 마음을 품고 눈물로 경고',
        '고독한 사역'
      ],
      characteristics: [
        '깊은 성찰',
        '슬픔과 눈물',
        '진실한 메시지',
        '고독',
        '인내'
      ],
      scriptureReferences: [
        '예레미야 1:6',
        '예레미야 20:9',
        '애가 3:55-57'
      ],
      imagePath: 'assets/images/characters/jeremiah.png',
      colorTheme: 'indigo',
      keyVerse: '내 속에서 불이 붙는 것 같아서 골수에 사무치니',
      verseReference: '예레미야 20:9',
    ),

    // 14. 요나단 (Jonathan)
    BiblicalCharacter(
      name: '요나단',
      englishName: 'Jonathan',
      description: '다윗과의 우정으로 유명한 충성스러운 왕자',
      mainEvents: [
        '다윗과의 우정',
        '블레셋 전투',
        '사울과의 갈등'
      ],
      behaviorPatterns: [
        '다윗을 보호하며 격려',
        '사울과 다윗 사이에서 중재',
        '희생적인 우정'
      ],
      characteristics: [
        '충성심',
        '우정',
        '격려',
        '중재',
        '희생'
      ],
      scriptureReferences: [
        '사무엘상 18:4',
        '사무엘상 20:4',
        '사무엘상 23:16'
      ],
      imagePath: 'assets/images/characters/jonathan.png',
      colorTheme: 'deepOrange',
      keyVerse: '여호와께서 우리를 위하여 일하실까 하노라',
      verseReference: '사무엘상 14:6',
    ),

    // 15. 돌아온탕자 (Prodigal Son)
    BiblicalCharacter(
      name: '돌아온탕자',
      englishName: 'Prodigal Son',
      description: '자유분방했지만 아버지께로 돌아온 회개의 모범',
      mainEvents: [
        '재산 탕진',
        '돼지 치기',
        '아버지께 돌아감'
      ],
      behaviorPatterns: [
        '모험을 위해 집을 떠남',
        '실패 후 솔직하게 돌아감',
        '즉흥적이고 감정적'
      ],
      characteristics: [
        '자유분방함',
        '즉흥적',
        '체험 중시',
        '감정적',
        '변화'
      ],
      scriptureReferences: [
        '누가복음 15:13',
        '누가복음 15:17-18',
        '누가복음 15:20'
      ],
      imagePath: 'assets/images/characters/prodigal_son.png',
      colorTheme: 'lime',
      keyVerse: '아버지여 내가 하늘과 아버지께 죄를 지었사오니',
      verseReference: '누가복음 15:21',
    ),

    // 16. 다윗 (David)
    BiblicalCharacter(
      name: '다윗',
      englishName: 'David',
      description: '하나님의 마음에 합한 용기 있는 목자왕',
      mainEvents: [
        '골리앗 승리',
        '사울 피해 도망',
        '밧세바 사건과 회개',
        '시편 기록'
      ],
      behaviorPatterns: [
        '즉시 골리앗에게 맞섬',
        '감정을 시편으로 표현',
        '실수 후 진심으로 회개'
      ],
      characteristics: [
        '용기',
        '감정 표현',
        '회개',
        '목양심',
        '음악적 재능'
      ],
      scriptureReferences: [
        '사무엘상 17:45',
        '사무엘하 12:13',
        '시편 51편'
      ],
      imagePath: 'assets/images/characters/david.png',
      colorTheme: 'blue',
      keyVerse: '만군의 여호와의 이름으로 네게 가노라',
      verseReference: '사무엘상 17:45',
    ),
  ];

  /// 이름으로 캐릭터 찾기
  static BiblicalCharacter? findByName(String name) {
    try {
      return characters.firstWhere((character) => character.name == name);
    } catch (e) {
      return null;
    }
  }

  /// 영어 이름으로 캐릭터 찾기
  static BiblicalCharacter? findByEnglishName(String englishName) {
    try {
      return characters.firstWhere((character) => character.englishName == englishName);
    } catch (e) {
      return null;
    }
  }

  /// 전체 캐릭터 개수
  static int get count => characters.length;
}