import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:fitness_tracking/data/model/lowerbody.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LowerbodyOverview extends StatefulWidget {
  const  LowerbodyOverview({super.key});

  @override
  State< LowerbodyOverview> createState() => _LowerbodyOverviewState();
}

class _LowerbodyOverviewState extends State<LowerbodyOverview> {
  @override
  Widget build(BuildContext context) {
    final TimerProvider timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300, 
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/image/Discover/full_body_bg.png', 
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Text("Lower Body Workout", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                        Text("9 Exercises | 10 mins | 220 Calories Burned", 
                          style: TextStyle(
                            color: Colors.grey
                          )
                        ),
                        SizedBox(height: 25),
                        LowerbodyCard(
                          title: "Squats",   
                          amount: "x 15", 
                          image: "assets/image/Discover/Lowerbody/Squats.png"
                        ),
                        SizedBox(height: 15),
                        LowerbodyCard(
                          title: "Side Leg Raises", 
                         amount: "x 20", 
                          image: "assets/image/Discover/Lowerbody/workout.png"
                        ),
                        SizedBox(height: 15),
                        LowerbodyCard(
                          title: "Squat Jumps", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Lowerbody/Squat Jumps.png"
                        ),  
                        SizedBox(height: 25),
                        LowerbodyCard(
                          title: "Bicycle Crunches", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Lowerbody/Bicycle Crunches.png"
                        ),
                        SizedBox(height: 15),
                        LowerbodyCard(
                          title: "Crunches", 
                         amount: "x 15", 
                          image: "assets/image/Discover/Lowerbody/Crunches.png"
                        ),
                        SizedBox(height: 15),
                        LowerbodyCard(
                          title: "Curtsy Lunges", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Lowerbody/Curtsy Lunges.png"
                        ), 
                        SizedBox(height: 15),
                        LowerbodyCard(
                          title: "Plie Squats", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Lowerbody/Plie Squats.png"
                        ),  
                        SizedBox(height: 25),
                       LowerbodyCard(
                          title: "Side Lunges", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Lowerbody/Side Lunges.png"
                        ),
                        SizedBox(height: 15),
                        LowerbodyCard(
                          title: "Sit Ups", 
                         amount: "x 15", 
                          image: "assets/image/Discover/Lowerbody/Sit Ups.png"
                        ),  
                        SizedBox(height: 80),                                                                              
                      ],
                    ),
                    ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, 
            left: 15, 
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Set the desired width
        child: FloatingActionButton.extended(
          onPressed: () {
            int initialIndex = 0;
            Navigator.pushNamed(
              context, 
              '/lowerbodyWorkout',
              arguments: {
                'workouts': workouts,
                'currentIndex': initialIndex,
              });
              timerProvider.startTimer();
          },
          backgroundColor: Colors.green[300],
          label: const Text(
            "Start Workout",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class LowerbodyCard extends StatelessWidget {
  final String title, amount, image;

  const LowerbodyCard({ Key? key, required this.title, required this.amount, required this.image})
    :super(key: key);
  
  @override
  
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green[100]!,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(amount, 
                style: const TextStyle(
                  color: Colors.grey,
                  )
              )
            ]
          ),     
        ]
      )
    );         
  }
}