import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/main.dart';
import 'package:hydra_gui_app/models/video_model.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import 'package:hydra_gui_app/widgets/server_button_network.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:hydra_gui_app/widgets/simple_dialog.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class VideoCard extends StatelessWidget {
  Video video;
  BuildContext context;

  VideoCard({Key? key, required this.video, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String duration = "null";
    try{
      var durationList = video.duration.toString().split(".")[0].split(":");
      if (durationList[0] == "0") {
        duration = (durationList[1] + ":" + durationList[2]);
      } else {
        duration =
            (durationList[0] + ":" + durationList[1] + ":" + durationList[2]);
      }
    }catch(e){}

    return Container(
      height: 140,
      // color: Colors.amber,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Container(
                width: 252,
                height: double.infinity,
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
                        borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                    ),
                  ),
                ),

                decoration: BoxDecoration(
                  // color: Color(0xFF36393F),
                  //   color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(40, 0, 0, 0),
                        blurRadius: 5,
                        offset: Offset(0, 5)
                      )
                    ]
                ),
              ),
              Container(
                width: 47,
                height: 21,
                margin: EdgeInsets.only(bottom: 9, right: 9),

                child: Center(
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 12,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),

                decoration: BoxDecoration(
                  color: Color(0xFF202225),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(40, 0, 0, 0),
                      blurRadius: 5,
                      offset: Offset(0, 5)
                    )
                  ]
                ),
              )
            ]
          ),
          SizedBox(width: 25,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 19,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8,),
                  Text(
                    video.description,
                    style: TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 9,
                      fontFamily: "segoe",
                    ),
                  ),
                  Expanded(child: SizedBox(height: 8,)),
                  Row(
                    children: [
                      Text(
                        "by ",
                        style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 13,
                          fontFamily: "segoe",
                        ),
                      ),
                      Text(
                        video.author,
                        style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 13,
                          fontFamily: "segoe",
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Expanded(child: SizedBox(width: 1,)),
                      SelectButton(
                        onPressed: () {
                          playButtonHandler();
                        },
                        text: "Play",
                        width: 100,
                      )
                    ],
                  )
                ],
              ),

              decoration: BoxDecoration(
                color: Color(0xFF36393F),
                // color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(40, 0, 0, 0),
                    blurRadius: 5,
                    offset: Offset(0, 5)
                  )
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  void playButtonHandler() async {
    if (ServerButtonNetwork.currentSelected == null){
      showDialog(
        context: context,
        builder: (context) => CustomSimpleDialog(
          title: "Where To Play?",
          subTitle: "Please select a server first",
          buttonText: "Got it",
        )
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SettingUpDialog(
        text: "Sending Request",
      )
    );

    // Obtain Streaming Url
    YoutubeExplode yt = YoutubeExplode();
    StreamManifest streamManifest = await yt.videos.streamsClient.getManifest(video.id);
    UnmodifiableListView<AudioOnlyStreamInfo> audios = streamManifest.audioOnly;
    String streamingUrl = audios[audios.length - 1].url.toString();
    yt.close();

    if (MainApp.currentUser == null){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => CustomSimpleDialog(
          title: "No User Found",
          subTitle: "Try restarting this software",
          buttonText: "Got it",
        )
      );
      return;
    }
    dynamic token = MainApp.currentUser?.token;

    try{
      Uri? apiRoute = ServerButtonNetwork.currentSelected?.getMessageUrl();
      http.Response response = await http.post(
        apiRoute??=Uri.parse("default"),
        headers: {"Authorization": token},
        body: {"content":streamingUrl}
      );

      if (response.statusCode != 200){
        showDialog(
          context: context,
          builder: (context) => CustomSimpleDialog(
            title: "Oops! An Unknown Error",
            subTitle: "Here is what you can do:\n1) Check your internet connection\n2) Make sure you entered right channel id while you were adding your server\n3) Try a different song\n\nIf you are a geek then this might help you:\n\tResponse status code: ${response.statusCode}",
            buttonText: "Got it",
          )
        );
      }
    }catch(e){
      showDialog(
        context: context,
        builder: (context) => CustomSimpleDialog(
          title: "Oops! An Unknown Error",
          subTitle: "Here is what you can do:\n1) Check your internet connection\n2) Make sure you entered right channel id while you were adding your server\n3) Try a different song}",
          buttonText: "Got it",
        )
      );
    }

    Navigator.pop(context);
    context.read<VideoModel>().updateTrack(video, ServerButtonNetwork.currentSelected!);
  }
}
