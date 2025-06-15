// ignore_for_file: deprecated_member_use

import 'package:chatify/logic/chat_logic.dart';
import 'package:chatify/logic/user_provider.dart';
import 'package:chatify/screens/chat/massege_field.dart';
import 'package:chatify/theaming/color.dart';
import 'package:chatify/theaming/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final Stream<List<Map<String, dynamic>>> _messagesStream;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messagesStream = ChatLogic.getmesseges();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatTimestamp(dynamic timestamp) {
    try {
      DateTime dateTime;

      if (timestamp is String) {
        dateTime = DateTime.parse(timestamp).toLocal();
      } else if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
      } else if (timestamp is DateTime) {
        dateTime = timestamp.toLocal();
      } else {
        return 'Invalid time';
      }

      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid time';
    }
  }

  void scrollToBottom() {
    if (_scrollController.hasClients && mounted) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    final username = Provider.of<UserProvider>(context).username ?? 'Guest';

    return WillPopScope(
      onWillPop: () async {
        await supabase.auth.signOut();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManege.background,
          title: Text(
            username,
            style: FontMange.buttonfont,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _messagesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No messages yet"));
            }

            final messages = snapshot.data!;
            WidgetsBinding.instance
                .addPostFrameCallback((_) => scrollToBottom());

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                final isMine = message['sender'] == currentUser?.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: isMine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(isMine ? '0xFF0052DA' : '0xFF1E1D25'),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: message['type'] == 'image'
                            ? Image.network(message['contant'], width: 200)
                            : Text(
                                message['contant'] ?? 'No content',
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatTimestamp(message['created_at']),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(20),
          child: MessageField(hint: "Type a message", isbassword: false),
        ),
      ),
    );
  }
}
