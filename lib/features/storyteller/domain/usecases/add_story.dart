
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';
import 'package:story_club/features/storyteller/domain/repositories/story_repository.dart';

class AddStory {
  final StoryRepository repo;
  AddStory(this.repo);

  Future<void> call(StoryEntity story) => repo.addStory(story);
}
