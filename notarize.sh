#!/bin/bash

# Developer ID 공증 스크립트
# 사용법: ./notarize.sh

echo "🔐 macOS 앱 공증 프로세스 시작..."

# 설정 (수정 필요)
DEVELOPER_ID="Developer ID Application: YOUR NAME (TEAM_ID)"
APPLE_ID="your.email@example.com"
TEAM_ID="YOUR_TEAM_ID"
APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"  # App-specific password

# 파일 경로
APP_PATH="build/macos/Build/Products/Release/biblical_mbti_app.app"
DMG_PATH="BiblicalMBTI.dmg"
DMG_SIGNED="BiblicalMBTI-signed.dmg"

echo "1️⃣ 앱 서명 중..."
codesign --deep --force --verify --verbose \
  --sign "$DEVELOPER_ID" \
  --options runtime \
  --entitlements macos/Runner/Release.entitlements \
  "$APP_PATH"

echo "2️⃣ 서명 확인..."
codesign --verify --verbose "$APP_PATH"

echo "3️⃣ 새 DMG 생성..."
rm -f "$DMG_SIGNED"
create-dmg \
  --volname "Biblical MBTI" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --app-drop-link 400 185 \
  "$DMG_SIGNED" \
  "build/macos/Build/Products/Release/"

echo "4️⃣ DMG 서명..."
codesign --sign "$DEVELOPER_ID" "$DMG_SIGNED"

echo "5️⃣ 공증 요청 (notarization)..."
xcrun notarytool submit "$DMG_SIGNED" \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID" \
  --password "$APP_PASSWORD" \
  --wait

echo "6️⃣ 스테이플링 (stapling)..."
xcrun stapler staple "$DMG_SIGNED"

echo "7️⃣ 최종 검증..."
spctl -a -t open --context context:primary-signature -v "$DMG_SIGNED"

echo "✅ 공증 완료! $DMG_SIGNED 파일을 배포하세요."
echo "📦 이제 사용자가 보안 경고 없이 설치할 수 있습니다!"