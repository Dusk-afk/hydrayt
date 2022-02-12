import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hydra_gui_app/data/user.dart';

class UserSelectDialog extends StatefulWidget {
  final List<User> users;
  final Function onSelect;
  const UserSelectDialog({Key? key, required this.users, required this.onSelect}) : super(key: key);

  @override
  _UserSelectDialogState createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 470,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox(width: 1,)),
                Text(
                  "Select Your Discord Account",
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                  ),
                ),
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
                )
              ],
            ),
            SizedBox(height: 20,),

            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: widget.users.length,
                itemBuilder: (context, index) => _UserSelectCard(
                  onPressed: () => widget.onSelect(widget.users[index]),
                  user: widget.users[index],
                ),
              ),
            ),

            SizedBox(height: 30,),
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

class _UserSelectCard extends StatelessWidget {
  final User user;
  final Function onPressed;
  const _UserSelectCard({Key? key, required this.onPressed, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 50),

      child: TextButton(
        onPressed: () => onPressed(),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: "https://cdn.discordapp.com/avatars/${user.id}/${user.avatar}.webp?size=128",
                placeholder: (context, url) => CircularProgressIndicator(
                  color: Color(0xFF5E74FF),
                  strokeWidth: 3,
                ),
                errorWidget: (context, url, error) => Container(
                  child: Center(
                    child: Text(
                      user.username[0],
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
              )
            ),
            SizedBox(width: 14,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.username,
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 18,
                    fontFamily: "segoe",
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Source: ${user.source}",
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 10,
                    fontFamily: "segoe",
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4,)
              ],
            )
          ],
        ),

        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.zero),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10)),
          overlayColor: MaterialStateProperty.all(Color(0xFF36393F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            )
          )
        ),
      ),

      decoration: BoxDecoration(
        // color: Colors.amber[200],
          border: Border(
            top: BorderSide(color: Color(0xFF3B3D42)),
            bottom: BorderSide(color: Color(0xFF3B3D42))
          )
      ),
    );
  }
}
