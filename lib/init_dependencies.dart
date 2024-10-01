import 'package:ai_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ai_blog/core/network/connection_checker.dart';
import 'package:ai_blog/features/auth/data/datasources/auth_remote_data_sorce.dart';
import 'package:ai_blog/features/auth/data/repositories/auth_respository_impl.dart';
import 'package:ai_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:ai_blog/features/auth/domain/usecase/current_user.dart';
import 'package:ai_blog/features/auth/domain/usecase/sign_out_user.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_in.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_up.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ai_blog/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:ai_blog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:ai_blog/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:ai_blog/features/blog/domain/repositories/blog_respositories.dart';
import 'package:ai_blog/features/blog/domain/usecases/delete_blog_by_id.dart';
import 'package:ai_blog/features/blog/domain/usecases/get_all_blog.dart';
import 'package:ai_blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:ai_blog/features/blog/presentation/Bloc/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';

final serviveLocator = GetIt.instance;

// registerLazySingleton is used to register the dependencies that are used only once in the app only one instance is created
// registerFactory is used to register the dependencies that are used multiple times in the app multiple instances are created

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  serviveLocator.registerFactory(
    () => InternetConnectionChecker(),
  );

  // getting the path for local storage
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  // register the hive box
  serviveLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );

  // core
  serviveLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  serviveLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviveLocator(),
    ),
  );

  print("connected");
}

void _initAuth() {
  serviveLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  serviveLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviveLocator(), serviveLocator()),
  );

  serviveLocator.registerFactory(
    () => UserSignUp(
      serviveLocator(),
    ),
  );

  serviveLocator.registerFactory(
    () => UserLogin(
      serviveLocator(),
    ),
  );

  serviveLocator.registerFactory(
    () => CurrentUser(
      serviveLocator(),
    ),
  );

  serviveLocator.registerFactory(() => SignOutUser(
        serviveLocator(),
      ));

  // ONLY ONE INSTANCE OF THE Auth BLOC IS CREATED because to persist the state of the user
  serviveLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviveLocator(),
      userLogin: serviveLocator(),
      currentUser: serviveLocator(),
      appUserCubit: serviveLocator(),
      signOutUser: serviveLocator(),
    ),
  );
}

void _initBlog() {
  serviveLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(),
  );

  serviveLocator.registerFactory<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(
      serviveLocator(),
    ),
  );

  serviveLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      serviveLocator(),
      serviveLocator(),
      serviveLocator(),
    ),
  );

  serviveLocator.registerFactory(
    () => UploadBlog(
      serviveLocator(),
    ),
  );

  serviveLocator.registerFactory(() => GetAllBlog(serviveLocator()));

  serviveLocator.registerFactory(() => DeleteBlogById(serviveLocator()));

  serviveLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviveLocator(),
      getAllBlogs: serviveLocator(),
      deleteBlogById: serviveLocator(),
    ),
  );
}
