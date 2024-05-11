import 'package:flutter/material.dart';

class Fullbody extends StatefulWidget {
  const Fullbody({super.key});

  @override
  State<Fullbody> createState() => _FullbodyState();
}

class _FullbodyState extends State<Fullbody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Text("testing"), 
        ]
      )
    );
  }
}