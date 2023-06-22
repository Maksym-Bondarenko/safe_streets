import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class CallScreen extends StatefulWidget {
  final String callerName;
  final String audioFilePath;

  const CallScreen({
    Key? key,
    required this.callerName,
    required this.audioFilePath,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final audioPlayer = AudioPlayer();
  late Timer _timer;
  late int _secondsRemaining;
  String _formattedDuration = '';
  bool isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = 0;
    startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining++;
        _formattedDuration = formatDuration(Duration(seconds: _secondsRemaining));
      });
    });
  }

  void playAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource(widget.audioFilePath));
    isAudioPlaying = true;
  }

  void stopAudio() async {
    await audioPlayer.stop();
    isAudioPlaying = false;
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('lib/assets/fake_call/profile_picture.png'),
              ),
              const SizedBox(height: 16),
              Text(
                widget.callerName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Call Duration: $_formattedDuration',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'muteButton',
                    onPressed: () {
                      // Add action for muting/unmuting the call
                    },
                    child: const Icon(Icons.volume_up),
                  ),
                  FloatingActionButton(
                    heroTag: 'switchCameraButton',
                    onPressed: () {
                      // Add action for switching the camera
                    },
                    child: const Icon(Icons.switch_camera),
                  ),
                  FloatingActionButton(
                    heroTag: 'endCallButton',
                    onPressed: () {
                      stopAudio();
                      // Close all widgets until the filter-map
                      Navigator.popUntil(context, ModalRoute.withName('/filterMap'));
                    },
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'audioButton',
          onPressed: () {
            (isAudioPlaying) ? stopAudio() : playAudio();
          },
          child: const Icon(Icons.headset),
        ),
      ),
    );
  }
}
