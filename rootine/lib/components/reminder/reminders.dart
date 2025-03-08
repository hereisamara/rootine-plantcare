import 'package:flutter/material.dart';
import 'package:rootine/api/api-services.dart';
import 'package:rootine/components/reminder/edit_reminders.dart';

class Reminder extends StatefulWidget {
  static final String id = 'reminders';
  final String idToken;
  final String plantId;
  final VoidCallback noti;
  const Reminder({super.key, required this.idToken, required this.plantId, required this.noti});

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  late bool isEditMode;
  bool isTaskDone = false;
  List<Map<String, dynamic>> reminders = [];
  final apiService = ApiService();

  @override
  void initState() {
    isEditMode = false;
    super.initState();
    fetchReminders();
    widget.noti();
  }

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  Future<void> fetchReminders() async {
    try {
      List<Map<String, dynamic>> fetchedReminders = await apiService.getReminders(
        context: context,
        idToken: widget.idToken, 
        plantId: widget.plantId);
      setState(() {
        reminders = fetchedReminders;
      });
    } catch (e) {
      print("Error fetching reminders: $e");
    }
  }

  Future<void> updateReminder(String plantId, String reminderType) async {
    try {
      await apiService.updateReminderStatus(
        context: context,
        idToken: widget.idToken,
        plantId: plantId,
        reminderType: reminderType,
      );
      fetchReminders(); // Refresh reminders after updating status
      widget.noti();

    } catch (e) {
      print("Error updating reminder status: $e");
    }
  }

  void onSaveReminders() {
    setState(() {
      isEditMode = false;
    });
    widget.noti();
    fetchReminders(); // Refresh reminders after saving
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: <Widget>[
            isEditMode
                ? EditReminders(
                  idToken: widget.idToken,
                  plantId: widget.plantId,
                  onSaveReminders: onSaveReminders,
                )
                : RemindersNoEditMode(
                    reminders: reminders,
                    onCheckReminder: updateReminder,
                  ),
            isEditMode
                ? SizedBox()
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff75A081),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: toggleEditMode,
                        child: Text(
                          'Edit Reminder',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class RemindersNoEditMode extends StatelessWidget {
  final List<Map<String, dynamic>> reminders;
  final Function(String, String) onCheckReminder;

  RemindersNoEditMode({required this.reminders, required this.onCheckReminder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Reminders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff5B7A49)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                'for today',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff74705F)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Container(
              height: 250,
              child: ReminderList(
                reminders: reminders,
                onCheckReminder: onCheckReminder,
              )),
        ),
      ],
    );
  }
}

class ReminderList extends StatelessWidget {
  final List<Map<String, dynamic>> reminders;
  final Function(String, String) onCheckReminder;

  ReminderList({required this.reminders, required this.onCheckReminder});

  @override
  Widget build(BuildContext context) {
    
    if (reminders.isEmpty) {
      return Center(
        child: Text(
          'No reminders for today',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    bool allComplete = reminders.every((reminder) => reminder['status'] == 'complete');

    if (allComplete) {
      return Center(
        child: Text(
          'All tasks are complete!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        var reminder = reminders[index];
        return ListTile(
          title: Text(
            reminder['reminder_type'],
            style: TextStyle(
              decoration: reminder['status'] == 'complete' ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: Checkbox(
            value: reminder['status'] == 'complete',
            onChanged: (value) {
              if (value == true) {
                onCheckReminder(reminder['plant_id'], reminder['reminder_type']);
              }
            },
          ),
        );
      },
    );
  }
}
