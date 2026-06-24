class ProductTypeModel {
  final String title;
  final String mockUpImage;

  const ProductTypeModel({required this.title, required this.mockUpImage});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          mockUpImage == other.mockUpImage;

  @override
  int get hashCode => Object.hash(title, mockUpImage);

  @override
  String toString() => 'ProductTypeModel(title: $title)';
}
