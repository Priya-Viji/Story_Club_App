import 'package:get_it/get_it.dart';

// ---------------- AUTH ----------------
import 'package:story_club/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:story_club/features/auth/domain/repositories/auth_repository.dart';
import 'package:story_club/features/auth/presentation/bloc/auth_bloc.dart';

// ---------------- STORY TELLER ----------------
import 'package:story_club/features/storyteller/data/datasources/story_remote_data_source.dart';
import 'package:story_club/features/storyteller/data/repositories/story_repo_impl.dart';
import 'package:story_club/features/storyteller/domain/repositories/story_repository.dart';
import 'package:story_club/features/storyteller/domain/usecases/add_story.dart';
import 'package:story_club/features/storyteller/domain/usecases/update_story.dart';
import 'package:story_club/features/storyteller/domain/usecases/delete_story.dart';
import 'package:story_club/features/storyteller/domain/usecases/get_stories.dart';
import 'package:story_club/features/storyteller/presentation/bloc/story_bloc.dart';
import 'package:story_club/features/storywriter/data/datasources/story_writer_remote_data_source.dart';
import 'package:story_club/features/storywriter/data/repositories/story_writer_repo_impl.dart';
import 'package:story_club/features/storywriter/domain/repositories/story_writer_repository.dart';
import 'package:story_club/features/storywriter/domain/usecases/add_written_story.dart';
import 'package:story_club/features/storywriter/domain/usecases/delete_written_story.dart';
import 'package:story_club/features/storywriter/domain/usecases/get_written_stories.dart';
import 'package:story_club/features/storywriter/domain/usecases/update_written_story.dart';
import 'package:story_club/features/storywriter/presentation/bloc/story_writer_bloc.dart';

final sl = GetIt.instance;

void initDependencies() {
  // ---------------------------
  // AUTH MODULE
  // ---------------------------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerFactory(() => AuthBloc(sl()));

  // ---------------------------
  // STORY TELLER MODULE
  // ---------------------------

  // Data Source
  sl.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSource(),
  );

  // Repository
  sl.registerLazySingleton<StoryRepository>(() => StoryRepositoryImpl());

  // Usecases
  sl.registerLazySingleton(() => AddStory(sl()));
  sl.registerLazySingleton(() => UpdateStory(sl()));
  sl.registerLazySingleton(() => DeleteStory(sl()));
  sl.registerLazySingleton(() => GetStories(sl()));

  // Bloc (FIXED PARAMETER NAMES)
  sl.registerFactory(
    () => StoryBloc(
      addStoryUsecase: sl(),
      updateStoryUsecase: sl(),
      deleteStoryUsecase: sl(),
      getStoriesUsecase: sl(),
    ),
  );

  sl.registerLazySingleton(() => StoryWriterRemoteDataSource());
  sl.registerLazySingleton<StoryWriterRepository>(
    () => StoryWriterRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => AddWrittenStory(sl()));
  sl.registerLazySingleton(() => UpdateWrittenStory(sl()));
  sl.registerLazySingleton(() => DeleteWrittenStory(sl()));
  sl.registerLazySingleton(() => GetWrittenStories(sl()));

  sl.registerFactory(
    () => StoryWriterBloc(
      addStory: sl(),
      updateStory: sl(),
      deleteStory: sl(),
      getStories: sl(),
    ),
  );

}
