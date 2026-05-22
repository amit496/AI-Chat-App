import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/brand_config.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/theme_provider.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.chatBackground(context),
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'General',
            children: [
              SwitchListTile(
                title: const Text('Dark mode'),
                subtitle: const Text('Same as ChatGPT dark theme'),
                value: theme.isDark,
                onChanged: (_) => theme.toggle(),
              ),
            ],
          ),
          _Section(
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                subtitle: Text(auth.user?.email ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              ),
            ],
          ),
          _Section(
            title: 'Data',
            children: [
              ListTile(
                leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                title: const Text('Clear all chats'),
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear all chats?'),
                      content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
                      ],
                    ),
                  );
                  if (ok == true && context.mounted) {
                    await context.read<ChatProvider>().clearAll();
                  }
                },
              ),
            ],
          ),
          _Section(
            title: 'About',
            children: [
              const ListTile(
                title: Text(BrandConfig.appName),
                subtitle: Text('AI chat · Powered by Gemini'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
              }
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted(context),
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.isDark(context) ? BrandConfig.darkSurface : BrandConfig.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.isDark(context) ? BrandConfig.darkBorder : BrandConfig.lightBorder,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
