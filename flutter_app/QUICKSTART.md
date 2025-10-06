# Quick Start Guide

## Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
cd flutter_app
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

### Step 3: Use the App
1. Enter product details in the form
2. Click **SALVAR PRODUTO** to save
3. Click on products in the list to edit them
4. Click **REMOVER PRODUTO** to delete

## What's Included

✅ **Product Model** - Complete data structure with JSON serialization  
✅ **Local Storage** - Persistent JSON file storage  
✅ **CRUD Operations** - Create, Read, Update, Delete functionality  
✅ **Form Validation** - Input validation with error messages  
✅ **Material UI** - Modern, clean interface  
✅ **Tests** - Unit tests for the Product model  

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── models/product.dart          # Product model
│   ├── services/product_storage.dart # Storage service
│   └── screens/product_form_screen.dart # Main UI
├── test/
│   └── product_test.dart            # Unit tests
├── pubspec.yaml                     # Dependencies
├── README.md                        # Overview
├── USAGE.md                         # Detailed guide
└── UI_DESIGN.md                     # UI documentation
```

## Requirements

- Flutter SDK 2.19.0 or higher
- Dart SDK (included with Flutter)
- Android Studio / VS Code / IntelliJ IDEA
- A device or emulator

## Key Features

### Form Inputs
- **ID Subproduto**: Numeric input with validation
- **ID Produto**: Numeric input with validation  
- **Título do Produto**: Text input (min 3 chars)

### Action Buttons
- **NOVO PRODUTO** (Blue): Clear form for new entry
- **SALVAR PRODUTO** (Green): Save/update product
- **REMOVER PRODUTO** (Red): Delete selected product

### Product List
- Displays all saved products
- Click to edit any product
- Shows ID Produto and ID Subproduto
- Visual selection indicator

### Data Persistence
- Automatically saves to local JSON file
- Products persist between app sessions
- No internet connection required

## Need Help?

See **USAGE.md** for detailed instructions on:
- Installation steps
- Running on different platforms
- Troubleshooting common issues
- Building for production

See **UI_DESIGN.md** for UI specifications and design details.

## Testing

Run tests with:
```bash
flutter test
```

## Next Steps

1. Customize the UI colors and styling
2. Add more fields to the Product model
3. Implement search/filter functionality
4. Add product categories
5. Export/import product data

---

**Happy Coding! 🚀**
