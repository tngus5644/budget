import 'package:budget/view/home.dart';
import 'package:budget/view/login.dart';
import 'package:budget/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';

final box = GetStorage();
final user = box.read('user');

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    print('[main] user : $user');

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

      getPages: [
        //Simple GetPage
        GetPage(
          name: '/home',
          page: () => Home( ),
        ),
        GetPage(
          name: '/login',
          page: () => Login( ),
        ),
      ],
      home: user == null ? Login() : Home(),
    );
  }
}
