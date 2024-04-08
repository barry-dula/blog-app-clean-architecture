// Import statements to include necessary dependencies and modules.
import 'package:blog_app/core/error/failures.dart'; // For handling errors and failures through a standardized Failure class.
import 'package:blog_app/core/usecase/usecase.dart'; // Base UseCase class which outlines the structure for all use cases in the application.
import 'package:blog_app/features/auth/domain/entities/user.dart'; // The User entity representing the structure of user data in the domain layer.
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // The abstract class defining the contract for the authentication repository.
import 'package:fpdart/fpdart.dart'; // A functional programming library in Dart, used here for the Either type.

// Definition of the CurrentUser class which implements the UseCase interface from the core/usecase/usecase.dart file.
// This use case is specialized for fetching the currently logged-in user, and it does not require any parameters to be passed for its execution.
class CurrentUser implements UseCase<User, NoParams> {
  // Declaration of a final property authRepository of type AuthRepository. 
  // This property will hold a reference to the concrete implementation of the AuthRepository, allowing this use case to interact with the authentication system.
  final AuthRepository authRepository;

  // Constructor for CurrentUser, expecting an AuthRepository instance to be injected. 
  // This follows the dependency inversion principle, allowing for easier testing and decoupling of components.
  CurrentUser(this.authRepository);

  // Override of the call method from the UseCase interface. This method is where the logic for the use case is executed.
  // In this case, it simply delegates the operation to the authRepository's currentUser method.
  // It accepts an instance of NoParams because, by definition, fetching the current user does not require any parameters.
  // The method returns a Future of Either<Failure, User>, encapsulating the asynchronous operation which could either result in a Failure or a successful retrieval of a User entity.
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
