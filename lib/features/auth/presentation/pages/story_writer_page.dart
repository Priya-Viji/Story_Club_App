import 'package:flutter/material.dart';

class StoryWriterPage extends StatelessWidget {
  const StoryWriterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Writer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'I Am A Story Writer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Write your stories, publish them, and let readers enjoy your imagination.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.edit_note),
                ),
                title: const Text('Write a new story'),
                subtitle: const Text('Start crafting your next great story.'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.library_books),
                ),
                title: const Text('Browse stories'),
                subtitle: const Text('Read stories from other writers.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
