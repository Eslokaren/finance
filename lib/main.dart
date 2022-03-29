import 'package:finance/finance/screens/pay_screen.dart';
import 'package:finance/login/login_screen.dart';
import 'package:finance/login/password_screen.dart';
import 'package:finance/marketplace/marketplace_screen.dart';
import 'package:finance/theme/main_theme.dart';
import 'package:flutter/material.dart';

import 'package:finance/finance/screens/transactions_screen.dart';
import 'finance/screens/wallet_details.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final authBox = "authBox";

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(authBox);

  runApp(FinanceManager());
}

class FinanceManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: getMainTheme(context),
        home: LoginScreen(),
        routes: {
          MarketplaceScreen.route: (context) => MarketplaceScreen(),
          FinanceTransactionsScreen.route: (context) =>
              FinanceTransactionsScreen(),
          PasswordScreen.route: (context) => PasswordScreen(),
          WalletDetails.route: (context) =>
              WalletDetails(currency: '', userId: 0, index: 0)
        });
  }
}
