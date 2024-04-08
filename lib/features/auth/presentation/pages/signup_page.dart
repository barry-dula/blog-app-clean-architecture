// Importing necessary packages and files.
import 'package:blog_app/core/common/widgets/loader.dart'; // Custom loader widget for indicating loading states.
import 'package:blog_app/core/theme/app_pallete.dart'; // App theme and color palette.
import 'package:blog_app/core/utils/show_snackbar.dart'; // Utility for showing snackbars for feedback.
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart'; // Authentication business logic component (BLoC).
import 'package:blog_app/features/auth/presentation/pages/login_page.dart'; // Page to navigate to for logging in.
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart'; // Custom text field widget for authentication forms.
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart'; // Custom button with a gradient.
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart'; // Main blog page to navigate to after successful signup.
import 'package:flutter/material.dart'; // Material design library for Flutter.
import 'package:flutter_bloc/flutter_bloc.dart'; // Library for implementing BLoC pattern.

// Defining a StatefulWidget for the SignUp page.
class SignUpPage extends StatefulWidget {
  // Static method to generate a route for navigating to the SignUpPage.
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );

  const SignUpPage({super.key}); // Constructor for the SignUpPage, optionally taking a key.

  @override
  State<SignUpPage> createState() => _SignUpPageState(); // Creating the state for this StatefulWidget.
}

class _SignUpPageState extends State<SignUpPage> {
  // TextEditingControllers to capture input for name, email, and password.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  // GlobalKey to identify the Form widget and assist in form validation.
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI of the SignUpPage.
    return Scaffold(
      appBar: AppBar(), // Simple AppBar for the SignUpPage.
      body: Padding(
        padding: const EdgeInsets.all(15.0), // Padding for the body content.
        child: BlocConsumer<AuthBloc, AuthState>(
          // Using BlocConsumer to listen to and build UI based on AuthBloc states.
          listener: (context, state) {
            // Listener reacts to state changes.
            if (state is AuthFailure) {
              // Show a snackbar if authentication fails.
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              // Navigate to the BlogPage and remove all previous routes on successful signup.
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            // Builder to construct the UI based on current state.
            if (state is AuthLoading) {
              // Display a loading indicator during authentication process.
              return const Loader();
            }

            // The main form for user input.
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centering the form vertically.
                children: [
                  // Display 'Sign Up' text at the top.
                  const Text(
                    'Sign Up.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30), // Space between 'Sign Up' text and first input field.
                  // Custom text field for name input.
                  AuthField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 15), // Spacing between input fields.
                  // Custom text field for email input.
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 15), // Spacing between input fields.
                  // Custom text field for password input, with obscured text.
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20), // Spacing before the sign up button.
                  // Custom gradient button to submit the form.
                  AuthGradientButton(
                    buttonText: 'Sign Up',
                    onPressed: () {
                      // Form validation and sign-up event trigger.
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 20), // Spacing before the 'Already have an account?' text.
                  // Gesture detector to navigate to the LoginPage.
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, LoginPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2, // Color theme for the 'Sign In' text.
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
