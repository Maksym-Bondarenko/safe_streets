import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'call_screen.dart';

class FakeCallWidget extends StatefulWidget {
  final String callerName;

  const FakeCallWidget({Key? key, required this.callerName}) : super(key: key);

  @override
  _FakeCallWidgetState createState() => _FakeCallWidgetState();
}

class _FakeCallWidgetState extends State<FakeCallWidget> {
  Timer? _timer;
  Duration _callDuration = const Duration();
  late Timer _callDurationTimer;
  final audioFilePath = "lib/assets/audio/beep.mp3";

  @override
  void initState() {
    super.initState();
    playAudio();
  }

  @override
  void dispose() {
    stopAudio();
    _timer?.cancel();
    _callDurationTimer.cancel();
    super.dispose();
  }

  final audioPlayer = AudioPlayer();

  void playAudio() async {
    await audioPlayer.play(AssetSource(audioFilePath));
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }

  void _startCallDurationTimer() {
    const durationInterval = Duration(seconds: 1);

    _callDuration = const Duration();
    _callDurationTimer = Timer.periodic(durationInterval, (Timer timer) {
      setState(() {
        _callDuration += durationInterval;
      });
    });
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
              backgroundImage:
                  AssetImage('lib/assets/fake_call/profile_picture.png'),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Call Duration: $_callDuration seconds',
              style: const TextStyle(
                fontSize: 16,
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
                  onPressed: () {
                    _timer?.cancel();
                    stopAudio();
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 32,
                  ),
                  onPressed: () {
                    _timer?.cancel();
                    stopAudio();
                    // Start a new timer to track call duration
                    _startCallDurationTimer();

                    // Navigate to the CallScreen with relevant data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          callerName: widget.callerName,
                          callDuration: _callDuration,
                          audioFilePath: 'lib/assets/audio/spoken_language.mp3',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
