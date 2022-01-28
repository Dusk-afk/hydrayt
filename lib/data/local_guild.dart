import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalGuild{
  String id;
  String name;
  String icon;
  String channel_id;

  static List<LocalGuild> currentUserGuilds = [];

  LocalGuild({required this.id, required this.name, required this.icon, required this.channel_id});

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
        )
      );
    }

    return currentUserGuilds;
  }

  Uri getMessageUrl() {
    return Uri.parse("https://discord.com/api/v9/channels/$channel_id/messages");
  }
}