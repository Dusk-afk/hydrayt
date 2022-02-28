import 'package:flutter/cupertino.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoModel with ChangeNotifier{
  Video? currentVideo;

  void updateTrack(Video video){
    currentVideo = video;
    notifyListeners();
  }
}