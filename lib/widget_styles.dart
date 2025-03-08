import 'package:flutter/material.dart';

const kTrackerTextFormBoxDecoration = BoxDecoration(
    
    color: Color(0xffEFEFEF),
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ));

const kTrackerTextFormFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
    fontSize: 12,
    color: Colors.grey,
  ),
  hintText: '',
  alignLabelWithHint: true,
  contentPadding: EdgeInsets.symmetric(vertical: 3),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  ),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5B7A49), width: 2)),
);

const kRootineDropDownButtonTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54);

const kRootineDropdownButtonBorderRadius = BorderRadius.all(Radius.circular(10));

const kRootineDropdownIcon = Icon(Icons.keyboard_arrow_down_rounded);

const kDetailTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    ));

const kDetailTextFieldTextStyle = TextStyle(fontSize: 14, color: Colors.black);
