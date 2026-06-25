import 'package:flutter/material.dart';
import 'story_writer_list_page.dart';

class StoryWriterTypesPage extends StatelessWidget {
  const StoryWriterTypesPage({super.key});

  static const List<Map<String, dynamic>> storyTypes = [
    {"name": "Short Film", "icon": Icons.movie},
    {"name": "Featured Film", "icon": Icons.local_movies},
    {"name": "Advertisements", "icon": Icons.campaign},
    {"name": "30 Seconds Stories", "icon": Icons.av_timer},
    {"name": "45 Seconds Stories", "icon": Icons.timer},
    {"name": "60 Seconds Stories", "icon": Icons.timer_outlined},
    {"name": "Books", "icon": Icons.menu_book},
    {"name": "Biographies", "icon": Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),

      appBar: AppBar(
        title: const Text(
          "Story Types",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 1.1,
        ),
        itemCount: storyTypes.length,
        itemBuilder: (context, index) {
          final item = storyTypes[index];

          return _typeCard(
            context: context,
            title: item["name"] as String,
            icon: item["icon"] as IconData,
          );
        },
      ),
    );
  }

  Widget _typeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryWriterListPage(storyType: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
