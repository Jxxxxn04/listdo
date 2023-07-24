import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';
import '../../constants.dart';
import '../providers/list_provider.dart';
import '../widgets/home_page_widgets.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<_HomePageCreateListAnimationState> createListAnimation =
      GlobalKey<_HomePageCreateListAnimationState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Column(
            children: [_appBar(), _body(context)],
          ),
          Positioned(
            bottom: 0,
            child: _HomePageCreateListAnimation(
              key: createListAnimation,
            ),
          ),
        ],
      ),
      endDrawer: _EndDrawer(
        scaffoldKey: scaffoldKey,
      ),
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

  Widget _body(BuildContext context) {
    final GlobalKey<_LoadingBackgroundState> loadinBackgroundKey =
        GlobalKey<_LoadingBackgroundState>();

    final GlobalKey<_LoadingBackgroundState> loadinForegroundKey =
        GlobalKey<_LoadingBackgroundState>();

    final GlobalKey<_HomePagePopupAnimationState> popupAnimationKey =
        GlobalKey<_HomePagePopupAnimationState>();

    final GlobalKey<_HomePageButtonState> homePageButton =
        GlobalKey<_HomePageButtonState>();

    return Stack(
      children: [
        const _GradientBackground(),
        _LoadingBackground(
          key: loadinBackgroundKey,
        ),
        _HomePageListBody(
          height: 74.h,
          loadingKey: loadinBackgroundKey,
        ),
        _LoadingBackground(
          key: loadinForegroundKey,
        ),
        Positioned(
            bottom: 11.h,
            child: _HomePagePopupAnimation(
              key: popupAnimationKey,
              homePageButton: homePageButton,
              createListAnimation: createListAnimation,
            )),
        Positioned(
            bottom: 0,
            child: Stack(children: [
              const RoundedNavigationBar(backgroundColor: Color(0xFF352f3b)),
              _NavigationBar(
                scaffoldKey: scaffoldKey,
                popupAnimationKey: popupAnimationKey,
                homePageButton: homePageButton,
                loadingkey: loadinForegroundKey,
              )
            ])),
        Positioned(
            bottom: 5.5.h,
            right: 41.5.w,
            left: 41.5.w,
            child: _HomePageButton(
              key: homePageButton,
              loadingkey: loadinForegroundKey,
              popupAnimationKey: popupAnimationKey,
            )),
      ],
    );
  }
}

class _EndDrawer extends StatelessWidget {
  const _EndDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
        child: Drawer(
          width: 80.w,
          child: Container(
            height: 100.h,
            width: 80.w,
            color: const Color(0xFF252525),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 5.w)),
                Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: _backSpaceButton()),
                        const Spacer()
                      ],
                    )),
                _bigProfilePicture(),
                Padding(
                    padding: EdgeInsets.only(top: 10.w, left: 5.w, right: 5.w),
                    child: _welcomeTextWidget()),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomTextButton(
                      height: 6.h,
                      width: 100.w,
                      text: "Einstellungen",
                      color: Colors.transparent,
                      textpadding: EdgeInsets.only(left: 8.w),
                      onTap: () {},
                    ),
                    CustomTextButton(
                      height: 6.h,
                      width: 100.w,
                      text: "Benachrichtigungen",
                      color: Colors.transparent,
                      textpadding: EdgeInsets.only(left: 8.w),
                      onTap: () {},
                    ),
                    CustomTextButton(
                      height: 6.h,
                      width: 100.w,
                      text: "Abmelden",
                      color: Colors.transparent,
                      textpadding: EdgeInsets.only(left: 8.w),
                      splashColor: Colors.red,
                      textColor: Colors.redAccent,
                      onTap: () {
                        _logout(context);
                      },
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backSpaceButton() {
    return Container(
      height: 12.w,
      width: 12.w,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF604949)),
      child: Material(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            scaffoldKey.currentState?.closeEndDrawer();
          },
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 16.sp,
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
          image: AssetImage("assets/images/equality_.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _welcomeTextWidget() {
    return FutureBuilder<String?>(
      future: getUsername(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String? username;

        if (snapshot.hasData) {
          username = snapshot.data;

          return AutoSizeText(
            "Willkommen ${username ?? ''}!",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontSize: 16.sp)),
            stepGranularity: 1,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            minFontSize: 14.sp.roundToDouble(),
          );
        }

        // TODO : Error behandeln

        else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  void _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userID");
    prefs.remove("username");
    prefs.remove("email");
    prefs.remove("created_at");
    if (context.mounted)
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
      if (mounted) {
        setState(() {
          _isLoading = !_isLoading;
        });
      }
    });
  }

  void setLoadingStatusTrue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    });
  }

  void setLoadingStatusFalse() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void test() {
    if (kDebugMode) {
      print("blub");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isLoading,
      child: Container(
        height: 85.h,
        width: 100.w,
        color: Colors.black.withOpacity(0.6),
      ),
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
  final Api api = Api();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getLists(context),
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
            style: const TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          widget.loadingKey.currentState?.setLoadingStatusFalse();
          // Konvertiere den JSON-Response in ein Dart-Map-Objekt
          Map<String, dynamic> response =
              json.decode(snapshot.data!.body.toString());

          // Extrahiere das 'lists'-Array aus dem Response
          List<dynamic> lists = response['lists'];

          bool isEmpty = response['isEmpty'];

          for(var list in lists) {
            ListWidget listWidget = ListWidget(
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
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<ListProvider>(context, listen: false).addList(listWidget);
            });
          }


          // TODO : if empty and list is created it wont be shown unless restarted
          return isEmpty ? isEmptyWidget() : gridView(lists, widget.loadingKey);
        } else {
          return SizedBox(
              //color: Colors.black.withOpacity(0.7),
              height: widget.height,
              width: 100.w,
              child: const Center(
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }

  Widget isEmptyWidget() {
    widget.loadingKey.currentState?.changeLoadingStatus();
    return SizedBox(
      height: widget.height,
      width: 100.w,
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
    return Consumer<ListProvider>(
      builder: (context, listProvider, child) {
        return SizedBox(
          height: widget.height,
          child: AnimationLimiter(
            child: GridView.builder(
              padding: EdgeInsets.all(10.w),
              itemCount: listProvider.lists.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 7.w,
                  mainAxisSpacing: 5.w),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  columnCount: 2,
                  position: index,
                  child: listProvider.lists[index],
                );
              },
            ),
          ),
        );
      },
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
  const _NavigationBar(
      {super.key,
      required this.scaffoldKey,
      required this.homePageButton,
      required this.popupAnimationKey,
      required this.loadingkey});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<_HomePageButtonState> homePageButton;
  final GlobalKey<_HomePagePopupAnimationState> popupAnimationKey;
  final GlobalKey<_LoadingBackgroundState> loadingkey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11.h,
      width: 100.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homeIcon(context),
          SizedBox(
            width: 25.w,
          ),
          profileIcon(context)
        ],
      ),
    );
  }

  Widget homeIcon(BuildContext context) {
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
          onTap: () {
            homePageButton.currentState?.setIconToAdd();
            popupAnimationKey.currentState?.stopAnimation();
            loadingkey.currentState?.setLoadingStatusFalse();
          },
        ),
      ),
    );
  }

  Widget profileIcon(BuildContext context) {
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: Material(
            borderRadius: BorderRadius.circular(100),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                homePageButton.currentState?.setIconToAdd();
                popupAnimationKey.currentState?.stopAnimation();
                loadingkey.currentState?.setLoadingStatusFalse();
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        )
      ],
    );
  }
}

class _HomePageButton extends StatefulWidget {
  const _HomePageButton(
      {super.key, required this.loadingkey, required this.popupAnimationKey});

  final GlobalKey<_LoadingBackgroundState> loadingkey;
  final GlobalKey<_HomePagePopupAnimationState> popupAnimationKey;

  @override
  State<_HomePageButton> createState() => _HomePageButtonState();
}

class _HomePageButtonState extends State<_HomePageButton> {
  bool _isIconExpanded = false;

  void changeIconStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isIconExpanded = !_isIconExpanded;
        });
      }
    });
  }

  void setIconToClose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isIconExpanded = true;
        });
      }
    });
  }

  void setIconToAdd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isIconExpanded = false;
        });
      }
    });
  }

  void toggleCreateListMenu(BuildContext context) {
    if (mounted) {
      setState(() {
        _isIconExpanded = !_isIconExpanded;
        widget.loadingkey.currentState?.changeLoadingStatus();
        widget.popupAnimationKey.currentState?.toggleAnimationStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17.w,
      width: 17.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF905BFF),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            toggleCreateListMenu(context);
          },
          child: Center(
            child: AnimatedCrossFade(
                firstCurve: Curves.linear,
                secondCurve: Curves.linear,
                duration: const Duration(milliseconds: 100),
                firstChild: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30.sp,
                ),
                secondChild: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.sp,
                ),
                crossFadeState: _isIconExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst),
          ),
        ),
      ),
    );
  }
}

class _HomePagePopupAnimation extends StatefulWidget {
  const _HomePagePopupAnimation(
      {super.key,
      required this.homePageButton,
      required this.createListAnimation});

  final GlobalKey<_HomePageButtonState> homePageButton;
  final GlobalKey<_HomePageCreateListAnimationState> createListAnimation;

  @override
  State<_HomePagePopupAnimation> createState() =>
      _HomePagePopupAnimationState();
}

class _HomePagePopupAnimationState extends State<_HomePagePopupAnimation> {
  bool _isAnimationStarted = false;

  void toggleAnimationStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isAnimationStarted = !_isAnimationStarted;
        });
      }
    });
  }

  void startAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isAnimationStarted = true;
        });
      }
    });
  }

  void stopAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isAnimationStarted = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _isAnimationStarted ? 89.h : 0,
      width: 100.w,
      duration: _isAnimationStarted
          ? const Duration(milliseconds: 100)
          : Duration.zero,
      curve: Curves.easeInExpo,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextButton(
              height: 7.h,
              width: 70.w,
              text: "Neue Liste",
              alignment: Alignment.center,
              color: const Color(0xFF867BFF),
              borderRadius: BorderRadius.circular(15),
              onTap: () => createListFunction(context),
            ),
            SizedBox(
              height: 3.h,
            ),
            CustomTextButton(
              height: 7.h,
              width: 70.w,
              text: "Liste beitreten",
              alignment: Alignment.center,
              color: const Color(0xFF87C5FF),
              borderRadius: BorderRadius.circular(15),
              onTap: joinListFunction,
            ),
          ],
        ),
      ),
    );
  }

  void createListFunction(BuildContext context) {
    widget.homePageButton.currentState?.toggleCreateListMenu(context);
    widget.createListAnimation.currentState?.startAnimation();
  }

  void joinListFunction() {
    // TODO : Stop the popupAnimation
    // TODO : Start the InviteAnimation
  }
}

class _HomePageCreateListAnimation extends StatefulWidget {
  const _HomePageCreateListAnimation({super.key});

  @override
  State<_HomePageCreateListAnimation> createState() =>
      _HomePageCreateListAnimationState();
}

class _HomePageCreateListAnimationState
    extends State<_HomePageCreateListAnimation> {
  final TextEditingController input = TextEditingController();

  Api api = Api();

  bool _emojiKeyboardShowing = false;
  bool _hasEmoji = false;
  String _emoji = "";
  bool _isAnimationStarted = false;
  bool _hasGradientBackground = true;
  Color? _createListAnimationBackgroundColor;
  GlobalKey<ColoredSquareState>? _selectedKey;

  //ColoredSquare Keys to controll selected Color when creating a List
  final GlobalKey<ColoredSquareState> _redSquareKey =
      GlobalKey<ColoredSquareState>();
  final GlobalKey<ColoredSquareState> _yellowSquareKey =
      GlobalKey<ColoredSquareState>();
  final GlobalKey<ColoredSquareState> _blueSquareKey =
      GlobalKey<ColoredSquareState>();
  final GlobalKey<ColoredSquareState> _pinkSquareKey =
      GlobalKey<ColoredSquareState>();
  final GlobalKey<ColoredSquareState> _magentaSquareKey =
      GlobalKey<ColoredSquareState>();
  final GlobalKey<ColoredSquareState> _lightGreenSquareKey =
      GlobalKey<ColoredSquareState>();
  final GlobalKey<ColoredSquareState> _darkBlueSquareKey =
      GlobalKey<ColoredSquareState>();

  //unselects every coloredSquare and select the given one. And it returns the current used key
  GlobalKey<ColoredSquareState> _selectColorController(
      GlobalKey<ColoredSquareState> key) {
    _redSquareKey.currentState?.unSelectItem();
    _yellowSquareKey.currentState?.unSelectItem();
    _blueSquareKey.currentState?.unSelectItem();
    _pinkSquareKey.currentState?.unSelectItem();
    _magentaSquareKey.currentState?.unSelectItem();
    _lightGreenSquareKey.currentState?.unSelectItem();
    _darkBlueSquareKey.currentState?.unSelectItem();
    key.currentState?.selectItem();

    return key;
  }

  //Checks whether the ColoredSquare is already selected
  bool _checkForSelectedColoredSquare(GlobalKey<ColoredSquareState> key) {
    return _selectedKey == key;
  }

  //Um den Hintergrund zu ändern
  void _changeCreateListAnimationBackgroundColor(Color color) {
    setState(() {
      _hasGradientBackground = false;
      _createListAnimationBackgroundColor = color;
    });
  }

  void _resetBackgroundAndColoredSquares() {
    setState(() {
      _hasGradientBackground = true;
      _createListAnimationBackgroundColor = null;
    });

    //Unselect every ColoreSquare
    _redSquareKey.currentState?.unSelectItem();
    _yellowSquareKey.currentState?.unSelectItem();
    _blueSquareKey.currentState?.unSelectItem();
    _pinkSquareKey.currentState?.unSelectItem();
    _magentaSquareKey.currentState?.unSelectItem();
    _lightGreenSquareKey.currentState?.unSelectItem();
    _darkBlueSquareKey.currentState?.unSelectItem();
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  void toggleAnimationStatus() {
    setState(() {
      _isAnimationStarted = !_isAnimationStarted;
    });
  }

  void startAnimation() {
    setState(() {
      _isAnimationStarted = true;
    });
  }

  void stopAnimation() {
    setState(() {
      _isAnimationStarted = false;
    });
    closeEmojiKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      width: 100.w,
      child: Stack(
        children: [
          gestureDetector(context),
          Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: Stack(children: [
                animationWidget(context),
                Positioned(bottom: 0, child: emojiKeyboard())]))
        ],
      ),
    );
  }

  // Er reagiert wenn man außerhalb des Widgets klickt
  Widget gestureDetector(BuildContext context) {
    return Visibility(
      visible: _isAnimationStarted,
      child: GestureDetector(
        onTap: () => toggleAnimationStatus(),
        child: Container(
          height: 85.h,
          width: 100.w,
          color: Colors.black.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget animationWidget(BuildContext context) {
    return AnimatedContainer(
      height: _isAnimationStarted ? 60.h : 0,
      width: 100.w,
      curve: Curves.fastLinearToSlowEaseIn,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _hasGradientBackground
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      Constants.linearGradientTopColor,
                      Constants.linearGradientBottomColor
                    ])
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      _createListAnimationBackgroundColor!,
                      _createListAnimationBackgroundColor!
                    ])),
      duration: const Duration(milliseconds: 500),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            textWidget(),
            SizedBox(
              height: 2.5.h,
            ),
            emojiInputWidget(),
            SizedBox(
              height: 2.5.h,
            ),
            textFormField(context),
            SizedBox(
              height: 4.h,
            ),
            coloredSquaresWidget(),
            SizedBox(
              height: 4.h,
            ),
            CustomTextButton(
              height: 7.h,
              width: 84.w,
              text: "Erstellen",
              color: const Color(0xFF4E4E4E),
              onTap: createList,
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(15),
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomTextButton(
              height: 6.h,
              width: 50.w,
              text: "Abbrechen",
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              alignment: Alignment.center,
              onTap: stopAnimation,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textWidget() {
    return Text(
      "Liste erstellen",
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget emojiInputWidget() {
    return Container(
      height: 18.w,
      width: 18.w,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4E4E4E)),
      child: Material(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: openEmojiKeyboard,
          child: _hasEmoji ?
              Center(
                child: Text(
                  _emoji,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38.sp,
                  ),
                ),
              )
              :Icon(
            Icons.add,
            color: Colors.white,
            size: 36.sp,
          ),
        ),
      ),
    );
  }

  Widget textFormField(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Listen Name:",
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(color: Colors.white, fontSize: 14.sp)),
                ),
              ),
            ),
            const Spacer()
          ],
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Form(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TextFormField(
              controller: input,
              decoration: InputDecoration(
                  labelText: "Liste",
                  labelStyle: TextStyle(
                      color: const Color(0xFFB0B0B0), fontSize: 15.sp),
                  fillColor: const Color(0xFFE8E8E8),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFF696969), width: 3)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF696969), width: 20)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF696969), width: 3))),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp("\\s"), allow: false),
                LengthLimitingTextInputFormatter(30)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget coloredSquaresWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ColoredSquare(
          key: _redSquareKey,
          color: Constants.redColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_redSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _redSquareKey;
              _selectColorController(_redSquareKey);
              _changeCreateListAnimationBackgroundColor(Constants.redColor);
            }
          },
        ),
        ColoredSquare(
          key: _yellowSquareKey,
          color: Constants.yellowColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_yellowSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _yellowSquareKey;
              _selectColorController(_yellowSquareKey);
              _changeCreateListAnimationBackgroundColor(Constants.yellowColor);
            }
          },
        ),
        ColoredSquare(
          key: _blueSquareKey,
          color: Constants.blueColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_blueSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _blueSquareKey;
              _selectColorController(_blueSquareKey);
              _changeCreateListAnimationBackgroundColor(Constants.blueColor);
            }
          },
        ),
        ColoredSquare(
          key: _pinkSquareKey,
          color: Constants.pinkColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_pinkSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _pinkSquareKey;
              _selectColorController(_pinkSquareKey);
              _changeCreateListAnimationBackgroundColor(Constants.pinkColor);
            }
          },
        ),
        ColoredSquare(
          key: _magentaSquareKey,
          color: Constants.magentaColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_magentaSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _magentaSquareKey;
              _selectColorController(_magentaSquareKey);
              _changeCreateListAnimationBackgroundColor(Constants.magentaColor);
            }
          },
        ),
        ColoredSquare(
          key: _lightGreenSquareKey,
          color: Constants.lightGreenColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_lightGreenSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _lightGreenSquareKey;
              _selectColorController(_lightGreenSquareKey);
              _changeCreateListAnimationBackgroundColor(
                  Constants.lightGreenColor);
            }
          },
        ),
        ColoredSquare(
          key: _darkBlueSquareKey,
          color: Constants.darkBlueColor,
          size: 9.w,
          onTap: () {
            //If Square is already selected go back to standard background and unselect the ColoredSquare
            if (_checkForSelectedColoredSquare(_darkBlueSquareKey)) {
              _selectedKey = null;
              _resetBackgroundAndColoredSquares();
            } else {
              _selectedKey = _darkBlueSquareKey;
              _selectColorController(_darkBlueSquareKey);
              _changeCreateListAnimationBackgroundColor(
                  Constants.darkBlueColor);
            }
          },
        ),
      ],
    );
  }

  void closeEmojiKeyboard() {
    setState(() {
      _emojiKeyboardShowing = false;
    });
  }

  void openEmojiKeyboard() {
    setState(() {
      _emojiKeyboardShowing = true;
    });
  }

  void createList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? ownerID = prefs.getInt("userID");

    // TODO : handle exception for color being null
    http.Response response = await api.createList(input.text.toString(),
        ownerID ?? 0, _returnColorID(_selectedKey?.currentState!.color), _emoji);

    if (response.statusCode == 201) {
      stopAnimation();
      // Get the current date and time
      DateTime now = DateTime.now();

      // Format the date and time to the desired format
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      ListWidget listWidget = ListWidget(
        list: CustomList(
            2, // TODO : Die ListID muss man noch von der API zurückkriegen
            input.text.toString(),
            _selectedKey?.currentState!.color ?? Colors.black,
            _emoji,
            formattedDateTime,
            ownerID!),
        onTap: () {
          // TODO : In Liste reingehen
        },
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ListProvider>(context, listen: false).addList(listWidget);
      });
    }

    FocusManager.instance.primaryFocus?.unfocus();
  }

  int _returnColorID(Color? colorCode) {
    const Color redColor = Color(0xFFFF8888);
    const Color yellowColor = Color(0xFFFFD952);
    const Color blueColor = Color(0xFF52C1FF);
    const Color pinkColor = Color(0xFFFF88F3);
    const Color magentaColor = Color(0xFFD988FF);
    const Color lightGreenColor = Color(0xFFA4D3A9);
    const Color darkBlueColor = Color(0xFF7785FF);

    if (colorCode == redColor) {
      return 1;
    } else if (colorCode == yellowColor) {
      return 2;
    } else if (colorCode == blueColor) {
      return 3;
    } else if (colorCode == pinkColor) {
      return 4;
    } else if (colorCode == magentaColor) {
      return 5;
    } else if (colorCode == lightGreenColor) {
      return 6;
    } else if (colorCode == darkBlueColor) {
      return 7;
    } else {
      return 8;
    }
  }

  Widget emojiKeyboard() {
    return Stack(
      children: [

        SizedBox(
          height: _emojiKeyboardShowing ? 100.h : 0,
          width: 100.w,
          child: GestureDetector(
            onTap: closeEmojiKeyboard,
          ),
        ),

        Positioned(
          bottom: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: Colors.transparent,
            height: _emojiKeyboardShowing ? 37.h : 0,
            width: 100.w,
            child: emoji.EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _hasEmoji = true;
                  _emoji = emoji.emoji;
                });
              },
              config: emoji.Config(
                columns: 8,
                emojiSizeMax: 32 *
                    (defaultTargetPlatform ==
                        TargetPlatform.iOS
                        ? 1.30
                        : 1.0),
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: emoji.Category.SMILEYS,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                recentTabBehavior: emoji.RecentTabBehavior.NONE,
                loadingIndicator: const SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const emoji.CategoryIcons(),
                buttonMode: emoji.ButtonMode.MATERIAL,
                checkPlatformCompatibility: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
