import '../../domain/entities/story_writer_entity.dart';

abstract class StoryWriterState {}

class StoryWriterInitial extends StoryWriterState {}

class StoryWriterLoading extends StoryWriterState {}

class StoryWriterLoaded extends StoryWriterState {
  final List<StoryWriterEntity> stories;
  StoryWriterLoaded(this.stories);
}

class StoryWriterError extends StoryWriterState {
  final String message;
  StoryWriterError(this.message);
}
