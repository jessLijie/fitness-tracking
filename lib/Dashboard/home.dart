import 'package:fitness_tracking/Dashboard/calendar.dart';
import 'package:fitness_tracking/Discover/discover.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/services/connection.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Connection _connection = Connection();
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic> data = await _connection.getUserProfileData();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Welcome back, ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              userData['full name'] ?? 'User',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Card(
                child: BmiCard(
                  BMI: userData['bmi'] != null
                      ? double.tryParse(userData['bmi'].toStringAsFixed(2)) ?? 0.0
                      : 0.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Card(
                child: CaloryCard(burnt: 100, goal: userData['goalCal'] != null ? userData['goalCal'] as int : 0,),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Card(
                child: Calculator(
                  height: (userData['height'] ?? 0).toDouble() * 100,
                  weight: (userData['weight'] ?? 0).toDouble(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      backgroundColor: Color.fromARGB(255, 40, 138, 29),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      shadowColor: Colors.black26,
                      elevation: 4,
                    ),
                    child: Text(
                      "Workout Diary >",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 200, 230, 201),
                      ),
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

class CaloryCard extends StatefulWidget {
  final int burnt;
  final int goal;

  CaloryCard({Key? key, required this.burnt, required this.goal})
      : super(key: key);

  @override
  _CaloryCardState createState() => _CaloryCardState();
}

class _CaloryCardState extends State<CaloryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.burnt.toDouble() / widget.goal.toDouble()).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(CaloryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.burnt != widget.burnt || oldWidget.goal != widget.goal) {
      _animation = Tween<double>(begin: 0, end: widget.burnt / widget.goal).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final double progressPercent = _animation.value.clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromARGB(255, 200, 230, 201),
            Color.fromARGB(255, 200, 230, 201),
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
                  Text("${widget.burnt}/ ${widget.goal} k is burnt today!"),
                  SizedBox(height: 25),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return LinearPercentIndicator(
                        barRadius: Radius.circular(6),
                        animation: false,
                        lineHeight: 20.0,
                        percent: progressPercent,
                        progressColor: Color.fromARGB(255, 40, 138, 29),
                      );
                    },
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 10),
                curve: Curves.easeInOut,
                left: (MediaQuery.of(context).size.width - 60) * progressPercent,
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

  Widget buildClickableText2(BuildContext context) {
    return Container();
  }
}

class BmiCard extends StatelessWidget {
  BmiCard({super.key, required this.BMI});
  final double BMI;
  final String imagePath = 'assets/image/meter.png';
 
  String _getBMICategoryText(double bmi) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 200, 230, 201),
            Color.fromARGB(255, 200, 230, 201),
          ],
        ),
      ),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            Padding(
              // padding: EdgeInsets.all(10.0),
              // child: Image.asset(
              //   imagePath,
              // ),
               padding: EdgeInsets.all(10.0),
              child: AnimatedRadialGauge(
                
                duration: const Duration(seconds: 3),
                curve: Curves.elasticOut,
                radius: 100.0, 
                value: BMI,
                axis: GaugeAxis(
                  
                  min: 0,
                  max: 35, 
                  degrees: 270,
                  style: const GaugeAxisStyle(
                    thickness: 20,
                    background: Color(0xFFDFE2EC),
                    segmentSpacing: 0,
                  ),
                  pointer: GaugePointer.needle(
                    height: 66,
                    width: 10,
                    color: Color.fromARGB(225, 0, 0, 0),
                    borderRadius: 16,
                  ),
                  progressBar: GaugeProgressBar.rounded(
                    color:Colors.transparent,
                  ),
                  segments: [
                    GaugeSegment(
                      from: 0,
                      to: 18.5,
                      color: Colors.blue,
                      cornerRadius: Radius.circular(5),
                    ),
                    GaugeSegment(
                      from: 18.5,
                      to: 25,
                      color: Colors.green,
                      cornerRadius: Radius.circular(5),
                    ),
                    GaugeSegment(
                      from: 25,
                      to: 30,
                      color: Colors.orange,
                      cornerRadius: Radius.circular(5),
                    ),
                    GaugeSegment(
                      from: 30,
                      to: 35,
                      color: Colors.red,
                      cornerRadius: Radius.circular(5),
                    ),
                    
                  ],
                  
                  
                  
                )
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
                      Text(
                        "Your BMI is",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 8),
                      Text(
                        BMI.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 18),
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
  Calculator({
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
    _height = widget.height > 0.0 ? widget.height.clamp(0, 200.0) : 160.0;
    _weight = widget.weight > 0.0 ? widget.weight : 60.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 200, 230, 201),
            Color.fromARGB(255, 200, 230, 201),
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
                      Text(
                        "Result:",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${getBMIvalue(_height, _weight)}",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        "= ${_calculateBMI(_height, _weight)}",
                        style: TextStyle(fontSize: 15),
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
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 10,
                    ),
                    child: Slider(
                      value: _height,
                      min: 80,
                      max: 200,
                      onChanged: (value) {
                        setState(() {
                          _height = value;
                        });
                      },
                      divisions: 200,
                      label: "${_height.toInt()} cm",
                      activeColor: Color.fromARGB(255, 40, 138, 29),
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  Text(
                    "Weight",
                    style: TextStyle(fontSize: 16),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 10,
                    ),
                    child: Slider(
                      value: _weight,
                      min: 30,
                      max: 200,
                      onChanged: (value) {
                        setState(() {
                          _weight = value;
                        });
                      },
                      divisions: 300,
                      label: "${_weight.toInt()} kg",
                      activeColor: Color.fromARGB(255, 40, 138, 29),
                      inactiveColor: Colors.grey,
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

  String _calculateBMI(double height, double weight) {
    
    double bmi = (weight / ((height / 100) * (height / 100)));
    int bmiInt= 0;

    if (bmi.isFinite) {
      bmiInt = bmi.round();
    }

    if (bmiInt >= 18.5 && bmiInt <= 25) {
      return "Normal";
    } else if (bmiInt > 25 && bmiInt <= 30) {
      return "Overweight";
    } else if (bmiInt> 30) {
      return "Obesity";
    } else if (!bmiInt.isFinite) {
      return "Invalid bmi";
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
