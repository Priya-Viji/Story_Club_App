// lib/features/storywriter/domain/entities/story_writer_entity.dart

class StoryWriterEntity {
  final String id;
  final String title;
  final String genre;
  final String storyType;
  final String coverImage;
  final String description;
  final String content;

  StoryWriterEntity({
    required this.id,
    required this.title,
    required this.genre,
    required this.storyType,
    required this.coverImage,
    required this.description,
    required this.content,
  });

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
