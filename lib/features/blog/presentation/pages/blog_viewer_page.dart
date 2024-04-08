// Importing necessary Dart packages and local modules for styling, utilities, and domain entities.
import 'package:blog_app/core/theme/app_pallete.dart'; // Application color palette for consistent styling.
import 'package:blog_app/core/utils/calculate_reading_time.dart'; // Utility to calculate the reading time of a blog post.
// The next import line is commented out, suggesting an alternate or deprecated utility for formatting dates.
// import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart'; // The Blog entity representing the blog post's data model.
import 'package:flutter/material.dart'; // Material package for Flutter's UI components.

import '../../../../core/utils/format_data.dart'; // Utility for formatting data, possibly dates in this context.

// BlogViewerPage is a StatelessWidget, meaning its properties won't change over time.
class BlogViewerPage extends StatelessWidget {
  // Static method to easily create a route for navigation to this page, taking a Blog object as an argument.
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          blog: blog,
        ),
      );

  final Blog
      blog; // Declaring a final property to hold the Blog object passed to this widget.

  // Constructor requiring a Blog object and optionally a key.
  const BlogViewerPage({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    // Building the UI of the page.
    return Scaffold(
      appBar: AppBar(), // A simple AppBar with default styling.
      body: Scrollbar(
        // Wrapping the content in a Scrollbar for better scroll feedback.
        child: SingleChildScrollView(
          // Making the body scrollable to accommodate content of any length.
          child: Padding(
            // Adding padding around the entire content for visual spacing.
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Using a Column widget to arrange content vertically.
              crossAxisAlignment: CrossAxisAlignment.start,
              // Aligning content to the start of the cross axis (left in this case).
              children: [
                Text(
                  blog.title, // Displaying the blog title.
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), // Providing vertical spacing.
                Text(
                  'By ${blog.posterName}', // Displaying the name of the poster.
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5), // More vertical spacing.
                Text(
                  // Displaying the formatted blog update date and calculated reading time.
                  '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20), // Vertical spacing.
                ClipRRect(
                  // Wrapping the image in a ClipRRect for rounded corners.
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      blog.imageUrl), // Displaying the blog's image from a URL.
                ),
                const SizedBox(height: 20), // Vertical spacing.
                Text(
                  blog.content, // Displaying the blog's content.
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2, // Line height for better readability.
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
