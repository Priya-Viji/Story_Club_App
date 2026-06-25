import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';
import '../../domain/usecases/add_story.dart';
import '../../domain/usecases/update_story.dart';
import '../../domain/usecases/delete_story.dart';
import '../../domain/usecases/get_stories.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final AddStory addStoryUsecase;
  final UpdateStory updateStoryUsecase;
  final DeleteStory deleteStoryUsecase;
  final GetStories getStoriesUsecase;

  StoryBloc({
    required this.addStoryUsecase,
    required this.updateStoryUsecase,
    required this.deleteStoryUsecase,
    required this.getStoriesUsecase,
  }) : super(StoryInitial()) {
    // ---------------- LOAD STORIES (STREAM) ----------------
    on<LoadStories>((event, emit) {
      emit(StoryLoading());

      getStoriesUsecase(event.genre).listen(
        (stories) {
          add(_StoriesUpdated(stories));
        },
        onError: (error, stackTrace) {
          add(_StoriesError(error.toString()));
        },
      );
    });

    // ---------------- STREAM UPDATE HANDLER ----------------
    on<_StoriesUpdated>((event, emit) {
      emit(StoryLoaded(event.stories)); // even if empty
    });

    on<_StoriesError>((event, emit) {
      emit(StoryError(event.message));
    });

    // ---------------- ADD STORY ----------------
    on<AddStoryEvent>((event, emit) async {
      await addStoryUsecase(event.story);
    });

    // ---------------- UPDATE STORY ----------------
    on<UpdateStoryEvent>((event, emit) async {
      await updateStoryUsecase(event.story);
    });

    // ---------------- DELETE STORY ----------------
    on<DeleteStoryEvent>((event, emit) async {
      await deleteStoryUsecase(event.id);
    });
  }
}

// INTERNAL EVENT FOR STREAM UPDATES
class _StoriesUpdated extends StoryEvent {
  final List<StoryEntity> stories;
  _StoriesUpdated(this.stories);
}

class _StoriesError extends StoryEvent {
  final String message;
  _StoriesError(this.message);
}
