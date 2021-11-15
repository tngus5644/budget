import 'package:budget/controller/expensesContoller.dart';
import 'package:budget/controller/incomeController.dart';
import 'package:budget/main.dart';
import 'package:budget/model/expensesModel.dart';
import 'package:budget/model/incomeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FireStoreInputBox extends StatefulWidget {
  final String input;

  const FireStoreInputBox({Key key, this.input}) : super(key: key);

  @override
  _FireStoreInputBoxState createState() => _FireStoreInputBoxState();
}

class _FireStoreInputBoxState extends State<FireStoreInputBox> {
  String selectedDay = box.read('selectedDay');
  DateTime selectedDate;
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  @override
  void initState() {
    selectedDate = DateTime(
        int.parse(selectedDay.substring(0, 4)),
        int.parse(selectedDay.substring(4, 6)),
        int.parse(selectedDay.substring(6, 8)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text('이름'),
              SizedBox(height: 10,),
              TextFormField(
                controller: nameController,
                onTap: () {},
                autofocus: true,
                style: TextStyle(fontSize: 30),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text('금액'),
              SizedBox(height: 10,),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp('[0-9]')),
                ],
                onTap: () {},
                style: TextStyle(fontSize: 30),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('날짜'),
                  GestureDetector(
                    child: Text(
                      '${selectedDay.substring(0, 4)} - ${selectedDay.substring(4, 6)} - ${selectedDay.substring(6, 8)}',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onTap: () async {
                      selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900, 01),
                          lastDate: DateTime(3000, 12));
                      List<String> todayList =
                      selectedDate.toUtc().toString().split(" ");
                      todayList = todayList[0].split("-");
                      setState(() {
                        selectedDay =
                            todayList[0] + todayList[1] + todayList[2];
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Get.back(result : 'cancel');
              },
              child: Text('닫기'),
            ),
            TextButton(
              child: Text('n/1'),
              onPressed: () {},
            ),
            TextButton(
              onPressed: () {
                if (widget.input == 'income'){
                  IncomeController controller = new IncomeController();
                  IncomeModel model = new IncomeModel(name: nameController.text, price: priceController.text, user: user, date: selectedDay, div: widget.input);
                  controller.setData(nameController.text, priceController.text, user, selectedDay, widget.input);
                  print('income input finish');
                  Get.back(result: model.toJson());

                }else if(widget.input == 'expenses'){
                  ExpensesController controller = new ExpensesController();
                  ExpensesModel model = new ExpensesModel(name: nameController.text, price: priceController.text, user: user, date: selectedDay, div: widget.input);
                  controller.setData(nameController.text, priceController.text, user, selectedDay, widget.input);
                  print('expenses input finish');
                  Get.back(result: model.toJson());
                }
              }, // passing true
              child: Text('입력'),
            ),
          ],
        )
      ],
    );
  }
}
