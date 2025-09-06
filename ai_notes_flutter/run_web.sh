#!/bin/bash
cd /Users/zhaoben/work/ai/code/ai-notes/ai_notes_flutter
echo "Current directory: $(pwd)"
echo "Files in directory:"
ls -la
echo "Checking Flutter version:"
flutter --version
echo "Starting Flutter web app..."
#flutter run -d chrome --web-port 8080
flutter run -d web-server --web-port=8888
