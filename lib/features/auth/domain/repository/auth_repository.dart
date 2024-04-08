
// Import statements to include necessary external and project-specific dependencies.
import 'package:blog_app/core/error/failures.dart'; // For handling errors and failures in a standardized way across the app.
import 'package:blog_app/features/auth/domain/entities/user.dart'; // The User entity that represents the data structure for a user in the domain layer.
import 'package:fpdart/fpdart.dart'; // A package that brings functional programming tools to Dart, used here for the Either type.

// Defines an abstract class named AuthRepository. It's meant to be an interface (though Dart uses `abstract class` for this purpose) 
// that specifies the contracts for authentication operations. This is a common pattern in clean architecture to define 
// the expected functionalities in the domain layer, which can then be implemented by the data layer.
abstract class AuthRepository {
  // A method signature for signing up a user with their name, email, and password. 
  // This function is asynchronous (returns a Future) and utilizes the Either type from the fpdart package 
  // to return either a Failure (left side) or a User entity (right side) upon completion.
  // This approach is preferred in functional programming and error handling because it forces the caller to 
  // handle both success and failure cases explicitly.
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name, // The user's name, marked as required meaning it cannot be null.
    required String email, // The user's email, also required.
    required String password, // The user's chosen password, required as well.
  });

  // Similar to signUpWithEmailPassword, this method is for logging in a user with their email and password.
  // It also returns a Future of Either a Failure or a User entity, enforcing explicit error handling.
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email, // Required user's email.
    required String password, // Required user's password.
  });

  // A method to get the current user if any. It doesn't require any parameters since the implementation 
  // would typically check the current session or authentication state to determine the logged-in user.
  // Like the other methods, it returns a Future of Either a Failure or a User entity.
  Future<Either<Failure, User>> currentUser();
}
