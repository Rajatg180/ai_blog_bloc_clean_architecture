import 'dart:io';

import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/features/blog/data/models/blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class BlogRemoteDataSource {
  // method to get all blogs
  Future<List<BlogModel>> getAllBlogs();

  // method to get a blog by id
  // Future<BlogModel> getBlogById(String id);

  // method to create a blog
  Future<BlogModel> uploadBlog(BlogModel blog);

  // method to upload a blog image
  Future<String> uploadBlogImage(File image);

  // method to update a blog
  // Future<BlogModel> updateBlog(BlogModel blog);

  // method to delete a blog
  Future<void> deleteBlog(String id);
}


class BlogRemoteDataSourceImpl extends BlogRemoteDataSource {

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      // code to upload blog to the server

      CollectionReference collRef =
          FirebaseFirestore.instance.collection('blogs');

      DocumentReference doc = collRef.doc(blog.id);

      await doc.set(blog.toJson());

      DocumentSnapshot docSnap = await doc.get();

      return BlogModel.fromJson(docSnap.data() as Map<String, dynamic>);
    } catch (e) {
      print("error from blog_remote_data source : ${e.toString()}");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref =
          storage.ref().child('blog_images/${DateTime.now().toString()}');

      UploadTask uploadTask = ref.putFile(image);

      String downloadURL = await (await uploadTask).ref.getDownloadURL();

      print("File uploaded successfully. URL: $downloadURL");

      return downloadURL;
    } catch (e) {
      print("error while uploading image");
      throw ServerException(e.toString());
    }
  }

   @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // Get all blogs from the server
      QuerySnapshot querySnap =
          await FirebaseFirestore.instance.collection('blogs').get();
      
      List<BlogModel> blogs = [];

      for (var doc in querySnap.docs) {

        BlogModel blog = BlogModel.fromJson(doc.data() as Map<String, dynamic>);

        // Fetch poster's name from the profiles collection using the posterId
        DocumentSnapshot profileSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(blog.posterId)
            .get();
        
        String? posterName = profileSnap['userName'] as String?;

        // Update the blog model with the poster's name
        blog = blog.copyWith(posterName: posterName ?? 'Unknown');

        blogs.add(blog);

      }

      print("this is length of blogs ${blogs.length}");

      return blogs;

    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String id) async {
    try {
      await FirebaseFirestore.instance.collection('blogs').doc(id).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  
}
