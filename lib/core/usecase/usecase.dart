import 'package:ai_blog/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

// UseCase is used to connect the domain layer with the data layer
// It will implement the UseCase interface
// it will return either a success(successType(generics) is type of success) or a error(Failure is type of error)

abstract interface class UseCase<successType,Params>{

   Future<Either<Failure,successType>> call(Params params);
   
}