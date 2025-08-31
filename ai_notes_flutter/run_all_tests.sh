#!/bin/bash

# AI Notes Flutter - Complete Test Suite Runner
# This script runs all tests for the AI Notes Flutter application

echo "🚀 Starting AI Notes Flutter Test Suite..."
echo "============================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Change to project directory
cd "$(dirname "$0")"
PROJECT_DIR=$(pwd)

echo "📁 Project Directory: $PROJECT_DIR"
echo ""

# Function to run a test suite
run_test_suite() {
    local test_name="$1"
    local test_path="$2"
    local description="$3"
    
    echo -e "${BLUE}🧪 Running $test_name${NC}"
    echo "   Description: $description"
    echo "   Path: $test_path"
    echo ""
    
    # Run the test and capture output
    if flutter test "$test_path" > "test_output_$(basename "$test_path" .dart).log" 2>&1; then
        # Extract test count from log
        local test_count=$(grep -o '+[0-9]\+' "test_output_$(basename "$test_path" .dart).log" | tail -1 | sed 's/+//')
        if [ -z "$test_count" ]; then
            test_count=0
        fi
        
        echo -e "${GREEN}✅ $test_name: PASSED ($test_count tests)${NC}"
        PASSED_TESTS=$((PASSED_TESTS + test_count))
        TOTAL_TESTS=$((TOTAL_TESTS + test_count))
    else
        # Extract test count from log (even for failed tests)
        local test_count=$(grep -o '+[0-9]\+' "test_output_$(basename "$test_path" .dart).log" | tail -1 | sed 's/+//')
        local failed_count=$(grep -o '\-[0-9]\+' "test_output_$(basename "$test_path" .dart).log" | tail -1 | sed 's/-//')
        
        if [ -z "$test_count" ]; then
            test_count=0
        fi
        if [ -z "$failed_count" ]; then
            failed_count=1
        fi
        
        echo -e "${RED}❌ $test_name: FAILED ($failed_count failed, $test_count passed)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + failed_count))
        PASSED_TESTS=$((PASSED_TESTS + test_count))
        TOTAL_TESTS=$((TOTAL_TESTS + test_count + failed_count))
        
        echo -e "${YELLOW}   💡 Check test_output_$(basename "$test_path" .dart).log for details${NC}"
    fi
    echo ""
}

# 1. Run Basic Functionality Tests
run_test_suite "Basic Functionality Tests" "test/basic_test.dart" "Core utilities and validation functions"

# 2. Run Error Handling Tests
run_test_suite "Error Handling Tests" "test/core/error_test.dart" "Comprehensive error and exception handling"

# 3. Run Integration Tests
run_test_suite "Integration Tests" "test/integration_test.dart" "Complete feature integration testing"

# 4. Try to run Auth Tests (might fail due to missing mocks)
if [ -f "test/features/auth/auth_test.dart" ]; then
    echo -e "${YELLOW}⚠️  Attempting to run Auth Tests (may require mock generation)${NC}"
    run_test_suite "Authentication Tests" "test/features/auth/auth_test.dart" "User authentication and authorization"
fi

# 5. Try to run Notes Tests (might fail due to missing mocks)
if [ -f "test/features/notes/notes_test.dart" ]; then
    echo -e "${YELLOW}⚠️  Attempting to run Notes Tests (may require mock generation)${NC}"
    run_test_suite "Notes Management Tests" "test/features/notes/notes_test.dart" "Notes CRUD operations and management"
fi

# 6. Run Integration Test App (requires device/emulator)
if [ -f "integration_test/app_test.dart" ]; then
    echo -e "${YELLOW}⚠️  Checking for Integration Test App (requires device/emulator)${NC}"
    echo "   This test requires a connected device or running emulator"
    echo "   To run manually: flutter test integration_test/app_test.dart"
    echo ""
fi

# Summary
echo "============================================="
echo -e "${BLUE}📊 Test Suite Summary${NC}"
echo "============================================="

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
else
    echo -e "${RED}⚠️  Some tests failed${NC}"
fi

echo ""
echo "📈 Results:"
echo "   Total Tests: $TOTAL_TESTS"
echo -e "   ${GREEN}Passed: $PASSED_TESTS${NC}"
if [ $FAILED_TESTS -gt 0 ]; then
    echo -e "   ${RED}Failed: $FAILED_TESTS${NC}"
fi

# Calculate success rate
if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "   Success Rate: ${SUCCESS_RATE}%"
fi

echo ""
echo "============================================="

# Test Coverage (if available)
echo -e "${BLUE}📊 Generating Test Coverage${NC}"
echo "Running tests with coverage analysis..."

if flutter test --coverage > coverage_output.log 2>&1; then
    echo -e "${GREEN}✅ Coverage report generated${NC}"
    if [ -f "coverage/lcov.info" ]; then
        echo "   📁 Coverage file: coverage/lcov.info"
        echo "   💡 To view coverage report, install lcov and run:"
        echo "      genhtml coverage/lcov.info -o coverage/html"
        echo "      open coverage/html/index.html"
    fi
else
    echo -e "${YELLOW}⚠️  Coverage generation completed with warnings${NC}"
    echo "   Check coverage_output.log for details"
fi

echo ""

# Next Steps
echo -e "${BLUE}🔄 Next Steps${NC}"
echo "============================================="

if [ $FAILED_TESTS -gt 0 ]; then
    echo "1. 🔧 Fix failing tests by checking the log files"
    echo "2. 🏗️  Generate mocks if needed: flutter packages pub run build_runner build"
    echo "3. 🔄 Re-run this script to verify fixes"
else
    echo "1. 🏗️  Generate mocks for auth/notes tests: flutter packages pub run build_runner build"
    echo "2. 📱 Set up device/emulator for integration tests"
    echo "3. 🚀 Run integration tests: flutter test integration_test/"
fi

echo "4. 📊 Set up continuous integration (CI/CD)"
echo "5. 📈 Monitor test coverage and improve"
echo ""

# Clean up log files option
echo -e "${YELLOW}🧹 Clean up log files? (y/n)${NC}"
read -r cleanup_choice
if [ "$cleanup_choice" = "y" ] || [ "$cleanup_choice" = "Y" ]; then
    rm -f test_output_*.log coverage_output.log
    echo "✅ Log files cleaned up"
fi

echo ""
echo "🎯 Test suite completed!"

# Exit with appropriate code
if [ $FAILED_TESTS -eq 0 ]; then
    exit 0
else
    exit 1
fi
