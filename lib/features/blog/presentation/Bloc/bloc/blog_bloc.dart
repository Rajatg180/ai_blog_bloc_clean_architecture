import 'dart:io';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/features/blog/domain/entities/blog.dart';
import 'package:ai_blog/features/blog/domain/usecases/get_all_blog.dart';
import 'package:ai_blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  
  final UploadBlog _uploadBlog;
  final GetAllBlog _getAllBlog;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlog getAllBlogs
  }) : 
      _uploadBlog = uploadBlog,
      _getAllBlog = getAllBlogs,
      super(BlogInitial()) {

    on<BlogEvent>((event, emit) {
      // start loading for any emit caused
      emit(BlogInitial());

      on<BlogUpload>(_onBlogUpload);

      on<FetchAllBlog>(_onFetchAllBlog);

    });
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {

    emit(BlogLoading());

    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics
      ),
    );

    res.fold(
      
      (l) => emit(
        BlogFailure(l.message),
      ),
      (r) => emit(
        BlogUploadSuccess(),
      ),
    );

  }

  void _onFetchAllBlog(FetchAllBlog event, Emitter<BlogState> emit) async {

      emit(BlogLoading());

      final res = await _getAllBlog(NoParams());

      res.fold(
      
      (l) => emit(
        BlogFailure(l.message),
      ),
      (r) => emit(
        BlogsDisplaySuccess(r),
      ),
    );


  }

}