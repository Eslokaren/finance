import 'package:finance/finance/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final dateController = MaskedTextController(mask: '00/00');

  late dynamic name, cardNumber, expiryDate, cvv, address;

  var a;

  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box("authBox").listenable(),
        builder: (context, Box<dynamic> box, widget) {
          return Form(
            key: _formKey,
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 2) {
                          return 'Insert your name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: "Name",
                          hintText: "Insert your name",
                          border: border),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        cardNumber = value;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 16) {
                          return 'Insert a valid value';
                        }
                        return null;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      maxLength: 16,
                      decoration: InputDecoration(
                          counterText: '',
                          hintStyle: const TextStyle(color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: "Card Number",
                          hintText: 'XXXX XXXX XXXX XXXX',
                          border: border),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: TextFormField(
                              onChanged: (value) {
                                expiryDate = value;
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 4) {
                                  return 'Invalid value';
                                }
                                return null;
                              },
                              controller: dateController,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 5,
                              decoration: InputDecoration(
                                  counterText: '',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  focusedBorder: border,
                                  enabledBorder: border,
                                  labelText: "Expired Date",
                                  hintText: "MM/YY",
                                  border: border),
                            )),
                        Spacer(),
                        Expanded(
                            flex: 5,
                            child: TextFormField(
                              onChanged: (value) {
                                cvv = value;
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 4) {
                                  return 'Insert a valid value';
                                }
                                return null;
                              },
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 4,
                              decoration: InputDecoration(
                                  counterText: '',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  focusedBorder: border,
                                  enabledBorder: border,
                                  labelText: "CVV",
                                  hintText: "XXXX",
                                  border: border),
                            ))
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        address = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: "Billing Address",
                          hintText: "Address",
                          border: border),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool didAdd = await FinanceApi().addPaymentMethod({
                              "eventType": "add_payment",
                              "cardNumber": cardNumber,
                              "expiryDate": expiryDate,
                              "cardHolderName": name,
                              "cvvCode": cvv,
                              "clientId": box.get("userId").toString()
                            });
                            if (!didAdd)
                              print("Error"); //TODO imlementar error snackbar
                            else {
                              Navigator.pop(context);
                              // TODO implementar payment added snackbar
                            }
                          }
                        },
                        child: Text("Add payment method"),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
