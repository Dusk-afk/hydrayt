// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/user.dart';
import 'package:hydra_gui_app/providers/guild_model.dart';
import 'package:hydra_gui_app/providers/setup_provider.dart';
import 'package:hydra_gui_app/providers/user_provider.dart';
import 'package:hydra_gui_app/providers/video_model.dart';
import 'package:hydra_gui_app/widgets/left_bar.dart';
import 'package:hydra_gui_app/widgets/main_screen.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:hydra_gui_app/widgets/title_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<User?> getUserData() async {
  // Getting Directory of user data
  Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
  // Getting user file inside this directory
  File userFile = File(userDir.path + "\\user.dk");

  // If this file doesn't exist then show setup screen
  if (!(await userFile.exists())){
    return null;
  }

  String token = await userFile.readAsString();
  User user = User.fromToken(token);
  await user.init();
  return user.isValid? user : null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  User? user = await getUserData();
  UserProvider userProvider = UserProvider();
  if (user != null) {
    userProvider.setCurrentUser(user);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => GuildProvider()),
        ChangeNotifierProvider(create: (_) => userProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/main" : (context) => MainScreen(),
          "/setup" : (context) => SetupScreen()
        },
        home: user == null? SetupScreen() : MainScreen(),

        theme: ThemeData(
          textTheme: TextTheme(
            // AppBar Text
            displayLarge: TextStyle(
              fontSize: 17,
              fontFamily: "segoe",
              fontWeight: FontWeight.w600,
              color: Color(0xFFADADAD),
              letterSpacing: 2
            )
          )
        ),
      ),
    )
  );

  doWhenWindowReady(() {
    appWindow.size = Size(1024, 768);
    appWindow.minSize = Size(800, 600);
    appWindow.title = "HydraYT";
    appWindow.show();
  });
}