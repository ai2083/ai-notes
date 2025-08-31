#!/bin/bash

# AI Notes Flutter Test Runner
# This script runs all tests and generates coverage reports

echo "🚀 Starting AI Notes Flutter Tests..."

# Navigate to the Flutter project directory
cd "$(dirname "$0")"

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not in Flutter project directory!"
    exit 1
fi

echo "📦 Getting dependencies..."
flutter pub get

echo "🧪 Running unit tests..."
flutter test test/ --coverage

echo "🔍 Running integration tests..."
# Note: Integration tests require a device/emulator
if flutter devices | grep -q "device"; then
    echo "📱 Device found, running integration tests..."
    flutter test integration_test/
else
    echo "⚠️  No device found, skipping integration tests"
    echo "   To run integration tests, connect a device or start an emulator"
fi

echo "📊 Generating coverage report..."
if command -v lcov &> /dev/null; then
    lcov --summary coverage/lcov.info
else
    echo "⚠️  lcov not found, install it to see detailed coverage"
    echo "   macOS: brew install lcov"
    echo "   Ubuntu: sudo apt install lcov"
fi

echo "✅ Tests completed!"
echo ""
echo "📈 Coverage report generated in coverage/lcov.info"
echo "🌐 To view HTML coverage report:"
echo "   genhtml coverage/lcov.info -o coverage/html"
echo "   open coverage/html/index.html"
