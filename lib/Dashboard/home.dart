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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0), // Add vertical margin between cards
                    child: Card(
                      child: BmiCard(BMI: 22.35),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0), // Add vertical margin between cards
                    child: Card(
                      child: CaloryCard(burnt: 50, goal: 200),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0), // Add vertical margin between cards
                    child: Card(
                      child: Calculator(height: 175, weight: 60),
                    ),
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
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$burnt/ $goal k is burnt !"),
                  SizedBox(height: 25),
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
              AnimatedPositioned(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
                left:
                    (MediaQuery.of(context).size.width - 65) * progressPercent,
                top: 50,
                child: Image.asset(
                  'assets/image/banana.png',
                  width: 35,
                  height: 35,
                ),
              ),
              Positioned(
                child: buildClickableText2(context),
              ),
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

class Calculator extends StatefulWidget {
  const Calculator({
    Key? key,
    required this.height,
    required this.weight,
  }) : super(key: key);

  final double height;
  final double weight;

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  late double _height;
  late double _weight;

  @override
  void initState() {
    super.initState();
    _height = widget.height;
    _weight = widget.weight;
  }

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
                        "Result:",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${_calculateBMI(_height, _weight)}",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        "~${getBMIvalue(_height, _weight)}",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Height",
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: _height,
                    min: 80,
                    max: 200,
                    onChanged: (value) {
                      setState(() {
                        _height = value;
                      });
                    },
                    divisions: 200,
                    label: "$_height cm",
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                  Text(
                    "Weight",
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: _weight,
                    min: 30,
                    max: 300,
                    onChanged: (value) {
                      setState(() {
                        _weight = value;
                      });
                    },
                    divisions: 300,
                    label: "$_weight kg",
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateBMI(double height, double weight) {
    int bmi = (weight / ((height / 100) * (height / 100))).round().toInt();
    if (bmi >= 18.5 && bmi <= 25) {
      return "Normal";
    } else if (bmi > 25 && bmi <= 30) {
      return "Overweight";
    } else if (bmi > 30) {
      return "Obesity";
    } else {
      return "Underweight";
    }
  }

  double getBMIvalue(double height, double weight) {
    double bmi = (weight / ((height / 100) * (height / 100)));
     return double.parse(bmi.toStringAsFixed(2));
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
      alignment: Alignment.bottomRight,
      child: Text(
        "View more >",
        style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 22, 53, 21)),
        textAlign: TextAlign.right,
      ),
    ),
  );
}
