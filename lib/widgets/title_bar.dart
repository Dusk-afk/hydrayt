// ignore_for_file: prefer_const_constructors

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  bool toAnimate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      child: MoveWindow(
        child: Container(
          color: Color(0xFF202225),
          child: Row(
            children: [
              Expanded(
                  child: SizedBox(
                width: 1,
              )),

              // Maximize Button
              TitleBarButton(
                onPressed: () {
                  appWindow.minimize();
                },
                onHoverColor: Color(0xFF585858),
                normalColor: Colors.transparent,
                child: Image.asset("assets/win_min_icon.png"),
              ),

              // Maximize Button
              TitleBarButton(
                onPressed: () {
                  appWindow.maximizeOrRestore();
                },
                onHoverColor: Color(0xFF585858),
                normalColor: Colors.transparent,
                child: Image.asset("assets/win_max_icon.png"),
              ),

              // Close Button
              TitleBarButton(
                onPressed: () {
                  appWindow.close();
                },
                onHoverColor: Colors.red,
                normalColor: Colors.transparent,
                child: Image.asset("assets/win_close_icon.png"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TitleBarButton extends StatefulWidget {
  Function onPressed;
  Color onHoverColor;
  Color normalColor;
  Widget child;

  TitleBarButton(
      {Key? key,
      required this.onPressed,
      required this.onHoverColor,
      required this.normalColor,
      required this.child})
      : super(key: key);

  @override
  _TitleBarButtonState createState() => _TitleBarButtonState();
}

class _TitleBarButtonState extends State<TitleBarButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => setState(() {
              isHovered = true;
            }),
        onExit: (_) => setState(() {
              isHovered = false;
            }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 22,
          height: 22,
          color: isHovered ? widget.onHoverColor : widget.normalColor,
          child: TextButton(
            onPressed: () {
              widget.onPressed();
            },
            child: widget.child,
            style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent),
          ),
        ));
  }
}
