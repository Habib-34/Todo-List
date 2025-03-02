import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_task_screen.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
  }

  void _deleteTask(DocumentSnapshot task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure to delete "${task['title']}" task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _firestore.collection('tasks').doc(task.id).delete();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void _changeWeek(int direction) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: direction * 7));
    });
  }

  Stream<String> _getTaskStatus(DateTime date) {
    return _firestore
        .collection('tasks')
        .where('date', isEqualTo: DateFormat('yMMMd').format(date))
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return '';
      var tasks = snapshot.docs;
      bool allCompleted = tasks.every((task) => task['done']);
      bool hasPending = tasks.any((task) => !task['done']);
      bool isToday = DateFormat('yMMMd').format(date) ==
          DateFormat('yMMMd').format(DateTime.now());

      if (allCompleted) return 'green';
      if (hasPending && !isToday && date.isBefore(DateTime.now())) return 'red';
      return 'purple';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          style: TextStyle(
            color: Color(0xff9867D7),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Center(
            child: Text(
              DateFormat('MMM yyyy').format(_selectedDate),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _goToToday,
            child: Text('Today', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(
            child: Container(
              color: Color(0xFFF2F2F2),
              child: StreamBuilder(
                stream: _firestore
                    .collection('tasks')
                    .where('date',
                        isEqualTo: DateFormat('yMMMd').format(_selectedDate))
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  var tasks = snapshot.data!.docs;
                  var pendingTasks =
                      tasks.where((task) => !task['done']).toList();
                  var doneTasks = tasks.where((task) => task['done']).toList();

                  return ListView(
                    children: [
                      _buildSectionTitle('Pending Tasks'),
                      if (pendingTasks.isNotEmpty)
                        ...pendingTasks
                            .map((task) => _buildTaskTile(task))
                            .toList()
                      else
                        _buildEmptyMessage('No pending tasks'),
                      _buildSectionTitle('Done Tasks'),
                      if (doneTasks.isNotEmpty)
                        ...doneTasks
                            .map((task) => _buildTaskTile(task))
                            .toList()
                      else
                        _buildEmptyMessage('No completed tasks'),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff9867D7),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
            onPressed: () => _changeWeek(-1),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime weekStart = _selectedDate
                    .subtract(Duration(days: _selectedDate.weekday - 1));
                DateTime date = weekStart.add(Duration(days: index));
                bool isSelected = _selectedDate.day == date.day &&
                    _selectedDate.month == date.month &&
                    _selectedDate.year == date.year;

                return StreamBuilder(
                  stream: _getTaskStatus(date),
                  builder: (context, snapshot) {
                    String color = snapshot.data ?? '';

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 9.0),
                        child: Column(
                          children: [
                            (color.isNotEmpty)
                                ? Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color == 'green'
                                          ? Colors.green
                                          : color == 'red'
                                              ? Colors.red
                                              : Colors.purple,
                                    ),
                                  )
                                : SizedBox(
                                    height: 6,
                                    width: 6,
                                  ),
                            Text(
                              DateFormat('E').format(date),
                              style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.purple
                                      : Colors.black),
                            ),
                            Text(
                              DateFormat('d').format(date),
                              style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.purple : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.purple),
            onPressed: () => _changeWeek(1),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(DocumentSnapshot task) {
    return GestureDetector(
      onLongPress: () => _deleteTask(task),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: task['done'],
              onChanged: (_) => _firestore
                  .collection('tasks')
                  .doc(task.id)
                  .update({'done': !task['done']}),
            ),
            Expanded(
              child: Container(
                height: 75,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.w500,
                        decoration: task['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 75,
              width: 90,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  task['time'],
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(message, style: TextStyle(color: Colors.grey)),
    );
  }
}
