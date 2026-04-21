import 'dart:async';
import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Timer? _timer;
  int _secondsLeft = 4;
  String _breathText = "Ready";
  bool _isRunning = false;

  final List<Map<String, dynamic>> _steps = [
    {"text": "Inhale", "seconds": 4},
    {"text": "Hold", "seconds": 4},
    {"text": "Exhale", "seconds": 4},
  ];

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(
      begin: 150,
      end: 250,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _setStep(0);
  }

  void _setStep(int stepIndex) {
    final step = _steps[stepIndex];

    setState(() {
      _currentStep = stepIndex;
      _breathText = step["text"];
      _secondsLeft = step["seconds"];
    });

    if (_breathText == "Inhale") {
      _controller.forward();
    } else if (_breathText == "Exhale") {
      _controller.reverse();
    }
  }

  void _startBreathing() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _setStep(0);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        int nextStep = (_currentStep + 1) % _steps.length;
        _setStep(nextStep);
      }
    });
  }

  void _stopBreathing() {
    _timer?.cancel();
    _controller.reset();

    setState(() {
      _isRunning = false;
      _breathText = "Ready";
      _secondsLeft = 4;
      _currentStep = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathing Exercise"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: _animation.value,
                    height: _animation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _breathText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                "$_secondsLeft",
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isRunning ? _stopBreathing : _startBreathing,
                child: Text(_isRunning ? "Stop" : "Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}