import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:story_club/cloudinary_service.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

class AddStoryPage extends StatefulWidget {
  final String genre;

  const AddStoryPage({super.key, required this.genre});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";

  File? thumbnailFile;
  File? audioFile;

  bool isUploading = false;

  // Pick Thumbnail Image
  Future<void> pickThumbnail() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => thumbnailFile = File(picked.path));
    }
  }

  // Pick Audio File
  Future<void> pickAudio() async {
    final result = await FilePicker.pickFiles(type: FileType.audio);

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        setState(() => audioFile = File(path));
      }
    }
  }

  // Save Story
  Future<void> saveStory() async {
    if (!_formKey.currentState!.validate()) return;

    if (thumbnailFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a thumbnail image")),
      );
      return;
    }

    if (audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an audio file")),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => isUploading = true);

    try {
      final cloudinary = CloudinaryService();

      final thumbnailUrl = await cloudinary.uploadImage(thumbnailFile!);
      final audioUrl = await cloudinary.uploadAudio(audioFile!);

      final story = StoryEntity(
        id: '',
        title: title,
        genre: widget.genre,
        description: description,
        thumbnail: thumbnailUrl!,
        audio: audioUrl!,
      );

      //  SEND TO BLoC (Correct Clean Architecture)
      context.read<StoryBloc>().add(AddStoryEvent(story));

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      print("Save failed: $e");
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),

      appBar: AppBar(
        title: const Text(
          "Add New Story",
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

                    _textField("Story Title", (v) => title = v!),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Genre: ${widget.genre}",
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
                      (v) => description = v!,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 28),
                    _sectionTitle("Upload Files"),

                    const SizedBox(height: 16),

                    _uploadTile(
                      label: "Select Thumbnail Image",
                      icon: Icons.image,
                      onTap: pickThumbnail,
                    ),

                    if (thumbnailFile != null) _previewImage(thumbnailFile!),

                    const SizedBox(height: 20),

                    _uploadTile(
                      label: "Select Audio File",
                      icon: Icons.audiotrack,
                      onTap: pickAudio,
                    ),

                    if (audioFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          audioFile!.path.split('/').last,
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
    String label,
    Function(String?) onSaved, {
    int maxLines = 1,
  }) {
    return TextFormField(
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

  Widget _previewImage(File file) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          file,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: saveStory,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        "Save Story",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.white),
      ),
    );
  }
}
