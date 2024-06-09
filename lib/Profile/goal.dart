import 'package:card_swiper/card_swiper.dart';
import 'package:fitness_tracking/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracking/main.dart';
import 'package:fitness_tracking/services/auth.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FFE0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50), // Adjust the height here
          Text(
            'What is your goal?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'We will help you to choose a best program',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: SwiperWidget(),
          ),
        ],
      ),
    );
  }
}

class SwiperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            // Get the selected goal text
            String selectedGoal = textMap[index]!;
            // Update goal in Firestore
            await AuthService().updateGoal(selectedGoal, context);
          },
          child: GoalCard(index: index),
        );
      },
      layout: SwiperLayout.STACK,
      itemWidth: MediaQuery.of(context).size.width * 0.7,
      itemHeight: MediaQuery.of(context).size.height * 0.7, // Adjust the height here
      loop: false,
    );
  }
}

class GoalCard extends StatelessWidget {
  final int index;

  const GoalCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            // Use Image.asset to display images from assets
            child: Image.asset(
              imageMap[index]!, // Access image path from the map
              width: 150, // Adjust the width of the image
              height: 280, // Adjust the height of the image
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            textMap[index]!, // Access text from the map
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
