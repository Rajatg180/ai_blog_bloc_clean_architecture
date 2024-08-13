import 'package:ai_blog/features/auth/domain/usecase/user_sign_in.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_blog/features/auth/domain/entities/user.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // UserSignUp from domain layer(UserSignUp usecase)
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  // AuthBloc constructor
  // we have taken userSignUp as a required parameter
  // and we have initialized it with the help of constructor

  AuthBloc({required UserSignUp userSignUp, required UserLogin userLogin})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      // start loading
      emit(AuthLoading());

      // call method in UserSignUp usecase had different properties we can call it without using function name as well we can directly call it with the help of object
      final res = await _userSignUp(UserSignUpParams(
          name: event.name, email: event.email, password: event.password));

      res.fold((failure) {
        emit(AuthFailure(failure.message));
      }, (user) {
        emit(AuthSuccess(user));
      });
    });


    // alternate method
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    // start loading
    emit(AuthLoading());

    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (user) {
      emit(AuthSuccess(user));
    });
  }


}
