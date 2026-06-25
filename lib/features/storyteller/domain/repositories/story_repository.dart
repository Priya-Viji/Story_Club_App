
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

abstract class StoryRepository {
  Future<void> addStory(StoryEntity story);
  Future<void> updateStory(StoryEntity story);
  Future<void> deleteStory(String id);
  Stream<List<StoryEntity>> getStories(String genre);
}
