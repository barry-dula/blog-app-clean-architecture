// This line indicates that the code below is part of another file, specifically 'auth_bloc.dart'.
// It's a way to split the class definition across multiple files for better organization.
part of 'auth_bloc.dart';

// An annotation to indicate that instances of classes extending AuthEvent should be immutable.
// Immutability is a key concept in Flutter (and functional programming) that helps ensure the UI behaves predictably.
@immutable
// A base class for all authentication-related events. It's marked as 'sealed' using the sealed_class package
// or it's meant to imply that conceptually, though Dart does not have sealed classes like Kotlin.
// This base class doesn't have any fields or methods; it's just a way to group related events.
sealed class AuthEvent {}

// A class representing a sign-up event, extending the base AuthEvent.
// This event is dispatched when a user attempts to sign up with their email, password, and name.
final class AuthSignUp extends AuthEvent {
  // Fields to hold the user's email, password, and name.
  final String email;
  final String password;
  final String name;

  // Constructor requiring all fields to be initialized.
  // The 'required' keyword ensures that these parameters must be passed when creating an instance of AuthSignUp.
  AuthSignUp({
    required this.email,
    required this.password,
    required this.name,
  });
}

// A class representing a login event, similar in structure to AuthSignUp but without the 'name' field.
// This event is dispatched when a user attempts to log in with their email and password.
final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

// A class representing an event to check if a user is currently logged in.
// This event doesn't carry any data; it's just a signal to perform the check.
final class AuthIsUserLoggedIn extends AuthEvent {}
