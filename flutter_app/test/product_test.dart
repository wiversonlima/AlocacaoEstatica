import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Product creation with valid data', () {
      final product = Product(
        idSubproduto: 1,
        idProduto: 100,
        titulo: 'Test Product',
      );

      expect(product.idSubproduto, 1);
      expect(product.idProduto, 100);
      expect(product.titulo, 'Test Product');
    });

    test('Product toJson conversion', () {
      final product = Product(
        idSubproduto: 1,
        idProduto: 100,
        titulo: 'Test Product',
      );

      final json = product.toJson();

      expect(json['id_subproduto'], 1);
      expect(json['id_produto'], 100);
      expect(json['titulo'], 'Test Product');
    });

    test('Product fromJson conversion', () {
      final json = {
        'id_subproduto': 1,
        'id_produto': 100,
        'titulo': 'Test Product',
      };

      final product = Product.fromJson(json);

      expect(product.idSubproduto, 1);
      expect(product.idProduto, 100);
      expect(product.titulo, 'Test Product');
    });

    test('Product toString', () {
      final product = Product(
        idSubproduto: 1,
        idProduto: 100,
        titulo: 'Test Product',
      );

      final str = product.toString();

      expect(str, contains('idSubproduto: 1'));
      expect(str, contains('idProduto: 100'));
      expect(str, contains('titulo: Test Product'));
    });
  });
}
