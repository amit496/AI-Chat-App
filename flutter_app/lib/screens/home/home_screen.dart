import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/shimmer_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(size: LogoSize.small, showName: true),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<ChatProvider>().startNewChat();
          Navigator.pushNamed(context, AppRoutes.chat);
        },
        icon: const Icon(Icons.add_comment),
        label: const Text('New chat'),
      ),
      body: chat.isLoading
          ? const ChatListShimmer()
          : chat.chats.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLogo(size: LogoSize.large, showName: false),
                        const SizedBox(height: 16),
                        Text('No chats yet', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Text('Start a conversation with Gemini AI'),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: chat.loadHistory,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: chat.chats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = chat.chats[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Theme.of(context).colorScheme.error,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          await chat.deleteChat(item.id);
                          return true;
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(item.title.isNotEmpty ? item.title[0].toUpperCase() : '?'),
                            ),
                            title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: item.createdAt != null
                                ? Text(item.createdAt!.toLocal().toString().substring(0, 16))
                                : null,
                            onTap: () async {
                              await chat.openChat(item.id);
                              if (context.mounted) {
                                Navigator.pushNamed(context, AppRoutes.chat);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
