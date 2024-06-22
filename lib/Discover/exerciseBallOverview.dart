import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:fitness_tracking/data/model/dumbbell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseBallOverview extends StatefulWidget {
  const ExerciseBallOverview({super.key});

  @override
  State<ExerciseBallOverview> createState() => _ExerciseBallOverviewState();
}

class _ExerciseBallOverviewState extends State<ExerciseBallOverview> {
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
                    'assets/image/Discover/Dumbbell_bg.png', 
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
                        Text("Exercise Ball Workout", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                        Text("12 Exercises | 15 mins | 320 Calories Burned", 
                          style: TextStyle(
                            color: Colors.grey
                          )
                        ),
                        SizedBox(height: 25),
                        FullBodyCard(
                          title: "Dumbbell Punch", 
                          amount: "x 25", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Punch.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Squat Clean and Press", 
                         amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Squat.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Rear Delt Row", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Rear Delt.png"
                        ),  
                        SizedBox(height: 25),
                        FullBodyCard(
                          title: "Dumbbell Lunges", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Lunges.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Crunch and Punches", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Crunch and Punches.png"
                        ), 
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Kickbacks", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Kickback.png"
                        ),  
                        SizedBox(height: 25),
                        FullBodyCard(
                          title: "Dumbbell Triceps Extension", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Tricep Extension.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbell Decline Floor Press", 
                         amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Decline Floor Press.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Plie Squat", 
                          amount: "x 20", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Plie Squat.png"
                        ), 
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Donkey Kicks", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Donkey KIcks.png"
                        ),   
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Torrture Tucks", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Torrture Tucks.png"
                        ),    
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Dumbbell Hip Hinge", 
                          amount: "x 15", 
                          image: "assets/image/Discover/Dumbbell/Dumbell Hip Hinge.png"
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
              '/exerciseBallWorkout',
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

class FullBodyCard extends StatelessWidget {
  final String title, amount, image;

  const FullBodyCard({ Key? key, required this.title, required this.amount, required this.image})
    :super(key: key);
  
  @override
  
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        // Navigator.pushNamed(context, route);
      },
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