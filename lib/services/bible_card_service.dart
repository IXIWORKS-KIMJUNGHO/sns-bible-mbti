import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BibleCardService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 성경 인물별 카드 이미지에 사용자 이름을 워터마크로 추가
  Future<Uint8List?> addNameWatermark({
    required String characterId,
    required String userName,
  }) async {
    try {
      // 1. Assets에서 이미지 로드
      final String imagePath =
          'assets/images/bible_cards/${_getImageFileName(characterId)}';
      final ByteData data = await rootBundle.load(imagePath);
      final Uint8List bytes = data.buffer.asUint8List();

      // 2. image 패키지로 디코딩
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) return null;

      // 3. 텍스트 위치 계산 (이미지 중앙 상단)
      final int textX = originalImage.width ~/ 2;
      final int textY = originalImage.height ~/ 6; // 상단 1/6 위치

      // 4. 워터마크 텍스트 추가
      // 한글 폰트 처리를 위해 Flutter의 Canvas 사용이 필요할 수 있음
      // 여기서는 기본적인 구현
      img.drawString(
        originalImage,
        userName,
        font: img.arial48,
        x: textX,
        y: textY,
        color: img.ColorRgb8(255, 255, 255), // 흰색 텍스트
      );

      // 5. 이미지를 바이트로 변환
      final Uint8List processedBytes = Uint8List.fromList(
        img.encodePng(originalImage),
      );

      return processedBytes;
    } catch (e) {
      print('Error adding watermark: $e');
      return null;
    }
  }

  /// Canvas를 사용한 고급 워터마크 추가 (한글 지원)
  Future<Uint8List?> addNameWatermarkWithCanvas({
    required String characterId,
    required String userName,
  }) async {
    try {
      // 1. Assets에서 이미지 로드
      final String imagePath =
          'assets/images/bible_cards/${_getImageFileName(characterId)}';
      final ByteData data = await rootBundle.load(imagePath);
      final Uint8List bytes = data.buffer.asUint8List();

      // 2. 이미지를 ui.Image로 변환
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      // 3. Canvas 생성 및 이미지 그리기
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      );

      // 원본 이미지 그리기
      canvas.drawImage(image, Offset.zero, Paint());

      // 4. 텍스트 스타일 설정 - Pretendard Light 폰트 사용
      final textStyle = ui.TextStyle(
        color: Colors.white,
        fontSize: 90, // 크기 조정 (템플릿에 맞게)
        fontFamily: 'Pretendard', // Pretendard 폰트 사용
        fontWeight: ui.FontWeight.w300, // Light weight
        shadows: [
          const ui.Shadow(
            offset: Offset(2, 2),
            blurRadius: 6,
            color: Colors.black45,
          ),
        ],
      );

      final paragraphBuilder =
          ui.ParagraphBuilder(
              ui.ParagraphStyle(
                textAlign: TextAlign.center,
                fontSize: 72,
                fontFamily: 'Pretendard',
                fontWeight: ui.FontWeight.w300, // Light weight
              ),
            )
            ..pushStyle(textStyle)
            ..addText(userName);

      final paragraph = paragraphBuilder.build()
        ..layout(ui.ParagraphConstraints(width: image.width.toDouble()));

      // 5. 텍스트 위치 계산 및 그리기 - 템플릿의 중앙 위치에 맞춤
      final double textX = (image.width - paragraph.width) / 2;
      final double textY = image.height * 0.41; // 중앙 위치 (템플릿의 "정호" 위치)

      canvas.drawParagraph(paragraph, Offset(textX, textY));

      // 6. Picture를 이미지로 변환
      final ui.Picture picture = recorder.endRecording();
      final ui.Image processedImage = await picture.toImage(
        image.width,
        image.height,
      );

      // 7. 이미지를 바이트로 변환
      final ByteData? byteData = await processedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) return null;

      return byteData.buffer.asUint8List();
    } catch (e) {
      print('Error adding watermark with canvas: $e');
      return null;
    }
  }

  /// Firebase Storage에 이미지 업로드
  Future<String?> uploadToFirebase({
    required Uint8List imageData,
    required String userName,
    required String characterId,
  }) async {
    try {
      // 1. 고유한 파일명 생성
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = '${userName}_${characterId}_$timestamp.png';

      // 2. Storage 경로 설정
      final Reference ref = _storage.ref().child(
        'bible_cards/$userName/$fileName',
      );

      // 3. 메타데이터 설정
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {
          'userName': userName,
          'characterId': characterId,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      // 4. 업로드
      final UploadTask uploadTask = ref.putData(imageData, metadata);

      // 5. 업로드 완료 대기
      final TaskSnapshot snapshot = await uploadTask;

      // 6. 다운로드 URL 가져오기
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading to Firebase: $e');
      return null;
    }
  }

  /// 전체 프로세스 실행
  Future<String?> generateBibleCard({
    required String characterId,
    required String userName,
  }) async {
    try {
      // 1. 워터마크 추가 (Canvas 방식 우선 사용)
      final Uint8List? imageData = await addNameWatermarkWithCanvas(
        characterId: characterId,
        userName: userName,
      );

      if (imageData == null) {
        print('Failed to add watermark');
        return null;
      }

      // 2. Firebase Storage 업로드
      final String? downloadUrl = await uploadToFirebase(
        imageData: imageData,
        userName: userName,
        characterId: characterId,
      );

      return downloadUrl;
    } catch (e) {
      print('Error generating bible card: $e');
      return null;
    }
  }

  /// 캐릭터 ID를 이미지 파일명으로 변환
  String _getImageFileName(String characterId) {
    // characterId를 적절한 파일명으로 매핑
    final Map<String, String> fileMapping = {
      'david': 'David.png',
      'esther': 'Esther.png',
      'moses': 'Moses.png',
      'mary': 'Mary.png',
      'joseph': 'Joseph.png',
      'paul': 'Paul.png',
      'daniel': 'Daniel.png',
      'solomon': 'Solomon.png',
      'deborah': 'Deborah.png',
      'barnabas': 'Barnabas.png',
      'luke': 'Nuke.png', // 파일명 오타 처리
      'jeremiah': 'Jeremiah.png',
      'noah': 'Noah.png',
      'rebekah': 'Rebekah.png',
      'prodigal_son': 'ProdigalSon.png',
      'peter': 'Peter.png',
    };

    return fileMapping[characterId] ?? 'Name_Template.png';
  }

  /// 로컬에 임시 저장 (테스트용)
  Future<File?> saveToLocal({
    required Uint8List imageData,
    required String fileName,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(imageData);
      return file;
    } catch (e) {
      print('Error saving to local: $e');
      return null;
    }
  }
}
