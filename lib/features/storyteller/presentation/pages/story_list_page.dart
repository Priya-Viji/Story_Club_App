import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_club/features/storyteller/presentation/pages/add_story_page.dart';
import 'package:story_club/features/storyteller/presentation/pages/edit_story_page.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../bloc/story_state.dart';
import 'story_detail_page.dart';
import 'package:story_club/features/storyteller/domain/entities/story_entity.dart';

class StoryListPage extends StatefulWidget {
  final String genre;

  const StoryListPage({super.key, required this.genre});

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  @override
  void initState() {
    super.initState();
    context.read<StoryBloc>().add(LoadStories(widget.genre));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),

      appBar: AppBar(
        title: Text(
          "${widget.genre} Stories",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddStoryPage(genre: widget.genre),
            ),
          ).then((_) {
            context.read<StoryBloc>().add(LoadStories(widget.genre));
          });
        },
      ),

      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading || state is StoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StoryLoaded) {
            final stories = state.stories;

            if (stories.isEmpty) {
              return const Center(
                child: Text(
                  "No stories available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final StoryEntity story = stories[index];
                return _storyCard(context, story);
              },
            );
          }

          if (state is StoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message.isNotEmpty
                      ? state.message
                      : 'Unable to load stories right now.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  // ---------------- STORY CARD ----------------

  Widget _storyCard(BuildContext context, StoryEntity story) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.90, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StoryDetailPage(story: story)),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail with rounded left side
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: story.thumbnail.isNotEmpty
                    ? Image.network(
                        story.thumbnail,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 110,
                            height: 110,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 110,
                        height: 110,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        story.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          story.genre,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Popup Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == "edit") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditStoryPage(story: story),
                      ),
                    );
                  } else if (value == "delete") {
                    _showDeleteDialog(context, story.id);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "edit", child: Text("Edit Story")),
                  PopupMenuItem(value: "delete", child: Text("Delete Story")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void _showDeleteDialog(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Delete Story?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete this story? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Delete"),
            onPressed: () {
              context.read<StoryBloc>().add(DeleteStoryEvent(id));
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
