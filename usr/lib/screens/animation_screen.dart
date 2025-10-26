import 'package:flutter/material.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class AnimationScreen extends StatefulWidget {
  final String name;
  final String message;
  final String theme;

  const AnimationScreen({
    super.key,
    required this.name,
    required this.message,
    required this.theme,
  });

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;
  late AnimationController _balloonAnimationController;
  late Animation<double> _balloonAnimation;
  bool _showConfetti = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    // Text fade in animation
    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _textAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_textAnimationController);

    // Balloon floating animation
    _balloonAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _balloonAnimation =
        Tween<double>(begin: 0.0, end: 50.0).animate(_balloonAnimationController);

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _textAnimationController.forward();

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _showConfetti = true;
    });

    _balloonAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getThemeColor(widget.theme),
      body: Stack(
        children: [
          // Animated balloons in background
          ..._buildBalloons(),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated cake icon
                AnimatedBuilder(
                  animation: _balloonAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_balloonAnimation.value),
                      child: const Icon(
                        Icons.cake,
                        size: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Animated text
                FadeTransition(
                  opacity: _textAnimation,
                  child: Text(
                    'Happy Birthday\n${widget.name}!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Message
                FadeTransition(
                  opacity: _textAnimation,
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Confetti effect
          if (_showConfetti) _buildConfetti(),

          // Bottom buttons
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement video export
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Video export coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Video'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pinkAccent,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'Party':
        return Colors.purpleAccent;
      case 'Sweet':
        return Colors.pinkAccent;
      case 'Rainbow':
        return Colors.orangeAccent;
      case 'Stars':
        return Colors.indigoAccent;
      default:
        return Colors.pinkAccent;
    }
  }

  List<Widget> _buildBalloons() {
    return List.generate(5, (index) {
      return Positioned(
        left: 50.0 + (index * 60),
        top: 100.0 + (index * 40),
        child: AnimatedBuilder(
          animation: _balloonAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_balloonAnimation.value * (0.5 + index * 0.2)),
              child: Icon(
                Icons.radio_button_unchecked,
                size: 30 + index * 5,
                color: Colors.white.withOpacity(0.7),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildConfetti() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.transparent,
          child: const Center(
            child: Text(
              '🎉✨🎂🎈🎊',
              style: TextStyle(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _balloonAnimationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}