import 'package:flutter/material.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:a2chat/chat_screen.dart';

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
