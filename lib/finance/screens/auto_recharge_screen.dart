import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:finance/global/localization_mixing.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AutoRechargeScreen extends StatefulWidget {
  const AutoRechargeScreen(
      {Key? key, required this.userId, required this.paymentMethods})
      : super(key: key);

  final int userId;
  final List<Method> paymentMethods;

  @override
  State<AutoRechargeScreen> createState() => _AutoRechargeScreenState();
}

class _AutoRechargeScreenState extends State<AutoRechargeScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _autoRechargeEnabled = false;
  final _minAmountController = TextEditingController();
  final _amountController = TextEditingController();
  Box<dynamic>? box;

  String? _selectedPaymentMethod;

  void _handleSwitchChange(BuildContext context, bool value) async {
    var userId = widget.userId;

    // endpoint de activar auto
    setState(() => _autoRechargeEnabled = !_autoRechargeEnabled);
  }

  void _handleSelectPaymentMethod(String? value) {
    setState(() => _selectedPaymentMethod = value);
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

  Widget _buildPaymentMethods(List<Method> paymentMethods) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        var paymentMethod = paymentMethods[index];

        return Container(
          child: RadioListTile<String>(
            dense: false,
            title: Row(
              children: [
               
                  Image.network(
                      'https://cdn.discordapp.com/attachments/854080643634036746/955984857123655710/card.png',
                      height: 35),
                  SizedBox(width: 10),
                  Text(
                      '(${paymentMethod.cardNumber}) ${paymentMethod.cardBrand ?? 'visa'}')
              ],
            ),
            value: paymentMethod.id ?? "",
            groupValue: _selectedPaymentMethod,
            onChanged: _handleSelectPaymentMethod,
          ),
        );
      },
    );
  }

  String _numericValidator(String? value) {
    value ??= '';
    if (value.isEmpty) return t('finance.validation_empty_field');
    var amount = num.tryParse(value);
    if (amount != null && amount <= 0) {
      return t('finance.validation_low_amount');
    }

    return '';
  }

  @override
  void initState() {
    super.initState();
    loadScreenKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(t('finance.auto_recharge_appbar_title')),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                top: 25,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('finance.auto_recharge_header_text'),
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 25),
                  SwitchListTile(
                    title: Text(_autoRechargeEnabled
                        ? t('finance.auto_recharge_enabled_label')
                        : t('finance.auto_recharge_enable_label')),
                    value: _autoRechargeEnabled,
                    onChanged: (value) => _handleSwitchChange(context, value),
                  ),
                  SizedBox(height: 20),
                  AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    vsync: this,
                    child: _autoRechargeEnabled
                        ? _buildForm(context)
                        : Container(),
                  ),
                  if (widget.paymentMethods.isNotEmpty) ...[
                    if (_autoRechargeEnabled) ...[
                      SizedBox(height: 25),
                      Text(
                        t('finance.pick_payment_method_text'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xff0000000),
                        ),
                      ),
                    ],
                    AnimatedOpacity(
                      opacity: _autoRechargeEnabled ? 1 : 0,
                      duration: Duration(seconds: 1),
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 1000),
                        vsync: this,
                        child: _autoRechargeEnabled
                            ? _buildPaymentMethods(widget.paymentMethods)
                            : Container(),
                      ),
                    )
                  ],
                  if (_autoRechargeEnabled)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                      child: FlatButton(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          t('finance.auto_recharge_submit_button'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                        disabledTextColor: Colors.grey,
                        disabledColor: Colors.grey,
                        onPressed: () {
                          //
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('finance.min_amount_label'),
          style: TextStyle(
            color: Color(0xff828282),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _minAmountController,
          keyboardType: TextInputType.number,
          validator: _numericValidator,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.attach_money,
              size: 20,
            ),
            contentPadding: EdgeInsets.only(top: 15),
          ),
        ),
        SizedBox(height: 28),
        Text(
          t('finance.recharge_amount_label'),
          style: TextStyle(
            color: Color(0xff828282),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          validator: _numericValidator,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.attach_money,
                size: 20,
              ),
              contentPadding: EdgeInsets.only(top: 25)),
        ),
      ],
    );
  }
}
