import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:safe_streets/router.dart';

class IActiveCallPageProps {
  final String name;
  final Duration duration;
  // final String audioFilePath;

  const IActiveCallPageProps({
    required this.name,
    required this.duration,
    // required this.audioFilePath,
  });
}

class ActiveCallPage extends StatelessWidget implements IActiveCallPageProps {
  @override
  final String name;
  @override
  final Duration duration;
  // final String audioFilePath;

  const ActiveCallPage({
    Key? key,
    required this.name,
    required this.duration,
    // required this.audioFilePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();

    void playAudio() async {
      //await audioPlayer.play(AssetSource(audioFilePath));
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
            // const CircleAvatar(
            //   radius: 80,
            //   backgroundImage:
            //       AssetImage('assets/fake_call/profile_picture.png'),
            // ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Call Duration: ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
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
                    // Close all widgets until the map
                    AppRouter.popUntil(context, AppRoutes.map);
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
