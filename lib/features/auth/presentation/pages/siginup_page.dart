import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ai_blog/features/auth/presentation/pages/login_page.dart';
import 'package:ai_blog/features/auth/presentation/widgets/auth_field.dart';
import 'package:ai_blog/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {

  // route method is used to navigate to the LoginPage
  static  route()=>MaterialPageRoute(builder: (context) => const LoginPage(),);

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  // GlobalKey is used to uniquely identify the form and it is used to validate the form
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                AuthField(hintText: 'Username',controller: nameController,),
                const SizedBox(height: 15),
                AuthField(hintText: 'Email',controller: emailController,),
                const SizedBox(height: 15),
                AuthField(hintText: 'Password',controller: passwordController,isObscureText: true),
                const SizedBox(
                  height: 20,
                ),
                AuthGradientButton(buttonText: 'Sign Up',onPressed: () {
                  if(formKey.currentState!.validate()){
                    // call the signup method
                    print("validated");
                    context.read<AuthBloc>().add(AuthSignUp(email: emailController.text.trim(), password: passwordController.text.trim(), name: nameController.text.trim()));
                  }
                },),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SignUpPage.route());
                  },
                  child:RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    // using the default theme which is provided by the MaterialApp(flutter's default theme)+
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppPallete.gradient2,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
