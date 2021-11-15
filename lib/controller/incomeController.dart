import 'package:budget/model/incomeModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<IncomeModel>> getData(String user) async {
    DocumentSnapshot ds;
    QuerySnapshot<Map<String, dynamic>> qs;
    List<IncomeModel> modelList = [];
    print('getData in incomeController');
    qs = await _firestore.collection('income').get();
    for (int i = 0; i < qs.size; i++) {
      ds = await _firestore.collection("income").doc(qs.docs[i].id).get();
      IncomeModel model = IncomeModel.fromJson(ds.data());
      modelList.add(model);
    }
    return modelList;
  }

  Future<List<IncomeModel>> getIncomeOfMonth(String start, String end) async {
    print('[getIncomeModelOfMonth]');
    DocumentSnapshot ds;
    QuerySnapshot<Map<String, dynamic>> qs;
    List<IncomeModel> modelList = [];
    print(start);
    print(end);
    qs = await _firestore
        .collection('income')
        .where("date", isGreaterThanOrEqualTo: start, isLessThan: end)
        .get();
    for (int i = 0; i < qs.size; i++) {
      ds = await _firestore.collection("income").doc(qs.docs[i].id).get();
      IncomeModel model = IncomeModel.fromJson(ds.data());
      modelList.add(model);
    }

    print('modelList in getIncomeModelOfMonth : $modelList');
    return modelList;
  }

  void setData(
      String name, String price, String user, String date, String div) {
    IncomeModel model =
        IncomeModel(name: name, price: price, user: user, date: date, div: div);
    print(model.toJson());
    _firestore.collection('income').add(model.toJson());
  }
}
