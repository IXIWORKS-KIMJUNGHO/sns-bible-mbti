import 'package:json_annotation/json_annotation.dart';

part 'biblical_character.g.dart';

/// 성경인물 데이터 모델
/// 
/// 성경적 사건과 행동 패턴을 기반으로 한 성경인물 정보
@JsonSerializable()
class BiblicalCharacter {
  /// 고유 식별자
  final String id;
  
  /// 한글 이름 (예: 다윗, 에스더)
  final String name;
  
  /// 영문 이름 (예: David, Esther)
  final String englishName;
  
  /// 설명적 타이틀 (예: 하나님의 마음에 합한 자)
  final String title;
  
  /// 간단한 성격/특성 설명
  final String description;
  
  /// 주요 성경적 사건들
  final List<String> mainEvents;
  
  /// 성경에서 나타난 행동 패턴
  final List<String> behaviorPatterns;
  
  /// 캐릭터 이미지 경로
  final String imageAsset;
  
  /// 주요 성격 특성들 (성경적 근거 기반)
  final List<String> traits;
  
  /// 강점들
  final List<String>? strengths;
  
  /// 성장 가능 영역들
  final List<String>? growthAreas;
  
  /// 관련 성경 구절
  final String bibleVerse;
  
  /// 성경 구절 참조
  final String verseReference;
  
  /// 색상 테마
  final String colorTheme;

  const BiblicalCharacter({
    required this.id,
    required this.name,
    required this.englishName,
    required this.title,
    required this.description,
    required this.mainEvents,
    required this.behaviorPatterns,
    required this.imageAsset,
    required this.traits,
    this.strengths,
    this.growthAreas,
    required this.bibleVerse,
    required this.verseReference,
    required this.colorTheme,
  });

  factory BiblicalCharacter.fromJson(Map<String, dynamic> json) =>
      _$BiblicalCharacterFromJson(json);

  Map<String, dynamic> toJson() => _$BiblicalCharacterToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BiblicalCharacter && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 16명 성경인물 데이터 (biblical-weight-design.md 기반)
class BiblicalCharacters {
  static final List<BiblicalCharacter> characters = [
    BiblicalCharacter(
      id: 'david',
      name: '다윗',
      englishName: 'David',
      title: '하나님의 마음에 합한 자',
      description: '목자에서 왕이 된 이스라엘의 위대한 왕, 시인이자 음악가',
      mainEvents: ['골리앗 격퇴', '사울로부터 도피', '왕으로 기름부음', '밧세바 사건과 회개'],
      behaviorPatterns: ['하나님께 대한 열정', '예배와 찬양', '진솔한 고백', '관계 중시'],
      imageAsset: 'assets/images/characters/david.png',
      traits: ['공감능력', '관계중심', '음악적', '충성', '감정적'],
      strengths: ['하나님과의 친밀함', '예배자의 마음', '용기와 믿음'],
      growthAreas: ['자제력 향상', '권력 남용 경계', '일관된 순종'],
      bibleVerse: '여호와는 나의 목자시니 내게 부족함이 없으리로다',
      verseReference: '시편 23:1',
      colorTheme: 'blue',
    ),
    
    BiblicalCharacter(
      id: 'esther',
      name: '에스더',
      englishName: 'Esther',
      title: '때를 위한 왕후',
      description: '민족을 구원하기 위해 목숨을 건 용감한 왕후',
      mainEvents: ['왕후 선발', '하만의 음모 발견', '금홀을 향해 나아감', '유대민족 구원'],
      behaviorPatterns: ['신중한 계획', '희생적 결단', '타인을 위한 헌신', '지혜로운 접근'],
      imageAsset: 'assets/images/characters/esther.png',
      traits: ['헌신적', '책임감', '용기', '희생', '보호본능'],
      strengths: ['희생적 사랑', '지혜로운 접근', '담대한 용기'],
      growthAreas: ['자기 돌봄', '주도성 개발', '변화 수용력'],
      bibleVerse: '죽으면 죽으리이다',
      verseReference: '에스더 4:16',
      colorTheme: 'purple',
    ),
    
    BiblicalCharacter(
      id: 'moses',
      name: '모세',
      englishName: 'Moses',
      title: '하나님의 친구',
      description: '이스라엘을 이집트에서 인도한 위대한 지도자이자 율법 수여자',
      mainEvents: ['불타는 떨기나무 체험', '이집트 10재앙', '홍해 도하', '시내산에서 율법 수여'],
      behaviorPatterns: ['신중한 결정', '백성들을 위한 중보기도', '하나님의 명령 전달', '인내심 있는 지도'],
      imageAsset: 'assets/images/characters/moses.png',
      traits: ['지도력', '순종', '인내', '겸손', '충성'],
      strengths: ['겸손한 리더십', '하나님과의 친밀함', '인내심'],
      growthAreas: ['자신감 향상', '분노 조절', '위임 능력'],
      bibleVerse: '이 사람 모세는 온유함이 지면의 모든 사람보다 승하더라',
      verseReference: '민수기 12:3',
      colorTheme: 'amber',
    ),
    
    BiblicalCharacter(
      id: 'mary',
      name: '마리아',
      englishName: 'Mary',
      title: '하나님의 은혜를 입은 자',
      description: '하나님의 뜻에 순종한 예수님의 어머니',
      mainEvents: ['천사 가브리엘의 수태고지', '엘리사벳 방문', '예수 탄생', '십자가 아래에서'],
      behaviorPatterns: ['조용한 순종', '마음에 간직함', '겸손한 수용', '깊은 사색'],
      imageAsset: 'assets/images/characters/mary.png',
      traits: ['온유함', '순종', '깊은신앙', '평화로움', '내향적'],
      strengths: ['온전한 순종', '깊은 영성', '내면의 평화'],
      growthAreas: ['자기 주장 표현', '리더십 개발', '적극성 기르기'],
      bibleVerse: '주의 여종이오니 말씀대로 내게 이루어지이다',
      verseReference: '누가복음 1:38',
      colorTheme: 'teal',
    ),
    
    BiblicalCharacter(
      id: 'joseph',
      name: '요셉',
      englishName: 'Joseph',
      title: '꿈의 해석자',
      description: '고난 속에서도 하나님을 신뢰한 이집트의 총리',
      mainEvents: ['형들에게 팔림', '보디발의 집에서 시험', '감옥에서 꿈 해석', '바로 앞에서 꿈 해석'],
      behaviorPatterns: ['현실적 대처', '실용적 해결책', '즉각적 행동', '위기 대응'],
      imageAsset: 'assets/images/characters/joseph.png',
      traits: ['실용적', '행동력', '순발력', '현실적', '적응력'],
      strengths: ['용서의 마음', '신실한 관리', '긍정적 태도'],
      growthAreas: ['자기 주장', '경계 설정', '감정 표현'],
      bibleVerse: '당신들은 나를 해하려 하였으나 하나님은 그것을 선으로 바꾸사',
      verseReference: '창세기 50:20',
      colorTheme: 'green',
    ),
    
    BiblicalCharacter(
      id: 'paul',
      name: '바울',
      englishName: 'Paul',
      title: '이방인의 사도',
      description: '체계적이고 전략적인 사도, 복음 전파의 전략가',
      mainEvents: ['다메섹 도상 회심', '1-3차 전도여행', '로마 감옥', '서신서 저술'],
      behaviorPatterns: ['논리적 설득', '체계적 계획', '불굴의 의지', '지적 토론'],
      imageAsset: 'assets/images/characters/paul.png',
      traits: ['논리적', '체계적', '목표지향적', '지적', '독립적'],
      strengths: ['전략적 사고', '확고한 신념', '탁월한 논리력'],
      growthAreas: ['감정적 공감 능력', '유연성 개발', '타인의 관점 수용'],
      bibleVerse: '내가 선한 싸움을 싸우고 나의 달려갈 길을 마치고',
      verseReference: '디모데후서 4:7',
      colorTheme: 'red',
    ),
    
    BiblicalCharacter(
      id: 'daniel',
      name: '다니엘',
      englishName: 'Daniel',
      title: '하나님만 의지하는 자',
      description: '어떤 상황에서도 신앙을 지킨 바벨론의 총리',
      mainEvents: ['바벨론 포로', '느부갓네살의 꿈 해석', '사자굴 체험', '환상과 예언'],
      behaviorPatterns: ['규칙적인 기도', '원칙적 생활', '꾸준한 학습', '신실한 섬김'],
      imageAsset: 'assets/images/characters/daniel.png',
      traits: ['충성', '기도', '믿음', '용기', '지혜'],
      strengths: ['타협없는 신앙', '탁월한 지혜', '기도의 사람'],
      growthAreas: ['유연성 개발', '관계 중심성', '감정 표현'],
      bibleVerse: '다니엘이 이 조서에 어인이 찍힌 것을 알고도 자기 집에 돌아가서',
      verseReference: '다니엘 6:10',
      colorTheme: 'indigo',
    ),
    
    // 추가 9명의 성경인물
    BiblicalCharacter(
      id: 'solomon',
      name: '솔로몬',
      englishName: 'Solomon',
      title: '지혜의 왕',
      description: '하나님께 지혜를 구한 이스라엘의 평화의 왕',
      mainEvents: ['기브온에서 지혜를 구함', '두 여인의 아기 재판', '성전 건축', '스바 여왕의 방문'],
      behaviorPatterns: ['깊은 사색', '지식 탐구', '논리적 분석', '창조적 사고'],
      imageAsset: 'assets/images/characters/solomon.png',
      traits: ['지혜로움', '분석적', '통찰력', '지적호기심', '창조적'],
      strengths: ['탁월한 지혜', '깊은 통찰력', '공정한 판단'],
      growthAreas: ['영적 일관성', '교만 경계', '실천력 강화'],
      bibleVerse: '지혜가 제일이니 지혜를 얻으라',
      verseReference: '잠언 4:7',
      colorTheme: 'yellow',
    ),
    
    BiblicalCharacter(
      id: 'deborah',
      name: '드보라',
      englishName: 'Deborah',
      title: '이스라엘의 어머니',
      description: '강력한 리더십을 가진 여사사이자 선지자',
      mainEvents: ['이스라엘 사사로 활동', '바락과 함께 가나안족과 전투', '승리의 노래', '40년 평화 통치'],
      behaviorPatterns: ['강력한 리더십', '전략적 계획', '결단력 있는 실행', '정의로운 통치'],
      imageAsset: 'assets/images/characters/deborah.png',
      traits: ['리더십', '결단력', '전략적', '정의로움', '카리스마'],
      strengths: ['강력한 리더십', '명확한 비전', '결단력과 실행력'],
      growthAreas: ['경청 능력', '인내심 기르기', '섬세한 배려'],
      bibleVerse: '이스라엘 중 영웅이 없어졌도다 나 드보라가 일어나기까지',
      verseReference: '사사기 5:7',
      colorTheme: 'deeporange',
    ),
    
    BiblicalCharacter(
      id: 'barnabas',
      name: '바나바',
      englishName: 'Barnabas',
      title: '위로의 아들',
      description: '격려와 위로의 사람, 사람을 세우는 멘토',
      mainEvents: ['사도들에게 바울을 소개', '안디옥 교회 사역', '1차 전도여행', '마가를 격려하고 회복시킴'],
      behaviorPatterns: ['다른 사람 격려', '화합 추구', '멘토링', '관계 회복'],
      imageAsset: 'assets/images/characters/barnabas.png',
      traits: ['격려', '위로', '화합', '멘토링', '사교적'],
      strengths: ['격려의 은사', '화평 조성', '멘토링 능력'],
      growthAreas: ['경계 설정', '자기 관리', '직면 능력'],
      bibleVerse: '착한 사람이요 성령과 믿음이 충만한 자라',
      verseReference: '사도행전 11:24',
      colorTheme: 'lightgreen',
    ),
    
    BiblicalCharacter(
      id: 'luke',
      name: '누가',
      englishName: 'Luke',
      title: '사랑하는 의사',
      description: '세심하고 정확한 의사이자 복음서 기자',
      mainEvents: ['바울과 동행', '누가복음 기록', '사도행전 저술', '의료 사역'],
      behaviorPatterns: ['세밀한 기록', '체계적 조사', '정확한 문서화', '신뢰성 있는 증언'],
      imageAsset: 'assets/images/characters/luke.png',
      traits: ['정확성', '세심함', '체계적', '신뢰성', '돌봄'],
      strengths: ['정확한 기록', '신뢰성', '체계적 접근'],
      growthAreas: ['창의성 개발', '융통성 기르기', '감정 표현'],
      bibleVerse: '모든 일을 근본부터 자세히 미루어 살핀 나도',
      verseReference: '누가복음 1:3',
      colorTheme: 'cyan',
    ),
    
    BiblicalCharacter(
      id: 'jeremiah',
      name: '예레미야',
      englishName: 'Jeremiah',
      title: '눈물의 선지자',
      description: '깊은 감정과 이상을 가진 선지자',
      mainEvents: ['선지자로 부름받음', '유다의 멸망 예언', '바벨론 포로 예언', '새 언약 예언'],
      behaviorPatterns: ['깊은 감정 표현', '민족을 위한 눈물', '진리에 대한 열정', '이상 추구'],
      imageAsset: 'assets/images/characters/jeremiah.png',
      traits: ['깊은감정', '이상주의', '민감함', '진실', '동정심'],
      strengths: ['깊은 공감력', '진실된 메시지', '영적 민감성'],
      growthAreas: ['감정 조절', '현실 균형', '자기 돌봄'],
      bibleVerse: '내가 너를 모태에 짓기 전에 너를 알았고',
      verseReference: '예레미야 1:5',
      colorTheme: 'deeppurple',
    ),
    
    BiblicalCharacter(
      id: 'noah',
      name: '노아',
      englishName: 'Noah',
      title: '의인이요 완전한 자',
      description: '하나님의 명령에 순종한 방주 건설자',
      mainEvents: ['방주 건설 명령', '120년간 방주 건설', '대홍수와 구원', '새로운 시작과 언약'],
      behaviorPatterns: ['꾸준한 순종', '성실한 실행', '책임감 있는 관리', '인내심 있는 기다림'],
      imageAsset: 'assets/images/characters/noah.png',
      traits: ['신실함', '순종', '책임감', '인내', '성실함'],
      strengths: ['완전한 순종', '끈기와 인내', '신실한 믿음'],
      growthAreas: ['변화 적응력', '소통 능력', '유연성'],
      bibleVerse: '노아는 의인이요 당대에 완전한 자라',
      verseReference: '창세기 6:9',
      colorTheme: 'brown',
    ),
    
    BiblicalCharacter(
      id: 'rebekah',
      name: '리브가',
      englishName: 'Rebekah',
      title: '이삭의 아내',
      description: '실용적이고 행동력 있는 족장 시대의 여인',
      mainEvents: ['아브라함의 종을 맞이함', '이삭과 결혼', '에서와 야곱을 낳음', '야곱의 축복을 위한 계략'],
      behaviorPatterns: ['즉석에서 판단', '실용적 해결', '현실적 대처', '행동 우선'],
      imageAsset: 'assets/images/characters/rebekah.png',
      traits: ['실용적', '행동력', '순발력', '현실적', '결단력'],
      strengths: ['빠른 실행력', '현실적 문제해결', '순발력'],
      growthAreas: ['인내심 개발', '장기 계획', '감정적 깊이'],
      bibleVerse: '그 소녀는 보기에 심히 아름답고',
      verseReference: '창세기 24:16',
      colorTheme: 'pink',
    ),
    
    BiblicalCharacter(
      id: 'prodigal_son',
      name: '돌아온 탕자',
      englishName: 'Prodigal Son',
      title: '회개와 회복의 아들',
      description: '경험을 통해 배우고 성장하는 자유로운 영혼, 실수를 통해 진정한 가치를 깨달음',
      mainEvents: ['아버지께 유산을 요구', '먼 나라에서 방탕한 생활', '돼지치기로 전락', '회개하고 아버지께 돌아옴'],
      behaviorPatterns: ['자유로운 탐험', '경험을 통한 학습', '진정한 회개', '겸손한 귀환'],
      imageAsset: 'assets/images/characters/prodigal_son.png',
      traits: ['자유로움', '경험중시', '회개', '겸손', '성장'],
      strengths: ['겸손한 회개', '경험을 통한 성장', '진정성 있는 변화'],
      growthAreas: ['장기적 계획 수립', '충동 억제력', '책임감 강화'],
      bibleVerse: '아버지여 내가 하늘과 아버지께 죄를 범하였사오니',
      verseReference: '누가복음 15:21',
      colorTheme: 'blueGrey',
    ),
    
    BiblicalCharacter(
      id: 'peter',
      name: '베드로',
      englishName: 'Peter',
      title: '열정적인 어부 사도',
      description: '충동적이지만 사랑이 넘치는 제자, 실수를 통해 성장하는 리더',
      mainEvents: ['예수님과의 첫 만남', '물 위를 걸음', '닭 울기 전 세 번 부인', '오순절 설교'],
      behaviorPatterns: ['즉흥적인 행동', '열정적인 선포', '실수 후 회개', '용감한 리더십'],
      imageAsset: 'assets/images/characters/peter.png',
      traits: ['열정적', '충동적', '사교적', '용감함', '감정적'],
      strengths: ['열정과 헌신', '대담한 믿음', '사람들과의 소통 능력'],
      growthAreas: ['신중한 판단력 기르기', '감정 조절 능력 향상', '일관성 유지하기'],
      bibleVerse: '예수께서 이르시되 시몬 바요나여 네가 복이 있도다',
      verseReference: '마태복음 16:17',
      colorTheme: 'orange',
    ),
  ];

  /// ID로 캐릭터 찾기
  static BiblicalCharacter? findById(String id) {
    try {
      return characters.firstWhere((character) => character.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 이름으로 캐릭터 찾기
  static BiblicalCharacter? findByName(String name) {
    try {
      return characters.firstWhere((character) => character.name == name);
    } catch (e) {
      return null;
    }
  }
}