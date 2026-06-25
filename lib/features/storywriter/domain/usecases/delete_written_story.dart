import '../repositories/story_writer_repository.dart';

class DeleteWrittenStory {
  final StoryWriterRepository repository;

  DeleteWrittenStory(this.repository);

  Future<void> call(String id) {
    return repository.deleteStory(id);
  }
}
