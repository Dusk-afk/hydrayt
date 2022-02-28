import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../data/guild.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class AddServerFinalDialog extends StatefulWidget {
  Guild guild;
  Function reload;
  AddServerFinalDialog({Key? key, required this.guild, required this.reload}) : super(key: key);

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
                    onPressed: () {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) => SetupStep1Dialog()
                      );
                    },
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
                  onPressed: () {
                    handleContinueButton();
                  },
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
    addGuildToData(channelId);
  }

  addGuildToData(String channelId) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SettingUpDialog()
    );

    String? messageId;
    try{
      http.Response response = await http.get(
        Uri.parse("https://discord.com/api/v9/channels/$channelId/messages"),
        headers: {
          "Content-Type": "application/json",
          "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
          "Authorization": MainApp.currentUser!.token
        }
      );

      try{
        List<dynamic> messages = await jsonDecode(response.body);
        messageId = messages[messages.length - 2]["id"];
      }catch(e){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error Occured"),
            content: Text(e.toString()),
            actions: [
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              )
            ],
          )
        );
      }
    }

    on SocketException{
      // No Internet
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Request Timed Out"),
          content: Text("Check you internet connection or try again later"),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        )
      );
    }

    catch(e){
      // Other error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error Occured"),
          content: Text(e.toString()),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        )
      );
    }

    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
    File guildsFile = File(userDir.path + "\\guilds.dk");

    // Create this file if it doesn't exist
    if (!(await guildsFile.exists())){
      guildsFile.create();

      String guildDetails = '{"id":"${widget.guild.id}", "name":"${widget.guild.name}", "icon":"${widget.guild.icon}", "channel_id":"$channelId", "message_id":"$messageId"}';
      List<dynamic> payload = [guildDetails];
      guildsFile.writeAsString(payload.toString());

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      widget.reload();

      return;
    }

    dynamic fileData = await guildsFile.readAsString();
    if (fileData.isEmpty){
      fileData = "[]";
    }

    try {
      fileData = jsonDecode(fileData);
    }catch(e){
      // File is probably corrupted
      fileData = [];
    }
    String guildDetails = '{"id":"${widget.guild.id}", "name":"${widget.guild.name}", "icon":"${widget.guild.icon}", "channel_id":"$channelId", "message_id":"$messageId"}';
    fileData.add(jsonDecode(guildDetails));

    guildsFile.writeAsString(jsonEncode(fileData));

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    widget.reload();
  }
}

class SetupStep1Dialog extends StatelessWidget {
  const SetupStep1Dialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 728,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox(width: 1,)),
                Text(
                  "1) Enable Developer Mode",
                  style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontFamily: "segoe",
                      fontWeight: FontWeight.w600,
                      fontSize: 17
                  ),
                ),
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
            SizedBox(height: 30,),
            const Text(
              "           1) Open discord settings",
              style: TextStyle(
                  color: Color(0xFFADADAD),
                  fontFamily: "segoe",
                  // fontWeight: FontWeight.w600,
                  fontSize: 19
              ),
            ),
            const SizedBox(height: 16,),
            const Text(
              "           2) Go to advanced and enable Developer Mode",
              style: TextStyle(
                  color: Color(0xFFADADAD),
                  fontFamily: "segoe",
                  // fontWeight: FontWeight.w600,
                  fontSize: 19
              ),
            ),
            SizedBox(height: 25,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 56),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset("assets/setup_step_1.png"),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(50, 0, 0, 0),
                    blurRadius: 5,
                    offset: Offset(0, 5)
                  )
                ]
              ),
            ),

            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(child: SizedBox(width: 1,)),
                SelectButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) => SetupStep2Dialog()
                    );
                  },
                  text: "Next",
                  width: 88,
                ),
                SizedBox(width: 25,)
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
}

class SetupStep2Dialog extends StatelessWidget {
  const SetupStep2Dialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 728,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(child: SizedBox(width: 1,)),
                const Text(
                  "2) Get Channel ID",
                  style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontFamily: "segoe",
                      fontWeight: FontWeight.w600,
                      fontSize: 17
                  ),
                ),
                Expanded(child: SizedBox(width: 1,)),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFADADAD),
                    size: 20,
                  ),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                )
              ],
            ),
            const SizedBox(height: 30,),
            const Text(
              "           1) Right-click on the text channel where Hydra responds",
              style: TextStyle(
                  color: Color(0xFFADADAD),
                  fontFamily: "segoe",
                  // fontWeight: FontWeight.w600,
                  fontSize: 19
              ),
            ),
            const SizedBox(height: 16,),
            const Text(
              "           2) Click on Copy ID",
              style: TextStyle(
                  color: Color(0xFFADADAD),
                  fontFamily: "segoe",
                  // fontWeight: FontWeight.w600,
                  fontSize: 19
              ),
            ),
            SizedBox(height: 25,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 56),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset("assets/setup_step_2.png"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(50, 0, 0, 0),
                        blurRadius: 5,
                        offset: Offset(0, 5)
                    )
                  ]
              ),
            ),

            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(child: SizedBox(width: 1,)),
                SelectButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Done",
                  width: 88,
                ),
                SizedBox(width: 25,)
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
}
