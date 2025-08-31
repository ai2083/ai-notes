#!/bin/bash

# AI Notes Flutter项目初始化脚本

echo "🚀 开始初始化 AI Notes Flutter项目..."

# 检查Flutter是否已安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "📖 安装指南: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 进入项目目录
cd ai_notes_flutter

echo "📦 安装Flutter依赖..."
flutter pub get

echo "🔧 运行代码生成..."
flutter packages pub run build_runner build

echo "🎯 检查Flutter环境..."
flutter doctor

echo "🧹 清理项目..."
flutter clean
flutter pub get

echo "✅ 项目初始化完成！"
echo ""
echo "🎉 下一步操作:"
echo "   1. 运行应用: flutter run"
echo "   2. 在Web上运行: flutter run -d chrome"
echo "   3. 构建APK: flutter build apk"
echo "   4. 构建iOS: flutter build ios"
echo ""
echo "📚 更多信息请查看: docs/development_guide.md"
