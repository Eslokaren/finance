import 'package:finance/finance/widgets/payment_form.dart';
import 'package:flutter/material.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPaymentMethodScreenState();
  }
}

class AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {


  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("x. Add payment method")),
      resizeToAvoidBottomInset: false,
      body: PaymentForm()
    );
  }
}
