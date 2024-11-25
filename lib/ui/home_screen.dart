// lib/ui/home_screen.dart
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
              onPressed: () {
                // Send a message to the server
                var message = {'message': 'Hello from Flutter'};
                SocketService.sendMessage('example_event', message); // Pass event name and message
                print('Sent message: $message');
              },
              child: Text('Send Message to Server'),
            ),
            SizedBox(height: 20),
            Text(
              'Server Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(responseMessage.isEmpty
                ? 'No response yet'
                : responseMessage),  // Show the response here
          ],
        ),
      ),
    );
  }
}
