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
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_appBar(), _body()],
      ),
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
    return Stack(
      children: [
        const _GradientBackground(),
        const Positioned(
            bottom: 0,
            child: RoundedNavigationBar(backgroundColor: Color(0xFF252525))),
        // 11.h
        _HomePageListBody(
          height: 74.h,
        ),

        // TODO : CreateList Button
      ],
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

class _HomePageListBody extends StatefulWidget {
  const _HomePageListBody({super.key, required this.height});

  final double height;

  @override
  State<_HomePageListBody> createState() => _HomePageListBodyState();
}

class _HomePageListBodyState extends State<_HomePageListBody> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getLists(28), // TODO : sharedprefernces benutzen
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          // Konvertiere den JSON-Response in ein Dart-Map-Objekt
          Map<String, dynamic> response =
              json.decode(snapshot.data!.body.toString());

          // Extrahiere das 'lists'-Array aus dem Response
          List<dynamic> lists = response['lists'];

          return gridView(lists);
        } else {
          return Container(
              color: Colors.black.withOpacity(0.7),
              height: widget.height,
              width: 100.w,
              child: const Center(
                child: CircularProgressIndicator(),
              )); // TODO : Beim Laden ist unten kein Opacity
        }
      },
    );
  }

  Widget gridView(List<dynamic> lists) {
    return SizedBox(
      height: widget.height,
      child: AnimationLimiter(
        child: GridView.builder(
          itemCount: lists.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8.w,
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
                  const Color(0xFFaff463),  // TODO : Konstante entfernen und Code korigieren
                  list['emoji'],
                  list['created_at'],
                  list['ownerID'],
                ),
                onTap: () {

                },
              ),
            );
          },
        ),
      ),
    );
  }
}
