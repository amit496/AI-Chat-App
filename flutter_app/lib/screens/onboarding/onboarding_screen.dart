import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';
import '../../widgets/app_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  final _slides = const [
    ('Chat with AI', 'Powered by Google Gemini free tier'),
    ('Voice & images', 'Speak, upload photos, get smart replies'),
    ('Your history', 'Chats saved securely on your account'),
  ];

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index < _slides.length - 1) {
      await _page.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      return;
    }
    await StorageService().setOnboardingDone();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const AppLogo(size: LogoSize.large),
            Expanded(
              child: PageView.builder(
                controller: _page,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 64, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 24),
                        Text(slide.$1, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(slide.$2, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _index == i
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(_index == _slides.length - 1 ? 'Get started' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
