import 'package:budget/widget/appbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            height: Get.height / 5,
            child: Center(
                child: Text(
              '사용자 선택',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            )),
          ),
          SizedBox(height: Get.height/5,),
          Row(
            children: [
              Container(
                width: Get.width / 2,
                height: Get.height / 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.pinkAccent;
                      } else {
                        return Colors.blue;
                      }
                    }),
                  ),
                  onPressed: () {
                    Get.offAllNamed('/home');
                    box.write('user', '윤수현');
                  },
                  child: Text('수현'),
                ),
              ),
              Container(
                width: Get.width / 2,
                height: Get.height / 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      } else {
                        return Colors.pinkAccent;
                      }
                    }),
                  ),
                  onPressed: () {
                    Get.offAllNamed('/home');
                    box.write('user', '최지혜');
                  },
                  child: Text('지혜'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
