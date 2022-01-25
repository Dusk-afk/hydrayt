import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/token.dart';
import 'package:path_provider/path_provider.dart';

class SetupScreen extends StatefulWidget {
  Function onEnd;
  SetupScreen({ Key? key, required this.onEnd }) : super(key: key);

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(),
          Expanded(child: SizedBox(height: 1,)),
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(top: 206, bottom: 250),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 80, right: 40),

                      child: Column(
                        children: [
                          SizedBox(height: 21,),
                          Text(
                            "Automatic",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "segoe",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD5D5D5),
                              letterSpacing: 2
                            ),
                          ),
                          SizedBox(height: 13,),
                          Text(
                            "Gets your discord account token from this device",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "segoe",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD5D5D5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(child: SizedBox(height: 1,)),
                          SelectButton(
                            onPressed: () {
                              handleButton(0);
                            },
                          ),
                          SizedBox(height: 20,)
                        ],
                      ),

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF0B0A21),
                            Color(0xFF1B0247),
                          ]
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(30, 0, 0, 0),
                            blurRadius: 5,
                            offset: Offset(0, 5)
                          )
                        ]
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 40, right: 80),

                      child: Column(
                        children: [
                          SizedBox(height: 21,),
                          Text(
                            "Manual",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "segoe",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD5D5D5),
                              letterSpacing: 2
                            ),
                          ),
                          SizedBox(height: 13,),
                          Text(
                            "Manually type your discord Token\n(Ooooh such a pain)",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "segoe",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD5D5D5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(child: SizedBox(height: 1,)),
                          SelectButton(
                            onPressed: () {
                              handleButton(1);
                            },
                          ),
                          SizedBox(height: 20,)
                        ],
                      ),
                      
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF2F3136),
                            Color(0xFF3A3C41),
                          ]
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(30, 0, 0, 0),
                            blurRadius: 5,
                            offset: Offset(0, 5)
                          )
                        ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox(height: 1,)),
        ],
      ),

      decoration: const BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
      )
    );
  }

  handleButton(int option) async {
    if (option == 0){
      User? user = await getUser();
      if (user == null){
        // TODO: Show that token not found
        return null;
      }

      // Getting Directory of user data
      Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");

      // If this directory doesn't exist then make one
      if (!(await userDir.exists())){
        userDir.create();
      }

      // Getting user file inside this directory
      File userFile = File(userDir.path + "\\user.dk");

      // If this file exists then delete it because we will create new file
      if (await userFile.exists()){
        userFile.delete();
      }
      userFile.create();

      // Write the user file with token
      userFile.writeAsString(user.token);

      // Close the setup screen
      widget.onEnd();
    }
    else if (option == 1) {

    }
  }

  Future<User?> getUser() async {
    // Get user name using temp dir
    Directory path = await getTemporaryDirectory();
    String windowsUserName = path.path.split("\\")[2];

    // Using user name get discord local storage dir
    String discordStoragePath = "C:\\Users\\$windowsUserName\\AppData\\Roaming\\discord\\Local Storage\\leveldb";

    // Get all files in this dir
    List<FileSystemEntity> files = Directory(discordStoragePath).listSync();

    // Iterate through these files
    for (FileSystemEntity file in files){

      // Check if file ends with .log or .ldb
      if (!file.path.endsWith(".log") && !file.path.endsWith(".ldb")){
        // If not then go to another file
        continue;
      }

      // Read the file and match the token re to look for possible tokens
      String data = String.fromCharCodes(await File(file.path).readAsBytes());
      RegExp regExp = RegExp(r"[\w-]{24}\.[\w-]{6}\.[\w-]{27}");

      // Instantiate a user class using the token
      User user = User.fromToken(regExp.stringMatch(data).toString());
      await user.init();

      // If the token is valid then return this user
      if(user.isValid){
        return user;
      }
    }
    return null;
  }
}

class SelectButton extends StatefulWidget {
  Function onPressed;
  SelectButton({ Key? key, required this.onPressed }) : super(key: key);

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 166,
          height: 35,
          child: const Center(
            child: Text(
              "Select",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "segoe",
                fontWeight: FontWeight.w600,
                color: Color(0xFFD5D5D5),
              ),
            ),
          ),
                                
          decoration: BoxDecoration(
            // color: isHovered? Color(0xFF2A3BF8) : Color(0xFF5865F2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5865F2),
                isHovered? Color(0xFF3B44A7) : Color(0xFF5865F2)
              ]
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatefulWidget {
  const AppBar({ Key? key }) : super(key: key);

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.only(bottom: 5),

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 13, horizontal: 21),
        child: Text(
          "Let's Get Set Up!",
          style: Theme.of(context).textTheme.headline1
        ),
      ),
      
      decoration: const BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(30, 0, 0, 0),
            blurRadius: 5,
            offset: Offset(0, 5)
          )
        ]
      )
    );
  }
}