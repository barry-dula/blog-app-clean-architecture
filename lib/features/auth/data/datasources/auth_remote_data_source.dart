
// Importing necessary dependencies and models.
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Declaring an abstract interface class for the authentication remote data source.
abstract interface class AuthRemoteDataSource {
  // Getter for retrieving the current user session.
  Session? get currentUserSession;

  // Method for signing up a user with email and password.
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  // Method for logging in a user with email and password.
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  // Method for fetching current user data.
  Future<UserModel?> getCurrentUserData();
}

// Implementation of the authentication remote data source interface.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  // Constructor for initializing the Supabase client.
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  // Method implementation for logging in a user with email and password.
  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Signing in with Supabase authentication.
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      // If user is null, throw a server exception.
      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      // Returning UserModel instance by parsing the response user data.
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      // Handling Supabase authentication exceptions and throwing server exception.
      throw ServerException(e.message);
    } catch (e) {
      // Catching other exceptions and throwing server exception.
      throw ServerException(e.toString());
    }
  }

  // Method implementation for signing up a user with email and password.
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Signing up with Supabase authentication.
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      // If user is null, throw a server exception.
      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      // Returning UserModel instance by parsing the response user data.
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      // Handling Supabase authentication exceptions and throwing server exception.
      throw ServerException(e.message);
    } catch (e) {
      // Catching other exceptions and throwing server exception.
      throw ServerException(e.toString());
    }
  }

  // Method implementation for fetching current user data.
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      // Checking if there is a current user session.
      if (currentUserSession != null) {
        // Fetching user data from Supabase profiles table.
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        // Parsing user data into UserModel and copying email from current session user.
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      // If there is no current user session, return null.
      return null;
    } catch (e) {
      // Catching exceptions and throwing server exception.
      throw ServerException(e.toString());
    }
  }
}
