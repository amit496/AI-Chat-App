import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/brand_config.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../routes/app_routes.dart';
import 'app_logo.dart';

/// Sidebar menu (ChatGPT-style quick actions).
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: const AppLogo(size: LogoSize.medium, showName: true),
            ),
            ListTile(
              leading: const Icon(Icons.add_comment_outlined),
              title: const Text('New chat'),
              onTap: () {
                Navigator.pop(context);
                context.read<ChatProvider>().startNewChat();
                Navigator.pushNamed(context, AppRoutes.chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Chat history'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            const Spacer(),
            if (auth.user != null)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: BrandConfig.primaryLight,
                  child: Text(
                    auth.user!.name.isNotEmpty ? auth.user!.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: BrandConfig.primary),
                  ),
                ),
                title: Text(auth.user!.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(auth.user!.email, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
