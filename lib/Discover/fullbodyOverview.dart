import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullbodyOverview extends StatefulWidget {
  const FullbodyOverview({super.key});

  @override
  State<FullbodyOverview> createState() => _FullbodyOverviewState();
}

class _FullbodyOverviewState extends State<FullbodyOverview> {
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
                        Text("Full Body Workout", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                        Text("11 Exercises | 32mins | 320 Calories Burned", 
                          style: TextStyle(
                            color: Colors.grey
                          )
                        ),
                        SizedBox(height: 25),
                        FullBodyCard(
                          title: "VCrunch", 
                          amount: "x 15", 
                          image: "assets/image/Discover/FullBody/VCrunch.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Reverse Crunches", 
                         amount: "x 15", 
                          image: "assets/image/Discover/FullBody/ReverseCrunch.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Legs It Out", 
                          amount: "x 20", 
                          image: "assets/image/Discover/FullBody/LegsItOut.png"
                        ),  
                        SizedBox(height: 25),
                        FullBodyCard(
                          title: "Plank to Pike", 
                          amount: "x 15", 
                          image: "assets/image/Discover/FullBody/plank_to_pike.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Mountain Climbers", 
                         amount: "x 15", 
                          image: "assets/image/Discover/FullBody/mountain_climber.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Plank Leg Up", 
                          amount: "x 20", 
                          image: "assets/image/Discover/FullBody/plank_leg_up.png"
                        ), 
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Flutter Kicks", 
                          amount: "x 20", 
                          image: "assets/image/Discover/FullBody/flutter_kicks.png"
                        ),  
                        SizedBox(height: 25),
                        FullBodyCard(
                          title: "Hyper Extension Exercise", 
                          amount: "x 15", 
                          image: "assets/image/Discover/FullBody/hyper_extension_exercise.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Prone Flutter Kicks", 
                         amount: "x 15", 
                          image: "assets/image/Discover/FullBody/prone_flutter_kicks.png"
                        ),
                        SizedBox(height: 15),
                        FullBodyCard(
                          title: "Superman Exercise", 
                          amount: "x 20", 
                          image: "assets/image/Discover/FullBody/superman_exercise.png"
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
            Navigator.pushNamed(context, 'Discover/fullbodyWorkout');
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