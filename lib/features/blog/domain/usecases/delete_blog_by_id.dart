
import 'package:ai_blog/core/error/failures.dart';
import 'package:ai_blog/core/usecase/usecase.dart';
import 'package:ai_blog/features/blog/domain/repositories/blog_respositories.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlogById implements UseCase<void, String>{

  final BlogRepository blogRepository;

  DeleteBlogById(this.blogRepository);

  @override
  Future<Either<Failure,void>> call(String params) async {

    return await blogRepository.deleteBlogById(id: params);
    
  }

}