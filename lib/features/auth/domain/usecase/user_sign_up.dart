import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/core/common/entities/user.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User,UserSignUpParams>{

  final AuthRepository authrepository;

  const UserSignUp(this.authrepository);

  @override
  Future<Either<Failure, User>> call(params) async {
    return await authrepository.signUpWithEmailPassword(name: params.name, email: params.email, password: params.password);
  }


}

// type of params to be passed to the usecase as generic
class UserSignUpParams{
  
  final String name;
  final String email;
  final String password;

  UserSignUpParams({required this.name,required this.email,required this.password});
  
}
