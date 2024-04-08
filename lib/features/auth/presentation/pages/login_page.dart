// Import statements to include necessary libraries and files for the app functionality.
import 'package:blog_app/core/common/widgets/loader.dart'; // Custom loader widget for loading state.
import 'package:blog_app/core/theme/app_pallete.dart'; // Theming and color scheme definitions.
import 'package:blog_app/core/utils/show_snackbar.dart'; // Utility function to show snackbars.
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart'; // BLoC related to authentication.
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart'; // Signup page import.
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart'; // Custom widget for auth text fields.
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart'; // Custom button with gradient.
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart'; // Blog page import.
import 'package:flutter/material.dart'; // Material design widgets and themes.
import 'package:flutter_bloc/flutter_bloc.dart'; // Package for using BLoC pattern for state management.

// LoginPage StatefulWidget is defined here, allowing for mutable state.
class LoginPage extends StatefulWidget {
  // Static method to easily navigate to this page using MaterialRoute.
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  const LoginPage({super.key}); // Constructor for LoginPage, initializing key for the widget.

  @override
  State<LoginPage> createState() => _LoginPageState(); // Creates the state associated with this StatefulWidget.
}

class _LoginPageState extends State<LoginPage> {
  // TextEditingControllers to manage the text input for email and password fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // GlobalKey to uniquely identify the Form widget and validate the form.
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose method to clean up the controllers when the widget is removed from the widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The build method defines the part of the user interface represented by this widget.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          // BlocConsumer to listen and build UI based on AuthBloc's state.
          listener: (context, state) {
            // Listener reacts to state changes to show snackbar messages or navigate on auth success.
            if (state is AuthFailure) {
              // Shows a snackbar if there is an authentication failure.
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              // Navigates to the BlogPage and removes all routes underneath when authentication is successful.
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            // Builder provides the UI based on the current state.
            if (state is AuthLoading) {
              // Displays a loading widget during authentication process.
              return const Loader();
            }

            // Main form displayed for user input on email and password.
            return Form(
              key: formKey, // Associates this form with the globally unique key.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the form widgets vertically.
                children: [
                  // Displaying the Sign In text at the top of the form.
                  const Text(
                    'Sign In.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30), // Adds spacing between elements.
                  // Custom AuthField widget for email input.
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 15), // Adds spacing between elements.
                  // Custom AuthField widget for password input, obscured.
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20), // Adds spacing between elements.
                  // Custom gradient button for submitting the form.
                  AuthGradientButton(
                    buttonText: 'Sign in',
                    onPressed: () {
                      // Validates the form and triggers the login event if valid.
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthLogin(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 20), // Adds spacing between elements.
                  // GestureDetector to navigate to the SignUp page on tap.
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2, // Theming for the Sign Up text.
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




