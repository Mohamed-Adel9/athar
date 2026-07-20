import 'package:athar/core/failure/api_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/failure/failure.dart';
import '../database/splash_data.dart';
import 'splash_repo.dart';

class SplashRepoImpl extends SplashRepo {
  final SplashData splashData;
  SplashRepoImpl({required this.splashData});

  @override
  Future<Either<Failure, Response>> login() async {
    try {
      return Right(await splashData.login());
    } catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
