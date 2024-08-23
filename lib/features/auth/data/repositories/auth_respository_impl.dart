import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/features/auth/data/datasources/auth_remote_data_sorce.dart';
import 'package:ai_blog/features/auth/data/model/user_model.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// AuthRepositoryImpl is used to connect the remote data source with the domain layer
// It will implement the AuthRepository interface

class AuthRepositoryImpl implements AuthRepository{

  // will not create instance of AuthRemoteDataSourceImpl  beacuse will not depend on how the implementaion is
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure,UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  })async{
    try{
      UserModel user = await  remoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password);
      return Right(user);
    }on ServerException catch(e){
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure,UserModel>> loginWithWithEmailPassword({
    required String email,
    required String password,
  })async{
    try{
      UserModel user = await  remoteDataSource.loginWithWithEmailPassword(email: email, password: password);
      return Right(user);
    }on ServerException catch(e){
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserCurrentData() async {
    try{
      UserModel? user = await remoteDataSource.getUserCurrentData();
      return Right(user!);
    }
    on ServerException catch(e){
      return Left(Failure(e.message));
    }
  }
  
  
}