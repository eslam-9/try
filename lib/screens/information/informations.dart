// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chatify/logic/nwe.dart';
import 'package:chatify/logic/user_provider.dart';
import 'package:chatify/screens/signup/textfieldmake.dart';
import 'package:chatify/theaming/color.dart';
import 'package:chatify/theaming/font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Informations extends StatefulWidget {
  const Informations({super.key});

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  final _nameController = TextEditingController();
  final _handler = UserDataHandler();
  File? _localImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final url = await _handler.fetchImageUrl();
    if (url != null) {
      Provider.of<UserProvider>(context, listen: false).setImageUrl(url);
    }
  }

  Future<void> _pickImage() async {
    final image = await _handler.pickImageAndUpload();
    if (image != null) {
      setState(() => _localImage = image);
      _loadImage();
    }
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await _handler.addName(name);
      Provider.of<UserProvider>(context, listen: false).setUsername(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final imageWidget = CircleAvatar(
      radius: 80,
      backgroundImage: userProvider.imageUrl != null
          ? NetworkImage(userProvider.imageUrl!)
          : _localImage != null
              ? FileImage(_localImage!) as ImageProvider
              : null,
      child: userProvider.imageUrl == null && _localImage == null
          ? const Icon(Icons.person)
          : null,
    );

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageWidget,
              IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_a_photo),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Textfieldmake(
              controller: _nameController,
              hint: "Username",
              isbassword: false,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _saveName();
              GoRouter.of(context).go("/signin/chat");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManege.mainblue,
              minimumSize: const Size(250, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Next", style: FontMange.buttonfont),
          )
        ]),
      ),
    );
  }
}
