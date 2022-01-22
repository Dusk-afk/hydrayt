import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
      ),
    );
  }
}