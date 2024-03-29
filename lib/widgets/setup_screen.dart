import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/user.dart';
import 'package:hydra_gui_app/providers/setup_provider.dart';
import 'package:hydra_gui_app/providers/user_provider.dart';
import 'package:hydra_gui_app/services/token_grabber.dart';
import 'package:hydra_gui_app/widgets/select_button.dart';
import 'package:hydra_gui_app/widgets/title_bar.dart';
import 'package:hydra_gui_app/widgets/user_select_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:win32/src/win32/crypt32.g.dart';

import '../main.dart';
import 'left_bar.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({ Key? key }) : super(key: key);

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>  with SingleTickerProviderStateMixin {
  bool _automaticOptionAvailable = true;
  bool _manualOptionSelected = false;
  bool _tokenTextFieldValidate = false;
  TextEditingController tokenTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202225),
      body: Column(
        children: [
          const TitleBar(),

          Expanded(
            child: Row(
              children: [
                const LeftBar(forSetupScreen: true),
                
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        const AppBar(),
                        const Expanded(child: SizedBox(height: 1,)),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 80, right: 40),
                    
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 21,),
                                      const Text(
                                        "Automatic",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: "segoe",
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFD5D5D5),
                                          letterSpacing: 2
                                        ),
                                      ),
                                      const SizedBox(height: 13,),
                                      const Text(
                                        "Gets your discord account token from this device",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "segoe",
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFD5D5D5),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Expanded(child: SizedBox(height: 1,)),
                                      SelectButton(
                                        onPressed: () {
                                          handleButton(0);
                                        },
                                        enabled: _automaticOptionAvailable? true : false,
                                        text: _automaticOptionAvailable? "Select" : "Unavailable",
                                      ),
                                      const SizedBox(height: 20,)
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
                                  margin: const EdgeInsets.only(left: 40, right: 80),
                    
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 21,),
                                      const Text(
                                        "Manual",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: "segoe",
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFD5D5D5),
                                          letterSpacing: 2
                                        ),
                                      ),
                                      const SizedBox(height: 13,),
                                      _manualOptionSelected?
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 23),
                                        height: 35,
                                        child: TextField(
                                          controller: tokenTextFieldController,
                                          style: const TextStyle(
                                            color: Color(0xFF70747B),
                                            fontSize: 12,
                                            fontFamily: "segoe",
                                            fontWeight: FontWeight.w600,
                                          ),
                                          cursorColor: const Color(0xFF5E74FF),
                                          decoration: InputDecoration(
                                            focusColor: const Color(0xFF5E74FF),
                                            errorStyle: const TextStyle(height: 0),
                                            errorText: _tokenTextFieldValidate? " " : null,
                                            hintText: "Enter Token",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF70747B),
                                              fontSize: 12,
                                              fontFamily: "segoe",
                                              fontWeight: FontWeight.w600,
                                            ),
                                            fillColor: const Color(0xFF202225),
                                            filled: true,
                                            contentPadding: const EdgeInsets.all(10.0),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF202225)
                                              ),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF5E74FF)
                                              ),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red
                                              ),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF5E74FF)
                                              ),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ) :
                                      const Text(
                                        "Manually type your discord Token\n(Ooooh such a pain)",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "segoe",
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFD5D5D5),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Expanded(child: SizedBox(height: 1,)),
                                      SelectButton(
                                        onPressed: () {
                                          handleButton(1);
                                        },
                                        text: _manualOptionSelected? "Go" : "Select",
                                      ),
                                      const SizedBox(height: 20,)
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
                        const Expanded(child: SizedBox(height: 1,)),
                      ],
                    ),
                    
                    decoration: const BoxDecoration(
                      color: Color(0xFF36393F),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleButton(int option) async {
    if (option == 0){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => SettingUpDialog()
      );

      TokenGrabber tokenGrabber = TokenGrabber();
      List<User> users = await tokenGrabber.grabTokens();

      if (users.isEmpty) {
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => TokenErrorDialog(
                  title: "Unable To Find Token",
                  subTitle: "Enter Token Manually",
                  buttonText: "Dismiss",
                ));
        setState(() {
          _automaticOptionAvailable = false;
        });
        return null;
      }
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => UserSelectDialog(
          users: users,
          onSelect: (user) {
            Navigator.pop(context);
            saveUserAndClose(user);
          },
        )
      );
    }
    else if (option == 1) {
      if (!_manualOptionSelected) {
        setState(() {
          _manualOptionSelected = true;
        });
      }

      else {
        if (tokenTextFieldController.text.isEmpty) {
          setState(() {
            _tokenTextFieldValidate = true;
          });
          return null;
        } else {
          setState(() {
            _tokenTextFieldValidate = false;
          });
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => SettingUpDialog()
        );

        User? user = await getUserManual(tokenTextFieldController.text);
        if (user == null) {
          Navigator.pop(context);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
              TokenErrorDialog(
                title: "Token Invalid",
                subTitle: "Please Try Again",
                buttonText: "OK",
              )
          );
          return null;
        }
        saveUserAndClose(user);
      }
    }
  }

  Future saveUserAndClose(User user) async {
    // Getting Directory of user data
    Directory userDir = Directory((await getApplicationDocumentsDirectory()).path + "\\HydraYTBot");

    // If this directory doesn't exist then make one
    if (!(await userDir.exists())) {
      userDir.create();
    }

    // Getting user file inside this directory
    File userFile = File(userDir.path + "\\user.dk");

    // If this file exists then delete it because we will create new file
    if (await userFile.exists()) {
      userFile.delete();
    }
    userFile.create();

    // Write the user file with token
    userFile.writeAsString(user.token);

    // Dismiss the dialog
    Navigator.pop(context);

    // Close the setup screen
    context.read<UserProvider>().setCurrentUser(user);
    Navigator.pushNamed(context, "/main");
  }

  void showUserSelectDialog(List<User> users) {

  }

  Future<User?> getUserManual(String token) async {
    User user = User.fromToken(token);
    await user.init();

    // If the token is valid then return this user
    if(user.isValid){
      return user;
    }
    return null;
  }
}

class TokenErrorDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;

  const TokenErrorDialog({Key? key, required this.title, required this.subTitle, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 21,
                  fontFamily: "segoe",
                  fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              subTitle,
              style: const TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 13,
                  fontFamily: "segoe",
                  // fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 23,),
            SelectButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: buttonText,
            )
          ],
        ),

        decoration: const BoxDecoration(
          color: Color(0xFF2F3136),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}


class SettingUpDialog extends StatelessWidget {
  final String text;
  const SettingUpDialog({Key? key, this.text = "Setting Up"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 21,
                fontFamily: "segoe",
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFF5E74FF),
                strokeWidth: 3,
              ),
            )
          ],
        ),

        decoration: const BoxDecoration(
          color: Color(0xFF2F3136),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
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
      margin: const EdgeInsets.only(bottom: 5),

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 21),
        child: Text(
          "Let's Get Set Up!",
          style: Theme.of(context).textTheme.displayLarge
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