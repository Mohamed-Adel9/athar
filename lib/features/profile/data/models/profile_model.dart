import '../../../designer/data/models/saved_design_model.dart';
import 'profile_order_model.dart';

class ProfileModel {
  const ProfileModel({
    required this.name,
    required this.email,
    this.phone,
    this.orders = const [],
    this.designs = const [],
  });

  final String name;
  final String email;
  final String? phone;
  final List<ProfileOrderModel> orders;
  final List<SavedDesignModel> designs;

  factory ProfileModel.fromSources({
    required Map<String, dynamic> user,
    required List<ProfileOrderModel> orders,
    required List<SavedDesignModel> designs,
  }) {
    return ProfileModel(
      name: _readName(user),
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString(),
      orders: orders,
      designs: designs,
    );
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    List<ProfileOrderModel>? orders,
    List<SavedDesignModel>? designs,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      orders: orders ?? this.orders,
      designs: designs ?? this.designs,
    );
  }
}

String _readName(Map<String, dynamic> user) {
  final name = user['name']?.toString();
  if (name != null && name.isNotEmpty) return name;

  final firstName = user['first_name']?.toString();
  final lastName = user['last_name']?.toString();
  final fullName = [
    firstName,
    lastName,
  ].where((part) => part != null && part.isNotEmpty).join(' ');

  return fullName.isEmpty ? 'User' : fullName;
}
