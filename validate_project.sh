#!/bin/bash

# Simple validation script for the Android monitoring application

echo "=== Validating Android Monitoring Application Structure ==="

# Check if all required files exist
check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1 exists"
        return 0
    else
        echo "✗ $1 missing"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✓ $1 directory exists"
        return 0
    else
        echo "✗ $1 directory missing"
        return 1
    fi
}

# Validate project structure
echo "Checking project structure..."
check_file "build.gradle"
check_file "settings.gradle"
check_file "gradlew"
check_file "app/build.gradle"
check_file "app/src/main/AndroidManifest.xml"

# Validate source files
echo "Checking source files..."
check_file "app/src/main/java/com/monitoramento/persistente/MainActivity.kt"
check_file "app/src/main/java/com/monitoramento/persistente/admin/DeviceAdminReceiver.kt"
check_file "app/src/main/java/com/monitoramento/persistente/services/MonitoringService.kt"
check_file "app/src/main/java/com/monitoramento/persistente/services/KeepAliveService.kt"
check_file "app/src/main/java/com/monitoramento/persistente/receivers/BootReceiver.kt"

# Validate resources
echo "Checking resources..."
check_file "app/src/main/res/layout/activity_main.xml"
check_file "app/src/main/res/values/strings.xml"
check_file "app/src/main/res/xml/device_admin.xml"

# Check for key components in AndroidManifest.xml
echo "Validating AndroidManifest.xml components..."
if grep -q "DeviceAdminReceiver" app/src/main/AndroidManifest.xml; then
    echo "✓ DeviceAdminReceiver declared in manifest"
else
    echo "✗ DeviceAdminReceiver missing from manifest"
fi

if grep -q "MonitoringService" app/src/main/AndroidManifest.xml; then
    echo "✓ MonitoringService declared in manifest"
else
    echo "✗ MonitoringService missing from manifest"
fi

if grep -q "BootReceiver" app/src/main/AndroidManifest.xml; then
    echo "✓ BootReceiver declared in manifest"
else
    echo "✗ BootReceiver missing from manifest"
fi

if grep -q "BIND_DEVICE_ADMIN" app/src/main/AndroidManifest.xml; then
    echo "✓ Device admin permission declared"
else
    echo "✗ Device admin permission missing"
fi

if grep -q "RECEIVE_BOOT_COMPLETED" app/src/main/AndroidManifest.xml; then
    echo "✓ Boot permission declared"
else
    echo "✗ Boot permission missing"
fi

# Validate Kotlin syntax (basic check)
echo "Checking Kotlin files syntax..."
find app/src/main/java -name "*.kt" | while read file; do
    if grep -q "^package com\.monitoramento\.persistente" "$file"; then
        echo "✓ $file has correct package declaration"
    else
        echo "✗ $file missing or incorrect package declaration"
    fi
done

echo "=== Validation Complete ==="