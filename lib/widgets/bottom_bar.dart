import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/local_guild.dart';
import 'package:hydra_gui_app/main.dart';
import 'package:hydra_gui_app/models/guild_model.dart';
import 'package:hydra_gui_app/models/video_model.dart';
import 'package:hydra_gui_app/widgets/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,

      child: Row(
        children: [
          Expanded(
            child: _LastPlayedFrame(),
          ),
          Expanded(
            child: _MusicControls(),
          ),
        ],
      ),

      decoration: const BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5)
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 3,
            offset: Offset(0, -3)
          )
        ]
      ),
    );
  }
}

class _MusicControls extends StatefulWidget {
  _MusicControls({Key? key}) : super(key: key);

  @override
  State<_MusicControls> createState() => _MusicControlsState();
}

class _MusicControlsState extends State<_MusicControls> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    LocalGuild? localGuild = context.watch<GuildModel>().currentGuild;

    if (localGuild == null){
      _disabled = true;
    }

    else if (localGuild.message_id == null){
      _disabled = true;
      localGuild.tryUpdatingMessageId((success) {
        if (success){
          setState(() {});
        }
      });
    }

    else{
      _disabled = false;
    }

    return Row(
      children: [
        Spacer(),
        MusicControlButton(
          onClick: () => replay(localGuild!),
          icon: Icons.replay,
          disabled: _disabled
        ),
        SizedBox(width: 12,),
        MusicControlButton(
          onClick: () => playPause(localGuild!),
          imageIcon: Image.asset("assets/play_pause_icon.png"),
          disabled: _disabled
        ),
        SizedBox(width: 12,),
        MusicControlButton(
          onClick: () => stop(localGuild!),
          icon: Icons.stop,
          disabled: _disabled
        ),
        SizedBox(width: 12,),
        MusicControlButton(
          onClick: () => skip(localGuild!),
          icon: Icons.fast_forward,
          disabled: _disabled
        ),
        SizedBox(width: 12,),
        MusicControlButton(
          onClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen()
              )
            );
          },
          icon: Icons.settings,
        ),
        SizedBox(width: 20,)
      ],
    );
  }

  Future replay(LocalGuild guild) async {
    Video? video = context.read<VideoModel>().currentVideo;

    // Obtain Streaming Url
    YoutubeExplode yt = YoutubeExplode();
    StreamManifest streamManifest = await yt.videos.streamsClient.getManifest(video?.id);
    UnmodifiableListView<AudioOnlyStreamInfo> audios = streamManifest.audioOnly;
    String streamingUrl = audios[audios.length - 1].url.toString();
    yt.close();

    if (video == null){
      return;
    }

    try{
      http.Response response = await http.post(
        guild.getMessageUrl(),
        headers: {"Authorization": "${MainApp.currentUser?.token}"},
        body: {"content": streamingUrl}
      );
    }catch(e){
      print(e);
    }
  }

  Future playPause(LocalGuild guild) async {
    try{
      http.Response response = await http.put(
        guild.getPlayPauseReactUrl(),
        headers: MainApp.currentUser?.getHeaders()
      );
    }catch(e){
      print(e);
    }
  }

  Future stop(LocalGuild guild) async {
    try{
      http.Response response = await http.put(
        guild.getStopReactUrl(),
        headers: MainApp.currentUser?.getHeaders()
      );
    }catch(e){
      print(e);
    }
  }

  Future skip(LocalGuild guild) async {
    try{
      http.Response response = await http.put(
        guild.getSkipReactUrl(),
        headers: MainApp.currentUser?.getHeaders()
      );
    }catch(e){
      print(e);
    }
  }
}

class MusicControlButton extends StatefulWidget {
  final IconData? icon;
  final Image? imageIcon;
  final Function onClick;
  final bool disabled;

  const MusicControlButton({Key? key, this.icon, required this.onClick, this.imageIcon, this.disabled = false}) : super(key: key);

  @override
  MusicControlButtonState createState() => MusicControlButtonState();
}

class MusicControlButtonState extends State<MusicControlButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled? null : () {
        widget.onClick();
        setState(() {
          _pressed = true;
        });

        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            _pressed = false;
          });
        });
      },

      child: MouseRegion(
        cursor: widget.disabled? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: widget.disabled? null : (_) {
          setState(() {
            _hovered = true;
          });
        },
        onExit: widget.disabled? null : (_) {
          setState(() {
            _hovered = false;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 45,
          height: 45,

          child: widget.imageIcon==null? Icon(
            widget.icon,
            color: Color(0xFFADADAD),
            size: 20,
          ) : Padding(
            padding: const EdgeInsets.all(10),
            child: widget.imageIcon,
          ),

          decoration: BoxDecoration(
            color: widget.disabled? Color(0xFF2B2E33) : Color(_hovered? 0xFF575C67 : 0xFF36393F),
            borderRadius: BorderRadius.circular(300),
            boxShadow: widget.disabled? null : [
              BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                blurRadius: _pressed? 0 : 4,
                offset: Offset(0, _pressed? 0 : 4)
              )
            ]
          ),
        ),
      ),
    );
  }
}



class _LastPlayedFrame extends StatefulWidget {
  const _LastPlayedFrame({Key? key}) : super(key: key);

  @override
  _LastPlayedFrameState createState() => _LastPlayedFrameState();
}

class _LastPlayedFrameState extends State<_LastPlayedFrame> {
  @override
  Widget build(BuildContext context) {
    Video? video = context.watch<VideoModel>().currentVideo;
    LocalGuild? guild = context.read<VideoModel>().currentVideoGuild;
    String title = video!=null? video.title.length >= 30? video.title.substring(0, 30) + "..." : video.title : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
      child: video!=null?
        Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                children: [
                  Container(
                    width: 59,
                    height: 59,
                    clipBehavior: Clip.antiAliasWithSaveLayer,

                    child: SizedBox(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: video.thumbnails.highResUrl,
                        placeholder: (context, url) => SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            color: Color(0xFF5E74FF),
                            strokeWidth: 3,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          child: Center(
                            child: Text(
                              "Thumbnail Not Loaded",
                              style: TextStyle(
                                  color: Color(0xFFD7D9DA),
                                  fontFamily: "segoe"
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF36393F),
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                        ),
                      ),
                    ),

                    decoration: const BoxDecoration(
                      // color: Color(0xFF36393F),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                         BoxShadow(
                          color: Color.fromARGB(40, 0, 0, 0),
                          blurRadius: 3,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                          width: 32,
                          height: 32,
                          imageUrl: "https://cdn.discordapp.com/icons/${guild?.id}/${guild?.icon}.webp?size=64",
                          placeholder: (context, url) => CircularProgressIndicator(
                            color: Color(0xFF5E74FF),
                            strokeWidth: 3,
                          ),
                          errorWidget: (context, url, error) => Container(
                            child: Center(
                              child: Text(
                                "${guild?.name[0]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFD7D9DA),
                                  fontFamily: "segoe"
                                ),
                              ),
                            ),
                          )
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF36393F),
                        borderRadius: BorderRadius.circular(300),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(80, 0, 0, 0),
                              blurRadius: 4,
                              offset: Offset(0, 4)
                          )
                        ]
                      )
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(width: 9,),

            SizedBox(
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text(
                    "Last Played",
                    style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 11,
                      fontFamily: "segoe"
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 17,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.bold
                    ),
                    // maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer()
                ],
              ),
            )
          ],
        ) :
        Row(
          children: [
            Container(
              width: 70,
              child: const Center(
                child: Text(
                  "?",
                  style: TextStyle(
                    color: Color(0xFFADADAD)
                  ),
                )
              ),
              decoration: BoxDecoration(
                color: Color(0xFF202225),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(20, 0, 0, 0),
                    offset: Offset(0, 3),
                    blurRadius: 3
                  )
                ]
              ),
            ),
          ],
      )
    );
  }
}
