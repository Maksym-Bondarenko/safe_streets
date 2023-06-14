import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CallScreen extends StatelessWidget {
  final String callerName;
  final Duration callDuration;
  final String audioFilePath;

  const CallScreen({
    Key? key,
    required this.callerName,
    required this.callDuration,
    required this.audioFilePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();

    void playAudio() async {
      await audioPlayer.play(AssetSource(audioFilePath));
    }

    void stopAudio() async {
      await audioPlayer.stop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage:
                  AssetImage('lib/assets/fake_call/profile_picture.png'),
            ),
            const SizedBox(height: 16),
            Text(
              callerName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Call Duration: ${callDuration.inMinutes}:${(callDuration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Add action for muting/unmuting the call
                  },
                  child: const Icon(Icons.volume_up),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Add action for switching the camera
                  },
                  child: const Icon(Icons.switch_camera),
                ),
                FloatingActionButton(
                  onPressed: () {
                    stopAudio();
                    // Close all widgets until the filter-map
                    Navigator.popUntil(
                        context, ModalRoute.withName('/filterMap'));
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
        onPressed: () {
          playAudio();
        },
        child: const Icon(Icons.headset),
      ),
    );
  }
}
