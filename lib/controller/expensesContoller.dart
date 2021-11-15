import 'package:budget/model/expensesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ExpensesModel>> getData(String user) async {
    DocumentSnapshot ds;
    QuerySnapshot<Map<String, dynamic>> qs;
    List<ExpensesModel> modelList = [];
    print('getData in expensesController');
    qs = await _firestore.collection('expenses').get();
    for (int i = 0; i < qs.size; i++) {
      ds = await _firestore.collection("expenses").doc(qs.docs[i].id).get();
      ExpensesModel model = ExpensesModel.fromJson(ds.data());
      modelList.add(model);
    }
    return modelList;
  }

  Future<List<ExpensesModel>> getExpensesOfMonth(
      String start, String end) async {
    print('[getExpensesOfMonth]');
    DocumentSnapshot ds;
    QuerySnapshot<Map<String, dynamic>> qs;
    List<ExpensesModel> modelList = [];
    print(start);
    print(end);
    qs = await _firestore
        .collection('expenses')
        .where("date", isGreaterThanOrEqualTo: start, isLessThan: end)
        .get();
    for (int i = 0; i < qs.size; i++) {
      ds = await _firestore.collection("expenses").doc(qs.docs[i].id).get();
      ExpensesModel model = ExpensesModel.fromJson(ds.data());
      modelList.add(model);
    }

    print('modelList in getExpensesOfMonth : $modelList');
    return modelList;
  }

  void setData(
      String name, String price, String user, String date, String div) {
    ExpensesModel model = ExpensesModel(
        name: name, price: price, user: user, date: date, div: div);
    print(model.toJson());
    _firestore.collection('expenses').add(model.toJson());
  }
}
