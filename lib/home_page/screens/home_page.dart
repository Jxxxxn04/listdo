import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:sizer/sizer.dart';

import '../../api.dart';
import '../../constants.dart';
import '../widgets/home_page_widgets.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [_appBar(), _body()],
      ),
      endDrawer: _endDrawer(),
      endDrawerEnableOpenDragGesture: false,
    );
  }

  Widget _appBar() {
    return Container(
      height: 15.h,
      width: 100.w,
      color: const Color(0xFF252525),
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Meine Listen",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontSize: 16.sp)),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    final GlobalKey<_LoadingBackgroundState> loadinBackgroundKey =
        GlobalKey<_LoadingBackgroundState>();

    return Stack(
      children: [
        const _GradientBackground(),
        _LoadingBackground(
          key: loadinBackgroundKey,
        ),
         Positioned(
            bottom: 0,
            child: Stack(children: [
              const RoundedNavigationBar(backgroundColor: Color(0xFF352f3b)),
              _NavigationBar(scaffoldKey: scaffoldKey,)
            ])),
        // 11.h
        _HomePageListBody(
          height: 74.h,
          loadingKey: loadinBackgroundKey,
        ),

        // TODO : CreateList Button
      ],
    );
  }
}

class _endDrawer extends StatelessWidget {
  const _endDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16)
        ),
        child: Drawer(
          width: 80.w,
          child: Container(
            height: 100.h,
            width: 80.w,
            color: const Color(0xFF252525),
            child: Column(
              children: [
                _bigProfilePicture()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bigProfilePicture() {
    return SizedBox(
      height: 25.w,
      width: 25.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: const Image(
          image: AssetImage(
            "assets/images/equality_.png"
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}


class _GradientBackground extends StatelessWidget {
  const _GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      width: 100.w,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Constants.linearGradientTopColor,
              Constants.linearGradientBottomColor
            ]),
      ),
    );
  }
}

class _LoadingBackground extends StatefulWidget {
  const _LoadingBackground({super.key});

  @override
  State<_LoadingBackground> createState() => _LoadingBackgroundState();
}

class _LoadingBackgroundState extends State<_LoadingBackground> {
  bool _isLoading = false;

  void changeLoadingStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void setLoadingStatusTrue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = true;
      });
    });
  }

  void setLoadingStatusFalse() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      width: 100.w,
      color: _isLoading ? Colors.black.withOpacity(0.6) : Colors.transparent,
    );
  }
}

class _HomePageListBody extends StatefulWidget {
  const _HomePageListBody(
      {super.key, required this.height, required this.loadingKey});

  final double height;
  final GlobalKey<_LoadingBackgroundState> loadingKey;

  @override
  State<_HomePageListBody> createState() => _HomePageListBodyState();
}

class _HomePageListBodyState extends State<_HomePageListBody> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getLists(),
      builder: (context, snapshot) {
        widget.loadingKey.currentState?.setLoadingStatusTrue();

        /*if (snapshot.hasData) {
          widget.loadingKey.currentState?.setLoadingStatusFalse();
          return Text("Blub");
        }

        else {
          return CircularProgressIndicator();
        }
*/
        if (snapshot.hasError) {
          widget.loadingKey.currentState?.setLoadingStatusFalse();
          return Text(
            snapshot.error.toString(),
            style: TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          widget.loadingKey.currentState?.setLoadingStatusFalse();
          // Konvertiere den JSON-Response in ein Dart-Map-Objekt
          Map<String, dynamic> response =
              json.decode(snapshot.data!.body.toString());

          // Extrahiere das 'lists'-Array aus dem Response
          List<dynamic> lists = response['lists'];
          bool isEmpty = response['isEmpty'];
          return isEmpty ? isEmptyWidget() : gridView(lists, widget.loadingKey);
        } else {
          return SizedBox(
              //color: Colors.black.withOpacity(0.7),
              height: widget.height,
              width: 100.w,
              child: const Center(
                child: CircularProgressIndicator(),
              )); // TODO : Beim Laden ist unten kein Opacity
        }
      },
    );
  }

  Widget isEmptyWidget() {
    return Container(
      height: widget.height,
      width: 100.w,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Text(
          "Keine Listen Vorhanden",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp)),
        ),
      ),
    );
  }

  Widget gridView(
      List<dynamic> lists, GlobalKey<_LoadingBackgroundState> loadingKey) {
    return SizedBox(
      height: widget.height,
      child: AnimationLimiter(
        child: GridView.builder(
          padding: EdgeInsets.all(10.w),
          itemCount: lists.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 7.w,
              mainAxisSpacing: 5.w),
          itemBuilder: (context, index) {
            var list = lists[index];

            return AnimationConfiguration.staggeredGrid(
              columnCount: 2,
              position: index,
              child: ListWidget(
                list: CustomList(
                  list['listID'],
                  list['listname'],
                  _returnColorCode(list['color']),
                  list['emoji'],
                  list['created_at'],
                  list['ownerID'],
                ),
                onTap: () {
                  // TODO : In Liste reingehen
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Color _returnColorCode(int colorID) {
    const Color redColor = Color(0xFFFF8888);
    const Color yellowColor = Color(0xFFFFD952);
    const Color blueColor = Color(0xFF52C1FF);
    const Color pinkColor = Color(0xFFFF88F3);
    const Color magentaColor = Color(0xFFD988FF);
    const Color lightGreenColor = Color(0xFFA4D3A9);
    const Color darkBlueColor = Color(0xFF7785FF);
    const Color errorBlackColor = Color(0xFF000000);

    switch (colorID) {
      case 1:
        return redColor;
      case 2:
        return yellowColor;
      case 3:
        return blueColor;
      case 4:
        return pinkColor;
      case 5:
        return magentaColor;
      case 6:
        return lightGreenColor;
      case 7:
        return darkBlueColor;
      default:
        return errorBlackColor;
    }
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11.h,
      width: 100.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homeIcon(),
          SizedBox(
            width: 25.w,
          ),
          profileIcon()
        ],
      ),
    );
  }

  Widget homeIcon() {
    return SizedBox(
      height: 7.h,
      width: 15.w,
      child: Material(
        color: const Color(0xFF352f3b).withOpacity(1.0),
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          child: Icon(
            const IconData(0xe318, fontFamily: 'MaterialIcons'),
            color: Colors.white,
            size: 34.sp,
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget profileIcon() {
    return Stack(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.grey, // Background color for the rounded picture
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: const Image(
              image: AssetImage("assets/images/equality_.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100)
          ),
          child: Material(
            borderRadius: BorderRadius.circular(100),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        )
      ],
    );
  }
}
