import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: const Workout(),
    );
  }
}

class Workout extends StatelessWidget {
  const Workout({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          WorkoutCard(
            title: "Full Body Workout", 
            description: "11 Exercises | 32 mins", 
            image:  "assets/image/Discover/full_body.png"
          ), 
          SizedBox(height: 30),
           WorkoutCard(
            title: "Lower Body Workout", 
            description: "12 Exercises | 40 mins", 
            image: "assets/image/Discover/lowerbody.png"
          ), 
          SizedBox(height: 30),
          WorkoutCard(
            title: "ABS Body Workout", 
            description: "14 Exercises | 20 mins", 
            image: "assets/image/Discover/abs.png"
          ),          
        ],
      ),
    );
  }
}


class WorkoutCard extends StatelessWidget {
  final String title, description, image;

  const WorkoutCard({super.key, required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 160,
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.green[100], 
          borderRadius: BorderRadius.circular(10)),
       child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(title, 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)
                ),
                const SizedBox(height: 5),
                Text (description, 
                  style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12),
                ),
                const SizedBox(height: 17),
                Container(
                  height: 35,
                  width: 120,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text("Start Now !"))
                )
              ],
            ),
            const SizedBox(width: 72),
              Stack(
                children: [
                ClipOval(
                  child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Colors.white
                  )),
                ),
                Positioned(
                  child: Image.asset(
                  image,
                  height: 100,
                  width: 95,
                  fit: BoxFit.scaleDown,
                  ),
                )
              ]
            )
          ],
        )
      ),
    );         
  }
}
