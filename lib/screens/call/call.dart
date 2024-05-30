import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:go_router/go_router.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _interval = const Duration(seconds: 1);
  final _name = 'John Doe';

  Duration _duration = const Duration();
  Timer? _timer;

  @override
  initState() {
    super.initState();
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Incoming Call',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/images/call_profile_picture.png',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Call Duration: $_formattedCallDuration',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.red,
                    size: 32,
                  ),
                  onPressed: () => _cancelCall(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 32,
                  ),
                  onPressed: _startCall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _cancelCall(BuildContext context) {
    FlutterRingtonePlayer.stop();
    GoRouter.of(context).pop();
  }

  void _startCall() {
    FlutterRingtonePlayer.stop();
    // TODO play audio call file
    _timer = Timer.periodic(_interval, (Timer timer) {
      setState(() {
        _duration += _interval;
      });
    });
  }

  void _endCall(BuildContext context) {
    // TODO stop audio call file
    _timer?.cancel();
    GoRouter.of(context).pop();
  }

  String get _formattedCallDuration {
    return '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
