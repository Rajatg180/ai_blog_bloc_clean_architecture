import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/features/blog/domain/entities/blog.dart';
import 'package:ai_blog/features/blog/domain/repositories/blog_respositories.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlog implements UseCase<List<Blog>,NoParams> {

  final BlogRepository blogRepository;

  GetAllBlog(this.blogRepository);

  @override
  Future<Either<Failure,List<Blog>>> call(NoParams params) async {

    return await blogRepository.getAllBlogs();
    
  }

}