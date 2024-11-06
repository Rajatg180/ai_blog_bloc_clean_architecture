import 'package:ai_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ai_blog/core/theme/theme.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ai_blog/features/auth/presentation/pages/login_page.dart';
import 'package:ai_blog/features/blog/presentation/Bloc/bloc/blog_bloc.dart';
import 'package:ai_blog/features/blog/presentation/Pages/blog_page.dart';
import 'package:ai_blog/firebase_options.dart';
import 'package:ai_blog/init_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {

  // await dotenv.load(fileName: ".env");
  
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();

  // final supabase = await Supabase.initialize(url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnnonKey);

  runApp(
    MultiBlocProvider(

      providers: [
        
        // BlocProvider(
        //   create: (context) => AuthBloc(
        //     userSignUp: UserSignUp(
        //       AuthRepositoryImpl(
        //         AuthRemoteDataSourceImpl(),
        //       ),
        //     ),
        //   ),
        // ),

        BlocProvider(
          create: (_) => serviveLocator<AppUserCubit>(),
        ),

        // using get it
        BlocProvider(
          create: (_) => serviveLocator<AuthBloc>(),
        ),

        BlocProvider(
          create: (_) => serviveLocator<BlogBloc>(),
        ),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override

  void initState() {

    super.initState();
    
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    // added this
    context.read<BlogBloc>().add(FetchAllBlog());

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      // BlocSelector is used to select the state of the cubit
      // and based on the state we can move to different pages
      // here we are checking if user is logged in or not
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          // check if user is logged in or not
          // if logged in we will move to Homepage else to LoginPage
          if (state) {
            return const BlogPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
