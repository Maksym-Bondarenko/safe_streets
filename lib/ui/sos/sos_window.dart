import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SOSWidget extends StatefulWidget {
  const SOSWidget({Key? key}) : super(key: key);

  @override
  _SOSWidgetState createState() => _SOSWidgetState();
}

class _SOSWidgetState extends State<SOSWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final audioPlayer = AudioPlayer();
  final audioFilePath = "audio/sos.wav";

  // bool _isFlashOn = false;

  void playAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setVolume(1.0);
    await audioPlayer.play(AssetSource(audioFilePath));
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }

  // TODO: find a solution to access the flashlight (torch)
  // Future<void> _toggleFlashlight() async {
  //   if (_isFlashOn) {
  //     // Torch.turnOff();
  //   } else {
  //     // Torch.turnOn();
  //   }
  //
  //   setState(() {
  //     _isFlashOn = !_isFlashOn;
  //   });
  // }

  void _stopAudioAndReturn() {
    stopAudio();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    playAudio();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // _toggleFlashlight();
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Container(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red, size: 50),
                      onPressed: _stopAudioAndReturn,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Transform.scale(
                    scale: _animation.value,
                    child: const Icon(
                      Icons.error_outline,
                      size: 200,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Attention !!!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
