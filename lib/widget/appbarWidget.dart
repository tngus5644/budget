import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: Text(
        'μ§νπ§‘μν κ°κ³λΆ',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
    );
  }
}