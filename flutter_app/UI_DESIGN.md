# UI Design - Product Registration Form

## Screen Layout

```
┌─────────────────────────────────────────────┐
│  Cadastro de Produtos                    [×]│
├─────────────────────────────────────────────┤
│                                             │
│  ╔═══════════════════════════════════════╗ │
│  ║  Product Form                         ║ │
│  ╠═══════════════════════════════════════╣ │
│  ║                                       ║ │
│  ║  ┌─────────────────────────────────┐ ║ │
│  ║  │  ID Subproduto                  │ ║ │
│  ║  │  [  123  ]                   🔢 │ ║ │
│  ║  └─────────────────────────────────┘ ║ │
│  ║                                       ║ │
│  ║  ┌─────────────────────────────────┐ ║ │
│  ║  │  ID Produto                     │ ║ │
│  ║  │  [  456  ]                   🔢 │ ║ │
│  ║  └─────────────────────────────────┘ ║ │
│  ║                                       ║ │
│  ║  ┌─────────────────────────────────┐ ║ │
│  ║  │  Título do Produto              │ ║ │
│  ║  │  [  Product Name  ]          📝 │ ║ │
│  ║  └─────────────────────────────────┘ ║ │
│  ║                                       ║ │
│  ║  ┌────────┐ ┌────────┐ ┌─────────┐  ║ │
│  ║  │ ➕ NOVO│ │💾 SALVAR│ │🗑️ REMOVER│ ║ │
│  ║  │ PRODUTO│ │ PRODUTO│ │ PRODUTO │  ║ │
│  ║  └────────┘ └────────┘ └─────────┘  ║ │
│  ╚═══════════════════════════════════════╝ │
│                                             │
│  ╔═══════════════════════════════════════╗ │
│  ║  📋 Produtos Cadastrados              ║ │
│  ╠═══════════════════════════════════════╣ │
│  ║                                       ║ │
│  ║  ┌───────────────────────────────────┐║ │
│  ║  │ ① Product Alpha                   │║ │
│  ║  │   ID Produto: 100 | ID Sub: 1  ▶ │║ │
│  ║  ├───────────────────────────────────┤║ │
│  ║  │ ② Product Beta                    │║ │
│  ║  │   ID Produto: 200 | ID Sub: 2  ▶ │║ │
│  ║  ├───────────────────────────────────┤║ │
│  ║  │ ③ Product Gamma                   │║ │
│  ║  │   ID Produto: 300 | ID Sub: 3  ▶ │║ │
│  ║  └───────────────────────────────────┘║ │
│  ║                                       ║ │
│  ╚═══════════════════════════════════════╝ │
│                                             │
└─────────────────────────────────────────────┘
```

## Color Scheme

- **Primary Color**: Blue (#2196F3)
- **Secondary Color**: Light Blue (#BBDEFB)
- **Success Color**: Green (#4CAF50)
- **Error/Delete Color**: Red (#F44336)
- **Background**: White (#FFFFFF)
- **Card Background**: White with elevation shadow
- **Text**: Dark Grey (#212121)

## Button Colors

1. **NOVO PRODUTO** (New Product)
   - Background: Blue (#2196F3)
   - Text: White
   - Icon: ➕ Add Icon

2. **SALVAR PRODUTO** (Save Product)
   - Background: Green (#4CAF50)
   - Text: White
   - Icon: 💾 Save Icon

3. **REMOVER PRODUTO** (Remove Product)
   - Background: Red (#F44336)
   - Text: White
   - Icon: 🗑️ Delete Icon

## Input Fields

All input fields have:
- Outlined border
- Label text
- Prefix icon
- Validation error messages (shown in red below field)
- Focus state (blue border when selected)

## Product List Items

Each product in the list shows:
- Circular avatar with item number (1, 2, 3...)
- Product title in bold
- Product IDs in subtitle
- Arrow icon on the right (►)
- Selected state (light blue background when tapped)
- Tap to edit functionality

## Snackbar Messages

Success messages:
- Green background
- White text
- 3-second duration
- Appears at bottom of screen

Error messages:
- Red background
- White text
- 3-second duration
- Appears at bottom of screen

## Responsive Design

- Padding: 16px on all sides
- Card elevation: 4dp
- Button height: Adaptive to content
- Form fields: Full width with margin
- Spacing between elements: 16px

## Material Design Features

- Cards with elevation shadows
- Ripple effect on buttons and list items
- Smooth transitions when selecting products
- TextField focus animations
- Outlined input style
- Icon-labeled buttons
- Material color palette
- Consistent spacing and alignment
