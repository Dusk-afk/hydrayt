import 'package:flutter/material.dart';

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
                              widget.onEnd();
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
                              widget.onEnd();
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