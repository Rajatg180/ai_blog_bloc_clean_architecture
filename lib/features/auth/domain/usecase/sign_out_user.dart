
import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class SignOutUser implements UseCase<void,NoParams> {

  final AuthRepository authRepository;

  const SignOutUser(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signOut();
  }

}