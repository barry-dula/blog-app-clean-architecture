
// Importing the `User` entity from a local package within the application.
import 'package:blog_app/features/auth/domain/entities/user.dart';

// Definition of the UserModel class that extends the User entity.
class UserModel extends User {
  // Constructor for the UserModel class. 
  // It calls the constructor of the base class (User) with required parameters.
  UserModel({
    required super.id,     // Required user ID, passed to the User base class.
    required super.email,  // Required user email, passed to the User base class.
    required super.name,   // Required user name, passed to the User base class.
  });

  // A factory constructor named `fromJson` that creates an instance of UserModel from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',     // Retrieves the 'id' from the map, defaults to an empty string if not found.
      email: map['email'] ?? '', // Retrieves the 'email' from the map, defaults to an empty string if not found.
      name: map['name'] ?? '',  // Retrieves the 'name' from the map, defaults to an empty string if not found.
    );
  }

  // A method named `copyWith` that allows copying the UserModel with optional new values for its fields.
  UserModel copyWith({
    String? id,    // Optional new id.
    String? email, // Optional new email.
    String? name,  // Optional new name.
  }) {
    return UserModel(
      id: id ?? this.id,      // Uses the new id if provided, otherwise uses the current instance's id.
      email: email ?? this.email, // Uses the new email if provided, otherwise uses the current instance's email.
      name: name ?? this.name,   // Uses the new name if provided, otherwise uses the current instance's name.
    );
  }
}
