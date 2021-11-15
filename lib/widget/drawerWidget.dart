import 'package:budget/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
            child: Container(
          color: Colors.blue,
        )),
        Container(
          color: Colors.redAccent,
          child: Column(
            children: [
              Text(box.read('user')),
              Text(box.read('selectedDay')),
            ],
          ),
        )
      ],
    ));
  }
}
