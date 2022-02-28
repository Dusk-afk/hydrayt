import 'dart:convert';
import 'dart:io';
import 'package:hydra_gui_app/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class LocalGuild{
  String id;
  String name;
  String icon;
  String channel_id;
  String? message_id;

  static List<LocalGuild> currentUserGuilds = [];

  LocalGuild({required this.id, required this.name, required this.icon, required this.channel_id, this.message_id});

  static Future<List<LocalGuild>?> loadFromLocal() async {
    currentUserGuilds = [];
    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
    File guildsFile = File(userDir.path + "\\guilds.dk");

    // Create this file if it doesn't exist
    if (!(await guildsFile.exists())) {
      guildsFile.create();
      return null;
    }

    for (var jsonGuild in jsonDecode(await guildsFile.readAsString())){
      currentUserGuilds.add(
        LocalGuild(
          id: jsonGuild["id"],
          name: jsonGuild["name"],
          icon: jsonGuild["icon"],
          channel_id: jsonGuild["channel_id"],
          message_id: jsonGuild["message_id"]
        )
      );
    }

    return currentUserGuilds;
  }

  Future tryUpdatingMessageId(Function(bool success)? callback) async {
    try{
      http.Response response = await http.get(
          Uri.parse("https://discord.com/api/v9/channels/$channel_id/messages"),
          headers: {
            "Content-Type": "application/json",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
            "Authorization": MainApp.currentUser!.token
          }
      );

      try{
        List<dynamic> messages = await jsonDecode(response.body);
        message_id = messages[messages.length - 2]["id"];
      }catch(e) {
        if (callback!=null){
          callback(false);
        }
        return;
      }
    }catch(e){
      if (callback!=null){
        callback(false);
      }
      return;
    }

    await updateMessageIdInLocal();
    if (callback!=null){
      callback(true);
    }
  }

  Future updateMessageIdInLocal() async {
    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
    File guildsFile = File(userDir.path + "\\guilds.dk");

    List<dynamic> jsonData = [];

    try{
      jsonData = jsonDecode(await guildsFile.readAsString());
      for (var item in jsonData){
        if (
          item["id"] == id &&
          item["name"] == name &&
          item["icon"] == icon &&
          item["channel_id"] == channel_id
        ){
          item["message_id"] = message_id;
          break;
        }
      }

    }catch(e){

    }

    await guildsFile.writeAsString(jsonEncode(jsonData));
  }

  Future tryUpdatingIcon(Function(bool success)? callback) async {
    try{
      http.Response response = await http.get(
        Uri.parse("https://discordapp.com/api/v9/users/@me/guilds"),
        headers: {
          "Authorization": "${MainApp.currentUser?.token}"
        }
      );

      List<dynamic> jsonGuilds = jsonDecode(response.body);

      for (var item in jsonGuilds){
        if (item["id"] == id){
          icon = item["icon"];
          break;
        }
      }
    }
    catch(e){
      if (callback!=null){
        callback(false);
      }
      return;
    }

    await updateIconInLocal();
    if (callback!=null){
      callback(true);
    }
  }

  Future updateIconInLocal() async {
    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
    File guildsFile = File(userDir.path + "\\guilds.dk");

    List<dynamic> jsonData = [];

    try{
      jsonData = jsonDecode(await guildsFile.readAsString());
      for (var item in jsonData){
        if (
          item["id"] == id &&
          item["name"] == name &&
          item["channel_id"] == channel_id
        ){
          item["icon"] = icon;
          break;
        }
      }

    }catch(e){

    }

    await guildsFile.writeAsString(jsonEncode(jsonData));
  }

  Uri getMessageUrl() => Uri.parse("https://discord.com/api/v9/channels/$channel_id/messages");

  Uri getPlayPauseReactUrl() => Uri.parse("https://discord.com/api/v9/channels/$channel_id/messages/$message_id/reactions/%E2%8F%AF/%40me");

  Uri getStopReactUrl() => Uri.parse("https://discord.com/api/v9/channels/$channel_id/messages/$message_id/reactions/%E2%8F%B9/%40me");

  Uri getSkipReactUrl() => Uri.parse("https://discord.com/api/v9/channels/$channel_id/messages/$message_id/reactions/%E2%8F%AD/%40me");
}