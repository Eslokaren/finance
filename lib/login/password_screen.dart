import 'dart:convert';

import 'package:finance/finance/screens/wallet_details.dart';
import 'package:finance/global/helpers.dart';
import 'package:finance/login/api.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PasswordScreen extends StatefulWidget {
  static const route = "/password_screen";

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final api = null;
  late String password;

  bool obscureText = true;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('authBox').listenable(),
        builder: (context, Box<dynamic> box, widget) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Wallet'),
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            'Enter your password',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            obscureText: obscureText,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Invalid password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () => setState(() {
                                        obscureText = !obscureText;
                                      })),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final req = await LoginApi()
                                    .login(box.get('email'), password);
                                if (req.statusCode == 200) {
                                  box.put('userId', json.decode(req.body)['i']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WalletDetails(
                                              currency: 'Credit',
                                              userId: box.get('userId'),
                                              index: 2)));
                                } else {
                                  // ADD INCORRECT PASSWORD RED SNACKBAR
                                  showSnackBar(
                                      content: "Incorrect password",
                                      context: context,
                                      backgroundColor: Colors.red);
                                }
                              }
                            },
                            child: Text("Login"),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
