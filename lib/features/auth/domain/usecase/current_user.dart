import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/core/common/entities/user.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class CurrentUser implements UseCase<User,NoParams>{

  final AuthRepository authrepository;

  const CurrentUser(this.authrepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authrepository.getUserCurrentData();
  } 

}

