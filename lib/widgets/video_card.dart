import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/providers/user_provider.dart';
import 'package:hydra_gui_app/providers/video_model.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import 'package:hydra_gui_app/widgets/server_button_network.dart';
import 'package:hydra_gui_app/widgets/setup_screen.dart';
import 'package:hydra_gui_app/widgets/simple_dialog.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class VideoCard extends StatelessWidget {
  final Video video;
  final BuildContext context;

  const VideoCard({Key? key, required this.video, required this.context}) : super(key: key);

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
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: const EdgeInsets.all(5),
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
                    placeholder: (context, url) => const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: Color(0xFF5E74FF),
                        strokeWidth: 3,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      child: const Center(
                        child: Text(
                          "Thumbnail Not Loaded",
                          style: TextStyle(
                            color: Color(0xFFD7D9DA),
                            fontFamily: "segoe"
                          ),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF36393F),
                        borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                    ),
                  ),
                ),

                decoration: const BoxDecoration(
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
                margin: const EdgeInsets.only(bottom: 9, right: 9),

                child: Center(
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 12,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),

                decoration: const BoxDecoration(
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
          const SizedBox(width: 25,),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 19,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    video.description,
                    style: const TextStyle(
                      color: Color(0xFFADADAD),
                      fontSize: 9,
                      fontFamily: "segoe",
                    ),
                  ),
                  const Expanded(child: SizedBox(height: 8,)),
                  Row(
                    children: [
                      const Text(
                        "by ",
                        style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 13,
                          fontFamily: "segoe",
                        ),
                      ),
                      Text(
                        video.author,
                        style: const TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 13,
                          fontFamily: "segoe",
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const Expanded(child: SizedBox(width: 1,)),
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

              decoration: const BoxDecoration(
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
      builder: (context) => const SettingUpDialog(
        text: "Sending Request",
      )
    );

    // Obtain Streaming Url
    YoutubeExplode yt = YoutubeExplode();
    StreamManifest streamManifest = await yt.videos.streamsClient.getManifest(video.id);
    UnmodifiableListView<AudioOnlyStreamInfo> audios = streamManifest.audioOnly;
    String streamingUrl = audios[audios.length - 1].url.toString();
    yt.close();

    if (context.read<UserProvider>().currentUser == null){
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
    String token = context.read<UserProvider>().currentUser!.token;

    try{
      Uri apiRoute = ServerButtonNetwork.currentSelected!.getMessageUrl();
      http.Response response = await http.post(
        apiRoute,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36',
          "Authorization": token
        },
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
      print(e);
      Navigator.pop(context);
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
    context.read<VideoProvider>().updateTrack(video, ServerButtonNetwork.currentSelected!);
  }
}
