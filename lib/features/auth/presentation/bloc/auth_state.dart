// Indicates that the content below is a part of another file, 'auth_bloc.dart'.
// This is used for code organization, allowing you to split a class across multiple files.
part of 'auth_bloc.dart';

// An annotation ensuring that every instance of AuthState and its subclasses are immutable.
// Immutable means the state objects cannot be changed once they are created.
@immutable
// A base class for all authentication states.
// The 'sealed' keyword isn't natively supported in Dart but suggests that 
// the intent is to limit the extension of this class to the ones defined within this file.
sealed class AuthState {
  // A constructor marked as 'const' encourages the use of compile-time constants where possible,
  // improving performance by reducing the need for runtime object creation.
  const AuthState();
}

// Represents the initial state of the authentication process.
// This is usually the state before any authentication action has been taken.
final class AuthInitial extends AuthState {}

// Represents a loading state, indicating that an authentication action is in progress.
// This could be shown to the user as a loading spinner or a progress bar.
final class AuthLoading extends AuthState {}

// Represents a successful authentication state.
// This state includes the authenticated user's data.
final class AuthSuccess extends AuthState {
  // Holds the authenticated user information.
  final User user;
  
  // Requires the authenticated user as an argument to be instantiated.
  const AuthSuccess(this.user);
}

// Represents a failed authentication state.
// This state includes a message describing the failure, which could be shown to the user.
final class AuthFailure extends AuthState {
  // Holds the failure message.
  final String message;
  
  // Requires a failure message as an argument to be instantiated.
  const AuthFailure(this.message);
}
