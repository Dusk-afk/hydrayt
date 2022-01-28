import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';

class CustomSimpleDialog extends StatelessWidget {
  String title;
  String subTitle;
  String buttonText;

  CustomSimpleDialog({Key? key, required this.title, required this.subTitle, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // width: 360,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 19,
                fontFamily: "segoe",
                fontWeight: FontWeight.bold
              ),
            ),

            Text(
              subTitle,
              style: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 19,
                fontFamily: "segoe",
              ),
            ),

            SizedBox(height: 30,),
            SelectButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: buttonText,
            ),
            SizedBox(height: 20,)
          ],
        ),

        decoration: BoxDecoration(
          color: Color(0xFF2F3136),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );;
  }
}
