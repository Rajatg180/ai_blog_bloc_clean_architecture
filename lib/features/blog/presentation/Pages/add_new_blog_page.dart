import 'dart:io';
import 'dart:ui';
import 'package:ai_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ai_blog/core/common/widgets/loader.dart';
import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:ai_blog/core/utils/pick_image.dart';
import 'package:ai_blog/core/utils/show_snackbar.dart';
import 'package:ai_blog/features/blog/presentation/Bloc/bloc/blog_bloc.dart';
import 'package:ai_blog/features/blog/presentation/Pages/blog_page.dart';
import 'package:ai_blog/features/blog/presentation/Widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final aiFormKey = GlobalKey<FormState>();

  List<String> seletedTopics = [];
  File? image;

  bool _isFetchingData = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-pro', apiKey: "AIzaSyCI-BViPUvEpgYt9QJ4-YUuDzOVHNjL8yI");
    _chat = _model.startChat();
    super.initState();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    } else {
      return null;
    }
  }

  void uploadBlog() {

    if (formKey.currentState!.validate() &&
        seletedTopics.isNotEmpty &&
        image != null) {

      final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.uid;

      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: seletedTopics,
            ),
          );
    }
  }

  Future<void> fetchBlogDescription(String description) async {

      setState(() {
        _isFetchingData = true;
      });

      final response = await _chat.sendMessage(Content.text(description));

      setState(() {
        _isFetchingData = false;
      });

      contentController.text = response.text.toString();

      descriptionController.clear();
    
  }

  void showAIDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: aiFormKey,
          child: AlertDialog(
            title: const Text('AI Blog Content Generator'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlogEditor(
                  controller: descriptionController,
                  hintText: 'Give a description of the blog',
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  
                  if (aiFormKey.currentState!.validate()) {

                    Navigator.of(context).pop();

                    String description =
                        "Generate a blog content for below description ${descriptionController.text.trim()}";

                    fetchBlogDescription(description);
                  }
                },
                child: const Text("Generate content"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              AddNewBlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          
          if (state is BlogLoading) {
            return const Loader();
          }
          return Stack(
            children: [
              (_isFetchingData)
                  ? Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              (image != null)
                                  ? GestureDetector(
                                      onTap: selectImage,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: selectImage,
                                      child: DottedBorder(
                                        color: Colors.grey,
                                        dashPattern: const [10, 4],
                                        radius: const Radius.circular(10),
                                        borderType: BorderType.RRect,
                                        strokeCap: StrokeCap.round,
                                        child: const SizedBox(
                                          height: 150,
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.folder_open,
                                                size: 40,
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                'Select your image',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: Row(
                                        children: [
                                          'Technology',
                                          'Business',
                                          'Programming',
                                          'Entertainment',
                                        ]
                                            .map(
                                              (e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (seletedTopics
                                                        .contains(e)) {
                                                      seletedTopics.remove(e);
                                                    } else {
                                                      seletedTopics.add(e);
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Chip(
                                                    label: Text(e),
                                                    color: seletedTopics
                                                            .contains(e)
                                                        ? const WidgetStatePropertyAll(
                                                            AppPallete
                                                                .gradient1)
                                                        : null,
                                                    side: seletedTopics
                                                            .contains(e)
                                                        ? null
                                                        : const BorderSide(
                                                            color: AppPallete
                                                                .borderColor,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  (_isFetchingData)
                                      ? const Loader()
                                      : IconButton(
                                          onPressed: showAIDialog,
                                          icon: const Icon(
                                              Icons.smart_toy_outlined),
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              BlogEditor(
                                controller: titleController,
                                hintText: 'Blog Title',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              BlogEditor(
                                controller: contentController,
                                hintText: 'Blog Content',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
