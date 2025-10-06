class Product {
  int idSubproduto;
  int idProduto;
  String titulo;

  Product({
    required this.idSubproduto,
    required this.idProduto,
    required this.titulo,
  });

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_subproduto': idSubproduto,
      'id_produto': idProduto,
      'titulo': titulo,
    };
  }

  // Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idSubproduto: json['id_subproduto'] as int,
      idProduto: json['id_produto'] as int,
      titulo: json['titulo'] as String,
    );
  }

  @override
  String toString() {
    return 'Product{idSubproduto: $idSubproduto, idProduto: $idProduto, titulo: $titulo}';
  }
}
