class ApiUrls {
  const ApiUrls._();

  static const baseUrl = 'http://192.168.1.7:9000/api/';

  static const login = 'auth/login';
  static const googleLogin = 'auth/google';
  static const googleLoginEndpoints = [
    'auth/google',
    'auth/google-login',
    'auth/google/callback',
    'auth/social-login',
    'auth/social',
    'social-login',
    'google-login',
    'login/google',
    'auth/firebase',
    'firebase/login',
  ];
  static const register = 'auth/register';
  static const me = 'auth/me';
  static const logout = 'auth/logout';
  static const getProfile = 'user';
  static const home = '';
  static const products = 'products';
  static const wishlist = 'wishlist';
  static const cart = 'cart';
  static const cartItems = 'cart/items';
  static const promoCodeEndpoints = [
    'promocodes/validate',
    'promo-codes/apply',
    'promo-codes/validate',
    'promo-codes/check',
    'promo-codes/verify',
    'promo-code/apply',
    'promo-code/validate',
    'promo-code/check',
    'promo-code/verify',
    'promocodes/apply',
    'promocodes/check',
    'promocodes/verify',
    'promo_codes/apply',
    'promo_codes/validate',
    'promo_codes/check',
    'promo_codes/verify',
    'coupons/apply',
    'coupons/validate',
    'coupons/check',
    'coupons/verify',
  ];
  static const promoCodeListEndpoints = [
    'promo-codes',
    'promo-code',
    'promocodes',
    'promo_codes',
    'coupons',
  ];
  static const orders = 'orders';
  static const adminDashboard = 'admin/dashboard';
  static const adminProducts = 'admin/products';
  static const adminOrders = 'admin/orders';
  static const designTemplates = 'designs/templates';
  static const designStickers = 'designs/stickers';
  static const savedDesigns = 'designs/saved';

  static String productsByCategoryType(int id) => 'products/category-types/$id';

  static String productsByCategory(int id) => 'products/categories/$id';

  static String productDetails(int id) => 'products/$id';

  static String wishlistProduct(int productId) => 'wishlist/$productId';

  static String cartItem(String id) => 'cart/items/$id';

  static String orderPaymentProof(int orderId) =>
      'orders/$orderId/payment-proof';

  static String productColorVariants({
    required int productId,
    required int colorId,
  }) => 'products/$productId/colors/$colorId/variants';
}
