import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      child: Center(
        child: Text(
          "Main Screen",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "segoe",
            fontSize: 32,
            fontWeight: FontWeight.w600
          ),
        )
      ),

      decoration: BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
      ),
    );
  }
}