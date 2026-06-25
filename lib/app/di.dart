import 'package:get_it/get_it.dart';
import 'package:story_club/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:story_club/features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));
}
