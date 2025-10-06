import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../services/product_storage.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idSubprodutoController = TextEditingController();
  final _idProdutoController = TextEditingController();
  final _tituloController = TextEditingController();
  final ProductStorage _storage = ProductStorage();
  
  List<Product> _products = [];
  int? _selectedProductIndex;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _idSubprodutoController.dispose();
    _idProdutoController.dispose();
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _storage.loadProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      _showMessage('Erro ao carregar produtos: $e', isError: true);
    }
  }

  void _clearForm() {
    _idSubprodutoController.clear();
    _idProdutoController.clear();
    _tituloController.clear();
    setState(() {
      _selectedProductIndex = null;
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final product = Product(
        idSubproduto: int.parse(_idSubprodutoController.text),
        idProduto: int.parse(_idProdutoController.text),
        titulo: _tituloController.text,
      );

      if (_selectedProductIndex != null) {
        // Update existing product
        await _storage.updateProduct(_selectedProductIndex!, product);
        _showMessage('Produto atualizado com sucesso!');
      } else {
        // Add new product
        await _storage.addProduct(product);
        _showMessage('Produto salvo com sucesso!');
      }

      _clearForm();
      await _loadProducts();
    } catch (e) {
      _showMessage('Erro ao salvar produto: $e', isError: true);
    }
  }

  Future<void> _removeProduct() async {
    if (_selectedProductIndex == null) {
      _showMessage('Selecione um produto para remover', isError: true);
      return;
    }

    try {
      await _storage.removeProduct(_selectedProductIndex!);
      _showMessage('Produto removido com sucesso!');
      _clearForm();
      await _loadProducts();
    } catch (e) {
      _showMessage('Erro ao remover produto: $e', isError: true);
    }
  }

  void _loadProductToForm(int index) {
    final product = _products[index];
    setState(() {
      _selectedProductIndex = index;
      _idSubprodutoController.text = product.idSubproduto.toString();
      _idProdutoController.text = product.idProduto.toString();
      _tituloController.text = product.titulo;
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Section
            Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _idSubprodutoController,
                        decoration: const InputDecoration(
                          labelText: 'ID Subproduto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o ID do subproduto';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Por favor, insira um número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idProdutoController,
                        decoration: const InputDecoration(
                          labelText: 'ID Produto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o ID do produto';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Por favor, insira um número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título do Produto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o título do produto';
                          }
                          if (value.length < 3) {
                            return 'O título deve ter pelo menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _clearForm,
                              icon: const Icon(Icons.add),
                              label: const Text('NOVO\nPRODUTO'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _saveProduct,
                              icon: const Icon(Icons.save),
                              label: const Text('SALVAR\nPRODUTO'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _removeProduct,
                              icon: const Icon(Icons.delete),
                              label: const Text('REMOVER\nPRODUTO'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Products List Section
            Expanded(
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.blue.shade100,
                      child: Row(
                        children: const [
                          Icon(Icons.list, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Produtos Cadastrados',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _products.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum produto cadastrado',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _products.length,
                              itemBuilder: (context, index) {
                                final product = _products[index];
                                final isSelected = _selectedProductIndex == index;
                                return ListTile(
                                  selected: isSelected,
                                  selectedTileColor: Colors.blue.shade50,
                                  leading: CircleAvatar(
                                    backgroundColor: isSelected
                                        ? Colors.blue
                                        : Colors.grey,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    product.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'ID Produto: ${product.idProduto} | ID Subproduto: ${product.idSubproduto}',
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () => _loadProductToForm(index),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
