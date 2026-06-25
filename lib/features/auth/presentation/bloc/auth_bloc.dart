import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_club/features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_checkStatus);
    on<LoginEvent>(_login);
    on<SignupEvent>(_signup);
    on<LogoutEvent>(_logout);
  }

  Future<void> _checkStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = await repository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user.email));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await repository.signIn(event.email, event.password);
    if (user != null) {
      emit(Authenticated(user.email));
    } else {
      emit(AuthError("Invalid email or password"));
    }
  }

  Future<void> _signup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await repository.signUp(event.email, event.password);
    if (user != null) {
      emit(Authenticated(user.email));
    } else {
      emit(AuthError("Signup failed"));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    await repository.signOut();
    emit(Unauthenticated());
  }
}
