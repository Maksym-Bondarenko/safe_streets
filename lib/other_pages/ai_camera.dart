import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

class AiCameraPage extends StatefulWidget {
  const AiCameraPage({super.key});

  @override
  _AiCameraPageState createState() => _AiCameraPageState();
}

class _AiCameraPageState extends State<AiCameraPage> {
  late CameraController _cameraController;
  Future<void>? _cameraInitializationFuture = null;
  bool _isRecording = false;
  bool _isDisposed = false;
  Position? startPosition;
  Position? endPosition;

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );

    _cameraInitializationFuture = _cameraController.initialize().then((_) {
      setState(() {}); // Trigger a rebuild after initialization
    }).catchError((error) {
      print('Error initializing camera: $error');
    });

    // Start geolocation tracking
    _startGeolocationTracking();
  }

  Future<void> _startGeolocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied
      return;
    }

    if (permission == LocationPermission.denied) {
      // Location permissions are denied, request permissions
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permissions are not granted
        return;
      }
    }

    // Start tracking geolocation
    geolocator.getPositionStream().listen((Position position) {
      if (_isDisposed)
        return; // to fix the error when disposed when animation/processes still occur
      setState(() {
        startPosition ??= position;
        endPosition = position;
      });
    });
  }

  void _stopGeolocationTracking() {
    setState(() {
      startPosition = null;
      endPosition = null;
    });
  }

  Future<void> _capturePhoto() async {
    try {
      await _cameraInitializationFuture;

      final XFile photoFile = await _cameraController.takePicture();

      _showConfirmationDialog(photoFile.path);
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    if (_cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      startPosition = await geolocator.getCurrentPosition();
      setState(() {
        _isRecording = true;
      });

      _cameraController.startVideoRecording().then((_) {
        // Video recording started successfully
      }).catchError((error) {
        print('Error starting video recording: $error');
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await _cameraController.stopVideoRecording();

      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  void _showConfirmationDialog(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to store this file?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Store the file
                _storeFile(filePath);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _storeFile(String filePath) {
    // Implement file storage logic here
    print('File stored: $filePath');
  }

  @override
  void dispose() {
    _isDisposed = true;
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Camera')),
      body: FutureBuilder<void>(
        future: _cameraInitializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _cameraController.value.aspectRatio,
                        child: CameraPreview(_cameraController),
                      ),
                      if (_isRecording)
                        const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.red,
                          size: 60,
                        ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_camera),
                        color: Colors.white,
                        onPressed: _capturePhoto,
                      ),
                      IconButton(
                        icon: Icon(
                          _isRecording ? Icons.stop : Icons.videocam,
                          color: _isRecording ? Colors.red : Colors.white,
                        ),
                        onPressed: _isRecording
                            ? _stopVideoRecording
                            : _startVideoRecording,
                      ),
                      IconButton(
                        icon: const Icon(Icons.flash_on),
                        color: Colors.white,
                        onPressed: () {
                          // Toggle flashlight
                          // Implement flashlight logic here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () {
                          // Stop geolocation tracking before closing the page
                          _stopGeolocationTracking();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
