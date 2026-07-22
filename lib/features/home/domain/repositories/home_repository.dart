import '../../../../core/utils/result.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<Result<HomeDataEntity>> fetchHome();
}
