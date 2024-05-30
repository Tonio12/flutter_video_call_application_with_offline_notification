import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:a2chat/generate_test_user_sig.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';

class A2ChatScreen extends StatefulWidget {
  const A2ChatScreen({super.key});

  @override
  State<A2ChatScreen> createState() => _A2ChatScreenState();
}

class _A2ChatScreenState extends State<A2ChatScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  bool _isLoading = false;
  String _userId = "";

  @override
  void initState() {
    super.initState();

    _loginToTUICallKit();

    TencentCloudChatPush().registerOnAppWakeUpEvent(onAppWakeUpEvent: () {
      _loginToTUICallKit();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _loginToTUICallKit() async {
    _userId = await setUserId();
    setState(() {
      _isLoading = true;
    });

    TUICallKit.instance.enableFloatWindow(true);

    final result = await TUICallKit.instance.login(
      GenerateTestUserSig.sdkAppId,
      _userId,
      GenerateTestUserSig.genTestSig(_userId),
    );

    TencentCloudChatPush()
        .registerPush(onNotificationClicked: _onNotificationClicked);

    if (result.code.isEmpty) {
      TUICallKit.instance.enableVirtualBackground(true);
      TUICallKit.instance.enableFloatWindow(true);
      TUICallKit.instance.enableIncomingBanner(true);
    } else {
      print('Login to TUICallKit failed');
      _showErrorDialog('Login failed: ${result.message}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onNotificationClicked({
    required String ext,
    String? userID,
    String? groupID,
  }) {
    debugPrint(
        "_onNotificationClicked: $ext, userID: $userID, groupID: $groupID");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _makeCall() {
    if (_nameController.text.isNotEmpty) {
      TUIOfflinePushInfo offlinePushInfo = TUIOfflinePushInfo();
      offlinePushInfo.title = "Flutter TUICallKit";
      offlinePushInfo.desc = "This is an incoming call from Flutter TUICallkit";
      offlinePushInfo.ignoreIOSBadge = false;
      offlinePushInfo.iOSSound = "phone_ringing.mp3";
      offlinePushInfo.androidSound = "phone_ringing";
      offlinePushInfo.androidFCMChannelID = "fcm_push_channel";
      offlinePushInfo.iOSPushType = TUICallIOSOfflinePushType.VoIP;

      TUICallParams params = TUICallParams();
      params.offlinePushInfo = offlinePushInfo;

      String calleeUserId = _numberController.text;
      TUICallKit.instance.call(calleeUserId, TUICallMediaType.video, params);
    } else {
      _showErrorDialog('Please enter your name.');
    }
  }

  Future<String> setUserId() async {
    final random = Random();
    String? userId;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");

    if (userId == null) {
      userId = (random.nextInt(900000) + 100000).toString();
      await prefs.setString("userId", userId);
    }

    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A2Chat'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 20.0),
              ],
              Text(
                'Your Number Is: $_userId',
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
                onPressed: _makeCall,
                child: const Text('Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
