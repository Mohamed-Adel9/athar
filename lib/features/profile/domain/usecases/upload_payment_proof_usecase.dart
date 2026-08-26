import 'dart:io';

import '../../../../core/utils/result.dart';
import '../../data/models/profile_order_model.dart';
import '../repositories/profile_repository.dart';

class UploadPaymentProofUseCase {
  const UploadPaymentProofUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<ProfileOrderModel>> call({
    required int orderId,
    required File proof,
  }) {
    return _repository.uploadPaymentProof(orderId: orderId, proof: proof);
  }
}
