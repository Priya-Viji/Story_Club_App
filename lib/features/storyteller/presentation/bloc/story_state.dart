import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final List<StoryEntity> stories;
  StoryLoaded(this.stories);
}

class StoryError extends StoryState {
  final String message;
  StoryError(this.message);
}
