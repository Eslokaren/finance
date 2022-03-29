import 'package:finance/finance/repository/finance_manager.dart';
import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:finance/finance/screens/add_payment_method_screen.dart';
import 'package:finance/finance/screens/payment_methods.dart';
import 'package:finance/finance/screens/transactions_screen.dart';
import 'package:finance/finance/screens/wallet_overview_fragment.dart';
import 'package:finance/finance/widgets/oshin_tab_bar.dart';
import 'package:finance/services/translation/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const TextStyle TABS_STYLE = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

class WalletDetails extends StatefulWidget {
  static const String route = '/wallet_details';

  final int initialIndex = 0;

  const WalletDetails(
      {Key? key,
      @required this.currency,
      @required this.userId,
      @required this.index})
      : super(key: key);
  final String? currency;
  final int? userId;
  final int? index;

  @override
  _WalletDetailsState createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails>
    with SingleTickerProviderStateMixin {
  String? currency;
  TabController? _tabController;
  int _tabIndex = 0;

  List<Method>? payments;
  Box<dynamic>? box;

  @override
  void initState() {
    super.initState();
    var userId = widget.userId;

    _loadPaymentMethods(userId.toString());
    loadScreenKeys();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    )..addListener(() {
        setState(() => _tabIndex = _tabController!.index);
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
  void dispose() {
    super.dispose();

    _tabController!.dispose();
  }

  Future _loadPaymentMethods(String userId) async {
    final paymentMethods = await FinanceApiManager().loadPaymentMethods(userId);
    setState(() {
      payments = paymentMethods;
    });
    print("data");
  }

  void _handleOpenInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('finance.information_dialog_title')),
        content: Text(t('finance.information_dialog_content')),
        actions: [
          FlatButton(
            child: Text(t('finance.information_dialog_ok_button')),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _openAddPaymentMethodScreenStripe(BuildContext context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(builder: (context) => AddPaymentMethodScreen()),
    )
        .then((value) async {
      await _loadPaymentMethods(widget.userId.toString());
    });
  }

  Future<void> changeLanguageAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('x. Change language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                    child: Text("English"),
                    onPressed: () async {
                      final keys = await Translation().loadLanguage('en');
                      setState(() {
                        box!.delete('keys');
                        box!.put('keys', keys);
                      });
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: Text("Spanish"),
                    onPressed: () async {
                      final keys = await Translation().loadLanguage('es');
                      setState(() {
                        box!.delete('keys');
                        box!.put('keys', keys);
                      });
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('authBox').listenable(),
        builder: (context, Box<dynamic> box, widget) {
          final id = box.get('userId');
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(t('finance.title')),
                actions: [
                  IconButton(
                      icon: Icon(Icons.store),
                      onPressed: () {
                        Navigator.pushNamed(context, '/marketplace');
                        setState(() {});
                      }),
                  IconButton(
                      icon: Icon(Icons.language),
                      onPressed: () {
                        changeLanguageAlert();
                        setState(() {});
                      }),
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () => _handleOpenInfoDialog(context),
                  )
                ],
                bottom: _buildTabs(context)),
            body: _buildTabViews(id),
            floatingActionButton: _tabIndex == 2 ? _buildButton(context) : null,
          );
        });
  }

  Widget _buildButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box("authBox").listenable(),
        builder: (context, Box<dynamic> box, widget) {
          return FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                    builder: (context) => AddPaymentMethodScreen()),
              )
                  .then((value) async {
                await _loadPaymentMethods(box.get('userId').toString());
                setState(() {});
              });
            },
          );
        });
  }

  PreferredSizeWidget _buildTabs(BuildContext context) => OshinTabBar(
        // isScrollable: true,
        controller: _tabController,
        tabs: [
          Tab(child: Text(t('finance.tab_wallet_overview'), style: TABS_STYLE)),
          Tab(child: Text(t('finance.tab_transaction'), style: TABS_STYLE)),
          Tab(child: Text(t('finance.tab_payment_methods'), style: TABS_STYLE)),
        ],
      );

  Widget _buildTabViews(int userId) => TabBarView(
        controller: _tabController,
        children: [
          WalletOverviewFragment(
              currency: widget.currency,
              userId: widget.userId,
              index: 0,
              payments: payments),
          FinanceTransactionsScreen(),
          PaymentMethodsScreen(userId: userId, payments: payments)
        ],
      );
}
