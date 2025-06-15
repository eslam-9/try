import 'package:chatify/logic/chat_logic.dart';
import 'package:chatify/theaming/color.dart';
import 'package:chatify/theaming/font.dart';
import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  final String hint;
  final bool isbassword;

  const MessageField({
    super.key,
    required this.hint,
    required this.isbassword,
  });

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: widget.isbassword,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: widget.hint,
        hintStyle: FontMange.hint,
        filled: true,
        fillColor: ColorManege.textfield,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final content = controller.text.trim();
                if (content.isEmpty) return;

                await ChatLogic.sendMessage(content);
                controller.clear();
              },
            ),
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () async {
                final file = await ChatLogic.pickImage();
                if (file != null) {
                  await ChatLogic.sendImageMessage(file);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
