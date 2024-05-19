import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
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
    DateTime currentDate =
        DateTime.now().add(Duration(days: 1)); // Start from tomorrow
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
  String _selectedFilter = 'Daily';

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
            SizedBox(height: 20),
            _buildFilterDropdown(),
            SizedBox(height: 20),
            _buildCaloriesGraph(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedFilter,
      items:
          <String>['Daily', 'Weekly', 'Monthly', 'Yearly'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedFilter = newValue!;
        });
      },
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
      return Container(); // Return an empty container if no date selected
    }
  }

  Widget _buildCaloriesGraph() {
    List<FlSpot> spots = [];
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    // Determine the range of dates based on the selected filter
    switch (_selectedFilter) {
      case 'Daily':
        startDate = DateTime.now().subtract(Duration(days: 1));
        endDate = DateTime.now();
        break;
      case 'Weekly':
        startDate = DateTime.now().subtract(Duration(days: 7));
        endDate = DateTime.now();
        break;
      case 'Monthly':
        startDate = DateTime.now().subtract(Duration(days: 30));
        endDate = DateTime.now();
        break;
      case 'Yearly':
        startDate = DateTime.now().subtract(Duration(days: 365));
        endDate = DateTime.now();
        break;
    }

    // Generate the data points
    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(Duration(days: 1))) {
      int totalCaloriesBurnt = 0;
      final activities = MockData.activities[date] ?? [];
      for (var activity in activities) {
        totalCaloriesBurnt += activity.caloriesBurnt;
      }
      spots.add(FlSpot(date.difference(startDate).inDays.toDouble(),
          totalCaloriesBurnt.toDouble()));
    }

    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: endDate.difference(startDate).inDays.toDouble(),
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              // colors: [Colors.green],
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                // colors: [
                //   Colors.green.withOpacity(0.3),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
