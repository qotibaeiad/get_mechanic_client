// lib/services/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;
  static Function(String)? onResponseReceived;

  // Connect to the server
  static void connectToServer() {
    _socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Handle server response
    _socket?.on('example_response', (data) {
      if (data is Map) {
        print('Received from server: ${data['message']}');
        // Call the callback function to notify the UI
        if (onResponseReceived != null) {
          onResponseReceived!(data['message']);
        }
      }
    });

    _socket?.on('connect', (_) {
      print('Connected to server');
    });

    _socket?.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  // Emit a message to the server
  static void sendMessage(String title, Map<String, dynamic> message) {
    _socket?.emit(title, message);
    print('Sent message to server: $message');
  }

  // Disconnect the socket connection
  static void disconnect() {
    _socket?.disconnect();
    print('Disconnected from server');
  }
}
