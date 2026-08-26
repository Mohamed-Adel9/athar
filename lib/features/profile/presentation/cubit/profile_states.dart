import 'package:equatable/equatable.dart';

import '../../../designer/data/models/saved_design_model.dart';
import '../../data/models/profile_order_model.dart';

enum ProfileSection { none, orders, designs, settings, wishlist }
enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    required this.name,
    required this.email,
    this.phone,
    this.orders = 0,
    this.designs = 0,
    this.wishlist = 0,
    this.orderItems = const [],
    this.savedDesigns = const [],
    this.paymentProofs = const {},
    this.selectedSection = ProfileSection.none,
    this.status = ProfileStatus.initial,
    this.isUpdating = false,
    this.errorMessage,
  });

  final String name;
  final String email;
  final String? phone;
  final int orders;
  final int designs;
  final int wishlist;
  final List<ProfileOrderModel> orderItems;
  final List<SavedDesignModel> savedDesigns;
  final Map<int, String> paymentProofs;
  final ProfileSection selectedSection;
  final ProfileStatus status;
  final bool isUpdating;
  final String? errorMessage;

  factory ProfileState.initial() => const ProfileState(name: '', email: '');

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    int? orders,
    int? designs,
    int? wishlist,
    List<ProfileOrderModel>? orderItems,
    List<SavedDesignModel>? savedDesigns,
    Map<int, String>? paymentProofs,
    ProfileSection? selectedSection,
    ProfileStatus? status,
    bool? isUpdating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      orders: orders ?? this.orders,
      designs: designs ?? this.designs,
      wishlist: wishlist ?? this.wishlist,
      orderItems: orderItems ?? this.orderItems,
      savedDesigns: savedDesigns ?? this.savedDesigns,
      paymentProofs: paymentProofs ?? this.paymentProofs,
      selectedSection: selectedSection ?? this.selectedSection,
      status: status ?? this.status,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    orders,
    designs,
    wishlist,
    orderItems,
    savedDesigns,
    paymentProofs,
    selectedSection,
    status,
    isUpdating,
    errorMessage,
  ];
}
