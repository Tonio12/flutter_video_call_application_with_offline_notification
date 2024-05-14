import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:a2chat/generate_test_user_sig.dart';
import 'package:tencent_calls_engine/tencent_calls_engine.dart';

void main() {
  runApp(const A2ChatApp());
}

String yourNumber = generateRandomNumber();
final _random = Random();

class A2ChatApp extends StatelessWidget {
  const A2ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [TUICallKit.navigatorObserver],
      title: 'A2Chat',
      home: const A2ChatScreen(),
    );
  }
}

class A2ChatScreen extends StatefulWidget {
  const A2ChatScreen({super.key});

  @override
  _A2ChatScreenState createState() => _A2ChatScreenState();
}

class _A2ChatScreenState extends State<A2ChatScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginToTUICallKit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'A2Chat',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Number Is: $yourNumber',
                style: const TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name: *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Recipient\'s Number:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Check if name field is not empty
                  if (_nameController.text.isNotEmpty) {
                    String calleeUserId = _numberController
                        .text; // Get the recipient's userID from the text field
                    TUICallKit.instance
                        .call(calleeUserId, TUICallMediaType.video);
                  } else {
                    // Show error message if name field is empty
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please enter your name.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void loginToTUICallKit() async {
  final result = await TUICallKit.instance.login(GenerateTestUserSig.sdkAppId,
      yourNumber, GenerateTestUserSig.genTestSig(yourNumber));

  // Check the result of the login operation
  if (result.code.isEmpty) {
    print('Login to TUICallKit successful');
    // Perform further actions if login is successful
  } else {
    print('Login to TUICallKit failed');
    // Handle login failure
  }
}

// Generate a random 6-digit number for $Num
String generateRandomNumber() {
  return (_random.nextInt(900000) + 100000).toString();
}
