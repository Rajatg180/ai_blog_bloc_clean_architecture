import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/core/common/entities/user.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import "package:fpdart/fpdart.dart";

class UserLogin implements UseCase<User,UserLoginParams>{

  final AuthRepository authrepository;

  const UserLogin(this.authrepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authrepository.loginWithWithEmailPassword(email: params.email, password: params.password);
  }

}


class UserLoginParams{
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}