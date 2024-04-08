
// Import statements to include necessary libraries and modules.
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// AuthRepositoryImpl class implementing the AuthRepository interface.
class AuthRepositoryImpl implements AuthRepository {
  // Dependencies injected via constructor.
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  // Method to get the current user. It uses functional programming concepts to handle success and error cases.
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      // Checks if there is an internet connection.
      if (!await (connectionChecker.isConnected)) {
        // If not connected, checks if there's a current session available locally.
        final session = remoteDataSource.currentUserSession;

        // If no session is available, it means the user is not logged in.
        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        // If a session is available, it constructs a UserModel (which implements User) and returns it.
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      // If connected to the internet, fetches current user data from the remote data source.
      final user = await remoteDataSource.getCurrentUserData();
      // If no user data is retrieved, it means the user is not logged in.
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      // If user data is retrieved, returns the user data.
      return right(user);
    } on ServerException catch (e) {
      // If any server exception occurs, returns a Failure with the error message.
      return left(Failure(e.message));
    }
  }

  // Method to login a user with email and password. It utilizes the _getUser helper function.
  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  // Method to sign up a user with name, email, and password. It utilizes the _getUser helper function.
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  // Helper function to abstract common logic for getting a user. It handles network checks and error handling.
  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      // Checks if there is an internet connection.
      if (!await (connectionChecker.isConnected)) {
        // If not, returns a Failure indicating no connection.
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      // Calls the provided function to get a user.
      final user = await fn();

      // If successful, returns the user.
      return right(user);
    } on ServerException catch (e) {
      // If any server exception occurs, returns a Failure with the error message.
      return left(Failure(e.message));
    }
  }
}
