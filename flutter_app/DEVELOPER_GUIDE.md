# Developer Guide

## Code Overview

This guide helps developers understand and extend the Flutter Product Registration App.

## Project Organization

### Directory Structure
```
flutter_app/
├── lib/              # Application source code
├── test/             # Unit and widget tests
├── pubspec.yaml      # Package dependencies
└── docs/             # Documentation (MD files)
```

### Layer Architecture

**Presentation Layer** (`lib/screens/`)
- UI components
- User interaction handling
- State management

**Business Logic Layer** (`lib/services/`)
- Data operations
- Business rules
- Storage management

**Data Layer** (`lib/models/`)
- Data structures
- Serialization logic
- Model definitions

## Key Components

### 1. Product Model (`lib/models/product.dart`)

**Purpose**: Define product data structure

**Responsibilities**:
- Store product data (id_subproduto, id_produto, titulo)
- Convert to/from JSON
- Provide string representation

**Methods**:
```dart
// Create from JSON
Product.fromJson(Map<String, dynamic> json)

// Convert to JSON
Map<String, dynamic> toJson()

// String representation
String toString()
```

**Usage Example**:
```dart
// Create product
final product = Product(
  idSubproduto: 1,
  idProduto: 100,
  titulo: 'Product Name',
);

// Serialize
final json = product.toJson();

// Deserialize
final product2 = Product.fromJson(json);
```

### 2. ProductStorage Service (`lib/services/product_storage.dart`)

**Purpose**: Handle all file I/O operations

**Responsibilities**:
- Manage JSON file access
- Perform CRUD operations
- Handle errors gracefully

**Methods**:
```dart
// Save all products
Future<void> saveProducts(List<Product> products)

// Load all products
Future<List<Product>> loadProducts()

// Add single product
Future<void> addProduct(Product product)

// Update product at index
Future<void> updateProduct(int index, Product product)

// Remove product at index
Future<void> removeProduct(int index)

// Clear all products
Future<void> clearProducts()
```

**Usage Example**:
```dart
final storage = ProductStorage();

// Load products
final products = await storage.loadProducts();

// Add product
await storage.addProduct(newProduct);

// Update product
await storage.updateProduct(0, updatedProduct);

// Delete product
await storage.removeProduct(0);
```

### 3. ProductFormScreen (`lib/screens/product_form_screen.dart`)

**Purpose**: Main UI and user interaction

**State Variables**:
```dart
_formKey                 // Form validation key
_idSubprodutoController  // ID Subproduto input
_idProdutoController     // ID Produto input
_tituloController        // Titulo input
_storage                 // Storage service instance
_products                // List of loaded products
_selectedProductIndex    // Currently selected product
```

**Key Methods**:
```dart
_loadProducts()    // Load from storage
_clearForm()       // Reset form
_saveProduct()     // Save/update product
_removeProduct()   // Delete product
_loadProductToForm() // Populate form with product
_showMessage()     // Display snackbar
```

## Adding New Features

### Example 1: Add Product Price Field

**Step 1**: Update Product Model
```dart
class Product {
  int idSubproduto;
  int idProduto;
  String titulo;
  double preco;  // NEW FIELD

  Product({
    required this.idSubproduto,
    required this.idProduto,
    required this.titulo,
    required this.preco,  // NEW FIELD
  });

  Map<String, dynamic> toJson() {
    return {
      'id_subproduto': idSubproduto,
      'id_produto': idProduto,
      'titulo': titulo,
      'preco': preco,  // NEW FIELD
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idSubproduto: json['id_subproduto'] as int,
      idProduto: json['id_produto'] as int,
      titulo: json['titulo'] as String,
      preco: json['preco'] as double,  // NEW FIELD
    );
  }
}
```

**Step 2**: Add Input Field in UI
```dart
// In product_form_screen.dart, add after titulo field:
TextFormField(
  controller: _precoController,  // Add controller
  decoration: const InputDecoration(
    labelText: 'Preço',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.attach_money),
  ),
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o preço';
    }
    if (double.tryParse(value) == null) {
      return 'Por favor, insira um preço válido';
    }
    return null;
  },
),
```

**Step 3**: Update Product Creation
```dart
// In _saveProduct() method:
final product = Product(
  idSubproduto: int.parse(_idSubprodutoController.text),
  idProduto: int.parse(_idProdutoController.text),
  titulo: _tituloController.text,
  preco: double.parse(_precoController.text),  // NEW
);
```

### Example 2: Add Search Functionality

**Step 1**: Add Search State
```dart
String _searchQuery = '';
List<Product> get _filteredProducts {
  if (_searchQuery.isEmpty) return _products;
  return _products.where((p) => 
    p.titulo.toLowerCase().contains(_searchQuery.toLowerCase())
  ).toList();
}
```

**Step 2**: Add Search Bar in UI
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Pesquisar',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (value) {
    setState(() {
      _searchQuery = value;
    });
  },
),
```

**Step 3**: Use Filtered List
```dart
ListView.builder(
  itemCount: _filteredProducts.length,  // Changed
  itemBuilder: (context, index) {
    final product = _filteredProducts[index];  // Changed
    // ... rest of code
  },
),
```

### Example 3: Add Product Categories

**Step 1**: Create Category Model
```dart
// lib/models/category.dart
class Category {
  String id;
  String name;
  
  Category({required this.id, required this.name});
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Category.fromJson(Map<String, dynamic> json) =>
    Category(id: json['id'], name: json['name']);
}
```

**Step 2**: Update Product Model
```dart
class Product {
  // ... existing fields
  String categoryId;  // NEW
  
  // Update constructor, toJson, and fromJson
}
```

**Step 3**: Add Dropdown in UI
```dart
DropdownButtonFormField<String>(
  value: _selectedCategoryId,
  decoration: const InputDecoration(
    labelText: 'Categoria',
    border: OutlineInputBorder(),
  ),
  items: categories.map((category) {
    return DropdownMenuItem(
      value: category.id,
      child: Text(category.name),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedCategoryId = value;
    });
  },
),
```

## Testing Guidelines

### Unit Tests

**Test Product Model**:
```dart
test('Product toJson and fromJson', () {
  final product = Product(
    idSubproduto: 1,
    idProduto: 100,
    titulo: 'Test',
  );
  
  final json = product.toJson();
  final product2 = Product.fromJson(json);
  
  expect(product2.idSubproduto, product.idSubproduto);
  expect(product2.idProduto, product.idProduto);
  expect(product2.titulo, product.titulo);
});
```

### Widget Tests

**Test Form Validation**:
```dart
testWidgets('Form validation shows errors', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Find save button and tap
  await tester.tap(find.text('SALVAR\nPRODUTO'));
  await tester.pump();
  
  // Expect validation errors
  expect(find.text('Por favor, insira o ID do subproduto'), findsOneWidget);
});
```

### Integration Tests

**Test Full Flow**:
```dart
testWidgets('Add and delete product', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Enter data
  await tester.enterText(find.byType(TextFormField).at(0), '1');
  await tester.enterText(find.byType(TextFormField).at(1), '100');
  await tester.enterText(find.byType(TextFormField).at(2), 'Test Product');
  
  // Save
  await tester.tap(find.text('SALVAR\nPRODUTO'));
  await tester.pumpAndSettle();
  
  // Verify product appears
  expect(find.text('Test Product'), findsOneWidget);
  
  // Select and delete
  await tester.tap(find.text('Test Product'));
  await tester.tap(find.text('REMOVER\nPRODUTO'));
  await tester.pumpAndSettle();
  
  // Verify product is gone
  expect(find.text('Test Product'), findsNothing);
});
```

## Common Patterns

### Error Handling
```dart
try {
  // Your operation
  await storage.addProduct(product);
  _showMessage('Success!');
} catch (e) {
  _showMessage('Error: $e', isError: true);
}
```

### Async Operations
```dart
Future<void> _loadData() async {
  final data = await storage.loadProducts();
  setState(() {
    _products = data;
  });
}
```

### Form Validation
```dart
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    if (condition) {
      return 'Validation error message';
    }
    return null;  // Valid
  },
)
```

## Performance Tips

1. **Minimize setState calls**: Only update what changed
2. **Use const constructors**: Reduces rebuilds
3. **Dispose controllers**: Prevent memory leaks
4. **Lazy load large lists**: Use ListView.builder
5. **Cache storage results**: Avoid repeated file reads

## Debugging

### Enable Debug Mode
```dart
// In main.dart
debugPrint('Message');  // Console logging
```

### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Common Issues

**Issue**: Products not persisting
- Check file path: `await _localFile`
- Verify JSON format: Use `json.encode()`
- Test serialization: `product.toJson()`

**Issue**: Form not validating
- Check `_formKey.currentState!.validate()`
- Ensure validators return null for valid input

**Issue**: UI not updating
- Wrap changes in `setState(() { })`
- Check if widget is mounted

## Best Practices

1. **Keep models simple**: Just data, no logic
2. **Service layer for I/O**: Separate concerns
3. **Validate all inputs**: Never trust user input
4. **Handle all errors**: Use try-catch
5. **Document your code**: Add comments for complex logic
6. **Write tests**: Test critical paths
7. **Use const**: For better performance
8. **Dispose resources**: Prevent leaks

## Code Style

Follow the Flutter style guide:
- Use `camelCase` for variables
- Use `PascalCase` for classes
- Prefix private with `_`
- Use `const` constructors when possible
- Format with `flutter format`

## Useful Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Format code
flutter format .

# Analyze code
flutter analyze

# Build release
flutter build apk --release

# Clean build
flutter clean
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design](https://material.io/design)
- [Flutter Packages](https://pub.dev)

## Contributing

When adding features:
1. Create a new branch
2. Write tests first (TDD)
3. Implement feature
4. Update documentation
5. Run tests and linting
6. Submit pull request

---

**Happy Developing! 🚀**
