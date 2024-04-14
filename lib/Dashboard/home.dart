import 'package:flutter/material.dart';

import '../Profile/profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Welcome back, ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'name',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Card(
                child: bmiCard(cardName: 'Outlined Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class bmiCard extends StatelessWidget {
  const bmiCard({required this.cardName});
  final String cardName;
  final String imagePath = 'assets/image/meter.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10.0), // Add border radius if needed
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.yellow,
            Color.fromARGB(255, 143, 231, 146)
          ], // Define your gradient colors
        ),
      ),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0), // Add margin to the image
              child: Image.asset(
                imagePath,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(22.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Your BMI is",
                        style: TextStyle(fontSize: 18),

                      ),
                      SizedBox(height: 8),
                      Text(
                        "22.5",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 18),
                      buildClickableText(context), 

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 GestureDetector buildClickableText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      child: Text(
        "View more >",
        style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 22, 53, 21)),
      ),
    );
  }
