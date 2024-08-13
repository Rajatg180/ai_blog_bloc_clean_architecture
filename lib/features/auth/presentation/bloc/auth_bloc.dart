import 'package:ai_blog/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  // UserSignUp from domain layer(UserSignUp usecase)
  final UserSignUp _userSignUp;

  // AuthBloc constructor
  // we have taken userSignUp as a required parameter
  // and we have initialized it with the help of constructor
  
  AuthBloc({required UserSignUp userSignUp}) : _userSignUp = userSignUp , super(AuthInitial()) {
    
    on<AuthSignUp>((event,emit) async {

      // call method in UserSignUp usecase had different properties we can call it without using function name as well we can directly call it with the help of object
      final res = await _userSignUp(UserSignUpParams(name: event.name, email: event.email, password: event.password));
      
      res.fold((failure) {
        emit(AuthFailure(failure.message));
      }, (uid) {
        emit(AuthSuccess(uid));
      });

    });
    
  }
  
}
