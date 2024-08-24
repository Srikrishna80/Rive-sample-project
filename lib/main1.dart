import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rive/rive.dart';

void main() {
  unawaited(RiveFile.initialize());
  runApp(
    MaterialApp(
      title: 'Rive Example',
      home: TalkingAvatar(),
      themeMode: ThemeMode.dark,
    ),
  );
}

class TalkingAvatar extends StatefulWidget {
  const TalkingAvatar({super.key});

  @override
  _TalkingAvatarState createState() => _TalkingAvatarState();
}

class _TalkingAvatarState extends State<TalkingAvatar> {
  late RiveAnimationController _talkController;
  late RiveAnimationController _hearController;
  late RiveAnimationController _successController;
  late RiveAnimationController _failController;
  late RiveAnimationController _hearStopController;
  late RiveAnimationController _handsUpController;
  late RiveAnimationController _waveController;
  late RiveAnimationController _looksDownRightController;
  late RiveAnimationController _looksDownLeftController;
  late RiveAnimationController _initialStageController;

  final FlutterTts _flutterTts = FlutterTts();
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _talkController = SimpleAnimation('Talk', autoplay: false);
    _hearController = SimpleAnimation('hands_hear_start', autoplay: false);
    _hearStopController = SimpleAnimation('hands_hear_stop', autoplay: true);
    _successController = SimpleAnimation('success', autoplay: false);
    _failController = SimpleAnimation('fail', autoplay: false);
    _handsUpController = SimpleAnimation('hands_up', autoplay: false);
    _waveController = SimpleAnimation('wave', autoplay: false);
    _looksDownLeftController =
        SimpleAnimation('Look_down_left', autoplay: false);
    _looksDownRightController =
        SimpleAnimation('Look_down_right', autoplay: false);
    _initialStageController = SimpleAnimation('look_idle', autoplay: false);

    // Trigger wave animation when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation(_waveController);
    });
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _startAnimation(RiveAnimationController controller) {
    // Stop any ongoing animation
    _stopCurrentAnimation();

    // Start the new animation
    _toggleAnimation(controller);

    // Set a timer to stop the animation after 1 minute
    _animationTimer = Timer(const Duration(minutes: 1), () {
      _disposeController(controller);
    });
  }

  void _stopCurrentAnimation() {
    // Cancel any ongoing animation timer
    _animationTimer?.cancel();

    // Stop all animations
    _disposeController(_talkController);
    _disposeController(_hearController);
    _disposeController(_successController);
    _disposeController(_failController);
    _disposeController(_hearStopController);
    _disposeController(_handsUpController);
    _disposeController(_waveController);
    _disposeController(_looksDownRightController);
    _disposeController(_looksDownLeftController);
    _disposeController(_initialStageController);
  }

  Future<void> _speak(String text) async {
    unawaited(RiveFile.initialize());
    _startAnimation(_talkController); // Start the talking animation
    await _flutterTts.speak(text);
  }

  void _toggleAnimation(RiveAnimationController controller) {
    setState(() {
      controller.isActive = true;
    });
  }

  void _disposeController(RiveAnimationController controller) {
    setState(() {
      controller.isActive = false;
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talking Avatar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _speak('Hello, how are you?'),
              child: SizedBox(
                height: 500, // Set the desired height
                width: 500, // Set the desired width
                child: RiveAnimation.asset(
                  'assets/avatar.riv',
                  controllers: [
                    _talkController,
                    _hearController,
                    _successController,
                    _failController,
                    _hearStopController,
                    _handsUpController,
                    _waveController,
                    _looksDownRightController,
                    _looksDownLeftController,
                    _initialStageController
                  ],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                _startAnimation(_hearController);
              },
              child: const Text('Hear'),
            ),
            ElevatedButton(
              onPressed: () => _speak('Hello, how are you?'),
              child: const Text('Talk'),
            ),
            ElevatedButton(
              onPressed: () {
                _startAnimation(_successController);
              },
              child: const Text('Success'),
            ),
            ElevatedButton(
              onPressed: () {
                _startAnimation(_failController);
              },
              child: const Text('Fail'),
            ),
          ],
        ),
      ),
    );
  }
}
