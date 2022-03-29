import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:finance/global/localization_mixing.dart';
import 'package:finance/services/translation/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api.dart';
import 'add_funds_screen.dart';

const TextStyle TITLE_STYLE = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 17,
);

const TextStyle BLUE_TEXT = TextStyle(
  color: Color(0xff2DADF5),
);

class WalletOverviewFragment extends StatefulWidget {
  const WalletOverviewFragment(
      {Key? key,
      @required this.currency,
      @required this.userId,
      @required this.index,
      @required this.payments})
      : super(key: key);

  final String? currency;
  final int? userId;
  final int? index;
  final List<Method>? payments;

  @override
  _WalletOverviewFragmentState createState() => _WalletOverviewFragmentState();
}

class _WalletOverviewFragmentState extends State<WalletOverviewFragment> {
  Map<String, dynamic>? data;
  Box<dynamic>? box;

  @override
  void initState() {
    super.initState();
    loadData();
    loadScreenKeys();
  }

  Future loadData() async {
    final details = await FinanceApi()
        .loadWalletDetails(this.widget.currency!, this.widget.userId!);
    setState(() {
      data = details;
    });
  }

  void _handleOpenAddFundsScreen(BuildContext context, int userId) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddFundsScreen(
              payments: widget.payments,
              userId: userId,
            )));

    await loadData();
  }

  void _handleOpenAutoRechargeScreen(BuildContext context, int userId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Container() //AutoRechargeScreen(),
        ));
  }

  void _handleOpenWithdrawScreen(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Container() //WithdrawScreen(),
            ));
  }

  void _handleOpenTransferCreditScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Container() //TransferCreditScreen(),
        ));
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
    return ValueListenableBuilder(
        valueListenable: Hive.box('authBox').listenable(),
        builder: (context, Box<dynamic> box, widget) {
          return data == null
              ? Scaffold(body: Center(child: CircularProgressIndicator()))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(
                        title: t('finance.balance_title'),
                        subTitle: t('finance.balance_subtitle'),
                      ),
                      _buildDivider(Theme.of(context).primaryColor),
                      _buildBalanceDetails(
                        label: t('finance.deposit_label'),
                        amount: data!['deposit'],
                      ),
                      _buildBalanceDetails(
                        label: t('finance.credits_label'),
                        amount: data!['coinsEarned'],
                      ),
                      _buildBalanceDetails(
                        label: t('finance.promotions_label'),
                        amount: data!['promotions'],
                      ),
                      _buildDivider(),
                      _buildBalanceDetails(
                        label: t('finance.total_label'),
                        amount: data!['currentBalance'],
                      ),
                      _buildFlatButton(
                        label: t('finance.add_funds_button'),
                        onPress: () => _handleOpenAddFundsScreen(
                            context, box.get("userId")),
                      ),
                      SizedBox(height: 8),
                      if (data!['autorecharge'])
                        _buildAutoRechargeEnableSection(context),
                      if (data!['autorecharge'])
                        _buildFlatButton(
                          label: t('finance.configure_auto_recharge_button'),
                          textColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          onPress: () => _handleOpenAutoRechargeScreen(
                              context, box.get('userId')),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(),
                      _buildHeader(
                        title: t('finance.earn_credits_title'),
                        subTitle: t('finance.earn_credits_subtitle'),
                      ),
                      _buildDivider(Theme.of(context).primaryColor),
                      _buildBalanceDetails(
                        label: t('finance.total_earn_credits_label'),
                        amount: data!['currentBalance'],
                      ),
                      _buildFlatButton(
                        label: t('finance.withdraw_button'),
                        onPress: () => _handleOpenWithdrawScreen(context),
                      ),
                      SizedBox(height: 8),
                      _buildFlatButton(
                        label: t('finance.transfer_credits_button'),
                        textColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        onPress: () => _handleOpenTransferCreditScreen(context),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                );
        });
  }

  Widget _buildHeader({
    String title = '',
    String subTitle = '',
    String trailing = '',
  }) =>
      ListTile(
        title: Text(
          title,
          style: TITLE_STYLE,
        ),
        subtitle: Text(subTitle),
        trailing: Text(
          trailing,
          style: BLUE_TEXT,
        ),
      );

  Widget _buildDivider([Color color = Colors.black]) => Divider(
        height: 4,
        indent: 16,
        endIndent: 16,
        color: color,
      );

  Widget _buildBalanceDetails({
    String? label,
    num? amount,
  }) =>
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Text(
          label!,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        trailing: Text(
          '\$ ${amount ?? 0.00}',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );

  Widget _buildFlatButton({
    String label = '',
    Color backgroundColor = const Color(0xffF2F2F2),
    Color textColor = Colors.black,
    VoidCallback? onPress,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FlatButton(
          height: 45,
          textColor: textColor,
          minWidth: double.infinity,
          color: backgroundColor,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          onPressed: onPress != null ? () => onPress() : null,
        ),
      );

  Widget _buildAutoRechargeEnableSection(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _handleOpenAutoRechargeScreen(context, 0),
      child: Column(
        children: [
          ListTile(
              title: Text(
            t('finance.auto_recharge_label'),
            style: TextStyle(color: Colors.black),
          )),
          ListTile(
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xff27AE60),
                ),
                Container(
                  width: 16,
                ),
                Text(t('finance.enabled_label')),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                t('finance.edit_auto_recharge_settings_label'),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: TextStyle(color: Color(0xff2D9CDB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
