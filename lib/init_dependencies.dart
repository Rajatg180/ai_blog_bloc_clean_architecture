import 'package:ai_blog/features/auth/data/datasources/auth_remote_data_sorce.dart';
import 'package:ai_blog/features/auth/data/repositories/auth_respository_impl.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_in.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_up.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final serviveLocator = GetIt.instance;

// registerLazySingleton is used to register the dependencies that are used only once in the app only one instance is created
// registerFactory is used to register the dependencies that are used multiple times in the app multiple instances are created

Future<void> initDependencies() async {
  
  _initAuth();

  print("connected");

}


void _initAuth() 
{
  serviveLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  serviveLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviveLocator()),
  );

  serviveLocator.registerFactory(
    () => UserSignUp(serviveLocator()),
  );

  serviveLocator.registerFactory(
    () => UserLogin(serviveLocator()),
  );

  // ONLY ONE INSTANCE OF THE Auth BLOC IS CREATED because to persist the state of the user
  serviveLocator.registerLazySingleton(
    () => AuthBloc(userSignUp: serviveLocator(), userLogin: serviveLocator()),
  );
  
}
