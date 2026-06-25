import '../entities/story_writer_entity.dart';
import '../repositories/story_writer_repository.dart';

class UpdateWrittenStory {
  final StoryWriterRepository repository;

  UpdateWrittenStory(this.repository);

  Future<void> call(StoryWriterEntity story) {
    return repository.updateStory(story);
  }
}

