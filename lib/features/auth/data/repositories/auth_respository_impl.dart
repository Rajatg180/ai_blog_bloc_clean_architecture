import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/features/auth/data/datasources/auth_remote_data_sorce.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// AuthRepositoryImpl is used to connect the remote data source with the domain layer
// It will implement the AuthRepository interface

class AuthRepositoryImpl implements AuthRepository{

  // will not create instance of AuthRemoteDataSourceImpl  beacuse will not depend on how the implementaion is
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure,String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  })async{
    try{
      print("AuthRepositoryImpl");
      final userId = await  remoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password);
      return Right(userId);
    }on ServerException catch(e){
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure,String>> loginWithWithEmailPassword({
    required String email,
    required String password,
  })async{
    try{
      final userId = await  remoteDataSource.loginWithWithEmailPassword(email: email, password: password);
      return Right(userId);
    }on ServerException catch(e){
      return Left(Failure(e.message));
    }
  }
  
}