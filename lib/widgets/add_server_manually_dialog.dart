import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/guild.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:path_provider/path_provider.dart';

class AddServerManuallyDialog extends StatefulWidget {
  Function reload;
  AddServerManuallyDialog({Key? key, required this.reload}) : super(key: key);

  @override
  _AddServerManuallyDialogState createState() => _AddServerManuallyDialogState();
}

class _AddServerManuallyDialogState extends State<AddServerManuallyDialog> {
  TextEditingController _channelIdController = TextEditingController();
  bool _channelIdFieldValidate = false;
  TextEditingController _serverIdController = TextEditingController();
  bool _serverIdFieldValidate = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 536,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox(width: 1,)),
                Column(
                  children: [
                    Text(
                      "Add Server",
                      style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontFamily: "segoe",
                          fontWeight: FontWeight.w600,
                          fontSize: 19
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
                      child: Text(
                        "First Time?",
                        style: TextStyle(
                          color: Color(0xFF5865F2),
                          fontSize: 12,
                          fontFamily: "segoe",
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(EdgeInsets.zero)
                      ),
                    )
                  ],
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
            SizedBox(height: 20,),

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
                        builder: (context) => SetupStep2Dialog()
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

            // Server ID Text Field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Text(
                    "Server ID ",
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
                        builder: (context) => SetupStep3Dialog()
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
                controller: _serverIdController,
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
                  errorText: _serverIdFieldValidate? " " : null,
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



            SizedBox(height: 30,),
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
    String serverId = _serverIdController.text;

    if (channelId.isEmpty && serverId.isEmpty){
      setState(() {
        _channelIdFieldValidate = true;
        _serverIdFieldValidate = true;
      });
      return;
    }
    else if (channelId.isEmpty){
      setState(() {
        _channelIdFieldValidate = true;
        _serverIdFieldValidate = false;
      });
      return;
    }
    else if (serverId.isEmpty){
      setState(() {
        _channelIdFieldValidate = false;
        _serverIdFieldValidate = true;
      });
      return;
    }

    // If reached here that means user entered all fields
    setState(() {
      _channelIdFieldValidate = false;
      _serverIdFieldValidate = false;
    });

    addGuildToData(channelId, serverId);
  }

  addGuildToData(String channelId, String serverId) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SettingUpDialog()
    );

    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
    File guildsFile = File(userDir.path + "\\guilds.dk");

    Guild? guild;
    for (Guild current_guild in Guild.currentUserGuilds){
      if (current_guild.id == serverId){
        guild = Guild(id: serverId, name: current_guild.name, icon: current_guild.icon);
      }
    }

    if (guild == null){
      // TODO: Show message: You are not joined to this server
      print("Not joined in this server");
      Navigator.pop(context);
      return;
    }

    // Create this file if it doesn't exist
    if (!(await guildsFile.exists())){
      guildsFile.create();

      String guildDetails = '{"id":"${guild.id}", "name":"${guild.name}", "icon":"${guild.icon}", "channel_id":"${channelId}"}';
      List<dynamic> payload = [guildDetails];
      guildsFile.writeAsString(payload.toString());

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
    String guildDetails = '{"id":"${guild.id}", "name":"${guild.name}", "icon":"${guild.icon}", "channel_id":"${channelId}"}';
    fileData.add(jsonDecode(guildDetails));

    guildsFile.writeAsString(jsonEncode(fileData));

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
                  "Enable Developer Mode",
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
                  "Get Channel ID",
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
                    showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) => SetupStep3Dialog()
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

class SetupStep3Dialog extends StatelessWidget {
  const SetupStep3Dialog({Key? key}) : super(key: key);

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
                  "How to get Server ID?",
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
              "           1) Right-click on the server",
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
