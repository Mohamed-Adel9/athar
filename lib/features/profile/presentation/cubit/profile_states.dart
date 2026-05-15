import 'package:equatable/equatable.dart';

enum ProfileSection { none, orders, designs, settings, wishlist }

class ProfileState extends Equatable {
  final String name;
  final String email;
  final int orders;
  final int designs;
  final int wishlist;
  final ProfileSection selectedSection;

  const ProfileState({
    required this.name,
    required this.email,
    this.orders = 0,
    this.designs = 0,
    this.wishlist = 0,
    this.selectedSection = ProfileSection.none,
  });

  factory ProfileState.initial() => const ProfileState(
    name: 'محمد عادل',
    email: 'mohamed@example.com',
    orders: 12,
    designs: 5,
    wishlist: 8,
  );

  ProfileState copyWith({
    String? name,
    String? email,
    int? orders,
    int? designs,
    int? wishlist,
    ProfileSection? selectedSection,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      orders: orders ?? this.orders,
      designs: designs ?? this.designs,
      wishlist: wishlist ?? this.wishlist,
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    orders,
    designs,
    wishlist,
    selectedSection,
  ];
}
