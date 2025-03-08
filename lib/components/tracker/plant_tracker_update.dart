import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rootine/api/api-services.dart';

import '../../widget_styles.dart';

class PlantTrackerUpdate extends StatefulWidget {
  final String idToken;
  final String plantId;
  final VoidCallback onTrackedDataUpdated;
  final VoidCallback onCancel;

  const PlantTrackerUpdate({
    super.key,
    required this.idToken,
    required this.plantId,
    required this.onTrackedDataUpdated,
    required this.onCancel
  });

  @override
  State<PlantTrackerUpdate> createState() => _PlantTrackerUpdateState();
}

class _PlantTrackerUpdateState extends State<PlantTrackerUpdate> {
  bool isInUpdateMode = false;
  TextEditingController heightController = TextEditingController();
  TextEditingController branchCountController = TextEditingController();
  TextEditingController leafCountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final apiService = ApiService();

  late String floweringStageDropdownValue;
  late String healthStatusDropdownValue;

  final List<String> _flowerStages = [
    'Budding',
    'Flowering',
    'Post-Flowering',
    'No Flowers',
  ];

  final List<String> _healthStatus = [
    'Healthy',
    'Stressed',
    'Diseased',
    'Nutrient Deficient',
    'Pest Infested',
  ];

  @override
  void initState() {
    super.initState();
    heightController.text = '';
    branchCountController.text = '';
    leafCountController.text = '';
    floweringStageDropdownValue = 'No Flowers';
    healthStatusDropdownValue = 'Healthy';
  }

  String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _updateValidationState(String value) {
    _formKey.currentState?.validate();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await apiService.addTrackedData(
          context: context,
          idToken: widget.idToken,
          plantId: widget.plantId,
          date: todayDate,
          height: heightController.text,
          branchCount: int.parse(branchCountController.text),
          leafCount: int.parse(leafCountController.text),
          floweringStage: floweringStageDropdownValue,
          healthStatus: healthStatusDropdownValue,
        );
        widget.onTrackedDataUpdated(); // Call the callback to reload data
      } catch (e) {
        print("Error saving tracked data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 18),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 22.0),
                  child: Text(
                    'Tracker',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5B7A49)),
                  ),
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Ready to update your plant growth for today?',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff74705F)),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      'Plant height',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff5B7A49)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: kTrackerTextFormBoxDecoration,
                      child: TextFormField(
                        controller: heightController,
                        decoration: kTrackerTextFormFieldDecoration.copyWith(
                          hintText: 'Enter the value in cm',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.center,
                        validator: validateNumeric,
                        onChanged: (newValue) {
                          _updateValidationState(newValue);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      'Branch counts',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff5B7A49)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: kTrackerTextFormBoxDecoration,
                      child: TextFormField(
                        controller: branchCountController,
                        decoration: kTrackerTextFormFieldDecoration.copyWith(
                          hintText: 'Enter number',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.center,
                        validator: validateNumeric,
                        onChanged: (newValue) {
                          _updateValidationState(newValue);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      'Leaf counts per branch',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff5B7A49)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: kTrackerTextFormBoxDecoration,
                      child: TextFormField(
                        controller: leafCountController,
                        decoration: kTrackerTextFormFieldDecoration.copyWith(
                          hintText: 'Enter number',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.center,
                        validator: validateNumeric,
                        onChanged: (newValue) {
                          _updateValidationState(newValue);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      'Flowering stage',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff5B7A49)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      width: 120,
                      height: 32,
                      decoration: kTrackerTextFormBoxDecoration,
                      child: Center(
                        child: DropdownButton(
                          value: floweringStageDropdownValue,
                          items: _flowerStages.map((String stage) {
                            return DropdownMenuItem(
                              value: stage,
                              child: Text(stage),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              floweringStageDropdownValue = value!;
                            });
                          },
                          icon: kRootineDropdownIcon,
                          borderRadius: kRootineDropdownButtonBorderRadius,
                          style: kRootineDropDownButtonTextStyle,
                          underline: Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      'Health Status',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff5B7A49)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      width: 120,
                      height: 32,
                      decoration: kTrackerTextFormBoxDecoration,
                      child: Center(
                        child: DropdownButton(
                          value: healthStatusDropdownValue,
                          items: _healthStatus.map((String status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              healthStatusDropdownValue = value!;
                            });
                          },
                          icon: kRootineDropdownIcon,
                          borderRadius: kRootineDropdownButtonBorderRadius,
                          style: kRootineDropDownButtonTextStyle,
                          underline: Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 57),
            isInUpdateMode
                ? Container()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 181, 181, 181),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: (){
                          widget.onCancel();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff75A081),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _saveData,
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
