import 'dart:convert';

import 'package:hydra_gui_app/data/user.dart';
import 'package:http/http.dart' as http;

class Guild{
  String id;
  String name;
  String icon;

  static List<Guild> currentUserGuilds = [];

  Guild({required this.id, required this.name, required this.icon});

  static Future<bool?> loadForUser(User user) async {
    Guild.currentUserGuilds = [];
    http.Response response = await http.get(
      Uri.parse("https://discordapp.com/api/v6/users/@me/guilds"),
      headers: {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
        "Authorization": user.token
      }
    );

    if (response.statusCode != 200){
      return false;
    }

    for (var json in jsonDecode(response.body)){
      Guild.currentUserGuilds.add(
        Guild(
          id: json["id"].toString(),
          name: json["name"].toString(),
          icon: json["icon"].toString(),
        )
      );
    }

    return true;
  }
}