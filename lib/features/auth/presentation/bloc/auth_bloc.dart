import 'package:ai_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/features/auth/domain/usecase/current_user.dart';
import 'package:ai_blog/features/auth/domain/usecase/sign_out_user.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_in.dart';
import 'package:ai_blog/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_blog/core/common/entities/user.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  // UserSignUp from domain layer
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final SignOutUser _signOutUser;

  // AuthBloc constructor
  // we have taken userSignUp as a required parameter
  // and we have initialized it with the help of constructor

  AuthBloc({
      required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit,
      required SignOutUser signOutUser,
    }): 
      _userSignUp = userSignUp,
      _userLogin = userLogin,
      _currentUser = currentUser,
      _appUserCubit = appUserCubit,
      _signOutUser = signOutUser,
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
        _emitAuthSuccess(user,emit);
      });
    });

    // alternate method
    on<AuthLogin>(_onAuthLogin);


    on<AuthIsUserLoggedIn>((event, emit) async {

      // emit(AuthLoading());

      final res = await _currentUser(NoParams());

      res.fold((failure) {
        print(failure.message);
      }, (user) {
        print(user.email);
        _emitAuthSuccess(user,emit);
      });
    });

    on<UserSignOut>((event, emit) async {

      final res = await _signOutUser(NoParams());

      res.fold((failure) {
        emit(AuthFailure(failure.message));
      }, (user) {
        _appUserCubit.logout();
        emit(UserSignOutSuccess());
      });
    });

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
      _emitAuthSuccess(user,emit);
    });
  }


  // function which will emit the state of the user
  void _emitAuthSuccess(User user,Emitter<AuthState> emit){

    print("navigating");

    // update the user
    _appUserCubit.updateUser(user);

    emit(AuthSuccess(user));

  }

}
