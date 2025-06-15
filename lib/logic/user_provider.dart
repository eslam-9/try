import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  String? _imageUrl;

  String? get username => _username;
  String? get imageUrl => _imageUrl;

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }

  void setImageUrl(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  void clearUserData() {
    _username = null;
    _imageUrl = null;
    notifyListeners();
  }

  Future<void> fetchUsername() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final response = await Supabase.instance.client
          .from("data")
          .select("username")
          .eq("id", userId)
          .maybeSingle();

      _username = response?["username"] as String?;
      notifyListeners();
    }
  }
}
