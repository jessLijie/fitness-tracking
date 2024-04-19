import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: const WorkoutCard(),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const Text(
          //   "What Do You Want to Train",
          //   textAlign: TextAlign.start,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold
          //   ),),
          Center(
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
                      const Text("Full Body Workout", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15)
                      ),
                      const SizedBox(height: 5),
                      const Text ("11 Exercises | 32 mins", 
                      style: TextStyle(
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
                  const SizedBox(width: 70),
                  Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          )),
                      ),
                      Positioned(
                        child: Image.asset(
                          "assets/image/full_body.png",
                          height: 200,
                          width: 100,
                        ),
                      )
                    ]
                  )
                ],
              ),),
          )
        ],
      ),
    );
  }
}
