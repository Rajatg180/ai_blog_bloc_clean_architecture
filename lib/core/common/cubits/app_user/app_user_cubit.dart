import 'package:ai_blog/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {

  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user){

    // if user is null means emit initalstate which is userlogged out
    if(user == null){
      emit(AppUserInitial());
    }
    else{
      emit(AppUserLoggedIn(user));
    }

  }

}