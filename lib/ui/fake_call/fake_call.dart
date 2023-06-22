import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'call_screen.dart';

class FakeCallWidget extends StatefulWidget {
  final String callerName;

  const FakeCallWidget({Key? key, required this.callerName}) : super(key: key);

  @override
  _FakeCallWidgetState createState() => _FakeCallWidgetState();
}

class _FakeCallWidgetState extends State<FakeCallWidget> with SingleTickerProviderStateMixin {
  final player = AudioPlayer();
  final audioSourcePath = "audio/beep.wav";
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    playAudio();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Zoom-in and zoom-out animation for the image
    _imageAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation for the icons
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    stopAudio();
    _animationController.dispose();
    super.dispose();
  }

  void playAudio() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource(audioSourcePath));
  }

  void stopAudio() async {
    await player.stop();
  }

  void acceptCall() {
    stopAudio();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          callerName: widget.callerName,
          audioFilePath: 'audio/spoken_language.mp3',
        ),
      ),
    );
  }

  void rejectCall() {
    stopAudio();
    Navigator.pop(context);
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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _imageAnimation.value,
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    AssetImage('lib/assets/fake_call/profile_picture.png'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              widget.callerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _iconAnimation.value * 0.2 * math.pi, // Adjust the rotation angle as needed
                      child: IconButton(
                        icon: const Icon(
                          Icons.call_end,
                          color: Colors.red,
                          size: 32,
                        ),
                        onPressed: rejectCall,
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: -_iconAnimation.value * 0.2 * math.pi, // Adjust the rotation angle as needed
                      child: IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                          size: 32,
                        ),
                        onPressed: acceptCall,
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
