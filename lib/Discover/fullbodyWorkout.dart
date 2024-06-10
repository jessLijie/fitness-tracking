import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:fitness_tracking/data/model/fullbody.dart';
import 'package:fitness_tracking/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FullbodyWorkout extends StatefulWidget {
  // final Fullbody fullbodyWorkout;
  final List<Fullbody> fullbodyWorkout;
  int currentIndex;

  FullbodyWorkout({
    Key? key,
    required this.fullbodyWorkout,
    required this.currentIndex
    }):super(key: key);

  @override
  State<FullbodyWorkout> createState() => _FullbodyWorkoutState();
}

class _FullbodyWorkoutState extends State<FullbodyWorkout> {

  Color green = const Color.fromRGBO(239, 255, 224, 1.0);
  bool isPaused = false;
  
  @override
  Widget build(BuildContext context) {
    final TimerProvider timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fullbody Workout'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back),
            onPressed:(){
              _showConfirmationDialog(context, widget.currentIndex);
            }
          ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Image.asset(
              widget.fullbodyWorkout[widget.currentIndex].gif,
              height: 250,
              width: 250,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            widget.fullbodyWorkout[widget.currentIndex].name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('${timerProvider.getSeconds.toString()}:00' , 
            style: const TextStyle(
              fontSize: 45, 
              fontWeight: FontWeight.bold,
              )
          ),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: (){
              setState((){
                if(isPaused){
                  timerProvider.resumeTimer();
                }else{
                  timerProvider.pauseTimer();
                }

                // toggle the value of isPaused (if tap, false to true)
                isPaused = !isPaused;
              });      
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width*0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isPaused ? Colors.green[300] : Colors.white,
                border: !isPaused ? 
                    Border.all(
                    color: Colors.green[300]!,
                    width: 2,
                  ):null
              ),
              child: Center(
                child: Text(
                  isPaused ? "Resume " : "|| Pause",
                  style: TextStyle(
                    fontSize: 20,
                    color: isPaused ? Colors.white: Colors.green[300],
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    timerProvider.resetTimer();
                    timerProvider.startTimer();
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: green,
                    ),
                    child: const Center(
                      child: Text(
                        "Previous",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: (){
                    int nextIndex = widget.currentIndex + 1 ;
                    if (nextIndex < widget.fullbodyWorkout.length) {
                      Navigator.pushNamed(
                        context, 
                        'Discover/fullbodyWorkout',
                        arguments: {
                          'workouts': widget.fullbodyWorkout,
                          'currentIndex': nextIndex,
                        }
                      );
                      timerProvider.resetTimer();
                      timerProvider.startTimer();
                    }else{

                    }             
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: green,
                    ),
                    child: const Center(
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ),
                ) 
              ],
            ),
          ),
        ],
      )
    );
    
  }  
}

 void sendCaloriesToFirebase(int totalCaloriesBurned) async {
  User? user = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService = DatabaseService();

  if (user != null) {
    Map<String, dynamic> userData = await _databaseService.getUserProfileData(user.uid);
    String uid = user.uid;

    // send the total calories burned to firebase
    await FirebaseFirestore.instance.collection('workout').add({
      'caloriesBurned': totalCaloriesBurned,
      'userid' : uid
    });
  }
}



  void _showConfirmationDialog(BuildContext context, int currentIndex) {

    // to calculate the total calories burned
    int totalCaloriesBurned = 0;
    final int kcalPerSet = 100;

    for(int i = 0; i< currentIndex+1; i++){
      totalCaloriesBurned +=  kcalPerSet;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text('Are you sure you want to go back? You have burned ${totalCaloriesBurned} kcal.'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', 
                style: TextStyle(
                  color: Colors. black
                )),
            ),
            TextButton(
              onPressed: () {
                sendCaloriesToFirebase(totalCaloriesBurned); // Send the total calories burned to firebase

                // Navigator.push(
                //   context, MaterialPageRoute(
                //     builder: (context) => const FullbodyOverview(), 
                //     settings: const RouteSettings(name: "Discover/fullbodyOverview")
                //   )
                // );

                Navigator.popUntil(context, (route) => route.settings.name == "Discover/fullbodyOverview");
              },
              child: Text('Confirm', 
                style: TextStyle(
                  color: Colors.green[500]
                )),
            ),
          ],
        );
      },
    );
  }
