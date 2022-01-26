import 'package:flutter/material.dart';

class SelectButton extends StatefulWidget {
  Function onPressed;
  String text;
  double? width;
  double? height;
  bool enabled;

  SelectButton({ Key? key, required this.onPressed, this.text = "Select", this.enabled = true, this.width, this.height}) : super(key: key);

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.enabled? widget.onPressed() : () {};
      },
      child: MouseRegion(
        cursor: widget.enabled? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: widget.width??=166,
          height: widget.height??=35,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "segoe",
                fontWeight: FontWeight.w600,
                color: Color(0xFFD5D5D5),
              ),
            ),
          ),

          decoration: BoxDecoration(
            // color: widget.enabled? Colors.transparent : Color(0xFF403D3D),
              gradient: widget.enabled? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5865F2),
                    isHovered? Color(0xFF3B44A7) : Color(0xFF5865F2)
                  ]
              ) : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF403D3D),
                    Color(0xFF403D3D),
                  ]
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5))
          ),
        ),
      ),
    );
  }
}