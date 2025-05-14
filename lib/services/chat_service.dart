import 'package:darlink/modules/authentication/login_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  IO.Socket? socket;
  bool isConnected = false;

  Future<void> connect() async {
    try {
      if (socket != null) {
        socket!.disconnect();
      }

      socket = IO.io('http://192.168.1.104:5000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
        'reconnectionAttempts': 5,
      });

      socket!.onConnect((_) {
        print('Connected to socket server');
        isConnected = true;

        // Send user authentication after connection
        socket!.emit('user_connected', {
          'email': usermail, // Assuming usermail is your global variable
        });
      });

      socket!.onConnectError((data) {
        print('Connection error: $data');
        isConnected = false;
      });

      socket!.onDisconnect((_) {
        print('Disconnected from socket server');
        isConnected = false;
      });

      await socket!.connect();
    } catch (e) {
      print('Error connecting to socket server: $e');
      isConnected = false;
      rethrow;
    }
  }
}
