// Importing necessary libraries and files for the authentication BLoC.
// These include Flutter's material and bloc packages, the application's use cases, entities, and cubits.
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 'part' directives to include additional parts of the Auth BLoC, like events and states.
part 'auth_event.dart';
part 'auth_state.dart';

// Declaration of the AuthBloc class, which extends Bloc with AuthEvent and AuthState types.
// This sets up the AuthBloc to respond to AuthEvents and emit AuthStates.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Declaration of private final variables for the use cases and the AppUserCubit.
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  // Constructor for AuthBloc, requiring instances of the use cases and AppUserCubit.
  // These instances are provided through dependency injection, allowing for flexibility and testability.
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) { // Initial state of the AuthBloc is set to AuthInitial.
    // Registering event handlers for different types of authentication events.
    // Each handler defines how the Bloc should react to specific events.
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  // Event handlers:

  // _isUserLoggedIn checks if a user is currently logged in by calling the _currentUser use case.
  // It emits a loading state, then either a failure or success state based on the operation's outcome.
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // Emit loading before processing.
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)), // Emit failure on error.
      (r) => _emitAuthSuccess(r, emit), // Emit success with user data.
    );
  }

  // _onAuthSignUp handles user sign-up events.
  // Similar to _isUserLoggedIn, it emits loading, then success or failure states based on the outcome.
  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // Emit loading before processing.
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)), // Emit failure on error.
      (user) => _emitAuthSuccess(user, emit), // Emit success with user data.
    );
  }

  // _onAuthLogin handles user login events.
  // It follows a similar pattern to the other event handlers, managing loading, success, and failure states.
  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // Emit loading before processing.
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)), // Emit failure on error.
      (r) => _emitAuthSuccess(r, emit), // Emit success with user data.
    );
  }

  // A helper function to emit success states.
  // It updates the AppUserCubit with the current user and emits an AuthSuccess state.
  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user); // Update user information in AppUserCubit.
    emit(AuthSuccess(user)); // Emit success state with user data.
  }
}
