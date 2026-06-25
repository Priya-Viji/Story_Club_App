
import 'package:story_club/features/storyteller/domain/repositories/story_repository.dart';

class DeleteStory {
  final StoryRepository repo;
  DeleteStory(this.repo);

  Future<void> call(String id) => repo.deleteStory(id);
}
