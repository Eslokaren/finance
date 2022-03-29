import 'package:flutter/material.dart';

class FinanceTransactionsScreen extends StatelessWidget {
  static const String route = '/transactions_screen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTile(
        title: Text('hello world'),
        subtitle: Text("hello world"),
        onTap: null,
        trailing: Container(
          child: Text(
            '0',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: true ? Color(0xff27AE60) : Color(0xffEB5757)),
          ),
        ),
      ),
    );
  }
}
