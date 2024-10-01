
import 'dart:io';
import 'package:ai_blog/core/error/exception.dart';
import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/network/connection_checker.dart';
import 'package:ai_blog/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:ai_blog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:ai_blog/features/blog/data/models/blog_model.dart';
import 'package:ai_blog/features/blog/domain/repositories/blog_respositories.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {

  final BlogRemoteDataSource blogRemoteDataSource;

  final BlogLocalDataSource blogLocalDataSource;

  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDataSource,this.connectionChecker,this.blogLocalDataSource);


  @override
  Future<Either<Failure, BlogModel>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  })  async { 
    
    try{

      if(!await connectionChecker.isConnected){
        return Left(Failure("No Internet Connection"),);
      }
      
      BlogModel blogModel = BlogModel(id: const Uuid().v1(), posterId: posterId, title: title, content: content, imageUrl: '', topics: topics, updatedAt: DateTime.now(),);

      final imageUrl =  await blogRemoteDataSource.uploadBlogImage(image);

      // add imageUrl to with the blogModel

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return Right(uploadedBlog);

    }
    on ServerException catch(e){
      print("Error from blog_rep_impl :${e.message}");
      return Left(Failure(e.message));
    }

  }

  @override
  Future<Either<Failure, List<BlogModel>>> getAllBlogs() async {
    try{
      // check for connection 
      if(!await connectionChecker.isConnected){
        final blogs = blogLocalDataSource.loadBlogs();
        return Right(blogs); 
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      
      //  if there is internet connect upload all blogs to the local data storage
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      return Right(blogs);
    }
    on ServerException catch(e){
      print("Error from blog_rep_impl :${e.message}");
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlogById({required String id}) async {
    try{
      if(!await connectionChecker.isConnected){
        return Left(Failure("No Internet Connection"),);
      }
      await blogRemoteDataSource.deleteBlog(id);
      return const Right(null);
    }
    on ServerException catch(e){
      print("Error from blog_rep_impl :${e.message}");
      return Left(Failure(e.message));
    }
  }

  

}