import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarStyle calendarStyle = CalendarStyle(
    canEventMarkersOverflow: true,
    todayColor: Colors.orange,
    selectedColor: Colors.blue,
    todayStyle: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white));

HeaderStyle headerStyle = HeaderStyle(
  centerHeaderTitle: true,
  formatButtonDecoration: BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(20.0),
  ),
  formatButtonTextStyle: TextStyle(color: Colors.white),
  formatButtonShowsNext: false,
);
