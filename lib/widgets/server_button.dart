import 'package:flutter/material.dart';

class ServerButton extends StatefulWidget {
  Widget child;
  Function onPressed;
  bool enabled;

  ServerButton({Key? key, required this.child, required this.onPressed, this.enabled = true}) : super(key: key);

  @override
  _ServerButtonState createState() => _ServerButtonState();
}

class _ServerButtonState extends State<ServerButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.enabled? widget.onPressed() : () {},
        child: AnimatedContainer(
          width: 48,
          height: 48,
          duration: Duration(milliseconds: 100),

          child: widget.child,

          decoration: BoxDecoration(
            color: Color(0xFF36393F),
            borderRadius: BorderRadius.all(Radius.circular(widget.enabled? (_hovered? 18 : 25) : 25))
          ),
        )
      ),
    );
  }
}
