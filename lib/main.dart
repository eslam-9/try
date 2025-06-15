import 'package:chatify/logic/user_provider.dart';
import 'package:chatify/screens/chat/chat.dart';
import 'package:chatify/screens/information/informations.dart';
import 'package:chatify/screens/sign_in/signin.dart';
import 'package:chatify/screens/signup/signup.dart';
import 'package:chatify/theaming/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://qnlafinwpywfponsqxdn.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFubGFmaW53cHl3ZnBvbnNxeGRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxOTUzOTEsImV4cCI6MjA2Mzc3MTM5MX0.5YJojGn0YYjFnMdXgFaHyomto-x1-eGK8drqpBchSqQ",
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _route,
      theme: ThemeData(
          primaryColor: ColorManege.mainblue,
          scaffoldBackgroundColor: ColorManege.background),
    );
  }
}

final _route = GoRouter(initialLocation: "/informations", routes: [
  GoRoute(
    path: "/signup",
    builder: (context, state) => SignUp(),
  ),
  GoRoute(path: "/signin", builder: (context, state) => Signin(), routes: [
    GoRoute(path: "/chat", builder: (context, state) => const Chat()),
  ]),
  GoRoute(
    path: "/informations",
    builder: (context, state) => const Informations(),
  ),
]);
