import 'package:flutter/material.dart';

class LeftBar extends StatefulWidget {
  const LeftBar({Key? key}) : super(key: key);

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: Color(0xFF202225),
    );
  }
}
