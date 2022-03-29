import 'package:finance/finance/widgets/oshin_tab_bar.dart';
import 'package:finance/marketplace/marketplace_tab.dart';
import 'package:finance/services/translation/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const TextStyle TABS_STYLE = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

class MarketplaceScreen extends StatefulWidget {
  static const route = "/marketplace";
  
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  List? docs;
  TabController? _tabController;
  int _tabIndex = 0;
  Box<dynamic>? box;

  void loadScreenKeys() async {
    final keysBox = await Hive.openBox('language');
    final keys = await Translation().loadLanguage('en');
    keysBox.put('keys', keys);
    setState(() {
      box = keysBox;
    });
  }

  String t(String key) {
    return box!.get('keys')[key];
  }

  @override
  void initState() {
    super.initState();
    loadScreenKeys();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    )..addListener(() {
        setState(() => _tabIndex = _tabController!.index);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Marketplace'),
          bottom: OshinTabBar(
            isScrollable: false,
            controller: _tabController,
            tabs: [
              Tab(child: Text("x. Videos", style: TABS_STYLE)),
              Tab(child: Text("x. Images", style: TABS_STYLE)),
              Tab(child: Text("x. Tracks", style: TABS_STYLE)),
            ],
          ),
        ),
        body: _buildTabViews());
  }

  Widget _buildTabViews() => TabBarView(
        controller: _tabController,
        children: [
          MarketplaceTab(type: "video"),
          MarketplaceTab(type: "image"),
          MarketplaceTab(type: "audio")
        ],
      );
}
