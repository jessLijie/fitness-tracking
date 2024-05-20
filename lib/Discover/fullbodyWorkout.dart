import 'package:flutter/material.dart';

class FullbodyWorkout extends StatefulWidget {
  const FullbodyWorkout({super.key});

  @override
  State<FullbodyWorkout> createState() => _FullbodyWorkoutState();
}

class _FullbodyWorkoutState extends State<FullbodyWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fullbody Workout')),
      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: Image.asset(
              "assets/image/Discover/FullBody_GIF/VCrunch.gif",
              height: 250,
              width: 250,
            ),
          ),
        ],
      )
    );
  }
}