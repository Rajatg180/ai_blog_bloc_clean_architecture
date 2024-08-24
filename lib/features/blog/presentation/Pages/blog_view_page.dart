import 'dart:ui';
import 'package:ai_blog/core/common/widgets/loader.dart';
import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:ai_blog/core/utils/calculate_reading_time.dart';
import 'package:ai_blog/core/utils/format_date.dart';
import 'package:ai_blog/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class BlogViewerPage extends StatefulWidget {
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          blog: blog,
        ),
      );

  final Blog blog;
  const BlogViewerPage({
    super.key,
    required this.blog,
  });

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool _isFetchingSummary = false;
  String _summary = '';

  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-pro', apiKey: "AIzaSyCI-BViPUvEpgYt9QJ4-YUuDzOVHNjL8yI");
    _chat = _model.startChat();
    super.initState();
  }

  Future<void> fetchBlogSummary(String content) async {
    setState(() {
      _isFetchingSummary = true;
    });

    final response = await _chat.sendMessage(
        Content.text("Please summarize the following blog content: $content"));

    setState(() {
      _isFetchingSummary = false;
      _summary = response.text.toString();
    });

    if (_summary.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Blog Summary'),
            content: Text(_summary),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _isFetchingSummary
                ? null
                : () => fetchBlogSummary(widget.blog.content),
            icon: _isFetchingSummary
                ? const Loader()
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
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
                            borderRadius: BorderRadius.circular(7),),
                        child: const  Text("Blog Summary"),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${widget.blog.posterName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(widget.blog.updatedAt)}   ${calculateReadingTime(widget.blog.content)} min read',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.blog.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
