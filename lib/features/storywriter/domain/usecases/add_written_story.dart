import '../entities/story_writer_entity.dart';
import '../repositories/story_writer_repository.dart';

class AddWrittenStory {
  final StoryWriterRepository repository;

  AddWrittenStory(this.repository);

  Future<void> call(StoryWriterEntity story) {
    return repository.addStory(story);
  }
}
