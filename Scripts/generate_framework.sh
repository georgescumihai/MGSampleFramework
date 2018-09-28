
# Set bash script to exit immediately if any commands fail.
set -e

# Setup some constants for use later on.
FRAMEWORK_NAME="$1"
OUTPUT_DIR="${SRCROOT}/build"
DERIVED_DATA_DIR="${OUTPUT_DIR}/DerivedData"

# If remnants from a previous build exist, delete them.
if [ -d "${DERIVED_DATA_DIR}" ]; then
rm -rf "${DERIVED_DATA_DIR}"
fi

# Build the framework for device and for simulator (using
# all needed architectures).
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration Release -arch arm64 -arch armv7 only_active_arch=no defines_module=yes -sdk "iphoneos" -derivedDataPath "${DERIVED_DATA_DIR}"
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator" -derivedDataPath "${DERIVED_DATA_DIR}"

# Remove .framework file if exists from previous run.
if [ -d "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework" ]; then
rm -rf "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework"
fi

# Copy the device version of framework.
cp -r "${DERIVED_DATA_DIR}/Build/Products/Release-iphoneos/${FRAMEWORK_NAME}.framework" "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework"

# Replace the framework executable within the framework with
# a new version created by merging the device and simulator
# frameworks' executables with lipo.
lipo -create -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${DERIVED_DATA_DIR}/Build/Products/Release-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${DERIVED_DATA_DIR}/Build/Products/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# Copy the Swift module mappings for the simulator into the
# framework. The device mappings already exist from step 6.
cp -r "${DERIVED_DATA_DIR}/Build/Products/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/" "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"
