class ProductTypeModel {
  final String title;
  final String mockUpImage;

  const ProductTypeModel({required this.title, required this.mockUpImage});

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      title: json['title']?.toString() ?? '',
      mockUpImage:
          json['mock_up_image']?.toString() ??
          json['mockUpImage']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'mock_up_image': mockUpImage,
    };
  }

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
