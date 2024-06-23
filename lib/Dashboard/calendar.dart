import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Dashboard/progressbar.dart';
import 'package:fitness_tracking/services/connection.dart';
import 'package:flutter/material.dart';

class Activity {
  final String name;
  final int sets;
  final int caloriesBurnt;

  Activity({
    required this.name,
    required this.sets,
    required this.caloriesBurnt,
  });
}

// class MockData {
//   static final Map<DateTime, List<Activity>> activities = {
//     DateTime(2024, 5, 16): [
//       Activity(name: 'Yoga', sets: 2, caloriesBurnt: 15),
//       Activity(name: 'Stretching', sets: 1, caloriesBurnt: 7),
//     ],
//     DateTime(2024, 5, 17): [
//       Activity(name: 'Yoga', sets: 1, caloriesBurnt: 10),
//       Activity(name: 'Walking', sets: 1, caloriesBurnt: 5),
//       Activity(name: 'Stretching', sets: 1, caloriesBurnt: 7),
//     ],
//     DateTime(2024, 5, 18): [
//       Activity(name: 'Yoga', sets: 2, caloriesBurnt: 10),
//       Activity(name: 'Walking', sets: 1, caloriesBurnt: 5),
//     ],
//     DateTime(2024, 5, 19): [
//       Activity(name: 'Yoga', sets: 2, caloriesBurnt: 10),
//       Activity(name: 'Swim', sets: 1, caloriesBurnt: 5),
//     ],
//     DateTime(2024, 5, 20): [
//       Activity(name: 'Gym', sets: 5, caloriesBurnt: 5),
//     ],

//   };
// }

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Connection _connection = Connection();

  Map<String, dynamic> userData = {};
  int totalCaloriesBurnt = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTotalCaloriesBurnt();
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic> data = await _connection.getUserProfileData();
    setState(() {
      userData = data;
    });
  }

  Future<void> _fetchTotalCaloriesBurnt() async {
    int totalCalories = await getTotalCaloriesBurned(_selectedDate) ?? 0;
    setState(() {
      totalCaloriesBurnt = totalCalories;
    });
  }

  List<DateTime> _generateDisabledDates(int days) {
    List<DateTime> disabledDates = [];
    DateTime currentDate = DateTime.now().add(Duration(days: 1)); // Start from tomorrow
    for (int i = 0; i < days; i++) {
      disabledDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return disabledDates;
  }

  final EasyInfiniteDateTimelineController _controller = EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Welcome back, ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              userData['full name'] ?? 'User',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                disabledDates: _generateDisabledDates(36525),
                onDateChange: (selectedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                  _fetchTotalCaloriesBurnt();
                },
                activeColor: const Color(0xff85A389),
                dayProps: const EasyDayProps(
                  todayHighlightStyle: TodayHighlightStyle.withBackground,
                  todayHighlightColor: Color(0xffE1ECC8),
                  activeDayStyle: DayStyle(
                    borderRadius: 32.0,
                  ),
                ),
                headerProps: const EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total calories burnt: $totalCaloriesBurnt kcal',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: progressBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int?> getTotalCaloriesBurned(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 0; // No user logged in, return 0
    }

    int totalCalories = 0;

    // Get the start and end of the specified date
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    // Query Firestore for documents where userId is equal to the current user's ID and date is within the specified range
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('workout')
        .where('userid', isEqualTo: user.uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    // Iterate over the documents and sum the caloriesBurned
    for (var doc in querySnapshot.docs) {
      totalCalories += (doc['caloriesBurned'] as num).toInt();
    }

    return totalCalories;
  }
}
