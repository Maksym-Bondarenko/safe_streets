import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _interval = const Duration(seconds: 1);
  final _name = 'John Doe';
  final _audioPlayer = AudioPlayer();
  final _audioFilePath = "assets/audio/beep.mp3";

  Duration _duration = const Duration();
  Timer? _timer;

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
                'assets/fake_call/profile_picture.png',
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
              'Call Duration: ${_duration.inMinutes % 60}:${_duration.inSeconds % 60}',
              style: const TextStyle(fontSize: 20),
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
                  onPressed: () => _endCall(context),
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

  // TODO implement cancel call functionality
  void _cancelCall(BuildContext context) {
    // context.pop();
  }

  void _startCall() async {
    _timer = Timer.periodic(_interval, (Timer timer) {
      setState(() {
        _duration += _interval;
      });
    });
    await _audioPlayer.play(AssetSource(_audioFilePath));
  }

  void _endCall(BuildContext context) async {
    _timer?.cancel();
    await _audioPlayer.stop();
    // context.pop();
  }
}
