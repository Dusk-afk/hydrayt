import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/guild.dart';
import 'package:hydra_gui_app/data/user.dart';
import 'package:hydra_gui_app/main.dart';
import 'package:hydra_gui_app/widgets/add_server_final_dialog.dart';
import 'package:hydra_gui_app/widgets/add_server_manually_dialog.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import 'package:http/http.dart' as http;

class AddServerDialog extends StatefulWidget {
  Function reload;
  AddServerDialog({Key? key, required this.reload}) : super(key: key);

  @override
  _AddServerDialogState createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 470,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox(width: 1,)),
                Text(
                  "Your Already Joined Servers",
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
            SizedBox(height: 20,),

            FutureBuilder(
              future: Guild.loadForUser(MainApp.currentUser!),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData){
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF5E74FF),
                      strokeWidth: 3,
                    ),
                  );
                }else{
                  return Container(
                    child: ListView.builder(
                      itemCount: Guild.currentUserGuilds.length,
                      itemBuilder: (context, index) => ServerCard(
                        guild: Guild.currentUserGuilds[index],
                        onPressed: () {
                          // Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AddServerFinalDialog(
                              guild: Guild.currentUserGuilds[index],
                              reload: widget.reload,
                            )
                          );
                        },
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 300,
                    ),
                  );
                }
              }
            ),

            SizedBox(height: 30,),
            SelectButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AddServerManuallyDialog(
                    reload: widget.reload,
                  )
                );
              },
              text: "Add Manually",
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

class ServerCard extends StatefulWidget {
  Guild guild;
  Function onPressed;
  ServerCard({Key? key, required this.guild, required this.onPressed}) : super(key: key);

  @override
  _ServerCardState createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: TextButton(
        onPressed: () {
          widget.onPressed();
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: "https://cdn.discordapp.com/icons/${widget.guild.id}/${widget.guild.icon}.webp?size=64",
                placeholder: (context, url) => CircularProgressIndicator(
                  color: Color(0xFF5E74FF),
                  strokeWidth: 3,
                ),
                errorWidget: (context, url, error) => Container(
                  child: Center(
                    child: Text(
                      widget.guild.name[0],
                      style: TextStyle(
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
            // Icon(
            //   Icons.account_circle
            // ),
            SizedBox(width: 14,),
            Text(
              widget.guild.name,
              style: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 18,
                fontFamily: "segoe",
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Color(0xFF36393F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            )
          )
        ),
      ),
      decoration: BoxDecoration(
        // color: Colors.amber[200],
        border: Border(
          top: BorderSide(color: Color(0xFF3B3D42)),
          bottom: BorderSide(color: Color(0xFF3B3D42))
        )
      ),
    );
  }
}
