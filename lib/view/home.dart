import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:budget/common/common.dart';
import 'package:budget/controller/expensesContoller.dart';
import 'package:budget/controller/incomeController.dart';
import 'package:budget/main.dart';
import 'package:budget/model/Event.dart';
import 'package:budget/model/expensesModel.dart';
import 'package:budget/model/incomeModel.dart';
import 'package:budget/widget/FloatingDialog.dart';
import 'package:budget/widget/appbarWidget.dart';
import 'package:budget/widget/drawerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

DateTime stringToDateTime(String string) {
  DateTime date = DateTime(int.parse(string.substring(0, 4)),
      int.parse(string.substring(4, 6)), int.parse(string.substring(6, 8)));
  return date;
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  ExpensesController _expensesController = new ExpensesController();
  IncomeController _incomeController = new IncomeController();
  CalendarController _controller;

  List<IncomeModel> incomeModelList = [];
  List<ExpensesModel> expensesModelList = [];
  List<String> dateList = [];
  List<dynamic> _selectedEvents;

  Map<DateTime, List> _events = Map<DateTime, List>();

  String user;
  String expensesOfMonth;
  String incomeOfMonth;

  @override
  void initState() {
    super.initState();
    user = box.read('user');
    _controller = CalendarController();
    _selectedDay = DateTime.now();
    _selectedEvents = [];
    getBudget();
    expensesOfMonth = "";
    incomeOfMonth = "";
    getSumOfMonth(_selectedDay); //지출, 수입 총합계
    print(user);
  }

  Future<void> getSumOfMonth(DateTime date) async {
    print("====================");
    int sum = 0;
    List<ExpensesModel> monthExpensesList =
        await _expensesController.getExpensesOfMonth(
            dateToString(DateTime(date.year, date.month, 00)),
            dateToString(DateTime(date.year, date.month + 1, 00)));
    for (int i = 0; i < monthExpensesList.length; i++) {
      sum += int.parse(monthExpensesList[i].price);
    }
    expensesOfMonth = sum.toString();

    sum = 0;
    List<IncomeModel> monthIncomeList =
        await _incomeController.getIncomeOfMonth(
            dateToString(DateTime(date.year, date.month, 00)),
            dateToString(DateTime(date.year, date.month + 1, 00)));
    for (int i = 0; i < monthIncomeList.length; i++) {
      sum += int.parse(monthIncomeList[i].price);
    }
    incomeOfMonth = sum.toString();
    setState(() {});
  }

  //firestore의 data를 받아와서 event(Map<Date, List>)에 할당.
  Future<void> getBudget() async {
    dateList = [];

    _events = Map<DateTime, List>();


    expensesModelList = await _expensesController.getData(user);
    incomeModelList = await _incomeController.getData(user);

    //dateList = 이벤트가 있는 날짜만 있는 List
    dateList += expensesModelList.map((value) => value.date).toList();
    dateList += incomeModelList.map((value) => value.date).toList();
    dateList.toSet().toList();

    //_events[dateList]에 list<expensesModel> add
    for (int j = 0; j < dateList.length; j++) {
      _events[stringToDateTime(dateList[j])] = [];
      for (int i = 0; i < expensesModelList.length; i++) {
        if (dateList[j] == expensesModelList[i].date) {
          _events[stringToDateTime(dateList[j])].add(expensesModelList[i]);
        }
      }
      for (int i = 0; i < incomeModelList.length; i++) {
        if (dateList[j] == incomeModelList[i].date) {
          _events[stringToDateTime(dateList[j])].add(incomeModelList[i]);
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        endDrawer: MyDrawerWidget(),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          splashColor: Colors.white,
          onPressed: () async {
            await Get.dialog(FloatingDialog());

            setState(() {
              getBudget();
              getSumOfMonth(_controller.selectedDay);
            });
          },
        ),
        drawerScrimColor: Colors.black,
        body: Column(
          children: [
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              onHeaderTapped: (DateTime date) {
                setState(() {
                  DateTime now = DateTime.now();
                  _selectedDay = now;
                  box.write('selectedDay', dateToString(_selectedDay));
                  _controller.setFocusedDay(now);
                });
              },
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,

              //다음달, 이전달로 이동했을 경우
              onVisibleDaysChanged: (date, date2, e) {

                setState(() {
                  _controller.setSelectedDay(_controller.focusedDay);
                  _selectedDay = _controller.selectedDay;
                  box.write('selectedDay', dateToString(_selectedDay));
                });
                getBudget();
                getSumOfMonth(_controller.focusedDay);
              },
              onDaySelected: (date, events, e) {
                String today = dateToString(date);
                box.write('selectedDay', today);
                print('$today 의 events : ${events.length}개 $events ');
                setState(() {
                  _selectedEvents = events;
                  _selectedDay = date;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) =>
                    CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.blueAccent,
                  events: events,
                  isSelect: true,
                ),
                todayDayBuilder: (context, date, events) =>
                    CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.blueAccent,
                  events: events,
                  isSelect: false,
                ),
                dayBuilder: (context, date, events) => CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.black,
                  events: events,
                  isSelect: false,
                ),
                weekendDayBuilder: (context, date, events) =>
                    CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.red,
                  events: events,
                  isSelect: false,
                ),
                outsideDayBuilder: (context, date, events) =>
                    CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.white,
                  events: events,
                  isSelect: false,
                ),
                outsideWeekendDayBuilder: (context, date, events) =>
                    CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.white,
                  events: events,
                  isSelect: false,
                ),
                outsideHolidayDayBuilder: (context, date, events) =>
                    CalendarBuilderWidget(
                  day: date.day.toString(),
                  backColor: Colors.white,
                  color: Colors.white,
                  events: events,
                  isSelect: false,
                ),
                markersBuilder: (context, date, events, holidays) => [],
              ),
              calendarController: _controller,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                '${_selectedDay.month}월 수입 총 합계',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                !incomeOfMonth.isBlank
                                    ? '${addComma(incomeOfMonth)}'
                                    : ' ',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        elevation: 5,
                      ),
                    ),
                    Container(
                      width: Get.width,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                '${_selectedDay.month}월 지출 총 합계',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                !expensesOfMonth.isBlank
                                    ? '${addComma(expensesOfMonth)}'
                                    : ' ',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        elevation: 5,
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      width: Get.width,
                      // height: 70 + (_selectedEvents.length * 100.0),
                      child: Column(
                        children: [
                          Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      '구분',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      '이름',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      '금액',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      '사용자',
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _selectedEvents.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: _selectedEvents[index].div ==
                                                'expenses'
                                            ? Text(
                                                '지출',
                                                style: TextStyle(fontSize: 15, color: Colors.red),
                                              )
                                            : Text(
                                                '수입',
                                                style: TextStyle(fontSize: 15, color: Colors.blueAccent),
                                              ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            _selectedEvents[index].name,
                                            style: TextStyle(fontSize: 15),
                                          )),
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            _selectedEvents[index].price,
                                            style: TextStyle(fontSize: 15),
                                          )),
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            _selectedEvents[index].user,
                                            style: TextStyle(fontSize: 15),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class CalendarBuilderWidget extends StatelessWidget {
  final String day;
  final Color backColor;
  final Color color;
  final List<dynamic> events;
  final bool isSelect;

  const CalendarBuilderWidget(
      {Key key,
      this.day,
      this.backColor,
      this.color,
      this.events,
      this.isSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: isSelect
                ? Border.all(color: Colors.blue, width: 1)
                : Border.all(width: 0, color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(
                15.0,
              ),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: TextStyle(color: color),
            ),
            Container(
              color: backColor,
              child: Text(
                events != null ? addComma(getTodayIncomeSum(events, day)) : '',
                style: TextStyle(fontSize: 10, color: Colors.blueAccent),
              ),
            ),
            Container(
              color: backColor,
              child: Text(
                events != null
                    ? addComma(getTodayExpensesSum(events, day))
                    : '',
                style: TextStyle(fontSize: 10, color: Colors.redAccent),
              ),
            )
          ],
        ));
  }

  String getTodayExpensesSum(List<dynamic> events, String day) {
    int result = 0;

    for (int i = 0; i < events.length; i++) {
      if (events[i].div == "expenses") {
        result += int.parse(events[i].price);
      }
    }
    return result.toString();
  }

  String getTodayIncomeSum(List<dynamic> events, String day) {
    int result = 0;

    for (int i = 0; i < events.length; i++) {
      if (events[i].div == "income") {
        result += int.parse(events[i].price);
      }
    }
    return result.toString();
  }
}
