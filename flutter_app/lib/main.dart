import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_routes.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/otp_login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/shell/chat_shell_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (DefaultFirebaseOptions.isConfigured) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(const NovaApp());
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => const SplashScreen(),
              AppRoutes.onboarding: (_) => const OnboardingScreen(),
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const RegisterScreen(),
              AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
              AppRoutes.otpLogin: (_) => const OtpLoginScreen(),
              AppRoutes.home: (_) => const ChatShellScreen(),
              AppRoutes.chat: (_) => const ChatShellScreen(),
              AppRoutes.profile: (_) => const ProfileScreen(),
              AppRoutes.settings: (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
