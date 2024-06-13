import 'package:flutter/material.dart';
import 'package:fitness_tracking/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Reminder {
  int id;
  String title;
  String description;
  TimeOfDay time;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': '${time.hour}:${time.minute}',
    };
  }

  static Reminder fromJson(Map<String, dynamic> json) {
    List<String> timeParts = json['time'].split(':');
    TimeOfDay time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: time,
    );
  }
}

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Reminder> _reminders = [];
  int _counter = 0;

  // Define your theme color here
  Color themeColor = Color.fromARGB(255, 200, 230, 201); // Example green shade

  @override
  void initState() {
    super.initState();
    NotificationService().init();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? reminderList = prefs.getStringList('reminders');
    if (reminderList != null) {
      setState(() {
        _reminders = reminderList.map((item) => Reminder.fromJson(json.decode(item))).toList();
        if (_reminders.isNotEmpty) {
          _counter = _reminders.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;
        }
      });
    }
  }

  Future<void> _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reminderList = _reminders.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('reminders', reminderList);
  }

  void _addReminder(Reminder reminder) {
    setState(() {
      _reminders.add(reminder);
    });
    _saveReminders();
    NotificationService().scheduleNotification(
      reminder.id,
      reminder.title,
      reminder.description,
      reminder.time,
    );
  }

  void _editReminder(Reminder reminder) {
    setState(() {
      int index = _reminders.indexWhere((r) => r.id == reminder.id);
      _reminders[index] = reminder;
    });
    _saveReminders();
    NotificationService().scheduleNotification(
      reminder.id,
      reminder.title,
      reminder.description,
      reminder.time,
    );
  }

  void _deleteReminder(int id) {
    setState(() {
      _reminders.removeWhere((reminder) => reminder.id == id);
    });
    _saveReminders();
    NotificationService().cancelNotification(id);
  }

  Future<void> _pickTime(BuildContext context, Reminder reminder) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: reminder.time,
    );
    if (picked != null) {
      reminder.time = picked;
      _editReminder(reminder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: themeColor, // Apply theme color to app bar
      ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text('${reminder.description} - ${reminder.time.format(context)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _pickTime(context, reminder),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteReminder(reminder.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: Icon(Icons.add),
        backgroundColor: themeColor, // Apply theme color to floating action button
      ),
    );
  }

  Future<void> _showAddReminderDialog(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Time: ${selectedTime.format(context)}'),
                        TextButton(
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (picked != null) {
                              setState(() {
                                selectedTime = picked;
                              });
                            }
                          },
                          child: Text('Select Time'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final String title = titleController.text;
                    final String description = descriptionController.text;
                    final int id = _counter++;
                    final Reminder reminder = Reminder(
                      id: id,
                      title: title,
                      description: description,
                      time: selectedTime,
                    );
                    _addReminder(reminder);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
