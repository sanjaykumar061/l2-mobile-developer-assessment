import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BalloonPopGame(),
    );
  }
}

class BalloonPopGame extends StatefulWidget {
  @override
  _BalloonPopGameState createState() => _BalloonPopGameState();
}

class _BalloonPopGameState extends State<BalloonPopGame> {
  int score = 0;
  int missed = 0;
  Timer? timer; // Nullable timer
  int timeLeft = 120; // 2 minutes
  List<Offset> balloons = [];

  @override
  void initState() {
    super.initState();
    timer = startTimer(); // Initialize the timer
    generateBalloons();
  }

  Timer startTimer() {
    return Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          t.cancel();
          endGame();
        }
      });
    });
  }

  void generateBalloons() {
    Random random = Random();
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (timeLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        double x = random.nextDouble() * 300; // Random x position
        balloons.add(Offset(x, 600)); // Start balloons from the bottom
      });
    });
  }

  void endGame() {
    // Display game over screen
  }

  void popBalloon(Offset balloon) {
    setState(() {
      for (int i = 0; i < balloons.length; i++) {
        double distance = (balloon - balloons[i]).distance;
        if (distance < 50) {
          balloons.removeAt(i);
          score += 2;
          return;
        }
      }
      missed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balloon Pop Game'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Time Left: ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Score: $score | Missed: $missed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          for (var balloon in balloons)
            Positioned(
              top: balloon.dy,
              left: balloon.dx,
              child: GestureDetector(
                onTap: () => popBalloon(balloon),
                child: Image.asset(
                  'assets/balloon.png',
                  width: 50,
                  height: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
