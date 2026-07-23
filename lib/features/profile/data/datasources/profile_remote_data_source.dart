import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../../../designer/data/models/saved_design_model.dart';
import '../models/profile_model.dart';
import '../models/profile_order_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();

  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<ProfileModel> fetchProfile() async {
    final responses = await Future.wait([
      _dioService.get(url: ApiUrls.getProfile),
      _dioService.get(url: ApiUrls.orders),
      _dioService.get(url: ApiUrls.savedDesigns),
    ]);

    return ProfileModel.fromSources(
      user: _dataMap(responses[0].data),
      orders: _ordersFromResponse(responses[1].data),
      designs: _designsFromResponse(responses[2].data),
    );
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final response = await _dioService.put(
      url: ApiUrls.getProfile,
      data: {
        'name': name,
        'email': email,
      },
    );
    final current = await fetchProfile();
    final updatedUser = _dataMap(response.data);
    if (updatedUser.isEmpty) return current.copyWith(name: name, email: email);
    return current.copyWith(
      name: updatedUser['name']?.toString() ?? name,
      email: updatedUser['email']?.toString() ?? email,
      phone: updatedUser['phone']?.toString() ?? current.phone,
    );
  }

  List<ProfileOrderModel> _ordersFromResponse(Object? value) {
    final data = _map(_map(value)['data']);
    final orders = data['orders'];
    if (orders is Map<String, dynamic>) {
      return _list(orders['data']).map(ProfileOrderModel.fromJson).toList();
    }
    return _list(orders).map(ProfileOrderModel.fromJson).toList();
  }

  List<SavedDesignModel> _designsFromResponse(Object? value) {
    final designs = _map(_map(value)['data'])['designs'];
    if (designs is Map<String, dynamic>) {
      return _list(designs['data']).map(SavedDesignModel.fromJson).toList();
    }
    return _list(designs).map(SavedDesignModel.fromJson).toList();
  }

  Map<String, dynamic> _dataMap(Object? value) {
    final payload = _map(value);
    final data = _map(payload['data']);
    if (data['user'] is Map<String, dynamic>) {
      return _map(data['user']);
    }
    return data.isEmpty ? payload : data;
  }
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList();
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}
