// lib/features/storywriter/data/models/story_writer_model.dart
import '../../domain/entities/story_writer_entity.dart';

class StoryWriterModel extends StoryWriterEntity {
  StoryWriterModel({
    required super.id,
    required super.title,
    required super.genre,
    required super.storyType,
    required super.coverImage,
    required super.description,
    required super.content,
  });

  factory StoryWriterModel.fromMap(Map<String, dynamic> map) {
    return StoryWriterModel(
      id: map["id"] ?? "",
      title: map["title"] ?? "",
      genre: map["genre"] ?? "",
      storyType: map["storyType"] ?? "",
      coverImage: map["coverImage"] ?? "",
      description: map["description"] ?? "",
      content: map["content"] ?? "",
    );
  }

  factory StoryWriterModel.fromEntity(StoryWriterEntity e) {
    return StoryWriterModel(
      id: e.id,
      title: e.title,
      genre: e.genre,
      storyType: e.storyType,
      coverImage: e.coverImage,
      description: e.description,
      content: e.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "genre": genre,
      "storyType": storyType,
      "coverImage": coverImage,
      "description": description,
      "content": content,
    };
  }
}
