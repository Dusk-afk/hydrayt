import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class User{
  String token;
  late bool isValid;

  late String id;
  late String username;
  late String discriminator;
  late String avatar;
  late String bio;
  late String bannerColor;

  static Future<User?> getCurrentUser() async {
    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");
    File userFile = File(userDir.path + "\\user.dk");
    String token = await userFile.readAsString();
    User user = User.fromToken(token);
    await user.init();
    return user.isValid? user : null;
  }

  User.fromToken(this.token){
    // init();
  }

  Future init() async {
    var data = await getData();
    try {
      id = data["id"];
      username = data["username"];
      discriminator = data["discriminator"];
      avatar = data["avatar"];
      bio = data["bio"];
      bannerColor = data["banner_color"];

      isValid = true;
    }catch(e){
      isValid = false;
    }
  }

  Future<dynamic> getData() async {
    http.Response response = await http.get(
      Uri.parse("https://discordapp.com/api/v6/users/@me"),
      headers: getHeaders()
    );

    return jsonDecode(response.body);
  }

  Color getColor(){
    return Color(int.parse("0xFF${bannerColor.toString().substring(1)}"));
  }

  String getSafeBio(){
    if ("\n".allMatches(bio).length > 5){
      int currentIndex = 0;
      for (int i in List<int>.generate(5, (i) => i)){
        currentIndex = bio.indexOf("\n", currentIndex+1);
      }
      return bio.substring(0, currentIndex);
    }else{
      return bio;
    }
  }

  Map<String, dynamic> getJson() {
    return {
      "id":id,
      "name":username,
      "discriminator":discriminator,
      "token":token,
      "avatar":avatar,
      "bio":bio,
      "bannerColor":bannerColor
    };
  }

  Map<String, String> getHeaders(){
    return {
      "Content-Type": "application/json",
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
      "Authorization": token
    };
  }
}