import '../../domain/entities/story_writer_entity.dart';

abstract class StoryWriterEvent {}

class LoadWrittenStories extends StoryWriterEvent {}

class AddWrittenStoryEvent extends StoryWriterEvent {
  final StoryWriterEntity story;
  AddWrittenStoryEvent(this.story);
}

class UpdateWrittenStoryEvent extends StoryWriterEvent {
  final StoryWriterEntity story;
  UpdateWrittenStoryEvent(this.story);
}

class DeleteWrittenStoryEvent extends StoryWriterEvent {
  final String id;
  DeleteWrittenStoryEvent(this.id);
}

class WrittenStoriesUpdated extends StoryWriterEvent {
  final List<StoryWriterEntity> stories;
  WrittenStoriesUpdated(this.stories);
}
