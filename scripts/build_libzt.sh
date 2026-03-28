#!/usr/bin/env bash
set -euo pipefail

# Build libzt (ZeroTier) static library for Android using NDK cross-compilation.
#
# Usage: ./scripts/build_libzt.sh <arch>
#   arch: arm64 | arm | amd64 | x86_64
#
# Environment:
#   ANDROID_NDK  - path to Android NDK (required)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LIBZT_DIR="$PROJECT_ROOT/core/zerotier/libzt"

# --- Parse architecture argument ---

ARCH="${1:-arm64}"

case "$ARCH" in
  arm64)
    ANDROID_ABI="arm64-v8a"
    ;;
  arm)
    ANDROID_ABI="armeabi-v7a"
    ;;
  amd64|x86_64)
    ANDROID_ABI="x86_64"
    ;;
  *)
    echo "Error: unsupported architecture '$ARCH'"
    echo "Supported: arm64, arm, amd64, x86_64"
    exit 1
    ;;
esac

echo "Building libzt for Android ABI=$ANDROID_ABI (arch=$ARCH)"

# --- Validate ANDROID_NDK ---

if [ -z "${ANDROID_NDK:-}" ]; then
  echo "Error: ANDROID_NDK environment variable is not set"
  exit 1
fi

if [ ! -d "$ANDROID_NDK" ]; then
  echo "Error: ANDROID_NDK directory does not exist: $ANDROID_NDK"
  exit 1
fi

TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake"
if [ ! -f "$TOOLCHAIN_FILE" ]; then
  echo "Error: NDK toolchain file not found: $TOOLCHAIN_FILE"
  exit 1
fi

# --- Clone/checkout libzt source if needed ---

if [ ! -d "$LIBZT_DIR" ] || [ -z "$(ls -A "$LIBZT_DIR" 2>/dev/null)" ]; then
  echo "Cloning libzt source..."
  mkdir -p "$(dirname "$LIBZT_DIR")"
  git clone --depth 1 https://github.com/zerotier/libzerotiercore.git "$LIBZT_DIR"
fi

# --- Build with CMake ---

BUILD_DIR="$LIBZT_DIR/build/$ANDROID_ABI"
OUTPUT_DIR="$LIBZT_DIR/lib/$ANDROID_ABI"
INCLUDE_DIR="$LIBZT_DIR/include"

mkdir -p "$BUILD_DIR"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$INCLUDE_DIR"

echo "Configuring CMake build in $BUILD_DIR..."

cmake -S "$LIBZT_DIR" -B "$BUILD_DIR" \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
  -DANDROID_ABI="$ANDROID_ABI" \
  -DANDROID_PLATFORM=android-21 \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DZTS_ENABLE_JAVA=OFF \
  -DZTS_ENABLE_PYTHON=OFF

echo "Building..."

cmake --build "$BUILD_DIR" --config Release -- -j"$(nproc 2>/dev/null || echo 4)"

# --- Copy output artifacts ---

echo "Copying static library to $OUTPUT_DIR..."

# Find and copy the static library
LIBZT_A=$(find "$BUILD_DIR" -name "libzt.a" -type f | head -n 1)
if [ -n "$LIBZT_A" ]; then
  cp "$LIBZT_A" "$OUTPUT_DIR/libzt.a"
  echo "Copied libzt.a to $OUTPUT_DIR/"
else
  echo "Warning: libzt.a not found in build output"
  # Try alternative names
  LIBZT_A=$(find "$BUILD_DIR" -name "*.a" -type f | head -n 1)
  if [ -n "$LIBZT_A" ]; then
    cp "$LIBZT_A" "$OUTPUT_DIR/libzt.a"
    echo "Copied $(basename "$LIBZT_A") as libzt.a to $OUTPUT_DIR/"
  else
    echo "Error: no static library found in build output"
    exit 1
  fi
fi

# --- Copy headers ---

echo "Copying headers to $INCLUDE_DIR..."

find "$LIBZT_DIR" -maxdepth 3 -name "*.h" -path "*/include/*" -exec cp {} "$INCLUDE_DIR/" \; 2>/dev/null || true

echo "libzt build complete for $ANDROID_ABI"
