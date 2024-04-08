// Import statements to include necessary Dart and Flutter packages as well as specific application modules.
import 'package:blog_app/core/common/widgets/loader.dart'; // Imports a custom loading widget for displaying loading indicators.
import 'package:blog_app/core/theme/app_pallete.dart'; // Imports the application's color palette for UI theming.
import 'package:blog_app/core/utils/show_snackbar.dart'; // Utility function to display snackbars for brief messages.
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart'; // Bloc related to blog functionalities (state management).
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart'; // Page to add a new blog post.
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart'; // Custom widget to display a blog card.
import 'package:flutter/cupertino.dart'; // Flutter package for iOS style widgets.
import 'package:flutter/material.dart'; // Material package for material design widgets.
import 'package:flutter_bloc/flutter_bloc.dart'; // Package for integrating Bloc pattern in Flutter.

// Declaration of the BlogPage StatefulWidget.
class BlogPage extends StatefulWidget {
  // Static method to generate route for BlogPage navigation.
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  
  const BlogPage({super.key}); // Constructor with an optional key argument.

  @override
  // Creating state for the StatefulWidget.
  State<BlogPage> createState() => _BlogPageState();
}

// State class for the BlogPage widget.
class _BlogPageState extends State<BlogPage> {
  @override
  // initState is the first method called when the widget is created (after the constructor), to initialize the state.
  void initState() {
    super.initState();
    // Triggering the fetching of all blog posts when the widget is initialized.
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  // Widget build method to construct the UI.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar configuration with a title and an action button.
        title: const Text('Blog App'),
        actions: [
          IconButton(
            // IconButton to navigate to the AddNewBlogPage.
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(
              CupertinoIcons.add_circled, // Using Cupertino (iOS style) icon.
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        // BlocConsumer to listen to BlogBloc state changes and build UI accordingly.
        listener: (context, state) {
          // Listener to handle failure state by showing a snackbar.
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          // Building UI based on the current state.
          if (state is BlogLoading) {
            // Displaying loader widget while data is being fetched.
            return const Loader();
          }
          if (state is BlogsDisplaySuccess) {
            // Displaying list of blogs if data is fetched successfully.
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                // For each blog, a BlogCard widget is used to display its information.
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  // Alternating card colors based on the index.
                  color: index % 2 == 0
                      ? AppPallete.gradient1
                      : AppPallete.gradient2,
                );
              },
            );
          }
          // Returning an empty widget in case no other states match.
          return const SizedBox();
        },
      ),
    );
  }
}
