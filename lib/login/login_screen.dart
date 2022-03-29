import 'package:finance/global/helpers.dart';
import 'package:finance/services/translation/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  initState() {
    loadLangs();
    super.initState();
  }

  Box<dynamic>? box;

  void loadLangs() async {
    final keys = await Translation().loadLanguage("en");
    final saveLangsBox = await Hive.openBox('language');
    saveLangsBox.put('keys', keys);

    print(keys);
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final api = null;

  late String email;

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
                            'Welcome!',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill the e-mail field.";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'E-mail Address',
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
                                final canLogin = await login(email);
                                if (!canLogin)
                                  // ADD RED SNACKBAR LOGIN DOES NOT EXIST
                                 showSnackBar(content: "Email does not exist", context: context,backgroundColor: Colors.red);
                                else {
                                  box.put("email", email);
                                  Navigator.pushNamed(
                                      context, '/password_screen');
                                }
                              }
                            },
                            child: Text("Continue"),
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

  Future<bool> login(String email) async {
    final Map data = {"email": email};

    final login = await http.post(
        Uri.parse('https://services.oshinstar.net/auth/check_email_exists'),
        body: data);

    if (login.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
