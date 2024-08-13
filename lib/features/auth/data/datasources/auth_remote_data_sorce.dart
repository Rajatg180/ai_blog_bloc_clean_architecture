import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/features/auth/data/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  // method to sign up with email and password
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  // method to login with email and password
  Future<String> loginWithWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<String> loginWithWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return 'false';
  }

  @override
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {

      // create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print(userCredential.user!.uid);

      // Create a UserModel instance
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        userName: name,
      );

      // Add user to Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.doc(userModel.uid).set(userModel.toJson());

      return userCredential.user!.uid;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception(e.code);
      } else if (e.code == 'email-already-in-use') {
        throw Exception(e.code);
      } else {
        throw Exception(e.code);
      }
    } on FirebaseFirestore catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }
}
