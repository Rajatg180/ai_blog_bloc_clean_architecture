import 'package:ai_blog/core/common/widgets/loader.dart';
import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:ai_blog/core/utils/show_snackbar.dart';
import 'package:ai_blog/features/blog/presentation/Bloc/bloc/blog_bloc.dart';
import 'package:ai_blog/features/blog/presentation/Pages/add_new_blog_page.dart';
import 'package:ai_blog/features/blog/presentation/Widgets/blog_card.dart';
import 'package:ai_blog/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(FetchAllBlog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Blogs',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.profile_circled,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewBlogPage(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                return BlogCard(
                  blog: state.blogs[index],
                  color: (index % 3 == 0)
                      ? AppPallete.gradient1
                      : (index % 3 == 1)
                          ? AppPallete.gradient2
                          : AppPallete.gradient3,
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
