import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  print("blub");
  // Dart client
  IO.Socket socket = IO.io('http://zentrale.ddns.net:3000',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .build()
  );
  socket.connect();
  socket.onConnect((_) {
    print('connect');
  });
  socket.on('totalClicks', (data) => print(data));
  socket.onDisconnect((_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));
}