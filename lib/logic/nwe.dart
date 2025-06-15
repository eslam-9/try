import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDataHandler {
  final SupabaseClient client = Supabase.instance.client;

  Future<File?> pickImageAndUpload() async {
    final user = client.auth.currentUser;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final image = File(pickedFile.path);
    final ext = extension(image.path);
    final imageName = "${user!.id}$ext";
    final imagePath = imageName;

    try {
      await client.storage.from("photo").upload(
            imagePath,
            image,
            fileOptions: const FileOptions(upsert: true),
          );
      final imageUrl = client.storage.from("photo").getPublicUrl(imagePath);

      await client.from("data").update({
        "imageurl": imageUrl,
      }).eq("id", user.id);

      return image;
    } catch (e) {
      return null;
    }
  }

  Future<void> addName(String username) async {
    final user = client.auth.currentUser;
    if (user != null) {
      await client.from("data").update({
        "username": username,
      }).eq("id", user.id);
    }
  }

  Future<String?> fetchImageUrl() async {
    final user = client.auth.currentUser;
    final result = await client
        .from("data")
        .select("imageurl")
        .eq("id", user!.id)
        .maybeSingle();
    return result?['imageurl'] as String?;
  }

  Future<String?> fetchUsername() async {
    final user = client.auth.currentUser;
    final result = await client
        .from("data")
        .select("username")
        .eq("id", user!.id)
        .maybeSingle();
    return result?['username'] as String?;
  }
}
