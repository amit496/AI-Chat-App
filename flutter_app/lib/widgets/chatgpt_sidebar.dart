import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/brand_config.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import 'brand_logo.dart';

/// ChatGPT-style dark sidebar with chat history.
class ChatGptSidebar extends StatelessWidget {
  const ChatGptSidebar({super.key});

  Future<void> _showChatMenu(BuildContext context, ChatProvider chat, dynamic item) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final position = box.localToGlobal(Offset.zero);
    final selected = await showMenu<String>(
      context: context,
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      position: RelativeRect.fromLTRB(
        position.dx + box.size.width - 160,
        position.dy,
        position.dx + box.size.width,
        position.dy + box.size.height,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'delete',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.redAccent.shade200, size: 20),
              const SizedBox(width: 12),
              Text('Delete chat', style: TextStyle(color: Colors.redAccent.shade200, fontSize: 14)),
            ],
          ),
        ),
      ],
    );

    if (selected == 'delete' && context.mounted) {
      final ok = await _confirmDelete(context, item.title);
      if (ok) await chat.deleteChat(item.id);
    }
  }

  Future<bool> _confirmDelete(BuildContext context, String title) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: BrandConfig.sidebarHover,
            title: const Text('Delete chat?', style: TextStyle(color: BrandConfig.sidebarText)),
            content: Text(
              'Remove "$title"? This cannot be undone.',
              style: const TextStyle(color: BrandConfig.sidebarMuted),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel', style: TextStyle(color: BrandConfig.sidebarMuted)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();

    return Theme(
      data: ThemeData.dark().copyWith(
        canvasColor: BrandConfig.sidebarBg,
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF2A2A2A),
          surfaceTintColor: Colors.transparent,
          textStyle: TextStyle(color: BrandConfig.sidebarText),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: BrandConfig.sidebarMuted,
          textColor: BrandConfig.sidebarText,
          tileColor: Colors.transparent,
        ),
      ),
      child: Drawer(
        backgroundColor: BrandConfig.sidebarBg,
        elevation: 0,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Row(
                  children: [
                    const BrandLogo(size: 32, variant: LogoVariant.sidebar),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        BrandConfig.appName,
                        style: TextStyle(
                          color: BrandConfig.sidebarText,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: BrandConfig.sidebarMuted, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Material(
                  color: BrandConfig.sidebarHover,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      chat.startNewChat();
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: BrandConfig.sidebarText, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'New chat',
                            style: TextStyle(color: BrandConfig.sidebarText, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Chats',
                  style: TextStyle(color: BrandConfig.sidebarMuted, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: chat.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: BrandConfig.sidebarMuted, strokeWidth: 2),
                      )
                    : chat.chats.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'No conversations yet',
                                style: TextStyle(color: BrandConfig.sidebarMuted, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: chat.chats.length,
                            itemBuilder: (context, index) {
                              final item = chat.chats[index];
                              final active = chat.activeChatId == item.id;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Dismissible(
                                    key: ValueKey('chat-${item.id}'),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      color: const Color(0xFF5C2B2B),
                                      child: const Icon(Icons.delete_outline, color: Color(0xFFFF8A80), size: 22),
                                    ),
                                    confirmDismiss: (_) => _confirmDelete(context, item.title),
                                    onDismissed: (_) => chat.deleteChat(item.id),
                                    child: Material(
                                      color: active ? BrandConfig.sidebarHover : Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          await chat.openChat(item.id);
                                          if (context.mounted) Navigator.pop(context);
                                        },
                                        onLongPress: () => _showChatMenu(context, chat, item),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.chat_bubble_outline,
                                                        size: 16,
                                                        color: active ? BrandConfig.sidebarText : BrandConfig.sidebarMuted,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          item.title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: BrandConfig.sidebarText,
                                                            fontSize: 14,
                                                            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Builder(
                                                builder: (btnCtx) => IconButton(
                                                  visualDensity: VisualDensity.compact,
                                                  padding: const EdgeInsets.all(8),
                                                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                                  icon: const Icon(
                                                    Icons.more_horiz,
                                                    color: BrandConfig.sidebarMuted,
                                                    size: 20,
                                                  ),
                                                  onPressed: () => _showChatMenu(btnCtx, chat, item),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              const Divider(color: Color(0xFF3F3F3F), height: 1),
              ListTile(
                dense: true,
                leading: Icon(
                  theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: BrandConfig.sidebarMuted,
                  size: 20,
                ),
                title: const Text('Dark mode', style: TextStyle(color: BrandConfig.sidebarText, fontSize: 14)),
                onTap: theme.toggle,
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.settings_outlined, color: BrandConfig.sidebarMuted, size: 20),
                title: const Text('Settings', style: TextStyle(color: BrandConfig.sidebarText, fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),
              if (auth.user != null)
                ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: BrandConfig.accent.withValues(alpha: 0.25),
                    child: Text(
                      auth.user!.name.isNotEmpty ? auth.user!.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: BrandConfig.accent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    auth.user!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BrandConfig.sidebarText, fontSize: 14),
                  ),
                  subtitle: Text(
                    auth.user!.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BrandConfig.sidebarMuted, fontSize: 11),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
