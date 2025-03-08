import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rootine/api/api-services.dart';

import '../../widget_styles.dart';

List<String> periodicityOptions = [
  'Daily',
  'Weekly',
  'Monthly',
  'None',
];

List<String> reminderDaysByWeekly = [
  'Every Sunday',
  'Every Monday',
  'Every Tuesday',
  'Every Wednesday',
  'Every Thursday',
  'Every Friday',
  'Every Saturday'
];

List<String> reminderDaysByMonthly = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
];

class EditReminders extends StatefulWidget {
  final String idToken;
  final String plantId;
  final VoidCallback onSaveReminders;

  EditReminders({super.key, required this.idToken, required this.plantId, required this.onSaveReminders});

  @override
  State<EditReminders> createState() => _EditRemindersState();
}

class _EditRemindersState extends State<EditReminders> {
  late String pestControlCurrentPeriod;
  late String pruningCurrentPeriod;
  late String wateringCurrentPeriod;
  late String fertilizingCurrentPeriod;

  String? pestControlReminderWeeklyValue;
  String? pestControlReminderMonthlyValue;
  String? pruningReminderWeeklyValue;
  String? pruningReminderMonthlyValue;
  String? wateringReminderWeeklyValue;
  String? wateringReminderMonthlyValue;
  String? fertilizingReminderWeeklyValue;
  String? fertilizingReminderMonthlyValue;

  @override
  void initState() {
    pestControlCurrentPeriod = 'None';
    pruningCurrentPeriod = 'None';
    wateringCurrentPeriod = 'None';
    fertilizingCurrentPeriod = 'None';
    super.initState();
  }

  Future<void> saveReminders() async {
    List<Map<String, dynamic>> reminders = [];

    void addReminder(String type, String period, String? weeklyValue, String? monthlyValue) {
      if (period == 'Daily') {
        reminders.add({
          'plant_id': widget.plantId,
          'reminder_type': type,
          'frequency': 'daily',
          'day': null,
          'status': 'active'
        });
      } else if (period == 'Weekly' && weeklyValue != null) {
        reminders.add({
          'plant_id': widget.plantId,
          'reminder_type': type,
          'frequency': 'weekly',
          'day': reminderDaysByWeekly.indexOf(weeklyValue) + 1,
          'status': 'active'
        });
      } else if (period == 'Monthly' && monthlyValue != null) {
        reminders.add({
          'plant_id': widget.plantId,
          'reminder_type': type,
          'frequency': 'monthly',
          'day': int.parse(monthlyValue),
          'status': 'active'
        });
      }
      else {
        reminders.add({
          'plant_id': widget.plantId,
          'reminder_type': type,
          'frequency': 'none',
          'day': null,
          'status': 'active'
        });
      }
    }

    addReminder('pest control', pestControlCurrentPeriod, pestControlReminderWeeklyValue, pestControlReminderMonthlyValue);
    addReminder('prune', pruningCurrentPeriod, pruningReminderWeeklyValue, pruningReminderMonthlyValue);
    addReminder('water', wateringCurrentPeriod, wateringReminderWeeklyValue, wateringReminderMonthlyValue);
    addReminder('fertilize', fertilizingCurrentPeriod, fertilizingReminderWeeklyValue, fertilizingReminderMonthlyValue);
    

    try {
      await ApiService().addReminders(
        context: context,
        idToken: widget.idToken,
        reminders: reminders,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminders saved successfully')));
      widget.onSaveReminders(); // Notify the parent widget
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save reminders: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Edit Reminders',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff5B7A49)),
        ),
        SizedBox(
          height: 12,
        ),
        //PestControl//
        buildReminderSection(
          context: context,
          icon: Icons.pest_control,
          reminderTitle: 'Pest Control',
          iconColor: Color(0xffBB64D9),
          currentPeriod: pestControlCurrentPeriod,
          weeklyValue: pestControlReminderWeeklyValue,
          monthlyValue: pestControlReminderMonthlyValue,
          onPeriodChanged: (String? value) {
            setState(() {
              pestControlCurrentPeriod = value!;
            });
          },
          onWeeklyChanged: (String? newValue) {
            setState(() {
              pestControlReminderWeeklyValue = newValue;
            });
          },
          onMonthlyChanged: (String? newValue) {
            setState(() {
              pestControlReminderMonthlyValue = newValue;
            });
          },
        ),
        //Pruning
        buildReminderSection(
          context: context,
          icon: Icons.cut_rounded,
          reminderTitle: 'Pruning',
          iconColor: Color(0xffA4A4A4),
          currentPeriod: pruningCurrentPeriod,
          weeklyValue: pruningReminderWeeklyValue,
          monthlyValue: pruningReminderMonthlyValue,
          onPeriodChanged: (String? value) {
            setState(() {
              pruningCurrentPeriod = value!;
            });
          },
          onWeeklyChanged: (String? newValue) {
            setState(() {
              pruningReminderWeeklyValue = newValue;
            });
          },
          onMonthlyChanged: (String? newValue) {
            setState(() {
              pruningReminderMonthlyValue = newValue;
            });
          },
        ),
        //Watering
        buildReminderSection(
          context: context,
          icon: Icons.water_drop,
          reminderTitle: 'Watering',
          iconColor: Color(0xff21A2FF),
          currentPeriod: wateringCurrentPeriod,
          weeklyValue: wateringReminderWeeklyValue,
          monthlyValue: wateringReminderMonthlyValue,
          onPeriodChanged: (String? value) {
            setState(() {
              wateringCurrentPeriod = value!;
            });
          },
          onWeeklyChanged: (String? newValue) {
            setState(() {
              wateringReminderWeeklyValue = newValue;
            });
          },
          onMonthlyChanged: (String? newValue) {
            setState(() {
              wateringReminderMonthlyValue = newValue;
            });
          },
        ),
        //Fertilizing
        buildReminderSection(
          context: context,
          icon: Icons.backpack_rounded,
          reminderTitle: 'Fertilizing',
          iconColor: Color(0xffCD995D),
          currentPeriod: fertilizingCurrentPeriod,
          weeklyValue: fertilizingReminderWeeklyValue,
          monthlyValue: fertilizingReminderMonthlyValue,
          onPeriodChanged: (String? value) {
            setState(() {
              fertilizingCurrentPeriod = value!;
            });
          },
          onWeeklyChanged: (String? newValue) {
            setState(() {
              fertilizingReminderWeeklyValue = newValue;
            });
          },
          onMonthlyChanged: (String? newValue) {
            setState(() {
              fertilizingReminderMonthlyValue = newValue;
            });
          },
        ),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 181, 181, 181),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: (){
                    widget.onSaveReminders();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                                ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff75A081),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: saveReminders,
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                ),
              ),

            ],)
        
      ],
    );
  }

  Widget buildReminderSection({
    required BuildContext context,
    required IconData icon,
    required String reminderTitle,
    required Color iconColor,
    required String currentPeriod,
    required String? weeklyValue,
    required String? monthlyValue,
    required ValueChanged<String?> onPeriodChanged,
    required ValueChanged<String?> onWeeklyChanged,
    required ValueChanged<String?> onMonthlyChanged,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double selectionFontSize = screenWidth * 0.03;
    double paddingRow = screenWidth * 0.01;
    double paddingHeight = 10;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingRow, vertical: paddingHeight),
      child: Column(
        children: <Widget>[
          ReminderTitle(
            icon: icon,
            reminderTitle: reminderTitle,
            iconColor: iconColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: periodicityOptions[0],
                groupValue: currentPeriod,
                onChanged: onPeriodChanged,
              ),
              Text(
                'Daily',
                style: TextStyle(fontSize: selectionFontSize, color: Colors.black),
              ),
              Radio(
                value: periodicityOptions[1],
                groupValue: currentPeriod,
                onChanged: onPeriodChanged,
              ),
              Text(
                'Weekly',
                style: TextStyle(fontSize: selectionFontSize, color: Colors.black),
              ),
              Radio(
                value: periodicityOptions[2],
                groupValue: currentPeriod,
                onChanged: onPeriodChanged,
              ),
              Text(
                'Monthly',
                style: TextStyle(fontSize: selectionFontSize, color: Colors.black),
              ),
              Radio(
                value: periodicityOptions[3],
                groupValue: currentPeriod,
                onChanged: onPeriodChanged,
              ),
              Text(
                'None',
                style: TextStyle(fontSize: selectionFontSize, color: Colors.black),
              ),
            ],
          ),
          currentPeriod == periodicityOptions[1] || currentPeriod == periodicityOptions[2]
              ? currentPeriod == periodicityOptions[1]
                  ? Container(
                      width: 170,
                      height: 24,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Color(0xffE8E8E8), borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: buildDropdownWeekly(context, weeklyValue, onWeeklyChanged),
                    )
                  : Container(
                      width: 170,
                      height: 24,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Color(0xffE8E8E8)),
                      child: buildDropdownMonthly(context, monthlyValue, onMonthlyChanged),
                    )
              : SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildDropdownMonthly(BuildContext context, String? reminderMonthlyValue, ValueChanged<String?> onChangedMonthly) {
    return DropdownButton(
      isExpanded: true,
      items: reminderDaysByMonthly.map((String day) {
        return DropdownMenuItem(value: day, child: Text(day));
      }).toList(),
      onChanged: onChangedMonthly,
      value: reminderMonthlyValue,
      icon: kRootineDropdownIcon,
      borderRadius: kRootineDropdownButtonBorderRadius,
      style: kRootineDropDownButtonTextStyle,
      underline: Container(),
    );
  }

  Widget buildDropdownWeekly(BuildContext context, String? reminderWeeklyValue, ValueChanged<String?> onChangedWeekly) {
    return DropdownButton(
      isExpanded: true,
      items: reminderDaysByWeekly.map((String day) {
        return DropdownMenuItem(value: day, child: Text(day));
      }).toList(),
      onChanged: onChangedWeekly,
      value: reminderWeeklyValue,
      icon: kRootineDropdownIcon,
      borderRadius: kRootineDropdownButtonBorderRadius,
      style: kRootineDropDownButtonTextStyle,
      underline: Container(),
    );
  }
}

class ReminderTitle extends StatelessWidget {
  final IconData icon;
  final String reminderTitle;
  final Color iconColor;

  ReminderTitle({super.key, required this.icon, required this.reminderTitle, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        Text(
          reminderTitle,
          style: TextStyle(color: Color(0xff5B7A49), fontSize: 16),
        )
      ],
    );
  }
}
