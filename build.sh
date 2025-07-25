#!/bin/bash

echo "🎮 Building Sweet Billions Game"
echo "=============================="

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Build for Android
echo "🤖 Building Android APK..."
flutter build apk --release

if [ $? -ne 0 ]; then
    echo "❌ Failed to build Android APK"
    exit 1
fi

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📱 APK location:"
echo "   build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "🚀 To install on a connected Android device:"
echo "   flutter install"
echo "" 