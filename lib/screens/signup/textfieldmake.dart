import 'package:chatify/theaming/color.dart';
import 'package:chatify/theaming/font.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Textfieldmake extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String hint;
  final bool isbassword;
  Textfieldmake({
    super.key,
    required this.controller,
    required this.hint,
    required this.isbassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isbassword,
      style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          hintText: hint,
          hintStyle: FontMange.hint,
          filled: true,
          fillColor: ColorManege.textfield),
    );
  }
}
