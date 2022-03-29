import 'dart:io';

import 'package:flutter/material.dart';

ThemeData getMainTheme(BuildContext context) => ThemeData(
      primaryColor: Color(0xff2DADF5), 
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        brightness: Brightness.light,
        // backwardsCompatibility: false,
        // systemOverlayStyle: Platform.isIOS
        //     ? null
        //     : SystemUiOverlayStyle(
        //         statusBarColor: Colors.transparent,
        //         statusBarBrightness: Brightness.dark,
        //         statusBarIconBrightness: Brightness.dark,
        //       ),
        iconTheme: IconThemeData(
          color: MaterialColor(0xff262628, {}),
        ),
        titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.black,
            ),
      ),
      fontFamily: 'Roboto',
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.grey.shade400,
        labelColor: Colors.black,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
      ),
    );
