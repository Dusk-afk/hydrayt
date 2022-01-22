// ignore_for_file: prefer_const_constructors

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/left_bar.dart';
import 'package:hydra_gui_app/widgets/main_screen.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:hydra_gui_app/widgets/title_bar.dart';

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

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202225),
      body: Column(
        children: [
          TitleBar(),
          Expanded(
            child: Row(
              children: [LeftBar(), Expanded(child: SetupScreen())],
            ),
          ),
        ],
      ),
    );
  }
}
