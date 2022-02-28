import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/guild.dart';
import 'package:hydra_gui_app/models/guild_model.dart';
import 'package:provider/provider.dart';
import '../data/local_guild.dart';

class ServerButtonNetwork extends StatefulWidget {
  LocalGuild guild;
  Function onPressed;
  Function reload;
  bool enabled;
  int index;

  static LocalGuild? currentSelected; // -1 because no server can be -1

  ServerButtonNetwork({Key? key, required this.guild, required this.onPressed, required this.reload, this.enabled = true,required this.index}) : super(key: key);

  @override
  _ServerButtonNetworkState createState() => _ServerButtonNetworkState();
}

class _ServerButtonNetworkState extends State<ServerButtonNetwork> {
  // bool _selected = false;
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 4,
          height: ServerButtonNetwork.currentSelected == null? _hovered? 16 : 0 : ServerButtonNetwork.currentSelected!.channel_id == widget.guild.channel_id? 40 : _hovered? 16 : 0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(3),
              bottomRight: Radius.circular(3),
            )
          ),
        ),
        SizedBox(width: 8,),
        MouseRegion(
          cursor: widget.enabled? SystemMouseCursors.click : SystemMouseCursors.basic,
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
                context.read<GuildModel>().changeGuild(widget.guild);
                setState(() {
                  if (ServerButtonNetwork.currentSelected != widget.guild){
                    ServerButtonNetwork.currentSelected = widget.guild;
                    widget.reload();
                  }
                });
                if (widget.enabled){
                  widget.onPressed();
                }else{

                }
              },
              child: AnimatedContainer(
                width: 48,
                height: 48,
                duration: Duration(milliseconds: 100),

                clipBehavior: Clip.antiAliasWithSaveLayer,

                child: CachedNetworkImage(
                  width: 48,
                  height: 48,
                  imageUrl: "https://cdn.discordapp.com/icons/${widget.guild.id}/${widget.guild.icon}.webp?size=64",
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: Color(0xFF5E74FF),
                    strokeWidth: 3,
                  ),
                  errorWidget: (context, url, error) {
                    widget.guild.tryUpdatingIcon((success) {
                      if (success){
                        setState(() {});
                      }
                    });
                    return Container(
                      child: Center(
                        child: Text(
                          widget.guild.name[0],
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFD7D9DA),
                            fontFamily: "segoe"
                          ),
                        ),
                      ),
                    );
                  }
                ),

                decoration: BoxDecoration(
                  color: Color(0xFF36393F),
                  borderRadius: BorderRadius.all(  //widget.enabled? (_hovered? 18 : 25) : 25)
                    Radius.circular(
                      widget.enabled?
                        ServerButtonNetwork.currentSelected == null?
                          _hovered?
                            18 : 25
                          :
                          ServerButtonNetwork.currentSelected!.channel_id == widget.guild.channel_id?
                            18 :
                            _hovered?
                              18 : 25
                        :
                        25
                    )
                  )
                ),
              )
          ),
        ),
      ],
    );
  }
}
