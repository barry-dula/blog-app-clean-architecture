// Importing necessary modules and files.
import 'package:blog_app/core/error/failures.dart'; // For standardized error handling across the app.
import 'package:blog_app/core/usecase/usecase.dart'; // The abstract UseCase class that outlines the structure for all use cases.
import 'package:blog_app/features/auth/domain/entities/user.dart'; // The User entity, representing the user's data structure in the domain layer.
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // The authentication repository interface.
import 'package:fpdart/fpdart.dart'; // A package for functional programming in Dart, used for the Either type.

// The UserLogin class, which implements the UseCase interface for the specific use case of logging a user in.
class UserLogin implements UseCase<User, UserLoginParams> {
  // A reference to the AuthRepository interface. This will be injected with a concrete implementation, enabling the use case to interact with authentication mechanisms.
  final AuthRepository authRepository;

  // Constructor that takes an AuthRepository. This allows for dependency injection, increasing modularity and testability.
  const UserLogin(this.authRepository);

  // Implementation of the call method from the UseCase interface. This method is where the use case logic is executed.
  // It takes UserLoginParams (which contains the user's email and password) as parameters and returns a Future of Either<Failure, User>.
  // This encapsulates an asynchronous operation that could either result in a Failure (if login fails) or a User entity (if login is successful).
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    // Delegates the login operation to the authRepository's loginWithEmailPassword method, passing the email and password.
    // This demonstrates the separation of concerns, where the use case doesn't know about the specifics of how the repository performs the operation.
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

// A class specifically designed to hold the parameters required for the UserLogin use case.
// This pattern is useful for use cases that require multiple parameters, keeping the method signatures clean and concise.
class UserLoginParams {
  // The user's email and password, marked as required to enforce that they cannot be null.
  final String email;
  final String password;

  // Constructor for UserLoginParams, accepting the user's email and password as arguments.
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
