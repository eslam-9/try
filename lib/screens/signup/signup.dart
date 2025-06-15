import 'package:chatify/logic/authorization.dart';
import 'package:chatify/screens/signup/textfieldmake.dart';
import 'package:chatify/theaming/color.dart';
import 'package:chatify/theaming/font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  onPressed: () {
                    Authorization.signUp(_pass.text.trim(), _email.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManege.mainblue,
                      minimumSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "Sign Up",
                    style: FontMange.buttonfont,
                  )),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go("/signin");
                  },
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    " have an account?",
                    style: FontMange.makeaccount,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
