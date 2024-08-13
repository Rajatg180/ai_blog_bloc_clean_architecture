import 'package:ai_blog/core/common/widgets/loader.dart';
import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:ai_blog/core/utils/show_snackbar.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ai_blog/features/auth/presentation/pages/siginup_page.dart';
import 'package:ai_blog/features/auth/presentation/widgets/auth_field.dart';
import 'package:ai_blog/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // GlobalKey is used to uniquely identify the form and it is used to validate the form
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is AuthFailure){
                showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObscureText: true),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is AuthLoading)
                      const Loader() 
                  else
                  AuthGradientButton(
                      buttonText: 'Sign In',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(AuthLogin(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()));
                        }
                      }
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Rich Text is used to display text with different styles but in same line
                  GestureDetector(
                    onTap: () {
                      // one way to navigate to another page
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage(),),);

                      // another way to navigate to another page
                      Navigator.push(context, LoginPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        // using the default theme which is provided by the MaterialApp(flutter's default theme)
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
