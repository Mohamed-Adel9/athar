class ApiUrls {
  const ApiUrls._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://athar_back.test/api/',
  );

  static const login = 'auth/login';
  static const register = 'auth/register';
  static const me = 'auth/me';
  static const logout = '/auth/logout';
  static const getProfile = 'user';
}
