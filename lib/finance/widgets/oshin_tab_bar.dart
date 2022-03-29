import 'package:flutter/material.dart';

class OshinTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController? controller;
  final bool? isScrollable;
  final List<Widget>? tabs;

  const OshinTabBar(
      {Key? key,
      this.controller,
      this.isScrollable = false,
      @required this.tabs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Color(0xffDAD9E2),
          labelColor: Colors.black,
        ),
      ),
      child: Container(
        color: Colors.grey[100],
        width: double.infinity,
        child: TabBar(
          controller: controller,
          isScrollable: isScrollable ?? false,
          indicatorColor: Color(0xff262628),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: tabs!,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 48);
}
