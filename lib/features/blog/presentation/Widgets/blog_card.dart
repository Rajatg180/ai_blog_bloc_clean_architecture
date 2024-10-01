import 'package:ai_blog/core/utils/calculate_reading_time.dart';
import 'package:ai_blog/features/blog/domain/entities/blog.dart';
import 'package:ai_blog/features/blog/presentation/Pages/blog_view_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {

  

  final Blog blog;

  final Color color;

  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BlogViewerPage.route(blog)
        );
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text('${calculateReadingTime(blog.content)} min read'),
          ],
        ),
      ),
    );
  }
}
