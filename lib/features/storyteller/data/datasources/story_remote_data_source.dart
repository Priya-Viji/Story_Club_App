import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

class StoryRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ---------------- ADD STORY ----------------
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

  // ---------------- LOAD STORIES BY GENRE ----------------
  Future<List<StoryEntity>> getStoriesByGenre(String genre) async {
    final querySnapshot = await firestore
        .collection("stories")
        .where("genre", isEqualTo: genre)
        .orderBy("createdAt", descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();

      return StoryEntity(
        id: data["id"],
        title: data["title"],
        genre: data["genre"],
        description: data["description"],
        thumbnail: data["thumbnail"],
        audio: data["audio"],
      );
    }).toList();
  }

  // ---------------- DELETE STORY ----------------
  Future<void> deleteStory(String id) async {
    await firestore.collection("stories").doc(id).delete();
  }
}
