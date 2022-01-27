import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/server_button_network.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: SizedBox(height: 1,)),
          Center(
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
          TextButton(
            onPressed: () {
              print(ServerButtonNetwork.currentSelected!.name);
            },
            child: Text("Current Server"),
          ),
          Expanded(child: SizedBox(height: 1,)),
        ],
      ),

      decoration: BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
      ),
    );
  }
}