import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/user.dart';

class ProfileDialog extends StatefulWidget {
  User user;
  ProfileDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 536,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: SizedBox(width: 1,)),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Color(0xFFADADAD),
                              size: 20,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox(height: 1,)),
                    ],
                  ),

                  decoration: BoxDecoration(
                      color: widget.user.getColor(),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10)
                      )
                  ),
                ),
                Positioned(
                  bottom: -90,
                  left: 30,
                  child: Container(
                    width: 130,
                    height: 130,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        width: 40,
                        height: 40,
                        imageUrl: "https://cdn.discordapp.com/avatars/${widget.user.id}/${widget.user.avatar}.webp?size=2048",
                        placeholder: (context, url) => CircularProgressIndicator(
                          color: Color(0xFF5E74FF),
                          strokeWidth: 3,
                        ),
                        errorWidget: (context, url, error) => Container(
                          child: Center(
                            child: Text(
                              widget.user.username[0],
                              style: TextStyle(
                                  color: Color(0xFFD7D9DA),
                                  fontFamily: "segoe"
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFF36393F),
                              borderRadius: BorderRadius.all(Radius.circular(40))
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100))
                      ),
                    ),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF2F3136),
                        width: 10
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                  ),
                )
              ],
              clipBehavior: Clip.none,
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 170,),
                Text(
                  widget.user.username,
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 25,
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  " #${widget.user.discriminator}",
                  style: TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 17,
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 170,),
                Text(
                  "Token: ••••••••••${widget.user.token.toString().substring(
                    widget.user.token.toString().length - 5,
                    widget.user.token.toString().length
                  )}",
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 13,
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(width: 10,),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.user.token));
                    setState(() {
                      _isCopied = true;
                    });
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _isCopied = false;
                      });
                    });
                  },
                  icon: Icon(
                    Icons.content_copy,
                    color: Color(0xFFADADAD),
                    size: 15,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  // splashRadius: 1,
                ),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 100),
                  child: Text("Copied"),
                  style: TextStyle(
                    color: Color.fromARGB(_isCopied? 255 : 0, 173, 173, 173),
                    fontSize: 13,
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

            SizedBox(height: 50,),
            Container(
              width: double.infinity,
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 31),
              color: Color(0xFF3B3D42),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                "About Me",
                style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 14,
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            SizedBox(height: 4,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                widget.user.getSafeBio(),
                style: TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 14,
                  fontFamily: "segoe",
                ),
              ),
            ),
          ],
        ),

        decoration: BoxDecoration(
          color: Color(0xFF2F3136),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
