import 'package:flutter/material.dart';

class StoryTellerPage extends StatelessWidget {
  const StoryTellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Teller'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'I Am A Story Teller',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Share your voice, record stories, and connect with listeners.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.mic),
                ),
                title: const Text('Record a story'),
                subtitle: const Text('Start sharing your voice with the community.'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.headphones),
                ),
                title: const Text('Listen to stories'),
                subtitle: const Text('Enjoy stories from other storytellers.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
