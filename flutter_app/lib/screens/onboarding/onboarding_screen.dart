import 'package:flutter/material.dart';

import '../../core/constants/brand_config.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/brand_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  final _slides = const [
    ('Chat with AI', 'Smart replies powered by Google Gemini'),
    ('Voice & images', 'Speak or attach photos — get clear answers'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F6FA), Color(0xFFE8ECF4)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const AppLogo(size: LogoSize.medium, showName: true),
              Expanded(
                child: PageView.builder(
                  controller: _page,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final slide = _slides[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BrandLogo(
                            size: 100,
                            variant: BrandLogo.variantFor(context),
                            borderRadius: 22,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            slide.$1,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: BrandConfig.textPrimary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.$2,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: BrandConfig.textSecondary,
                                ),
                          ),
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
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _index == i ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _index == i ? BrandConfig.primary : BrandConfig.border,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(_index == _slides.length - 1 ? 'Get started' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
