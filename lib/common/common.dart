import 'package:intl/intl.dart';

String dateToString(DateTime date) {
  List<String> todayList = date.toUtc().toString().split(" ");
  todayList = todayList[0].split("-");
  return todayList[0] + todayList[1] + todayList[2];

}

String addComma(String string){
  return  NumberFormat('###,###,###,###').format(int.parse(string)).replaceAll(' ', '');
}