import '../entities/story_writer_entity.dart';
import '../repositories/story_writer_repository.dart';

class GetWrittenStories {
  final StoryWriterRepository repository;

  GetWrittenStories(this.repository);

  Stream<List<StoryWriterEntity>> call() {
    return repository.getStories();
  }
}
