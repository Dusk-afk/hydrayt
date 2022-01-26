import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../data/local_guild.dart';

class ServerButtonNetwork extends StatefulWidget {
  LocalGuild guild;
  Function onPressed;
  bool enabled;

  ServerButtonNetwork({Key? key, required this.guild, required this.onPressed, this.enabled = true}) : super(key: key);

  @override
  _ServerButtonNetworkState createState() => _ServerButtonNetworkState();
}

class _ServerButtonNetworkState extends State<ServerButtonNetwork> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
              ),
            ),

            decoration: BoxDecoration(
              color: Color(0xFF36393F),
              borderRadius: BorderRadius.all(Radius.circular(widget.enabled? (_hovered? 18 : 25) : 25))
            ),
          )
      ),
    );
  }
}
