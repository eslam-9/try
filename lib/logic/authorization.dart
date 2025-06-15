// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authorization {
  static Future<void> signUp(String password, String email) async {
    try {
      final response = await Supabase.instance.client.auth
          .signUp(password: password, email: email);

      final insert = await Supabase.instance.client
          .from('data')
          .insert({"id": response.user!.id});
    } catch (ex) {}
  }

  static Future<void> signIn(String password, String email) async {
    try {
      final response = await Supabase.instance.client.auth
          .signInWithPassword(password: password, email: email);
    } catch (e) {}
  }

  static Future<void> addname(String username) async {
    final user = Supabase.instance.client.auth.currentUser;

    await Supabase.instance.client.from("data").update({
      "username": username,
    }).eq("id", user!.id);
  }

  Future<void> addimage() async {
    final user = Supabase.instance.client.auth.currentUser;
    final pickimage = await ImagePicker().pickImage(source: ImageSource.camera);
    final image = File(pickimage!.path);
    final imageExt = extension(image.path);
    final imageName = "${user!.id}$imageExt";
    final imagePath = "photo/$imageName";
    final storage = Supabase.instance.client.storage;
    try {
      await storage.from("photo").upload(imagePath, image,
          fileOptions: const FileOptions(upsert: true));
    } catch (e) {}
    final imageUrl = storage.from("photo").getPublicUrl(imagePath);
    await Supabase.instance.client.from("data").update({
      "imageurl": imageUrl,
    }).eq("id", user.id);
  }
}
