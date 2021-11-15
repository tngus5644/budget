import 'package:budget/widget/FireStoreInputBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingDialog extends StatelessWidget {
  const FloatingDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dialog(
      // backgroundColor: Colors.pinkAccent,
      insetPadding: EdgeInsets.all(50),
      child: Container(
        padding: EdgeInsets.all(20),
        height: Get.height / 2,
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      '버튼 선택',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
            DialogButtonWidget(text: '사용자변경'),
            SizedBox(
              height: 20,
            ),
            DialogButtonWidget(text: '지출입력'),
            SizedBox(
              height: 20,
            ),
            DialogButtonWidget(text: '수입입력'),
          ],
        ),
      ),
    );
  }
}

class DialogButtonWidget extends StatefulWidget {
  const DialogButtonWidget({Key key, @required this.text}) : super(key: key);
  final String text;

  @override
  _DialogButtonWidgetState createState() => _DialogButtonWidgetState();
}

class _DialogButtonWidgetState extends State<DialogButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height / 10,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.orange;
            } else {
              return Colors.grey[200];
            }
          }),
        ),
        onPressed: () async {
          var result;
          switch (widget.text) {
            case "사용자변경":
              Get.offAllNamed('login');
              break;
            case "지출입력":
              result = await Get.dialog(FireStoreInputBox(
                input: 'expenses',
              ));
              Get.back(result: result);
              break;

            case "수입입력":
              result = await Get.dialog(FireStoreInputBox(input: 'income'));
              Get.back(result: result);
              break;
            default:
              // Get.back();
              break;
          }
          print(result);
        },
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}