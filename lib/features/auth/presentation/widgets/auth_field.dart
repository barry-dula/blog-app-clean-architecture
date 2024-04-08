// Importing the material.dart package to use Flutter's material design UI components.
import 'package:flutter/material.dart';

// Declaring the AuthField class which is a stateless widget.
// Stateless widgets do not maintain any internal state and are rebuilt every time setState is called.
class AuthField extends StatelessWidget {
  // Declaring and initializing various properties required for the AuthField widget.
  
  // 'hintText' is used to display a hint in the TextField. It is a required parameter.
  final String hintText;
  // 'controller' is used to control the text being edited. It is required to capture user input.
  final TextEditingController controller;
  // 'isObscureText' determines whether the text should be obscured (for passwords). It defaults to false.
  final bool isObscureText;
  
  // Constructor for the AuthField widget.
  // It requires 'hintText' and 'controller' to be passed when instantiated.
  // 'isObscureText' is optional and defaults to false if not provided.
  const AuthField({
    super.key, // Optionally includes a key for the widget.
    required this.hintText,
    required this.controller,
    this.isObscureText = false, // Defaults to false making text visible by default.
  });

  @override
  // Building the widget's UI.
  Widget build(BuildContext context) {
    // Returns a TextFormField widget which allows users to enter text.
    return TextFormField(
      controller: controller, // Sets the controller for the text field.
      decoration: InputDecoration(
        hintText: hintText, // Sets the hint text for the text field.
      ),
      validator: (value) {
        // Validator function to check if the input field is empty.
        if (value!.isEmpty) {
          // If the field is empty, return a string indicating which field is missing.
          return "$hintText is missing!";
        }
        // If the field is not empty, return null indicating the input is valid.
        return null;
      },
      obscureText: isObscureText, // If true, obscures text for privacy (useful for passwords).
    );
  }
}
