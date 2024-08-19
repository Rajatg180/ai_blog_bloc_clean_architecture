// what is abstract interface class? 
// An abstract class is a class that cannot be instantiated, and is frequently either partially implemented, or not at all implemented.
// An interface is a contract between a class and the outside world, defining the methods that the class must implement.
// An abstract interface class is a class that cannot be instantiated, and is frequently either partially implemented, or not at all implemented and is a contract between a class and the outside world, defining the methods that the class must implement.
import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  // it will return either a success(string is type of success) or a error(Failure is type of error)

  // method to sign up with email and password
  Future<Either<Failure,User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  // method to login with email and password
  Future<Either<Failure,User>> loginWithWithEmailPassword({
    required String email,
    required String password,
  });

  // method to get the current user
  Future<Either<Failure,User>> getUserCurrentData();
  
}