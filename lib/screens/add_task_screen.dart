import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveTask() {
    if (_taskController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      _firestore.collection('tasks').add({
        'title': _taskController.text,
        'date': DateFormat('yMMMd').format(_selectedDate!),
        'time': _selectedTime!.format(context),
        'done': false,
      });
      Navigator.pop(context);
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'New Task',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff9867D7),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff9867D7),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'What is to be done?',
              ),
              maxLength: 50,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(_selectedDate != null
                    ? DateFormat('yMMMd').format(_selectedDate!)
                    : 'No due date set'),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Color(0xff9867D7),
                  ),
                  onPressed: _pickDate,
                ),
              ],
            ),
            Row(
              children: [
                Text(_selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'No due time set'),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.access_time),
                  color: Color(0xff9867D7),
                  onPressed: _pickTime,
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
