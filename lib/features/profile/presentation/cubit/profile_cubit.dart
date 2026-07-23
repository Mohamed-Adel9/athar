import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._fetchProfileUseCase, this._updateProfileUseCase)
    : super(ProfileState.initial());

  final FetchProfileUseCase _fetchProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> fetchProfile({int? wishlistCount}) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        wishlist: wishlistCount,
        clearError: true,
      ),
    );

    final result = await _fetchProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          name: profile.name,
          email: profile.email,
          phone: profile.phone,
          orders: profile.orders.length,
          designs: profile.designs.length,
          orderItems: profile.orders,
          savedDesigns: profile.designs,
          wishlist: wishlistCount,
          status: ProfileStatus.success,
          clearError: true,
        ),
      ),
    );
  }

  void selectSection(ProfileSection section) {
    emit(state.copyWith(selectedSection: section));
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    emit(state.copyWith(isUpdating: true, clearError: true));
    final result = await _updateProfileUseCase(name: name, email: email);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUpdating: false,
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (profile) {
        emit(
          state.copyWith(
            name: profile.name,
            email: profile.email,
            phone: profile.phone,
            orders: profile.orders.length,
            designs: profile.designs.length,
            orderItems: profile.orders,
            savedDesigns: profile.designs,
            isUpdating: false,
            status: ProfileStatus.success,
            clearError: true,
          ),
        );
        return true;
      },
    );
  }

  void updateWishlistCount(int count) {
    emit(state.copyWith(wishlist: count));
  }
}
