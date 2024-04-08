// Import necessary Dart packages and local modules.
import 'package:blog_app/core/error/failures.dart'; // For handling failures.
import 'package:blog_app/core/usecase/usecase.dart'; // Base use case interface.
import 'package:blog_app/features/auth/domain/entities/user.dart'; // User entity.
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // Authentication repository interface.
import 'package:fpdart/fpdart.dart'; // Functional programming in Dart.

// A class implementing the UseCase interface for user signup functionality.
class UserSignUp implements UseCase<User, UserSignUpParams> {
  // Dependency on the AuthRepository interface for handling authentication logic.
  final AuthRepository authRepository;
  
  // Constructor accepting an AuthRepository instance.
  const UserSignUp(this.authRepository);

  // The call method, inherited from the UseCase interface, is overridden to execute the use case.
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    // Delegates the operation to the authRepository, passing the signup parameters.
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

// A class designed to hold parameters required for the user signup use case.
class UserSignUpParams {
  // User's email.
  final String email;
  // User's password.
  final String password;
  // User's name.
  final String name;

  // Constructor with required parameters.
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
