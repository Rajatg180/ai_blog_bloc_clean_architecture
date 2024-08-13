import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  // method to sign up with email and password
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  // method to login with email and password
  Future<UserModel> loginWithWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> loginWithWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try{

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(userCredential.user!);

      User? firebaseUser = userCredential.user;

      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .get();


      // Create a UserModel using fromJson
      UserModel userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

      return userModel;

    }catch(e){
      print(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
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

      return userModel;

    }catch(e){
      print("this is from auth_remote_data_source"+e.toString());
      throw ServerException(e.toString());
    }
    
  }
}
