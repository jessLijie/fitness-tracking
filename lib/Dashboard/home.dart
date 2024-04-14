import 'package:fitness_tracking/Discover/discover.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Profile/profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Welcome back, ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'name',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Column(
                children: [
                  Card(
                    child: BmiCard(BMI: 22.35),
                  ),
                  Card(
                    child: CaloryCard(burnt: 100, goal: 200),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaloryCard extends StatelessWidget {
  const CaloryCard({Key? key, required this.burnt, required this.goal})
      : super(key: key);
  final int burnt;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final double progressPercent = burnt / goal;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.yellow,
            Color.fromARGB(255, 143, 231, 146),
          ],
        ),
      ),
      height: 120,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$burnt/ $goal k is burnt !"),
                  SizedBox(
                      height:
                          10), // Adding some space between text and progress indicator
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return LinearPercentIndicator(
                        barRadius: Radius.circular(6),
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2000,
                        percent: progressPercent,
                        progressColor: Colors.greenAccent,
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                left:
                    (MediaQuery.of(context).size.width - 65) * progressPercent,
                top: 40,
                child: Image.asset('assets/image/banana.png',
                    width: 35, height: 35),
              ),
              const SizedBox(height: 18),
              // Text("${(progressPercent * 100).toStringAsFixed(1)}%"),
              buildClickableText2(context),
            ],
          ),
        ),
      ),
    );
  }
}

class BmiCard extends StatelessWidget {
  const BmiCard({super.key, required this.BMI});
  final double BMI;
  final String imagePath = 'assets/image/meter.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.yellow,
            Color.fromARGB(255, 143, 231, 146),
          ],
        ),
      ),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                imagePath,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(22.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Your BMI is",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        BMI.toStringAsFixed(1),
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 18),
                      buildClickableText(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildClickableText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      child: Text(
        "View more >",
        style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 22, 53, 21)),
      ),
    );
  }
}

GestureDetector buildClickableText2(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiscoverPage()),
      );
    },
    child: Container(
      alignment: Alignment.bottomRight, // Align text to the right
      child: Text(
        "View more >",
        style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 22, 53, 21)),
        textAlign: TextAlign.right,
      ),
    ),
  );
}
