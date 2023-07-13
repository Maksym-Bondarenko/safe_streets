import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';

class SOSWidget extends StatefulWidget {
  const SOSWidget({Key? key}) : super(key: key);

  @override
  _SOSWidgetState createState() => _SOSWidgetState();
}

class _SOSWidgetState extends State<SOSWidget>
    with SingleTickerProviderStateMixin {

  bool _alarmIsOn = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final audioPlayer = AudioPlayer();
  final audioFilePath = "audio/sos.wav";


  void playAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setVolume(1.0);
    await audioPlayer.play(AssetSource(audioFilePath));
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }

  // signaling via phone-torch for attention
  void _startSignaling() async {
    while (_alarmIsOn) {
      await TorchLight.enableTorch();  // Turn on the torch
      await Future.delayed(const Duration(milliseconds: 500)); // Wait for 0.5 seconds
      await TorchLight.disableTorch(); // Turn off the torch
      await Future.delayed(const Duration(milliseconds: 500)); // Wait for 0.5 seconds
    }
  }

  void _stopAudioLightAndReturn() {
    setState(() {
      _alarmIsOn = false;
    });
    stopAudio();
    TorchLight.disableTorch();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _alarmIsOn= true;
    });
    playAudio();
    _startSignaling();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    stopAudio();
    TorchLight.disableTorch();
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
                      onPressed: _stopAudioLightAndReturn,
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
