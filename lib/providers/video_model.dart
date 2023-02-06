import 'package:flutter/cupertino.dart';
import 'package:hydra_gui_app/data/local_guild.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoProvider with ChangeNotifier{
  Video? currentVideo;
  LocalGuild? currentVideoGuild;

  void updateTrack(Video video, LocalGuild guild){
    currentVideo = video;
    currentVideoGuild = guild;
    notifyListeners();
  }
}