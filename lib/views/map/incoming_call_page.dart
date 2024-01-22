import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:safe_streets/router.dart';
import 'package:safe_streets/views/map/active_call_page.dart';

class IncomingCallPage extends StatefulWidget {
  final String callerName = 'John Doe';

  const IncomingCallPage({Key? key}) : super(key: key);

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  final audioFilePath = "assets/audio/beep.mp3";
  Timer? _timer;
  Duration _callDuration = const Duration();
  late Timer _callDurationTimer;

  @override
  void initState() {
    super.initState();
    //playAudio();
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
              // backgroundImage:
              //     AssetImage('assets/fake_call/profile_picture.png'),
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
                    AppRouter.router.pop();
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
                    // Navigate to the ActiveCallPage with relevant data
                    AppRouter.router.pushNamed(
                      AppRoutes.activeCall,
                      extra: IActiveCallPageProps(
                        name: widget.callerName,
                        duration: _callDuration,
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
