import 'package:flutter/material.dart';
import 'package:get_mechanic/services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String responseMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize the socket connection and pass the callback function
    SocketService.onResponseReceived = (String message) {
      setState(() {
        responseMessage = message;
      });
    };
    SocketService.connectToServer();
  }

  @override
  void dispose() {
    // Disconnect the socket when the screen is disposed
    SocketService.disconnect();
    super.dispose();
  }

  void sendMessage(String title, String content) {
    var message = {'title': title, 'content': content};
    SocketService.sendMessage('example_event', message); // Send event with title
    print('Sent message: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Flutter Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => sendMessage('greeting', 'Hello Server!'),
              child: Text('Send Greeting'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => sendMessage('file_upload', 'Sending a file...'),
              child: Text('Send File Upload Request'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => sendMessage('request_info', 'Requesting information...'),
              child: Text('Request Information'),
            ),
            SizedBox(height: 20),
            Text(
              'Server Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(responseMessage.isEmpty ? 'No response yet' : responseMessage),
          ],
        ),
      ),
    );
  }
}
