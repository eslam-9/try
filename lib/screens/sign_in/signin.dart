// ignore_for_file: use_build_context_synchronously

import 'package:chatify/logic/authorization.dart';
import 'package:chatify/logic/user_provider.dart';
import 'package:chatify/screens/signup/textfieldmake.dart';
import 'package:chatify/theaming/color.dart';
import 'package:chatify/theaming/font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signin extends StatelessWidget {
  Signin({super.key});
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 250,
              ),
              const Text(
                "Chatify",
                style: FontMange.appname,
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Textfieldmake(
                    controller: _email,
                    hint: "Email",
                    isbassword: false,
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Textfieldmake(
                    controller: _pass,
                    hint: "Password",
                    isbassword: true,
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Authorization.signIn(
                        _pass.text.trim(), _email.text.trim());
                    final response = await Supabase.instance.client
                        .from("data")
                        .select("username")
                        .eq('id', Supabase.instance.client.auth.currentUser!.id)
                        .maybeSingle();
                    if (response != null) {
                      Provider.of<UserProvider>(context, listen: false)
                          .fetchUsername();
                      GoRouter.of(context).go("/signin/chat");
                    } else {
                      GoRouter.of(context).go("/informations");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManege.mainblue,
                      minimumSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "Sign In",
                    style: FontMange.buttonfont,
                  )),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go("/signup");
                  },
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    "Don't have an account?",
                    style: FontMange.makeaccount,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
