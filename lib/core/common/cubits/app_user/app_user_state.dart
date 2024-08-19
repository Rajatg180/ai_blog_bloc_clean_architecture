part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

// AppUserInitial means AppUserLoggedOut
final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);
}



// core folder can not depends on other features 
// but other features can use core