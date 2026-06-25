// lib/features/storywriter/data/datasources/story_writer_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_writer_model.dart';

class StoryWriterRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<StoryWriterModel>> getStories() {
    return firestore.collection("written_stories").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data["id"] = doc.id;
        return StoryWriterModel.fromMap(data);
      }).toList();
    });
  }

  Future<void> addStory(StoryWriterModel story) async {
    final docRef = firestore.collection("written_stories").doc();
    await docRef.set({
      ...story.toMap(),
      "id": docRef.id,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStory(StoryWriterModel story) async {
    await firestore.collection("written_stories").doc(story.id).update({
      ...story.toMap(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStory(String id) async {
    await firestore.collection("written_stories").doc(id).delete();
  }
}
