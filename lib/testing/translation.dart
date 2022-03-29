import 'package:flutter/material.dart';
import 'package:finance/services/translation/translation_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TranslationTest extends StatefulWidget {
  @override
  State<TranslationTest> createState() => _TranslationTestState();
}

class _TranslationTestState extends State<TranslationTest> {
  dynamic box;

  @override
  void initState() {
    loadLangs();
    super.initState();
  }

  void loadLangs() async {
    final keys = await Translation().loadLanguage("en");
    final saveLangsBox = await Hive.openBox('language');
    setState(() {
      box = saveLangsBox;
    });
    saveLangsBox.put('keys', keys);
  }

  @override
  Widget build(BuildContext context) {
    if (box == null) return CircularProgressIndicator();
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            height: 50.0,
          ),
          ElevatedButton(
            child: Text(box.get('keys')[
                'job_front.job_screen.body.positions.apply_to_position_button']),
            onPressed: () async {},
          ),
          Container(
            height: 50.0,
          ),
          ElevatedButton(
            child: Text("Load Keys"),
            onPressed: () async {
              final keys = box.get('keys');
              print(keys);
            },
          ),
        ],
      )),
    );
  }
}
