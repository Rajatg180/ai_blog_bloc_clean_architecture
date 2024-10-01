import 'package:ai_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ai_blog/core/common/widgets/loader.dart';
import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:ai_blog/core/utils/show_snackbar.dart';
import 'package:ai_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ai_blog/features/auth/presentation/pages/login_page.dart';
import 'package:ai_blog/features/blog/domain/entities/blog.dart';
import 'package:ai_blog/features/blog/presentation/Bloc/bloc/blog_bloc.dart';
import 'package:ai_blog/features/blog/presentation/Pages/blog_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool _isExpanded = false; // Track if "Your Blogs" section is expanded

  List<Blog> userBlogs = [];

  @override
  void initState() {
    super.initState();
  }

  void _fetchUserBlogs() {
    if (!_isExpanded) {
      context.read<BlogBloc>().add(FetchAllBlog());
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${state.user.userName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.gradient2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${state.user.email}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _fetchUserBlogs,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: !_isExpanded
                                ? AppPallete.borderColor
                                : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Blogs',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    BlocConsumer<BlogBloc, BlogState>(
                      listener: (context, blogState) {
                        if (blogState is BlogFailure) {
                          return showSnackBar(context, blogState.error);
                        }
                      },
                      builder: (context, blogState) {
                        if (blogState is BlogLoading) {
                          return const Loader();
                        }

                        if (blogState is BlogsDisplaySuccess) {
                          // Filter blogs based on the current user's ID
                          final userBlogs = blogState.blogs
                              .where((blog) => blog.posterId == state.user.uid)
                              .toList();

                          if (userBlogs.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'No blogs found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: userBlogs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          userBlogs[index].title,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        trailing:
                                            const Icon(Icons.chevron_right),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            BlogViewerPage.route(
                                              userBlogs[index],
                                            ),
                                          );
                                        },
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                        ),
                                        height: 1.0,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppPallete.gradient1,
                                              AppPallete.gradient2,
                                              AppPallete.gradient3,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(UserSignOut());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppPallete.gradient1,
                              AppPallete.gradient2,
                              AppPallete.gradient3,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "LogOut   ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                            Icon(Icons.logout),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        listener: (context, state) {
          if (state is AppUserInitial) {
            print("moving");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
