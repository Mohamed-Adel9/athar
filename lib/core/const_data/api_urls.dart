class ApiUrls {
  const ApiUrls._();

  static const baseUrl = 'http://192.168.1.7:9000/api/';

  static const login = 'auth/login';
  static const register = 'auth/register';
  static const me = 'auth/me';
  static const logout = 'auth/logout';
  static const getProfile = 'user';
  static const home = '';
  static const products = 'products';
  static const designTemplates = 'designs/templates';
  static const designStickers = 'designs/stickers';
  static const savedDesigns = 'designs/saved';

  static String productsByCategoryType(int id) => 'products/category-types/$id';

  static String productsByCategory(int id) => 'products/categories/$id';

  static String productDetails(int id) => 'products/$id';

  static String productColorVariants({
    required int productId,
    required int colorId,
  }) => 'products/$productId/colors/$colorId/variants';
}
