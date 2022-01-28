import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/local_guild.dart';
import 'package:hydra_gui_app/data/user.dart';
import 'package:hydra_gui_app/widgets/add_server_dialog.dart';
import 'package:hydra_gui_app/widgets/profile_dialog.dart';
import 'package:hydra_gui_app/widgets/server_button.dart';
import 'package:hydra_gui_app/widgets/server_button_network.dart';

import '../main.dart';

class LeftBar extends StatefulWidget {
  const LeftBar({Key? key}) : super(key: key);

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: Color(0xFF202225),

      child: Column(
        children: [
          SizedBox(height: 4,),
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
          ) :
          ProfileButton(),
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
          MainApp.showSetupScreen?
          Container() :
          FutureBuilder(
            future: LocalGuild.loadFromLocal(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData){
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        ServerButtonNetwork(
                          onPressed: () {},
                          reload: reload,
                          guild: snapshot.data[index],
                          index: index,
                        ),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: 10,),
          MainApp.showSetupScreen?
          Container() :
          ServerButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddServerDialog(
                  reload: () {setState(() {});},
                )
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
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}

class ProfileButton extends StatefulWidget {
  ProfileButton({Key? key}) : super(key: key);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: User.getCurrentUser(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData){
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                _hovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                _hovered = false;
              });
            },
            child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ProfileDialog(
                      user: snapshot.data,
                    )
                  );
                },
                child: AnimatedContainer(
                  width: 48,
                  height: 48,
                  duration: Duration(milliseconds: 100),

                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  child: CachedNetworkImage(
                    width: 48,
                    height: 48,
                    imageUrl: "https://cdn.discordapp.com/avatars/${snapshot.data.id}/${snapshot.data.avatar}.webp?size=64",
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: Color(0xFF5E74FF),
                      strokeWidth: 3,
                    ),
                    errorWidget: (context, url, error) => Container(
                      child: Center(
                        child: Text(
                          snapshot.data.username[0],
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFD7D9DA),
                              fontFamily: "segoe"
                          ),
                        ),
                      ),
                    ),
                  ),

                  decoration: BoxDecoration(
                      color: Color(0xFF36393F),
                      borderRadius: BorderRadius.all(Radius.circular(_hovered? 18 : 25))
                  ),
                )
            ),
          );
        }
        else{
          return SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Color(0xFF5E74FF),
              strokeWidth: 3,
            ),
          );
        }
      },
    );
  }
}
