import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String userName;

  UserModel({required this.uid, required this.email, required this.userName});

  // factory method to create UserModel from FirebaseUser
  UserModel.fromFirebaseUser(User user)
      : uid = user.uid,
        email = user.email!,
        userName = user.displayName!;

  // factory method to create UserModel from Json
  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        userName = json['userName'];
        

  // method to convert UserModel to Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
    };
  }

  // method to copy UserModel
  UserModel copyWith({String? uid, String? email, String? userName}) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
    );
  }

}


