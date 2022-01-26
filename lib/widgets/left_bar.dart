import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/add_server_dialog.dart';
import 'package:hydra_gui_app/widgets/server_button.dart';

import '../main.dart';

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

      child: Column(
        children: [
          MainApp.showSetupScreen?
          ServerButton(
            onPressed: () {},
            enabled: false,
            child: Center(
              child: Text(
                "?",
                style: TextStyle(
                  color: Color(0xFFFFED00),
                  fontSize: 26,
                  fontFamily: "segoe",
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ) : Container(),
          SizedBox(height: 8,),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Color(0xFF2D2F32),
              borderRadius: BorderRadius.all(Radius.circular(100))
            ),
          ),
          SizedBox(height: 8,),
          ServerButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddServerDialog()
              );
            },
            child: SizedBox(
              width: 16,
              height: 16,
              child: Icon(
                Icons.add,
                color: Color(0xFF3BA55D),
              ),
            ),
          )
        ],
      ),
    );
  }
}
