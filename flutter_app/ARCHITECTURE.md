# Application Architecture

## Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         main.dart                           │
│                    (Application Entry)                      │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  MyApp (StatelessWidget)                              │ │
│  │  - MaterialApp configuration                          │ │
│  │  - Theme setup (Colors.blue)                          │ │
│  │  - Navigation setup                                   │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              product_form_screen.dart                       │
│           (Main UI - StatefulWidget)                        │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  ProductFormScreen                                    │ │
│  │  - Form management                                    │ │
│  │  - User input handling                                │ │
│  │  - UI rendering                                       │ │
│  │  - Event handling (button clicks)                     │ │
│  └───────────────────────────────────────────────────────┘ │
└──────────┬──────────────────────────────────┬───────────────┘
           │                                  │
           │ Uses                       Uses  │
           ▼                                  ▼
┌──────────────────────────┐    ┌────────────────────────────┐
│   product_storage.dart   │    │      product.dart          │
│   (Storage Service)      │    │      (Data Model)          │
│  ┌────────────────────┐  │    │  ┌──────────────────────┐ │
│  │ ProductStorage     │  │    │  │  Product             │ │
│  │                    │  │    │  │                      │ │
│  │ - saveProducts()   │  │    │  │  Fields:             │ │
│  │ - loadProducts()   │  │    │  │  - idSubproduto      │ │
│  │ - addProduct()     │  │    │  │  - idProduto         │ │
│  │ - updateProduct()  │  │    │  │  - titulo            │ │
│  │ - removeProduct()  │  │    │  │                      │ │
│  │ - clearProducts()  │  │    │  │  Methods:            │ │
│  └────────────────────┘  │    │  │  - toJson()          │ │
└──────────┬───────────────┘    │  │  - fromJson()        │ │
           │                    │  │  - toString()        │ │
           │ Uses               │  └──────────────────────┘ │
           ▼                    └────────────────────────────┘
┌──────────────────────────┐
│   path_provider package  │
│   (File System Access)   │
│  ┌────────────────────┐  │
│  │ getApplicationDocs │  │
│  │ Directory()        │  │
│  └────────────────────┘  │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│   Local File System      │
│                          │
│   products.json          │
│   ┌────────────────────┐ │
│   │ [                  │ │
│   │   {                │ │
│   │     id_subproduto  │ │
│   │     id_produto     │ │
│   │     titulo         │ │
│   │   }                │ │
│   │ ]                  │ │
│   └────────────────────┘ │
└──────────────────────────┘
```

## Data Flow

### 1. Create Product Flow
```
User Input → Form Validation → Product Object → Storage Service → JSON File
    ↓            ↓                   ↓                ↓               ↓
  [Form]    [Validate]          [Product()]     [addProduct()]   [Write]
    ↓            ↓                   ↓                ↓               ↓
  [Fill]     [Check]              [Create]         [Save]         [Persist]
    ↓            ↓                   ↓                ↓               ↓
  [Submit]   [Pass/Fail]          [Serialize]      [Update]       [Success]
```

### 2. Read Products Flow
```
App Launch → Storage Service → JSON File → Product List → UI Display
     ↓             ↓              ↓            ↓             ↓
  [Init]     [loadProducts()]  [Read]    [Deserialize]  [Render]
     ↓             ↓              ↓            ↓             ↓
  [Mount]      [Fetch]         [Parse]   [Create List]  [ListView]
```

### 3. Update Product Flow
```
User Select → Load to Form → User Edit → Validate → Update Object → Save
     ↓             ↓             ↓          ↓           ↓            ↓
 [Click Item]  [Populate]   [Modify]   [Check]    [Product()]   [Update]
     ↓             ↓             ↓          ↓           ↓            ↓
 [Set Index]   [Fill Form]  [Change]   [Pass]     [Serialize]   [Write]
```

### 4. Delete Product Flow
```
User Select → Confirm Delete → Remove from List → Save List → Update UI
     ↓              ↓                ↓                ↓           ↓
 [Click Item]   [Button Click]  [removeAt()]    [saveProducts()]  [Refresh]
     ↓              ↓                ↓                ↓           ↓
 [Set Index]    [Execute]       [Delete]        [Write File]   [Render]
```

## State Management

```
ProductFormScreen State:
├── _formKey (GlobalKey<FormState>)
├── _idSubprodutoController (TextEditingController)
├── _idProdutoController (TextEditingController)
├── _tituloController (TextEditingController)
├── _storage (ProductStorage)
├── _products (List<Product>)
└── _selectedProductIndex (int?)

State Changes Trigger:
├── initState() → Load products from storage
├── User Input → Form field updates
├── Button Click → CRUD operation
├── Operation Success → setState() → UI Rebuild
└── dispose() → Clean up controllers
```

## File I/O Operations

```
Write Operation:
Product List → JSON Encode → String → Write to File → Disk Storage

Read Operation:
Disk Storage → Read File → String → JSON Decode → Product List
```

## Error Handling

```
User Action
    ↓
Try {
    Form Validation
        ↓ (pass)
    Storage Operation
        ↓ (success)
    Update UI
        ↓
    Show Success Message
}
    ↓ (fail)
Catch {
    Log Error
        ↓
    Show Error Message (SnackBar)
        ↓
    Maintain Current State
}
```

## UI Component Hierarchy

```
Scaffold
├── AppBar
│   └── Title: "Cadastro de Produtos"
└── Body (Column)
    ├── Form Card
    │   ├── ID Subproduto (TextFormField)
    │   ├── ID Produto (TextFormField)
    │   ├── Título (TextFormField)
    │   └── Button Row
    │       ├── NOVO PRODUTO (ElevatedButton)
    │       ├── SALVAR PRODUTO (ElevatedButton)
    │       └── REMOVER PRODUTO (ElevatedButton)
    └── Product List Card
        ├── Header
        └── ListView
            └── ListTile (for each product)
                ├── CircleAvatar (number)
                ├── Title (product name)
                ├── Subtitle (IDs)
                └── Trailing (arrow)
```

## Dependency Graph

```
main.dart
    └── depends on: flutter/material
    └── depends on: screens/product_form_screen

product_form_screen.dart
    └── depends on: flutter/material
    └── depends on: flutter/services
    └── depends on: models/product
    └── depends on: services/product_storage

product_storage.dart
    └── depends on: dart:convert
    └── depends on: dart:io
    └── depends on: path_provider
    └── depends on: models/product

product.dart
    └── depends on: (none - pure Dart)
```

## Key Design Patterns

1. **MVC Pattern**
   - Model: `Product` class
   - View: `ProductFormScreen` UI
   - Controller: State management in `_ProductFormScreenState`

2. **Repository Pattern**
   - `ProductStorage` acts as repository
   - Abstracts data persistence details
   - Single source of truth for products

3. **Singleton-like Service**
   - Each screen instance has its own `ProductStorage`
   - But storage points to same JSON file
   - Ensures data consistency

4. **Form Management**
   - Controllers for each input field
   - Form validation with GlobalKey
   - Proper disposal of resources

5. **Error Handling**
   - Try-catch for all async operations
   - User-friendly error messages
   - Graceful degradation
