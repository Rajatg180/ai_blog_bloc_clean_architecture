import 'dart:io';

import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  
  Future<Either<Failure, Blog>> uploadBlog({
    
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,

  });

  Future<Either<Failure,List<Blog>>> getAllBlogs();


  Future<Either<Failure,void>> deleteBlogById({
    required String id
  });

}