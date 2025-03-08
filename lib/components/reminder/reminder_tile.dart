import 'package:flutter/material.dart';

class ReminderTile extends StatefulWidget {
  final IconData reminderIcon;
  final String reminderTitle;
  final Color iconColor;
  bool isReminderDone;

  ReminderTile({
    super.key,
    required this.reminderTitle,
    required this.isReminderDone,
    required this.reminderIcon,
    required this.iconColor,
  });

  void taskDone() {
    isReminderDone = !isReminderDone;
  }

  @override
  State<ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            widget.reminderIcon,
            color: widget.iconColor,
            size: 24,
          ),
          Text(
            widget.reminderTitle,
            style: TextStyle(
              color: Color(0xff5B7A49),
              fontSize: 16,
              decoration: widget.isReminderDone ? TextDecoration.lineThrough : TextDecoration.none,
              decorationThickness: 3,
            ),
          )
        ],
      ),
      trailing: Checkbox(
          value: widget.isReminderDone,
          onChanged: (value) {
            setState(() {
              widget.taskDone();
            });
          }),
    );
  }
}
