import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class ProductStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/products.json');
  }

  // Save products to JSON file
  Future<void> saveProducts(List<Product> products) async {
    try {
      final file = await _localFile;
      final List<Map<String, dynamic>> jsonList =
          products.map((product) => product.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      throw Exception('Erro ao salvar produtos: $e');
    }
  }

  // Load products from JSON file
  Future<List<Product>> loadProducts() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar produtos: $e');
    }
  }

  // Add a product
  Future<void> addProduct(Product product) async {
    final products = await loadProducts();
    products.add(product);
    await saveProducts(products);
  }

  // Update a product by index
  Future<void> updateProduct(int index, Product product) async {
    final products = await loadProducts();
    if (index >= 0 && index < products.length) {
      products[index] = product;
      await saveProducts(products);
    }
  }

  // Remove a product by index
  Future<void> removeProduct(int index) async {
    final products = await loadProducts();
    if (index >= 0 && index < products.length) {
      products.removeAt(index);
      await saveProducts(products);
    }
  }

  // Clear all products
  Future<void> clearProducts() async {
    await saveProducts([]);
  }
}
