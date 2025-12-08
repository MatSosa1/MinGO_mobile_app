import '../entities/sign.dart';
import '../repositories/sign_repository.dart';

class CreateSignUseCase {
  final SignRepository repository;

  CreateSignUseCase(this.repository);

  Future<Sign> call(Sign sign) async {
    return await repository.createSign(sign);
  }
}

class GetAllSignsUseCase {
  final SignRepository repository;

  GetAllSignsUseCase(this.repository);

  Future<List<Sign>> call() async {
    return await repository.getAllSigns();
  }
}

class GetSignByIdUseCase {
  final SignRepository repository;

  GetSignByIdUseCase(this.repository);

  Future<Sign?> call(int id) async {
    return await repository.getSignById(id);
  }
}
