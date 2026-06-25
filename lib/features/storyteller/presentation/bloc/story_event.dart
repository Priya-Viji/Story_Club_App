import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

abstract class StoryEvent {}

class LoadStories extends StoryEvent {
  final String genre;
  LoadStories(this.genre);
}

class AddStoryEvent extends StoryEvent {
  final StoryEntity story;
  AddStoryEvent(this.story);
}

class UpdateStoryEvent extends StoryEvent {
  final StoryEntity story;
  UpdateStoryEvent(this.story);
}

class DeleteStoryEvent extends StoryEvent {
  final String id;
  DeleteStoryEvent(this.id);
}
