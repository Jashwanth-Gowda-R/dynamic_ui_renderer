#!/bin/bash

# --------------------------------------------------
# Flutter/Dart Package Pre-Publish Checklist Script
# Author: Shani
# Purpose: Run all validation checks before publishing
# --------------------------------------------------

set -e  # Exit immediately if any command fails

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔍 Running analyzer..."
flutter analyze

echo "🧪 Running tests..."
flutter test

echo "🎨 Checking formatting..."
dart format .

echo "📦 Running pub publish dry-run..."
dart pub publish --dry-run

echo "📊 Running pana for package scoring..."
pana .

echo "--------------------------------------------"
echo "✅ All checks passed successfully!"
echo "🚀 Safe to tag and publish."
echo "--------------------------------------------"
