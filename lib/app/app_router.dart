import 'package:flutter/material.dart';
import 'package:story_club/features/auth/presentation/pages/home_page.dart';
import 'package:story_club/features/auth/presentation/pages/story_teller_page.dart';
import 'package:story_club/features/auth/presentation/pages/story_writer_page.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/story-teller':
        return MaterialPageRoute(builder: (_) => const StoryTellerPage());

      case '/story-writer':
        return MaterialPageRoute(builder: (_) => const StoryWriterPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
