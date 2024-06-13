import 'package:flutter/material.dart';

class Reminder {
  int id;
  String title;
  String description;
  TimeOfDay time;

  Reminder({required this.id, required this.title, required this.description, required this.time});
}
