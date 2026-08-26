import 'dart:io';

import '../../../../core/utils/result.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/profile_order_model.dart';

abstract class ProfileRepository {
  Future<Result<ProfileModel>> fetchProfile();

  Future<Result<ProfileModel>> updateProfile({
    required String name,
    required String email,
  });

  Future<Result<ProfileOrderModel>> uploadPaymentProof({
    required int orderId,
    required File proof,
  });
}
