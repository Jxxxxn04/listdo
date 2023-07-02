import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

IO.Socket connectAndListen() {
  IO.Socket socket = IO.io('http://zentrale.ddns.net:3000',
      OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) {
    print('connect');
  });

  socket.on('totalClicks', (data) => streamSocket.addResponse(data.toString()));

  socket.onDisconnect((_) => print('disconnect'));

  socket.connect(); // Verbindung zum Server herstellen

  return socket;
}

class CookiePage extends StatefulWidget {
  const CookiePage({Key? key}) : super(key: key);

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {

  IO.Socket socket = connectAndListen(); // Verbindung herstellen und auf Daten hören

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    socket.dispose();
    streamSocket.dispose();
  }

  void addCookie() {
    socket.emit('click');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFB88C),
                        Color(0xFFDE6262)
                      ]
                  )
              ),
              height: 100.h,
              width: 100.w,
              child: Stack(
                children: [
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(256),
                        onTap: addCookie,
                        child: Image(
                          image: AssetImage(
                              "assets/images/cookie.png"
                          ),
                        ),
                      ),
                    ),),
                  Center(child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
                    child: Text(
                      snapshot.data!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none
                      ),
                    ),
                  ))
                ],
              ),
            );
          } else {
            return Container(
              child: Text('No data'),
            );
          }
        },
    );
  }



}
