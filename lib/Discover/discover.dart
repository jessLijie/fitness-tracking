import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discover'),
          bottom: TabBar(
            indicatorColor: Colors.green[500],
            labelColor: Colors.black ,
            tabs: const [
              Tab(text: 'Beginner'),
              Tab(text: 'With Equipment'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Workout(), 
            WithEquipment(), 
          ],
        ),
      ),
    );
  }
}

class Workout extends StatelessWidget {
  const Workout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          WorkoutCard(
            title: "Full Body Workout",
            description: "11 Exercises | 32 mins",
            image: "assets/image/Discover/full_body.png",
            route: '/fullbodyOverview',
          ),
          SizedBox(height: 30),
          WorkoutCard(
            title: "Lower Body Workout",
            description: "10 Exercises | 40 mins",
            image: "assets/image/Discover/lowerbody.png",
            route: '/lowerbodyOverview',
          ),
          SizedBox(height: 30),
          WorkoutCard(
            title: "ABS Body Workout",
            description: "14 Exercises | 20 mins",
            image: "assets/image/Discover/abs.png",
            route: '/absOverview',
          ),
        ],
      ),
    );
  }
}

class WithEquipment extends StatelessWidget {
  const WithEquipment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          WorkoutCard(
            title: "Dumbbell Workout",
            description: "12 Exercises | 15 mins",
            image: "assets/image/Discover/Dumbbell.png",
            route: '/dumbbellOverview',
          ),
          SizedBox(height: 30),
          WorkoutCard(
            title: "Exercise Ball Workout",
            description: "12 Exercises | 30 mins",
            image: "assets/image/Discover/ExerciseBall.png",
            route: '/dumbbellOverview',
          ),
        ],
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title, description, image, route;

  const WorkoutCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromRGBO(239, 255, 224, 1.0);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Center(
        child: Container(
            height: 160,
            width: MediaQuery.of(context).size.width - 30,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 5),
                    Text(description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        )),
                    const SizedBox(height: 17),
                    Container(
                        height: 35,
                        width: 120,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text("Start Now !")))
                  ],
                ),
                const SizedBox(width: 72),
                Stack(
                  children: [
                    ClipOval(
                      child: Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(color: Colors.white)),
                    ),
                    Positioned(
                      child: Image.asset(
                        image,
                        height: 100,
                        width: 95,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
