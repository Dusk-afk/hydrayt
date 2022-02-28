import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/title_bar.dart';
import 'package:native_context_menu/native_context_menu.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TitleBar(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Color(0xFF2F3136),
                  ),
                ),
                Expanded(
                  flex: 23,
                  child: Stack(
                    children: [
                      Container(
                        color: Color(0xFF36393F),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: _CloseButton()
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({Key? key}) : super(key: key);

  @override
  _CloseButtonState createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          _hovered = true;
        }),
        onExit: (_) => setState(() {
          _hovered = false;
        }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          margin: EdgeInsets.only(top: 20, right: 30),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF72767D),
              width: 1.5
            ),
            color: _hovered? Color(0xFF5A5A5A) : Colors.transparent,
            borderRadius: BorderRadius.circular(300)
          ),
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
