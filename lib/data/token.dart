import 'dart:convert';

import 'package:http/http.dart' as http;

class User{
  String token;
  late bool isValid;

  late String id;
  late String username;
  late String discriminator;
  late String email;

  User.fromToken(this.token){
    // init();
  }

  Future init() async {
    var data = await getData();
    try {
      id = data["id"];
      username = data["username"];
      discriminator = data["discriminator"];
      email = data["email"];

      isValid = true;

      // print(id);
      // print(username);
      // print(discriminator);
      // print(email);
    }catch(e){
      isValid = false;
    }
  }

  Future<dynamic> getData() async {
    http.Response response = await http.get(
      Uri.parse("https://discordapp.com/api/v6/users/@me"),
      headers: {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
        "Authorization": token
      }
    );
    return jsonDecode(response.body);
  }
}