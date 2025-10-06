# Usage Guide - Flutter Product Registration App

## Prerequisites

Before running this Flutter application, ensure you have:

1. **Flutter SDK** installed (version 2.19.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Follow the installation guide for your operating system

2. **An IDE** with Flutter support (recommended):
   - Android Studio with Flutter plugin
   - VS Code with Flutter extension
   - IntelliJ IDEA with Flutter plugin

3. **Device or Emulator**:
   - Android device/emulator
   - iOS device/simulator (macOS only)
   - Chrome browser (for web)
   - Windows/macOS/Linux desktop

## Installation Steps

1. **Navigate to the project directory:**
   ```bash
   cd flutter_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup:**
   ```bash
   flutter doctor
   ```
   This will check if your Flutter environment is properly configured.

## Running the Application

### For Mobile (Android/iOS)

1. **Connect a device or start an emulator:**
   ```bash
   # List available devices
   flutter devices
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Or run in release mode for better performance:**
   ```bash
   flutter run --release
   ```

### For Web

```bash
flutter run -d chrome
```

### For Desktop

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Running Tests

```bash
flutter test
```

## Application Features

### 1. Adding a New Product

1. Fill in all three fields:
   - **ID Subproduto**: Enter a numeric value (e.g., 1, 2, 3)
   - **ID Produto**: Enter a numeric value (e.g., 100, 200, 300)
   - **Título do Produto**: Enter the product name (minimum 3 characters)

2. Click the **SALVAR PRODUTO** button

3. You'll see a success message: "Produto salvo com sucesso!"

4. The product will appear in the list below

### 2. Editing an Existing Product

1. Click on any product in the list below

2. The form fields will be populated with the product data

3. Modify any fields you want to update

4. Click **SALVAR PRODUTO**

5. You'll see a success message: "Produto atualizado com sucesso!"

### 3. Deleting a Product

1. Click on the product you want to delete in the list

2. Click the **REMOVER PRODUTO** button

3. You'll see a success message: "Produto removido com sucesso!"

4. The product will be removed from the list

### 4. Creating a New Product (Clearing Form)

1. Click the **NOVO PRODUTO** button

2. All form fields will be cleared

3. You can now enter data for a new product

## Form Validation

The app includes the following validations:

- **ID Subproduto**: Required, must be a valid number
- **ID Produto**: Required, must be a valid number
- **Título do Produto**: Required, minimum 3 characters

If validation fails, you'll see error messages below each field.

## Data Persistence

- All products are automatically saved to a local JSON file
- Products persist between app sessions
- The file is stored in the application's documents directory
- File location varies by platform:
  - Android: `/data/data/com.example.flutter_app/app_flutter/products.json`
  - iOS: `~/Library/Application Support/products.json`
  - Desktop: Application support directory for your OS

## Troubleshooting

### Issue: "Flutter command not found"
**Solution**: Ensure Flutter is properly installed and added to your PATH

### Issue: "No devices found"
**Solution**: 
- For Android: Start an Android emulator via Android Studio
- For iOS: Start a simulator via Xcode (macOS only)
- For web: Use `-d chrome` flag
- For desktop: Ensure desktop support is enabled

### Issue: "Package dependencies error"
**Solution**: Run `flutter pub get` to install dependencies

### Issue: "Build errors"
**Solution**: 
1. Run `flutter clean`
2. Run `flutter pub get`
3. Try building again

## Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```
Output: `build/web/`

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## Additional Commands

### Format Code
```bash
flutter format .
```

### Analyze Code
```bash
flutter analyze
```

### Check for Updates
```bash
flutter upgrade
```

## Support

For Flutter-related issues, visit:
- Official Documentation: https://flutter.dev/docs
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- GitHub Issues: https://github.com/flutter/flutter/issues
