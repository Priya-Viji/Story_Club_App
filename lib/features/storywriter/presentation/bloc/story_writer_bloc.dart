// story_writer_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_written_story.dart';
import '../../domain/usecases/update_written_story.dart';
import '../../domain/usecases/delete_written_story.dart';
import '../../domain/usecases/get_written_stories.dart';
import 'story_writer_event.dart';
import 'story_writer_state.dart';

class StoryWriterBloc extends Bloc<StoryWriterEvent, StoryWriterState> {
  final AddWrittenStory addStory;
  final UpdateWrittenStory updateStory;
  final DeleteWrittenStory deleteStory;
  final GetWrittenStories getStories;

  StoryWriterBloc({
    required this.addStory,
    required this.updateStory,
    required this.deleteStory,
    required this.getStories,
  }) : super(StoryWriterInitial()) {
    on<LoadWrittenStories>((event, emit) {
      emit(StoryWriterLoading());
      getStories().listen(
        (stories) => add(WrittenStoriesUpdated(stories)),
        onError: (e, stackTrace) {
          emit(StoryWriterError(e.toString()));
        },
      );
    });

    on<WrittenStoriesUpdated>((event, emit) {
      emit(StoryWriterLoaded(event.stories));
    });

    on<AddWrittenStoryEvent>((event, emit) async {
      await addStory(event.story);
    });

    on<UpdateWrittenStoryEvent>((event, emit) async {
      await updateStory(event.story);
    });

    on<DeleteWrittenStoryEvent>((event, emit) async {
      await deleteStory(event.id);
    });
  }
}
