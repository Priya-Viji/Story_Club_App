import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story_writer_entity.dart';
import '../bloc/story_writer_bloc.dart';
import '../bloc/story_writer_event.dart';
import '../../../../cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class EditStoryWriterPage extends StatefulWidget {
  final StoryWriterEntity story;

  const EditStoryWriterPage({super.key, required this.story});

  @override
  State<EditStoryWriterPage> createState() => _EditStoryWriterPageState();
}

class _EditStoryWriterPageState extends State<EditStoryWriterPage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String genre;
  late String storyType;
  late String description;
  late String content;

  File? newCoverImageFile;
  bool isUploading = false;

  final List<String> storyTypes = [
    "Short Film",
    "Featured Film",
    "Advertisements",
    "30 Seconds Stories",
    "45 Seconds Stories",
    "60 Seconds Stories",
    "Books",
    "Biographies",
  ];

  @override
  void initState() {
    super.initState();
    title = widget.story.title;
    genre = widget.story.genre;
    storyType = widget.story.storyType;
    description = widget.story.description;
    content = widget.story.content;
  }

  Future<void> pickCoverImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newCoverImageFile = File(picked.path));
    }
  }

  Future<void> updateStory() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isUploading = true);

    String finalCoverUrl = widget.story.coverImage;

    if (newCoverImageFile != null) {
      final cloudinary = CloudinaryService();
      final uploadedUrl = await cloudinary.uploadImage(newCoverImageFile!);
      if (uploadedUrl != null) {
        finalCoverUrl = uploadedUrl;
      }
    }

    final updatedStory = StoryWriterEntity(
      id: widget.story.id,
      title: title,
      genre: genre,
      storyType: storyType,
      coverImage: finalCoverUrl,
      description: description,
      content: content,
    );

    context.read<StoryWriterBloc>().add(UpdateWrittenStoryEvent(updatedStory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Story", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input("Story Title", title, (v) => title = v!),
              _input("Genre", genre, (v) => genre = v!),

              DropdownButtonFormField(
                value: storyType,
                decoration: _decor("Story Type"),
                items: storyTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => storyType = v!,
                validator: (v) => v == null ? "Select story type" : null,
              ),

              const SizedBox(height: 16),
              _input(
                "Description",
                description,
                (v) => description = v!,
                maxLines: 3,
              ),
              _input(
                "Story Content",
                content,
                (v) => content = v!,
                maxLines: 6,
              ),

              const SizedBox(height: 20),
              _uploadTile(),

              const SizedBox(height: 20),
              isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                      ),
                      onPressed: updateStory,
                      child: const Text("Update Story"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    String initial,
    Function(String?) onSaved, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initial,
        maxLines: maxLines,
        decoration: _decor(label),
        validator: (v) => v!.isEmpty ? "Enter $label" : null,
        onSaved: onSaved,
      ),
    );
  }

  InputDecoration _decor(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xfff3f3f3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _uploadTile() {
    return InkWell(
      onTap: pickCoverImage,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.image, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Text(
              newCoverImageFile == null
                  ? "Change Cover Image"
                  : "New Image Selected",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
