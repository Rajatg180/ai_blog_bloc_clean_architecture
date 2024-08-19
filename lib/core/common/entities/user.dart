
// this user class is not doing anything but just holding the data 
// the UserModel class is used to convert the data from the firestore to the user class

class User{
  final String uid;
  final String email;
  final String userName;

  User({required this.uid, required this.email, required this.userName});
  
}