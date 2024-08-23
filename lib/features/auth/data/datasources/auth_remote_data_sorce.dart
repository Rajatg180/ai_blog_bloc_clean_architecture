import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {

  // getter for getting the usertoken 
  Future<String?> get userToken; 

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

  // method to geting the current user
  Future<UserModel?> getUserCurrentData();
  
}


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  AuthRemoteDataSourceImpl();

  // getting the user token
  @override
  Future<String?> get userToken async => await FirebaseAuth.instance.currentUser?.getIdToken();

  
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

  // geting the currentUser and persist the state of user
  @override
  Future<UserModel?> getUserCurrentData() async {

    try{

      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if(firebaseUser!=null){
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

        if(userDoc.exists){
          UserModel userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
          print("user found");
          return userModel;
        }
        else{
          print("user not found");
          throw ServerException("User not found");
        }
      }
      else{
        print("no user is currenlty signed in");
        throw ServerException("No user is currently signed in ");
      }

    }
    catch(e){
      print("error in fetching the current user data");
      throw ServerException(e.toString());
    }
  }

  
}
