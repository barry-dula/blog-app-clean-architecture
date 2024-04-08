// Importing necessary Dart, Flutter, and project-specific packages.
import 'dart:io'; // For working with files.

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart'; // Bloc for user management.
import 'package:blog_app/core/common/widgets/loader.dart'; // Custom widget for loading indication.
import 'package:blog_app/core/constants/constants.dart'; // Access to global constants.
import 'package:blog_app/core/theme/app_pallete.dart'; // Theme-specific color palette.
import 'package:blog_app/core/utils/pick_image.dart'; // Utility for image selection.
import 'package:blog_app/core/utils/show_snackbar.dart'; // Utility for displaying snackbars.
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart'; // Bloc for blog-related actions.
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart'; // Screen for displaying blogs.
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart'; // Custom widget for text input.
import 'package:dotted_border/dotted_border.dart'; // Third-party package for dotted borders.
import 'package:flutter/material.dart'; // Flutter's material design UI toolkit.
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc pattern library for Flutter.

// Defining the StatefulWidget, which allows the widget to hold state.
class AddNewBlogPage extends StatefulWidget {
  // Static method to return a MaterialPageRoute for navigation.
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );

  const AddNewBlogPage({super.key}); // Constructor with an optional key parameter.

  @override
  // Creating the state for this StatefulWidget.
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

// The state class for AddNewBlogPage.
class _AddNewBlogPageState extends State<AddNewBlogPage> {
  // Text controllers for handling input text.
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  // GlobalKey for form validation.
  final formKey = GlobalKey<FormState>();
  // List to hold selected topics.
  List<String> selectedTopics = [];
  // Variable to hold the selected image file.
  File? image;

  // Method to select an image asynchronously.
  void selectImage() async {
    final pickedImage = await pickImage(); // Using a utility method to pick an image.
    if (pickedImage != null) { // Checking if an image was selected.
      setState(() {
        image = pickedImage; // Updating the state with the selected image.
      });
    }
  }

  // Method to handle the upload of a new blog post.
  void uploadBlog() {
    // Validating form inputs, topics selection, and image selection.
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      // Extracting the poster's ID from the current user state.
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      // Dispatching a BlogUpload event to the BlogBloc with the blog details.
      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
            ),
          );
    }
  }

  @override
  // Disposing of the controllers when the widget is disposed.
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  // Building the widget's UI.
  Widget build(BuildContext context) {
    // The UI is wrapped in a Scaffold widget.
    return Scaffold(
      appBar: AppBar(
        // AppBar with an action button to submit the blog post.
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog(); // Calling uploadBlog when the button is pressed.
            },
            icon: const Icon(Icons.done_rounded), // Setting the icon of the button.
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        // Using BlocConsumer to listen to and build UI based on BlogBloc states.
        listener: (context, state) {
          // Handling different states with appropriate actions.
          if (state is BlogFailure) {
            // Showing an error message if there's a failure.
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            // Navigating to the BlogPage on successful upload and removing all previous routes.
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          // Showing a loader while the blog is being uploaded.
          if (state is BlogLoading) {
            return const Loader();
          }

          // Main content of the page allowing the user to input blog details.
          return SingleChildScrollView(
            // Using SingleChildScrollView to prevent overflow when the keyboard is visible.
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // Form widget for input validation.
                key: formKey, // Setting the key for the form.
                child: Column(
                  // The main layout is a column.
                  children: [
                    // Conditional rendering based on whether an image has been selected.
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              // Displaying the selected image if available.
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            // Offering the user to select an image if not already selected.
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              // Using DottedBorder for a stylistic choice.
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                // Placeholder content encouraging the user to select an image.
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    // Horizontal scrollable list of topics for the user to select from.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // Mapping predefined topics to Chips for selection.
                        children: Constants.topics
                            .map(
                              (topic) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Toggling topic selection on tap.
                                    if (selectedTopics.contains(topic)) {
                                      selectedTopics.remove(topic);
                                    } else {
                                      selectedTopics.add(topic);
                                    }
                                    setState(() {}); // Updating the UI.
                                  },
                                  child: Chip(
                                    // Using Chips as a UI element for topics.
                                    label: Text(topic),
                                    // Styling the Chip based on whether it's selected.
                                    color: selectedTopics.contains(topic)
                                        ? const MaterialStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(topic)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Custom BlogEditor widget for the blog title input.
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                    ),
                    const SizedBox(height: 10),
                    // Custom BlogEditor widget for the blog content input.
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
