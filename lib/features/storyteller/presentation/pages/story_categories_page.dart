import 'package:flutter/material.dart';
import 'story_list_page.dart';

class StoryCategoriesPage extends StatelessWidget {
  const StoryCategoriesPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      "name": "Romance",
      "icon": Icons.favorite,
      "colors": [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
    },
    {
      "name": "Comedy",
      "icon": Icons.emoji_emotions,
      "colors": [Color(0xFFFFE259), Color(0xFFFFA751)],
    },
    {
      "name": "Thriller",
      "icon": Icons.visibility,
      "colors": [Color(0xFF434343), Color(0xFF000000)],
    },
    {
      "name": "Sports",
      "icon": Icons.sports_soccer,
      "colors": [Color(0xFF4AC29A), Color(0xFFBDFFF3)],
    },
    {
      "name": "Horror",
      "icon": Icons.nightlight_round,
      "colors": [Color(0xFF8E0E00), Color(0xFF1F1C18)],
    },
    {
      "name": "News",
      "icon": Icons.newspaper,
      "colors": [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        title: const Text(
          "Story Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.90,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return _animatedCategoryCard(
              context,
              title: category["name"],
              icon: category["icon"],
              colors: category["colors"],
            );
          },
        ),
      ),
    );
  }

  Widget _animatedCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> colors,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.85, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StoryListPage(genre: title)),
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
