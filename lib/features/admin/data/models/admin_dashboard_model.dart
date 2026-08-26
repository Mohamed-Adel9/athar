import '../../../../core/const_data/api_urls.dart';

class AdminDashboardModel {
  const AdminDashboardModel({
    this.totalProducts = 0,
    this.featuredProducts = 0,
    this.normalProducts = 0,
    this.totalCategories = 0,
    this.totalReviews = 0,
    this.totalSliders = 0,
    this.totalDesignStickers = 0,
    this.totalSavedDesigns = 0,
    this.totalCartItems = 0,
    this.totalOrders = 0,
    this.totalUsers = 0,
    this.totalMessages = 0,
    this.revenue = 0,
    this.avgRating = 0,
    this.months = const [],
    this.monthsCount = const [],
    this.topCategories = const [],
    this.topColors = const [],
    this.latestProducts = const [],
    this.recentOrders = const [],
  });

  final int totalProducts;
  final int featuredProducts;
  final int normalProducts;
  final int totalCategories;
  final int totalReviews;
  final int totalSliders;
  final int totalDesignStickers;
  final int totalSavedDesigns;
  final int totalCartItems;
  final int totalOrders;
  final int totalUsers;
  final int totalMessages;
  final double revenue;
  final double avgRating;
  final List<String> months;
  final List<int> monthsCount;
  final List<AdminCategorySummaryModel> topCategories;
  final List<AdminColorSummaryModel> topColors;
  final List<AdminLatestProductModel> latestProducts;
  final List<AdminRecentOrderModel> recentOrders;

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']).isEmpty ? json : _map(json['data']);
    return AdminDashboardModel(
      totalProducts: _int(_pick(data, ['totalProducts', 'total_products', 'products_count', 'products'])),
      featuredProducts: _int(_pick(data, ['featuredProducts', 'featured_products'])),
      normalProducts: _int(_pick(data, ['normalProducts', 'normal_products'])),
      totalCategories: _int(_pick(data, ['totalCategories', 'total_categories', 'categories_count', 'categories'])),
      totalReviews: _int(_pick(data, ['totalReviews', 'total_reviews', 'reviews_count', 'reviews'])),
      totalSliders: _int(_pick(data, ['totalSliders', 'total_sliders', 'sliders_count', 'sliders'])),
      totalDesignStickers: _int(_pick(data, ['totalDesignStickers', 'total_design_stickers', 'design_stickers_count'])),
      totalSavedDesigns: _int(_pick(data, ['totalSavedDesigns', 'total_saved_designs', 'saved_designs_count'])),
      totalCartItems: _int(_pick(data, ['totalCartItems', 'total_cart_items', 'cart_items_count'])),
      totalOrders: _int(_pick(data, ['totalOrders', 'total_orders', 'orders_count', 'orders'])),
      totalUsers: _int(_pick(data, ['totalUsers', 'total_users', 'users_count', 'users'])),
      totalMessages: _int(_pick(data, ['totalMessages', 'total_messages', 'messages_count', 'messages'])),
      revenue: _double(_pick(data, ['revenue', 'total_revenue', 'sales', 'total_sales'])),
      avgRating: _double(_pick(data, ['avgRating', 'avg_rating', 'average_rating'])),
      months: _stringList(_pick(data, ['months', 'month_labels'])),
      monthsCount: _intList(_pick(data, ['monthsCount', 'months_count', 'monthly_orders', 'monthlySales'])),
      topCategories: _list(_pick(data, ['topCategories', 'top_categories']))
          .map(AdminCategorySummaryModel.fromJson)
          .toList(),
      topColors: _list(_pick(data, ['topColors', 'top_colors']))
          .map(AdminColorSummaryModel.fromJson)
          .toList(),
      latestProducts: _list(_pick(data, ['latestProducts', 'latest_products']))
          .map(AdminLatestProductModel.fromJson)
          .toList(),
      recentOrders: _list(_pick(data, ['recentOrders', 'recent_orders']))
          .map(AdminRecentOrderModel.fromJson)
          .toList(),
    );
  }
}

class AdminCategorySummaryModel {
  const AdminCategorySummaryModel({required this.name, required this.total});

  final String name;
  final int total;

  factory AdminCategorySummaryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategorySummaryModel(
      name: _localized(json['title'] ?? json['name'] ?? json['category']),
      total: _int(json['products_count'] ?? json['total'] ?? json['count']),
    );
  }
}

class AdminColorSummaryModel {
  const AdminColorSummaryModel({required this.name, required this.total});

  final String name;
  final int total;

  factory AdminColorSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdminColorSummaryModel(
      name: _localized(_map(json['color'])['name'] ?? json['name'] ?? json['color']),
      total: _int(json['total'] ?? json['count']),
    );
  }
}

class AdminLatestProductModel {
  const AdminLatestProductModel({
    required this.name,
    this.image,
    this.createdAt,
  });

  final String name;
  final String? image;
  final String? createdAt;

  factory AdminLatestProductModel.fromJson(Map<String, dynamic> json) {
    return AdminLatestProductModel(
      name: _localized(json['name'] ?? json['title']),
      image: _imageUrl(json['image_url'] ?? json['image']),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class AdminRecentOrderModel {
  const AdminRecentOrderModel({
    required this.id,
    required this.status,
    required this.total,
    this.customer,
    this.createdAt,
    this.paymentMethod = '',
    this.paymentProvider = '',
    this.paymentStatus = '',
    this.paymentProofUrl,
  });

  final int id;
  final String status;
  final double total;
  final String? customer;
  final String? createdAt;
  final String paymentMethod;
  final String paymentProvider;
  final String paymentStatus;
  final String? paymentProofUrl;

  bool get isInstapay {
    final method = paymentMethod.toLowerCase();
    final provider = paymentProvider.toLowerCase();
    return method.contains('instapay') || provider.contains('instapay');
  }

  factory AdminRecentOrderModel.fromJson(Map<String, dynamic> json) {
    final user = _map(json['user'] ?? json['customer']);
    final payment = _map(json['payment']);
    return AdminRecentOrderModel(
      id: _int(json['id']),
      status: json['status']?.toString() ?? '',
      total: _double(json['total']),
      customer: _localized(user['name'] ?? json['customer_name']),
      createdAt: json['created_at']?.toString(),
      paymentMethod:
          json['payment_method']?.toString() ??
          json['paymentMethod']?.toString() ??
          payment['method']?.toString() ??
          '',
      paymentProvider:
          json['payment_provider']?.toString() ??
          json['paymentProvider']?.toString() ??
          payment['provider']?.toString() ??
          '',
      paymentStatus:
          json['payment_status']?.toString() ??
          json['paymentStatus']?.toString() ??
          payment['status']?.toString() ??
          '',
      paymentProofUrl:
          json['payment_proof_url']?.toString() ??
          json['paymentProofUrl']?.toString() ??
          payment['proof_url']?.toString(),
    );
  }
}

Object? _pick(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key)) return json[key];
  }
  return null;
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList();
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
}

List<int> _intList(Object? value) {
  if (value is! List) return const [];
  return value.map(_int).toList();
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

String _localized(Object? value) {
  if (value is Map<String, dynamic>) {
    return value['ar']?.toString() ?? value['en']?.toString() ?? '';
  }
  return value?.toString() ?? '';
}

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String? _imageUrl(Object? value) {
  final path = value?.toString().trim();
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('assets/')) {
    return path;
  }

  final root = ApiUrls.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return '$root$normalizedPath';
}
