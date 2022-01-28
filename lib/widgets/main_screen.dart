import 'package:flutter/material.dart';
import 'package:hydra_gui_app/widgets/server_button_network.dart';
import 'package:hydra_gui_app/widgets/video_card.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MainScreen extends StatefulWidget {
  MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _searchInitiated = false;
  String _currentSearchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppBar(
            searchCallback: handleSearchRequest,
            onClearPressed: () {
              setState(() {
                _searchInitiated = false;
              });
            },
          ),
          // Expanded(child: SizedBox(height: 1,)),
          _searchInitiated?
          FutureBuilder(
            future: getVideos(_currentSearchQuery),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => VideoCard(
                        video: snapshot.data[index],
                        context: context,
                      )
                    ),
                  );
                }else{
                  return Container(
                    child: Text("Looks like a error"),
                  );
                }
              }
              else{
                return Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: CircularProgressIndicator(
                    color: Color(0xFF5E74FF),
                    strokeWidth: 3,
                  ),
                );
              }
            },
          ) :
          Container(
            padding: EdgeInsets.only(top: 5, right: 200),
            width: 600,
            child: Image.asset("assets/try_searching.png"),
          )
          // Expanded(child: SizedBox(height: 1,)),
        ],
      ),

      decoration: BoxDecoration(
        color: Color(0xFF36393F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
      ),
    );
  }

  void handleSearchRequest(String query) async {
    _currentSearchQuery = query;
    setState(() {
      _searchInitiated = true;
    });
  }

  Future<SearchList> getVideos(String query) async {
    YoutubeExplode yt = YoutubeExplode();
    SearchList list = await yt.search.getVideos(query);
    yt.close();
    return list;
  }
}

class AppBar extends StatefulWidget {
  Function searchCallback;
  Function onClearPressed;

  AppBar({ Key? key , required this.searchCallback, required this.onClearPressed}) : super(key: key);

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  TextEditingController _searchFieldController = TextEditingController();
  bool _searchFieldValidate = false;
  bool _tappedOnSearch = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 58,
        margin: EdgeInsets.only(bottom: 5),

        child: Container(
          margin: EdgeInsets.symmetric(vertical: 13, horizontal: 21),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: TextField(
                  controller: _searchFieldController,
                  style: const TextStyle(
                    color: Color(0xFF70747B),
                    fontSize: 12,
                    fontFamily: "segoe",
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: const Color(0xFF5E74FF),
                  decoration: InputDecoration(
                    focusColor: const Color(0xFF5E74FF),
                    errorStyle: TextStyle(height: 0),
                    errorText: _searchFieldValidate? " " : null,
                    fillColor: Color(0xFF202225),
                    filled: true,
                    hintText: "Enter Query or URL",
                    hintStyle: const TextStyle(
                      color: Color(0xFF57595E),
                      fontSize: 12,
                      fontFamily: "segoe",
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF202225)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF5E74FF)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF5E74FF)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15,),
              SearchButton(
                onPressed: () {searchButtonHandler();},
              ),
              Expanded(flex: 5, child: SizedBox(width: 1,)),
              ClearButton(
                onPressed: () {
                  clearButtonHandler();
                },
                hidden: !_tappedOnSearch,
              ),
            ],
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
  void searchButtonHandler(){
    String searchQuery = _searchFieldController.text;
    if (searchQuery.isEmpty){
      setState(() {
        _searchFieldValidate = true;
        _tappedOnSearch = false;
      });
      return;
    }
    setState(() {
      _searchFieldValidate = false;
      _tappedOnSearch = true;
    });

    widget.searchCallback(searchQuery);
  }

  void clearButtonHandler(){
    widget.onClearPressed();
    setState(() {
      _tappedOnSearch = false;
    });
    _searchFieldController.text = "";
  }
}

class SearchButton extends StatefulWidget {
  Function onPressed;

  SearchButton({ Key? key, required this.onPressed}) : super(key: key);

  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
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
          width: 80,
          height: 35,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 100),
              child: Text("Search"),
              style: TextStyle(
                fontSize: 12,
                fontFamily: "segoe",
                fontWeight: FontWeight.w600,
                color: isHovered? Colors.white : Color(0xFF72767D),
              ),
            ),
          ),

          decoration: BoxDecoration(
            color: isHovered? Color(0xFF555555) : Color(0xFF202225),
            borderRadius: const BorderRadius.all(Radius.circular(5))
          ),
        ),
      ),
    );
  }
}

class ClearButton extends StatefulWidget {
  Function onPressed;
  bool hidden;

  ClearButton({Key? key, required this.onPressed, this.hidden = false}) : super(key: key);

  @override
  _ClearButtonState createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: MouseRegion(
        cursor: widget.hidden? SystemMouseCursors.basic : SystemMouseCursors.click,
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
          width: 80,
          height: 35,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 100),
              child: Text("Clear"),
              style: TextStyle(
                fontSize: 12,
                fontFamily: "segoe",
                fontWeight: FontWeight.w600,
                color: widget.hidden? Colors.transparent : (isHovered? Colors.white : Color(0xFF72767D)),
              ),
            ),
          ),

          decoration: BoxDecoration(
            color: widget.hidden? Colors.transparent : (isHovered? Color(0xFF555555) : Color(0xFF202225)),
            borderRadius: const BorderRadius.all(Radius.circular(5))
          ),
        ),
      ),
    );
  }
}
