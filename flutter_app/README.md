# Flutter Product Registration App

A Flutter application for product registration with local JSON storage.

## Features

- **Product Model**: Includes fields for `id_subproduto`, `id_produto`, and `titulo`
- **Local Storage**: Uses `path_provider` to save products in a local JSON file
- **CRUD Operations**: Complete Create, Read, Update, and Delete functionality
- **Form Validation**: Validates all input fields before saving
- **Material Design UI**: Clean and modern user interface
- **Success/Error Messages**: User-friendly feedback for all operations

## Buttons

- **NOVO PRODUTO**: Clears the form to create a new product
- **SALVAR PRODUTO**: Saves or updates the current product
- **REMOVER PRODUTO**: Deletes the selected product

## Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── product.dart          # Product model
│   ├── services/
│   │   └── product_storage.dart  # Storage service
│   └── screens/
│       └── product_form_screen.dart  # Main form screen
└── pubspec.yaml                  # Dependencies
```

## Dependencies

- `flutter`: SDK
- `path_provider`: ^2.0.15 - For accessing local storage paths
- `shared_preferences`: ^2.2.0 - For local data persistence

## Getting Started

1. Install Flutter SDK from https://flutter.dev/docs/get-started/install
2. Navigate to the flutter_app directory:
   ```bash
   cd flutter_app
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Adding a Product**:
   - Enter ID Subproduto (numeric)
   - Enter ID Produto (numeric)
   - Enter Título do Produto (text, minimum 3 characters)
   - Click "SALVAR PRODUTO"

2. **Editing a Product**:
   - Click on a product in the list
   - Modify the fields
   - Click "SALVAR PRODUTO"

3. **Deleting a Product**:
   - Click on a product in the list
   - Click "REMOVER PRODUTO"

4. **Creating a New Product**:
   - Click "NOVO PRODUTO" to clear the form

All products are automatically saved to a local JSON file and persist between app sessions.
