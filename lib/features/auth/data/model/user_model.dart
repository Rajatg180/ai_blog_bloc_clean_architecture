import "package:ai_blog/core/common/entities/user.dart";

class UserModel extends User {

  UserModel({required super.uid, required super.email, required super.userName});

   // Method to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String,
    );
  }

  // method to convert UserModel to Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
    };
  }

}


