import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Elevator_1_left extends StatefulWidget {
  const Elevator_1_left({super.key});

  @override
  State<Elevator_1_left> createState() => _Elevator_1_leftState();
}

class _Elevator_1_leftState extends State<Elevator_1_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("오른쪽 화면에 나오는 엘리베이터 호출 버튼을 눌러보세요", "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/common/elevator.png"),
        fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Elevator_1_right extends StatefulWidget {
  const Elevator_1_right({super.key});

  @override
  State<Elevator_1_right> createState() => _Elevator_1_rightState();
}

class _Elevator_1_rightState extends State<Elevator_1_right> {
  SMITrigger? _touch_down;
  SMITrigger? _touch_up;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _touch_down =
          controller.findInput<SMITrigger>('touch_down') as SMITrigger?;
      _touch_up = controller.findInput<SMITrigger>('touch_up') as SMITrigger?;
    }
  }

  void _hitBumpDown() {
    _touch_down?.fire();
    print("Touch Down TRIGGERED!");
  }

  void _hitBumpUp() {
    _touch_up?.fire();
    print("Touch Up TRIGGERED!");
  }

  void _onStateChange(String stateMachineName, String stateName) {
    if (stateName == 'exit') {
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTapDown: (_) => _hitBumpDown(),
          onTapUp: (_) => _hitBumpUp(),
          child: RiveAnimation.asset(
            "assets/elevator_button.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}