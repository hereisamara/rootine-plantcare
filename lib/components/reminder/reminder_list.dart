import 'package:flutter/material.dart';
import 'package:rootine/components/reminder/reminder_tile.dart';

class ReminderList extends StatelessWidget {
  
  final bool isDone;

  ReminderList({required this.isDone});

  List<Map<String, dynamic>> remindersData = [
    {'icon': Icons.pest_control, 'color': Color(0xffBB64D9), 'text': 'Pest Control'},
    {'icon': Icons.cut_rounded, 'color': Color(0xffA4A4A4), 'text': 'Pruning'},
    {'icon': Icons.water_drop, 'color': Color(0xff21A2FF), 'text': 'Watering'},
    {'icon': Icons.backpack, 'color': Color(0xffCD995D), 'text': 'Fertilizing'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ReminderTile(
          reminderTitle: remindersData[index]['text'],
          reminderIcon: remindersData[index]['icon'],
          iconColor: remindersData[index]['color'],
          isReminderDone: isDone,
        );
      },
      itemCount: remindersData.length,
    );
  }
}
