import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';
import 'package:story_club/features/storyteller/domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addStory(StoryEntity story) async {
    final docRef = firestore.collection("stories").doc();

    await docRef.set({
      "id": docRef.id,
      "title": story.title,
      "genre": story.genre,
      "description": story.description,
      "thumbnail": story.thumbnail,
      "audio": story.audio,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateStory(StoryEntity story) async {
    await firestore.collection("stories").doc(story.id).update({
      "title": story.title,
      "genre": story.genre,
      "description": story.description,
      "thumbnail": story.thumbnail,
      "audio": story.audio,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteStory(String id) async {
    await firestore.collection("stories").doc(id).delete();
  }

  @override
  Stream<List<StoryEntity>> getStories(String genre) {
    return firestore
        .collection("stories")
        .where("genre", isEqualTo: genre)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return StoryEntity(
              id: data["id"]?.toString() ?? '',
              title: data["title"]?.toString() ?? 'Untitled story',
              genre: data["genre"]?.toString() ?? genre,
              description: data["description"]?.toString() ?? 'No description available',
              thumbnail: data["thumbnail"]?.toString() ?? '',
              audio: data["audio"]?.toString() ?? '',
            );
          }).toList();
        });
  }
}
