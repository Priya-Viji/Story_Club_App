import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:story_club/cloudinary_service.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

class EditStoryPage extends StatefulWidget {
  final StoryEntity story;

  const EditStoryPage({super.key, required this.story});

  @override
  State<EditStoryPage> createState() => _EditStoryPageState();
}

class _EditStoryPageState extends State<EditStoryPage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;

  File? newThumbnailFile;
  File? newAudioFile;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    title = widget.story.title;
    description = widget.story.description;
  }

  // Pick new thumbnail
  Future<void> pickThumbnail() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newThumbnailFile = File(picked.path));
    }
  }

  // Pick Audio File
  Future<void> pickAudio() async {
    final result = await FilePicker.pickFiles(type: FileType.audio);

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        setState(() => newAudioFile = File(path));
      }
    }
  }

  // Save updated story
  Future<void> updateStory() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isUploading = true);

    String thumbnailUrl = widget.story.thumbnail;
    String audioUrl = widget.story.audio;

    try {
      final cloudinary = CloudinaryService();

      // Upload new thumbnail if selected
      if (newThumbnailFile != null) {
        thumbnailUrl =
            await cloudinary.uploadImage(newThumbnailFile!) ?? thumbnailUrl;
      }

      // Upload new audio if selected
      if (newAudioFile != null) {
        audioUrl = await cloudinary.uploadAudio(newAudioFile!) ?? audioUrl;
      }

      final updatedStory = StoryEntity(
        id: widget.story.id,
        title: title,
        genre: widget.story.genre,
        description: description,
        thumbnail: thumbnailUrl,
        audio: audioUrl,
      );

      // Send update event to BLoC
      context.read<StoryBloc>().add(UpdateStoryEvent(updatedStory));

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      print("Update failed: $e");
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),

      appBar: AppBar(
        title: const Text(
          "Edit Story",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Story Details"),

                    const SizedBox(height: 16),

                    _textField(
                      "Story Title",
                      initialValue: title,
                      onSaved: (v) => title = v!,
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Genre: ${widget.story.genre}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _textField(
                      "Description",
                      initialValue: description,
                      maxLines: 3,
                      onSaved: (v) => description = v!,
                    ),

                    const SizedBox(height: 28),
                    _sectionTitle("Thumbnail"),

                    const SizedBox(height: 16),

                    _uploadTile(
                      label: "Change Thumbnail",
                      icon: Icons.image,
                      onTap: pickThumbnail,
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: newThumbnailFile != null
                          ? Image.file(
                              newThumbnailFile!,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.story.thumbnail,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),

                    const SizedBox(height: 28),
                    _sectionTitle("Audio File"),

                    const SizedBox(height: 16),

                    _uploadTile(
                      label: "Change Audio File",
                      icon: Icons.audiotrack,
                      onTap: pickAudio,
                    ),

                    if (newAudioFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          newAudioFile!.path.split('/').last,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.story.audio.split('/').last,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    Center(
                      child: isUploading
                          ? const CircularProgressIndicator()
                          : _saveButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI COMPONENTS ----------------

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _textField(
    String label, {
    required String initialValue,
    required Function(String?) onSaved,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      validator: (v) => v!.isEmpty ? "Enter $label" : null,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xfff3f3f3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _uploadTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 28),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: updateStory,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        "Update Story",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
