import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/brand_config.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    try {
      await auth.bootstrap();
    } catch (_) {
      await auth.logout();
    }
    if (!mounted) return;
    final onboardingDone = await StorageService().isOnboardingDone();
    if (!mounted) return;
    final route = auth.isLoggedIn
        ? AppRoutes.home
        : (onboardingDone ? AppRoutes.login : AppRoutes.onboarding);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: BrandConfig.lightBg,
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: LogoSize.hero, showName: true),
                const SizedBox(height: 12),
                Text(
                  BrandConfig.tagline,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: BrandConfig.textSecondary,
                      ),
                ),
                const SizedBox(height: 40),
                CircularProgressIndicator(
                  color: BrandConfig.primary.withValues(alpha: 0.8),
                  strokeWidth: 2.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
