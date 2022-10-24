import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}
// здесь ты добавил виджет 31 минута
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.8),
            child: Text(
              "Test your\nreaction sped",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize:38, fontWeight: FontWeight.w900, color:Colors.white),
            ),
          ),
          // серидиный видже
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: Color(0xFF6D6D6D),
              child: SizedBox(
                height: 150,
                width: 250,
                child: Center(
                  child: Text(
                    millisecondsText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize:36, fontWeight: FontWeight.w500, color:Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch(gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    gameState = GameState.canBeStopped;
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: _getButtonColor(),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: TextStyle(fontSize:38, fontWeight: FontWeight.w900, color:Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "Start";
      case GameState.waiting:
        return "Wait";
      case GameState.canBeStopped:
        return "Stop";
    }
  }

  Color _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return const Color(0xFF40CA88);
      case GameState.waiting:
        return Color(0xFFE0982D);
      case GameState.canBeStopped:
        return Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000);
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }
  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }
}
enum GameState {readyToStart, waiting, canBeStopped}