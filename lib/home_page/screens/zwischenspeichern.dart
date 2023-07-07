import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      body: _body(context),
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

    final GlobalKey<_HomePageCreateListAnimationState> createListAnimation =
    GlobalKey<_HomePageCreateListAnimationState>();

    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: Stack(
        children: [
          const Positioned(bottom: 0, child: _GradientBackground()),
          _LoadingBackground(
            key: loadinBackgroundKey,
          ),
          Positioned(
            bottom: 0,
            child: _HomePageListBody(
              height: 74.h,
              loadingKey: loadinBackgroundKey,
            ),
          ),
          Positioned(
            bottom: 0,
            child: _LoadingBackground(
              key: loadinForegroundKey,
            ),
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
          _appBar(),
          Positioned(
              bottom: 5.5.h,
              right: 41.5.w,
              left: 41.5.w,
              child: _HomePageButton(
                key: homePageButton,
                loadingkey: loadinForegroundKey,
                popupAnimationKey: popupAnimationKey,
              )),
          Positioned(
            bottom: 0,
            child: _HomePageCreateListAnimation(
              key: createListAnimation,
            ),
          ),
        ],
      ),
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
    return SizedBox(
      height: widget.height,
      width: 100.w,
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
  const _NavigationBar({super.key,
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
  const _HomePagePopupAnimation({super.key,
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

  bool _isAnimationStarted = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      width: 100.w,
      child: Stack(
        children: [
          Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: gestureDetector(context)),
          Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: animationWidget())
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

  Widget animationWidget() {
    return AnimatedContainer(
      height: _isAnimationStarted ? 50.h : 0,
      width: 100.w,
      curve: Curves.fastLinearToSlowEaseIn,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants.linearGradientTopColor,
                Constants.linearGradientBottomColor
              ])),
      duration: const Duration(milliseconds: 500),
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
          textFormField(),
        ],
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
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 36.sp,
          ),
        ),
      ),
    );
  }

  Widget textFormField() {
    return Form(
      child: TextFormField(

      ),
    );
  }

  void openEmojiKeyboard() {}
}
