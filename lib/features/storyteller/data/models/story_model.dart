
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  StoryModel({
    required super.id,
    required super.title,
    required super.genre,
    required super.description,
    required super.thumbnail,
    required super.audio,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'genre': genre,
      'description': description,
      'thumbnail': thumbnail,
      'audio': audio,
    };
  }

  factory StoryModel.fromDoc(String id, Map<String, dynamic> map) {
    return StoryModel(
      id: id,
      title: map['title'],
      genre: map['genre'],
      description: map['description'],
      thumbnail: map['thumbnail'],
      audio: map['audio'],
    );
  }
}
