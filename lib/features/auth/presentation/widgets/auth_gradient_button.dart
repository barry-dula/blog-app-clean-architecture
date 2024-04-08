// Importing necessary packages.
import 'package:blog_app/core/theme/app_pallete.dart'; // For accessing predefined colors.
import 'package:flutter/material.dart'; // For using Flutter's material design UI components.

// Declaring the AuthGradientButton class which is a stateless widget.
// Stateless widgets do not hold any internal state.
class AuthGradientButton extends StatelessWidget {
  // Properties of the AuthGradientButton.
  
  // 'buttonText' is the text that will be displayed on the button.
  final String buttonText;
  // 'onPressed' is the callback function that gets called when the button is tapped.
  final VoidCallback onPressed;
  
  // Constructor for the AuthGradientButton widget.
  // Requires 'buttonText' and 'onPressed' to be passed when instantiated.
  const AuthGradientButton({
    super.key, // Optionally includes a key for the widget.
    required this.buttonText,
    required this.onPressed,
  });

  @override
  // Building the widget's UI.
  Widget build(BuildContext context) {
    // Returns a Container widget that will hold the button.
    return Container(
      decoration: BoxDecoration(
        // Applying a linear gradient as the background of the container.
        gradient: const LinearGradient(
          // The colors to be used in the gradient. Referring to predefined colors in AppPallete.
          colors: [
            AppPallete.gradient1, // Starting color of the gradient.
            AppPallete.gradient2, // Ending color of the gradient.
            // AppPallete.gradient3, // This line is commented out, but it shows how you could add more colors.
          ],
          begin: Alignment.bottomLeft, // Starting point of the gradient.
          end: Alignment.topRight, // Ending point of the gradient.
        ),
        borderRadius: BorderRadius.circular(7), // Rounded corners for the container.
      ),
      // The child of the container is an ElevatedButton.
      child: ElevatedButton(
        onPressed: onPressed, // Setting the onPressed callback for the button.
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55), // Fixed size of the button.
          backgroundColor: AppPallete.transparentColor, // Making the button's background transparent.
          shadowColor: AppPallete.transparentColor, // Removing any shadow by making it transparent.
        ),
        // The text inside the button.
        child: Text(
          buttonText, // The text to display on the button.
          style: const TextStyle(
            fontSize: 17, // Font size of the text.
            fontWeight: FontWeight.w600, // Weight of the font.
          ),
        ),
      ),
    );
  }
}
