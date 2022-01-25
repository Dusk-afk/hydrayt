// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/left_bar.dart';
import 'package:hydra_gui_app/widgets/main_screen.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:hydra_gui_app/widgets/title_bar.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),

      theme: ThemeData(
        textTheme: TextTheme(
          // AppBar Text
          headline1: TextStyle(
            fontSize: 17,
            fontFamily: "segoe",
            fontWeight: FontWeight.w600,
            color: Color(0xFFADADAD),
            letterSpacing: 2
          )
        )
      ),
    )
  );

  doWhenWindowReady(() {
    appWindow.size = Size(1024, 768);
    appWindow.minSize = Size(800, 600);
    appWindow.show();
  });
}

class MainApp extends StatefulWidget {
  static bool showSetupScreen = false;

  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    checkForUserData();
  }

  checkForUserData() async {
    // Getting Directory of user data
    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");

    // If this directory doesn't exist then show setup screen
    if (!(await userDir.exists())){
      // print("Directory doesn't exist");
      setState(() {
        MainApp.showSetupScreen = true;
      });
      return;
    }

    // Getting user file inside this directory
    File userFile = File(userDir.path + "\\user.dk");

    // If this file doesn't exist then show setup screen
    if (!(await userFile.exists())){
      // print("File doesn't exist");
      setState(() {
        MainApp.showSetupScreen = true;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202225),
      body: Column(
        children: [
          TitleBar(),
          Expanded(
            child: Row(
              children: [
                LeftBar(),
                Expanded(
                  child: MainApp.showSetupScreen? SetupScreen(
                    onEnd: () {
                      setState(() {
                        MainApp.showSetupScreen = false;
                      });
                    },
                  ) : MainScreen()
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
