import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';
import 'package:story_club/features/storyteller/domain/repositories/story_repository.dart';

class GetStories {
  final StoryRepository repo;
  GetStories(this.repo);

  Stream<List<StoryEntity>> call(String genre) => repo.getStories(genre);
}
