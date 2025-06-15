import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatLogic {
  static Stream<List<Map<String, dynamic>>> getmesseges() {
    return Supabase.instance.client
        .from("messege")
        .stream(primaryKey: ["id"]).order("created_at", ascending: false);
  }

  static Future<void> sendMessage(String content) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    await supabase.from('messege').insert({
      'contant': content,
      'sender': user!.id,
    });
  }

  static Future<void> sendImageMessage(File imageFile) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    final fileName = 'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('chat').upload(fileName, imageFile);

    final imageUrl = supabase.storage.from('chat').getPublicUrl(fileName);

    await supabase.from('messege').insert({
      'contant': imageUrl,
      'sender': user!.id,
      'type': 'image',
    });
  }

  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
