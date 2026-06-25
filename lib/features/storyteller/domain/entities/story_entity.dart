import 'package:cloud_firestore/cloud_firestore.dart';

class StoryEntity {
  final String id;
  final String title;
  final String genre;
  final String description;
  final String thumbnail;
  final String audio;

  StoryEntity({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.thumbnail,
    required this.audio,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "genre": genre,
      "description": description,
      "thumbnail": thumbnail,
      "audio": audio,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}
