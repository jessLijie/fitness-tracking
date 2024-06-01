import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullbodyWorkout extends StatefulWidget {
  const FullbodyWorkout({super.key});

  @override
  State<FullbodyWorkout> createState() => _FullbodyWorkoutState();
}

class _FullbodyWorkoutState extends State<FullbodyWorkout> {

  Color color = const Color.fromRGBO(239, 255, 224, 1.0);
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
              Navigator.pop(context);
              timerProvider.resetTimer();
            }
          ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Image.asset(
              "assets/image/Discover/FullBody_GIF/VCrunch.gif",
              height: 250,
              width: 250,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "VCrunch",
            style: TextStyle(
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
                    
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: color,
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
            
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: color,
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