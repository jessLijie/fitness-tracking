import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fitness_tracking/Dashboard/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class MockData {
  static final Map<DateTime, List<Activity>> activities = {
    DateTime(2024, 5, 16): [
      Activity(name: 'Yoga', sets: 2, caloriesBurnt: 15),
      Activity(name: 'Stretching', sets: 1, caloriesBurnt: 7),
    ],
    DateTime(2024, 5, 17): [
      Activity(name: 'Yoga', sets: 1, caloriesBurnt: 10),
      Activity(name: 'Walking', sets: 1, caloriesBurnt: 5),
      Activity(name: 'Stretching', sets: 1, caloriesBurnt: 7),
    ],
    DateTime(2024, 5, 18): [
      Activity(name: 'Yoga', sets: 2, caloriesBurnt: 10),
      Activity(name: 'Walking', sets: 1, caloriesBurnt: 5),
    ],
  };
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<DateTime> _generateDisabledDates(int days) {
    List<DateTime> disabledDates = [];
    DateTime currentDate = DateTime.now().add(Duration(days: 1)); // Start from tomorrow
    for (int i = 0; i < days; i++) {
      disabledDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return disabledDates;
  }
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  DateTime? _selectedDate =
      DateTime.now(); // Initialize with current date and time

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
              'name',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              disabledDates: _generateDisabledDates(36525),
              onDateChange: (selectedDate) {
                setState(() {
                  _selectedDate = selectedDate;
                });
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
            if (_selectedDate != null) _buildSelectedDateActivities(),
            progressBar(),

          ],
        ),
        
      ),
    );
  }

  Widget _buildSelectedDateActivities() {
    if (_selectedDate != null) {
      final activities = MockData.activities[_selectedDate!] ?? [];
      if (activities.isNotEmpty) {
        int totalSets = 0;
        int totalCaloriesBurnt = 0;
        final activityWidgets = activities.map((activity) {
          totalSets += activity.sets;
          totalCaloriesBurnt += activity.caloriesBurnt;
          return Text('${activity.sets} set(s) of ${activity.name}');
        }).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On ${DateFormat.yMMMMd().format(_selectedDate!)}, you have completed:',
              style: TextStyle(fontSize: 16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activityWidgets,
            ),
            Text(
              'Total calories burnt: $totalCaloriesBurnt',
              style: TextStyle(fontSize: 16),
            )
          ],
        );
      } else {
        return Text(
          'On ${DateFormat.yMMMMd().format(_selectedDate!)}, You have completed:\n-- no activities done --\nTotal calories burnt: 0',
          style: TextStyle(fontSize: 16),
        );
      }
    } else {
      return Container(); 
    }
  }
}
