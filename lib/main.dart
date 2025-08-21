import 'package:bca_flutter_lab_codes/crud_different_pages/user_form_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: UserFormPage());
  }
}
