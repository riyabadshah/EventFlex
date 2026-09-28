import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/navbar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    AppDataState.instance.sendMessage(text);
    _msgController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'messages'),
          endDrawer: const AppDrawer(),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 16,
                  vertical: 24,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.border),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Row(
                    children: [
                      // Left Conversation Sidebar
                      if (isDesktop)
                        SizedBox(
                          width: 320,
                          child: _buildConversationList(context, state),
                        ),

                      if (isDesktop)
                        const VerticalDivider(width: 1, color: AppTheme.border),

                      // Chat Area
                      Expanded(
                        child: Column(
                          children: [
                            // Chat Header
                            _buildChatHeader(context, state),
                            const Divider(height: 1),

                            // Chat Messages Stream
                            Expanded(
                              child: state.messages.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppTheme.textMuted),
                                            SizedBox(height: 12),
                                            Text(
                                              'No messages yet',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              'Send a message to coordinate shift details.',
                                              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      controller: _scrollController,
                                      padding: const EdgeInsets.all(20),
                                      itemCount: state.messages.length,
                                      itemBuilder: (context, index) {
                                        final msg = state.messages[index];
                                        return _buildMessageBubble(msg);
                                      },
                                    ),
                            ),

                            const Divider(height: 1),

                            // Input Field
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.attach_file_rounded, color: AppTheme.textMuted),
                                    onPressed: () {},
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _msgController,
                                      onSubmitted: (_) => _send(),
                                      decoration: InputDecoration(
                                        hintText: 'Type your message...',
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  FilledButton(
                                    onPressed: _send,
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.all(14),
                                      shape: const CircleBorder(),
                                    ),
                                    child: const Icon(Icons.send_rounded, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConversationList(BuildContext context, AppDataState state) {
    final channelTitle = state.currentRole == 'Organizer'
        ? (state.currentProfessional.name.isNotEmpty ? state.currentProfessional.name : 'Event Staff Channel')
        : (state.currentOrganizer.companyName.isNotEmpty ? state.currentOrganizer.companyName : (state.currentOrganizer.name.isNotEmpty ? state.currentOrganizer.name : 'Event Organizer'));

    final eventSubtitle = state.events.isNotEmpty ? state.events.first.name : 'Active Event Coordination';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Conversations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Direct messaging between organizers & staff',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ListTile(
          selected: true,
          selectedTileColor: AppTheme.primaryLight.withOpacity(0.5),
          leading: const CircleAvatar(
            backgroundColor: AppTheme.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          title: Text(
            channelTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            eventSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          trailing: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.success,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatHeader(BuildContext context, AppDataState state) {
    final title = state.currentRole == 'Organizer'
        ? (state.currentProfessional.name.isNotEmpty ? state.currentProfessional.name : 'Event Staff')
        : (state.currentOrganizer.companyName.isNotEmpty
            ? state.currentOrganizer.companyName
            : (state.currentOrganizer.name.isNotEmpty ? state.currentOrganizer.name : 'Event Organizer'));

    final initials = title.isNotEmpty
        ? title.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join()
        : 'EV';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryLight,
            child: Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Row(
                  children: const [
                    Icon(Icons.circle, color: AppTheme.success, size: 8),
                    SizedBox(width: 6),
                    Text(
                      'Online • Shift Coordination',
                      style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: msg.isMe ? AppTheme.primary : AppTheme.surfaceSubtle,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msg.message,
                style: TextStyle(
                  color: msg.isMe ? Colors.white : AppTheme.textDark,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                msg.timestamp,
                style: TextStyle(
                  color: msg.isMe ? Colors.white70 : AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
