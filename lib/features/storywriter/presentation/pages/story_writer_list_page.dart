import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story_writer_entity.dart';
import '../bloc/story_writer_bloc.dart';
import '../bloc/story_writer_event.dart';
import '../bloc/story_writer_state.dart';
import 'add_story_writer_page.dart';
import 'edit_story_writer_page.dart';
import 'story_writer_detail_page.dart';

class StoryWriterListPage extends StatefulWidget {
  final String storyType;

  const StoryWriterListPage({super.key, required this.storyType});

  @override
  State<StoryWriterListPage> createState() => _StoryWriterListPageState();
}

class _StoryWriterListPageState extends State<StoryWriterListPage> {
  @override
  void initState() {
    super.initState();
    context.read<StoryWriterBloc>().add(LoadWrittenStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),

      appBar: AppBar(
        title: Text(
          widget.storyType,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStoryWriterPage()),
          );
        },
      ),

      body: BlocBuilder<StoryWriterBloc, StoryWriterState>(
        builder: (context, state) {
          if (state is StoryWriterLoading || state is StoryWriterInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StoryWriterLoaded) {
            final filteredStories = state.stories
                .where((story) => story.storyType == widget.storyType)
                .toList();

            if (filteredStories.isEmpty) {
              return const Center(
                child: Text(
                  "No stories available",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStories.length,
              itemBuilder: (context, index) {
                final story = filteredStories[index];
                return _storyCard(story);
              },
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  Widget _storyCard(StoryWriterEntity story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoryWriterDetailPage(story: story),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
              child: Image.network(
                story.coverImage,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      story.genre,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "edit") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditStoryWriterPage(story: story),
                    ),
                  );
                } else if (value == "delete") {
                  _showDeleteDialog(story.id);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: "edit", child: Text("Edit Story")),
                PopupMenuItem(value: "delete", child: Text("Delete Story")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Story?"),
        content: const Text("Are you sure you want to delete this story?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<StoryWriterBloc>().add(DeleteWrittenStoryEvent(id));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
