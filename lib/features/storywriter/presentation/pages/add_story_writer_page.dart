import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story_writer_entity.dart';
import '../bloc/story_writer_bloc.dart';
import '../bloc/story_writer_event.dart';
import '../../../../cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryWriterPage extends StatefulWidget {
  const AddStoryWriterPage({super.key});

  @override
  State<AddStoryWriterPage> createState() => _AddStoryWriterPageState();
}

class _AddStoryWriterPageState extends State<AddStoryWriterPage> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String genre = "";
  String storyType = "";
  String description = "";
  String content = "";

  File? coverImageFile;
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

  Future<void> pickCoverImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => coverImageFile = File(picked.path));
    }
  }

  Future<void> saveStory() async {
    if (!_formKey.currentState!.validate()) return;

    if (coverImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a cover image")),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => isUploading = true);

    final cloudinary = CloudinaryService();
    final coverUrl = await cloudinary.uploadImage(coverImageFile!);

    final story = StoryWriterEntity(
      id: "",
      title: title,
      genre: genre,
      storyType: storyType,
      coverImage: coverUrl ?? "",
      description: description,
      content: content,
    );

    context.read<StoryWriterBloc>().add(AddWrittenStoryEvent(story));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Written Story",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input("Story Title", (v) => title = v!),
              _input("Genre", (v) => genre = v!),

              DropdownButtonFormField(
                decoration: _decor("Story Type"),
                items: storyTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => storyType = v!,
                validator: (v) => v == null ? "Select story type" : null,
              ),

              const SizedBox(height: 16),
              _input("Description", (v) => description = v!, maxLines: 3),
              _input("Story Content", (v) => content = v!, maxLines: 6),

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
                      onPressed: saveStory,
                      child: const Text("Save Story"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, Function(String?) onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
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
              coverImageFile == null ? "Upload Cover Image" : "Image Selected",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
