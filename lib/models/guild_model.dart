import 'package:flutter/cupertino.dart';
import 'package:hydra_gui_app/data/local_guild.dart';

class GuildModel with ChangeNotifier{
  LocalGuild? currentGuild;

  void changeGuild(LocalGuild guild){
    currentGuild = guild;
    notifyListeners();
  }
}