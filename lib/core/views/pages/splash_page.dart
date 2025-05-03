import 'package:flutter/material.dart';
import 'package:youtube_download_manager/core/views/pages/bottom_nav_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomNavPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              'YouTube\n Video Downloader',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
