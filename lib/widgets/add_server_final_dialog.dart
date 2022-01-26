import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import '../data/guild.dart';

class AddServerFinalDialog extends StatefulWidget {
  Guild guild;
  AddServerFinalDialog({Key? key, required this.guild}) : super(key: key);

  @override
  _AddServerFinalDialogState createState() => _AddServerFinalDialogState();
}

class _AddServerFinalDialogState extends State<AddServerFinalDialog> {
  TextEditingController _channelIdController = TextEditingController();
  bool _channelIdFieldValidate = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 536,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox(width: 1,)),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Color(0xFFADADAD),
                    size: 20,
                  ),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                )
              ],
            ),
            SizedBox(height: 7,),
            Row(
              children: [
                SizedBox(width: 30,),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CachedNetworkImage(
                      width: 132,
                      height: 132,
                      imageUrl: "https://cdn.discordapp.com/icons/${widget.guild.id}/${widget.guild.icon}.webp?size=2048",
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: Color(0xFF5E74FF),
                        strokeWidth: 3,
                      ),
                      errorWidget: (context, url, error) => Container(
                        child: Center(
                          child: Text(
                            widget.guild.name[0],
                            style: TextStyle(
                              fontSize: 48,
                              color: Color(0xFFD7D9DA),
                              fontFamily: "segoe"
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF36393F),
                          borderRadius: BorderRadius.all(Radius.circular(40))
                        ),
                      ),
                    )
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF36393F),
                    borderRadius: BorderRadius.all(Radius.circular(500)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        blurRadius: 5,
                        offset: Offset(0, 5)
                      )
                    ]
                  ),
                ),
                Expanded(child: SizedBox(width: 1,)),
              ],
            ),
            SizedBox(height: 19,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                widget.guild.name,
                style: TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 43,
                  fontFamily: "segoe",
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            SizedBox(height: 35,),

            // Channel ID Text Field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Text(
                    "Channel ID ",
                    style: TextStyle(
                      color: Color(0xFF72767D),
                      fontSize: 16,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "?",
                      style: TextStyle(
                          color: Color(0xFF5865F2),
                          fontSize: 18,
                          fontFamily: "segoe",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all(Size.zero)
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 7,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _channelIdController,
                style: const TextStyle(
                  color: Color(0xFF70747B),
                  fontSize: 16,
                  fontFamily: "segoe",
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: const Color(0xFF5E74FF),
                decoration: InputDecoration(
                  focusColor: const Color(0xFF5E74FF),
                  errorStyle: TextStyle(height: 0),
                  errorText: _channelIdFieldValidate? " " : null,
                  fillColor: Color(0xFF202225),
                  filled: true,
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF202225)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF5E74FF)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF5E74FF)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            SizedBox(height: 36,),

            Row(
              children: [
                Expanded(child: SizedBox(width: 1,)),
                SelectButton(
                  onPressed: () {handleContinueButton();},
                  text: "Continue",
                  width: 100,
                ),
                SizedBox(width: 30,)
              ],
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
    );
  }

  handleContinueButton() {
    String channelId = _channelIdController.text;

    if (channelId.isEmpty){
      setState(() {
        _channelIdFieldValidate = true;
      });
      return;
    }

    // If reached here that means user entered all fields
    setState(() {
      _channelIdFieldValidate = false;
    });

    // TODO: Add Server using this data
  }
}
