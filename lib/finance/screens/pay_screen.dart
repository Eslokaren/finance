import 'package:finance/finance/repository/finance_manager.dart';
import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:finance/finance/screens/add_funds_screen.dart';
import 'package:finance/finance/screens/add_payment_method_screen.dart';
import 'package:finance/finance/widgets/oshin_tab_bar.dart';
import 'package:finance/marketplace/api.dart';
import 'package:finance/marketplace/models/doc.dart';
import 'package:finance/marketplace/models/media_details.dart';
import 'package:finance/marketplace/widgets/information_modal.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

class PayScreen extends StatefulWidget {
  const PayScreen(
      {Key? key, required this.doc, required this.isFromSubscription})
      : super(key: key);

  final Doc doc;
  final bool isFromSubscription;

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen>
    with SingleTickerProviderStateMixin {
  Box<dynamic>? box;
  TabController? _tabController;
  num? currentBalance;
  String? _paymentMethodId;
  List<Method>? paymentMethods;
  var userWallet;
  bool isStateLoading = true;
  late Doc doc;
  bool _isInformationModalShown = false;
   MediaDetails? details;

  Future<void> _loadInitialData() async {
    userWallet =
        await FinanceApiManager().loadWalletDetails('Credit', doc.userId ?? 0);
    var data = await FinanceApiManager()
        .loadPaymentMethods('${doc.userId}', payScreen: true);
    setState(() {
      paymentMethods = data;
      currentBalance = userWallet["currentBalance"];
      isStateLoading = false;
    });
  }

  void _handleOpenAddFundsScreen(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          AddFundsScreen(userId: doc.userId, payments: paymentMethods),
    ));

    await _loadInitialData();
  }

  void _handleChangePaymentMethod(String? value) {
    setState(() => _paymentMethodId = value);
  }

  void _handleOpenAddPaymentMethod(BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddPaymentMethodScreen()));
    await _loadInitialData();
  }

  Future<void> _showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        actionsPadding: EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t('membership.finalize_purshase_screen.payment_success.title'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            WebsafeSvg.asset(
              'lib/assets/images/check.svg',
              width: 50,
              height: 50,
            ),
            SizedBox(height: 15),
            Text(
              t('membership.finalize_purshase_screen.payment_success.subtitle'),
            ),
            SizedBox(height: 15),
            Container(
              width: 150,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  t('membership.finalize_purshase_screen.payment_success.ok'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _payWithBalance(BuildContext context, num balance) async {
    int price = doc.price != null ? doc.price!.round() : 0;
    if (balance >= price) {
      bool success = !widget.isFromSubscription
          ? await FinanceApiManager().buyMedia(
              userId: '${doc.userId}',
              mediaId: doc.id,
              amount: price,
              methodUid: '0',
            )
          : await FinanceApiManager().buySubscription(
              userId: '${doc.userId}',
              amount: price,
              methodUid: '0',
              targetId: "o"); //TODO);

      if (success) {
        await _showSuccessDialog(context);
        Navigator.of(context).pop(true);
      } else {
        _showPayErrorMessage(context);
      }
    } else {
      _showPayErrorMessage(context);
    }
  }

  _showPayErrorMessage(BuildContext context) {
    _showErrorMessage(
      context,
      message: t(
          'membership.finalize_purshase_screen.error_pay_with_balance.dialog_messsage'),
      ok: t(
          'membership.finalize_purshase_screen.error_pay_with_balance.dialog_ok_button'),
      title: t(
          'membership.finalize_purshase_screen.error_pay_with_balance.dialog_title'),
    );
  }

  Future<void> _payWithCard(
      BuildContext context, List<Method> paymentMethods) async {
    int price = doc.price != null ? doc.price!.round() : 0;
    bool success = widget.isFromSubscription
        ? await FinanceApiManager().buySubscription(
            userId: '${doc.userId}',
            amount: price,
            methodUid: _paymentMethodId,
            targetId: '0') //TODO),
        : await FinanceApiManager().buyMedia(
            userId: '${doc.userId}',
            mediaId: doc.id,
            amount: price,
            methodUid: _paymentMethodId,
          );

    if (success) {
      await _showSuccessDialog(context);
      Navigator.of(context).pop(true);
    } else {
      _showErrorMessage(
        context,
        title: t(
            'membership.finalize_purshase_screen.error_pay_with_card.dialog_title'),
        message: t(
            'membership.finalize_purshase_screen.error_pay_with_card.dialog_messsage'), //result.isDetail ? result.detailResponse : 'Transaction error',
        ok: t(
            'membership.finalize_purshase_screen.error_pay_with_card.dialog_ok_button'),
      );
    }
  }

  void _showErrorMessage(
    BuildContext context, {
    required String title,
    required String message,
    required String ok,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        actionsPadding: EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 10),
            WebsafeSvg.asset(
              'lib/assets/images/error.svg',
              height: 80,
              width: 80,
            ),
            SizedBox(height: 10),
            Text(message),
            SizedBox(height: 10),
            Container(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  ok,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(
    BuildContext context,
    num balance,
    List<Method> paymentMethods,
  ) {
    if (_paymentMethodId == null) return;

    if (_paymentMethodId == '0') {
      _payWithBalance(context, balance);
    } else {
      _payWithCard(context, paymentMethods);
    }
  }

  Widget _buildAddPaymentmethodOption(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(left: 20),
      title: Text(
        t('membership.finalize_purshase_screen.add_payment_method_label'),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
        ),
      ),
      onTap: () => _handleOpenAddPaymentMethod(context),
    );
  }

  Widget _buildPaymentMethods(List<Method> paymentMethods) {
    var options = paymentMethods
        .map<Widget>((e) => RadioListTile<String>(
              dense: true,
              title: Row(
                children: [
                  Image.asset('lib/assets/images/card.png', height: 35),
                  SizedBox(width: 10),
                  Text(
                      "${t('membership.finalize_purshase_screen.card_purshase_label')} (${e.cardNumber}) ${e.cardBrand ?? "visa"})")
                ],
              ),
              value: e.id ?? "0",
              groupValue: _paymentMethodId,
              onChanged: _handleChangePaymentMethod,
            ))
        .toList()
          ..add(ListTile());

    return ListView(
      shrinkWrap: true,
      children: [
        _buildAddPaymentmethodOption(context),
        ...options,
      ],
    );
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

  List<Widget> _informationModal(Doc doc, MediaDetails details) => [
        GestureDetector(
          child: Container(color: Colors.black38),
          onTap: _notifyInformationModalChanges,
        ),
        SafeArea(
          child: ExpandableScrollableModal(
            onModalDismiss: _notifyInformationModalChanges,
            child: InformationContent(
                _notifyInformationModalChanges, doc, details),
          ),
        ),
      ];

  @override
  void initState() {
    doc = widget.doc;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      details = await MarketplaceApi().getMediaDetails(doc.id ?? 0);
    });
    loadScreenKeys();
    _loadInitialData();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  void _notifyInformationModalChanges() {
    setState(() {
      _isInformationModalShown = !_isInformationModalShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title:
              Text('membership.finalize_purshase_screen.payment_method_label'),
          actions: [
            IconButton(
                onPressed: () => _notifyInformationModalChanges(),
                icon: Icon(
                  Icons.info,
                ))
          ],
        ),
        body: isStateLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildItemPreview(),
                    _buildPaymentMethodsTitle(),
                    _buildTabs(),
                    _buildTabViews(
                        paymentMethods: paymentMethods ?? [],
                        balance: currentBalance ?? 0),
                  ],
                ),
              ),
        bottomSheet: _buildBuyButton(
            context: context,
            price: doc.price != null ? doc.price!.toInt() : 0,
            balance: currentBalance ?? 0,
            disabled: _paymentMethodId == null,
            paymentMethod: paymentMethods ?? []),
      ),
      if (_isInformationModalShown  && details != null)
        ..._informationModal(doc, details!)
    ]);
  }

  Widget _buildBuyButton({
    required BuildContext context,
    required int price,
    num balance = 0,
    required List<Method> paymentMethod,
    bool disabled = false,
  }) =>
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: disabled ? Colors.grey : Theme.of(context).primaryColor,
          ),
          onPressed: disabled
              ? () => _showErrorMessage(
                    context,
                    title: t(
                        'membership.finalize_purshase_screen.select_payment_method_dialog.title'),
                    message: t(
                        'membership.finalize_purshase_screen.select_payment_method_dialog.subtitle'),
                    ok: t(
                        'membership.finalize_purshase_screen.select_payment_method_dialog.ok'),
                  )
              : () => _handleSubmit(context, balance, paymentMethod),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    t('membership.finalize_purshase_screen.purchase_button'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              if (price != null)
                Text(
                  '\$ $price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
            ],
          ),
        ),
      );

  Widget _errorBuilder(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return Container(
      color: Colors.red,
      width: 0,
      height: 0,
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      child: OshinTabBar(
        controller: _tabController,
        tabs: [
          Tab(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet),
              SizedBox(width: 5),
              Text(
                t('membership.finalize_purshase_screen.balance_title'),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          )),
          Tab(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/card.png',
                height: 35,
              ),
              SizedBox(width: 5),
              Text(t('membership.finalize_purshase_screen.card_title'),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  )),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Text(
          t('membership.finalize_purshase_screen.payment_method_label'),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  List<Widget> _buildItemPreview() {
    return [
      ListTile(
        dense: false,
        minLeadingWidth: 0,
        leading: doc.thumbnail == null
            ? null
            : Image.network(doc.thumbnail ?? '', errorBuilder: _errorBuilder),
        title: Text(
          doc.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // isThreeLine: DateTime.now().toIso8601String() != null,
        // subtitle: details.date == null
        //     ? Text(details.subtitle ?? '')
        //     : Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(details.subtitle ?? ''),
        //           SizedBox(height: 3),
        //           Text(
        //             details.date!,
        //             style: TextStyle(color: Theme.of(context).primaryColor),
        //           )
        //         ],
        //       ),
      ),
      Divider(thickness: 1)
    ];
  }

  Widget _buildTabViews({
    required List<Method> paymentMethods,
    required num balance,
  }) =>
      SizedBox(
        height: 350,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBalanceSection(),
            _buildPaymentMethods(paymentMethods),
          ],
        ),
      );

  Widget _buildBalanceSection() {
    return ListView(
      shrinkWrap: true,
      children: [
        RadioListTile<String>(
          title: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 30,
              ),
              SizedBox(width: 5),
              Text(t('membership.finalize_purshase_screen.curren_balance')),
              SizedBox(width: 5),
              Text(
                '\$ ${currentBalance ?? 00.0}',
                style: TextStyle(color: Colors.green),
              )
            ],
          ),
          value: '0',
          groupValue: _paymentMethodId,
          onChanged: _handleChangePaymentMethod,
        ),
        Divider(),
        ListTile(
            onTap: () => _handleOpenAddFundsScreen(context),
            leading: Image.asset(
              'lib/assets/images/earn_credit.png',
              width: 40,
              height: 40,
            ),
            title: Text(t(
                'membership.finalize_purshase_screen.recharge_balance_title')),
            subtitle: Text(t(
                'membership.finalize_purshase_screen.recharge_balance_subtitle')))
      ],
    );
  }
}
