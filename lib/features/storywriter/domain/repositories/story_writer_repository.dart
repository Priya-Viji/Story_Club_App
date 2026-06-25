import '../entities/story_writer_entity.dart';

abstract class StoryWriterRepository {
  Future<void> addStory(StoryWriterEntity story);
  Future<void> updateStory(StoryWriterEntity story);
  Future<void> deleteStory(String id);
  Stream<List<StoryWriterEntity>> getStories();
}
