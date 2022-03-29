import 'package:finance/finance/api.dart';
import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:finance/finance/screens/auto_recharge_screen.dart';
import 'package:finance/global/localization_mixing.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

class AddFundsScreen extends StatefulWidget {
  AddFundsScreen({Key? key, @required this.userId, @required this.payments})
      : super(key: key);

  final int? userId;
  final List<Method>? payments;

  @override
  _AddFundsScreenState createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  @override
  void initState() {
    loadScreenKeys();
    super.initState();
  }

  Box<dynamic>? box;

  String? _selectedPaymentMethod = '0';

  int? selected;
  int? amount = 5;

  void _handleChangePaymentMethod(String? value) {
    setState(() {
      _selectedPaymentMethod = value;
    });
  }

  void loadScreenKeys() async {
    final keysBox = await Hive.openBox('language');
    setState(() {
      box = keysBox;
    });
  }

  String t(String key) {
    return box!.get('keys')[key];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.info)],
        title: Text(t("finance.add_funds_appbar_title")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t('finance.header_text'),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                    child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money_outlined),
                  ),
                  initialValue: "5",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    amount = int.tryParse(value);
                  },
                )),
              ),
              Container(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.payments!.length,
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<int>(
                    dense: false,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                            'https://services.oshinstar.net/finance/assets/card',
                            height: 35),
                        SizedBox(width: 10),
                        Text("(${widget.payments![index].cardNumber}) visa")
                      ],
                    ),
                    value: index,
                    groupValue: selected,
                    onChanged: (int? value) {
                      setState(() {
                        selected = value;
                      });
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () async {
                            final resp = await FinanceApi().addFunds({
                              "eventType": "add_funds",
                              "clientId": widget.userId,
                              "amount": amount,
                              "methodUid": widget.payments![selected ?? 0].uid
                            });

                            return resp
                                ? _showSuccessDialog(context)
                                : _showErrorMessage(context);
                          },
                          child: Text(t("finance.add_funds_button_text")))))
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t('finance.error_dialog_title'),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(t('finance.error_adding_funds')),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t('finance.error_dialog_ok_button')),
          )
        ],
        elevation: 24.0,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
        actionsPadding: EdgeInsets.all(15),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t('finance.success_dialog_title'),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            WebsafeSvg.asset(
              'lib/assets/images/check.svg',
              width: 50,
              height: 50,
            ),
            SizedBox(height: 15),
            Text(t('finance.success_auto_recharge_message')),
            SizedBox(height: 10),
            Text(
              t('finance.success_how_to_do_it_text'),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  color: Color(0xffE0E0E0),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    t('finance.success_no'),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                FlatButton(
                  onPressed: () => _goToAutoRechargeScreen(context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(t('finance.success_yes')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _goToAutoRechargeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AutoRechargeScreen(
        userId: widget.userId ?? 0,
        paymentMethods: widget.payments ?? [],
      ),
    ));
  }
}
