import 'package:ai_blog/core/theme/theme.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ai_blog/features/auth/presentation/pages/login_page.dart';
import 'package:ai_blog/firebase_options.dart';
import 'package:ai_blog/init_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
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
        //         AuthRemoteDataSourceImpl(supabaseClient: supabase.client),
        //       ),
        //     ),
        //   ),
        // ),


        // using get it
        BlocProvider(
          create: (_) => serviveLocator<AuthBloc>(),
        ),



      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Blog App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: const LoginPage());
  }
}
