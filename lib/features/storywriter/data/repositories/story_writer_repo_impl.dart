import '../../domain/entities/story_writer_entity.dart';
import '../../domain/repositories/story_writer_repository.dart';
import '../datasources/story_writer_remote_data_source.dart';
import '../models/story_writer_model.dart';

class StoryWriterRepositoryImpl implements StoryWriterRepository {
  final StoryWriterRemoteDataSource remote;

  StoryWriterRepositoryImpl(this.remote);

  @override
  Future<void> addStory(StoryWriterEntity story) {
    return remote.addStory(StoryWriterModel.fromMap(story.toMap()));
  }

  @override
  Future<void> updateStory(StoryWriterEntity story) {
    return remote.updateStory(StoryWriterModel.fromMap(story.toMap()));
  }

  @override
  Future<void> deleteStory(String id) {
    return remote.deleteStory(id);
  }

  @override
  Stream<List<StoryWriterEntity>> getStories() {
    return remote.getStories();
  }
}
