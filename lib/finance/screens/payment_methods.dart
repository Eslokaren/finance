import 'package:finance/finance/api.dart';
import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:finance/global/localization_mixing.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

enum PaymentMethodAction { setPrimary, setBackup, delete }

class PaymentMethodsScreen extends StatefulWidget {
  PaymentMethodsScreen(
      {Key? key, @required this.userId, @required this.payments})
      : super(key: key);

  final int? userId;
  List<Method>? payments;
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethodsScreen> {
  List? payments;
  Box<dynamic>? box;

  Future refreshPaymentList(dynamic userId) async {
    final newList = await FinanceApi().loadPaymentMethods(userId);
    setState(() {
      widget.payments = newList;
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
  void initState() {
    super.initState();
    loadScreenKeys();
  }

  void _post(Map<String, dynamic> data, int index) async {
    final response = await http.post(
        Uri.parse("https://services.oshinstar.net/v2/finance"),
        body: data);
    if (response.statusCode == 200) {
      // context.read<AppBloc>().showSuccessSnackBar(
      //     content: data['eventType'] == "delete_payment"
      //         ? "Successfully deleted."
      //         : data['eventType'] == "set_primary"
      //             ? "Successfully set as primary."
      //             : data['eventType'] == "set_backup"
      //                 ? "Successfully set as backup"
      //                 : "");
      setState(() {
        refreshPaymentList(data['clientId'].toString());
      });
    } else
      print("error");
    // context.read<AppBloc>().showSuccessSnackBar(
    //     content: "Error updating payment methods. Please try again");
  }

  void editMethod(BuildContext context, PaymentMethodAction action, String? uid,
      int index, int? id) async {
    // final id = context.read<AppBloc>().state.user.id.toString();

    switch (action) {
      case PaymentMethodAction.delete:
        _post({
          "eventType": "delete_payment",
          "uid": uid,
          "clientId": id.toString()
        }, index);

        break;
      case PaymentMethodAction.setBackup:
        _post(
            {"eventType": "set_backup", "uid": uid, "clientId": id.toString()},
            index);
        break;
      case PaymentMethodAction.setPrimary:
        _post(
            {"eventType": "set_primary", "uid": uid, "clientId": id.toString()},
            index);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.payments == null)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    return ValueListenableBuilder(
        valueListenable: Hive.box('authBox').listenable(),
        builder: (context, Box<dynamic> box, widget) {
          return Scaffold(body: _buildMethods(userId: box.get('userId')));
        });
  }

  _buildMethods({@required int? userId}) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.payments!.length,
            itemBuilder: (BuildContext context, int index) {
              bool isPrimary = widget.payments![index].priority == "primary";
              bool isBackup = widget.payments![index].priority == "backup";
              bool isCredit = index == 0;

              return ListTile(
                onLongPress: () => {
                  _showOptionsDrawer(context, isPrimary, isBackup, isCredit,
                      widget.payments![index].uid, index, userId)
                },
                contentPadding: EdgeInsets.all(8),
                leading: index == 0 // TODO CHANGE TO LOCAL URL LINKS
                    ? Image.network(
                        "https://services.oshinstar.net/finance/assets/credit")
                    : Image.network(
                        'https://services.oshinstar.net/finance/assets/card',
                        height: 35),
                isThreeLine: true,
                trailing: index == 0
                    ? null
                    : IconButton(
                        icon: Icon(Icons.more_vert_sharp),
                        onPressed: () => _showOptionsDrawer(
                            context,
                            isPrimary,
                            isBackup,
                            isCredit,
                            widget.payments![index].uid,
                            index,
                            userId),
                      ),
                title: index == 0
                    ? Text("Oshinstar Credits")
                    : Text(
                        "Visa * * * *   * * * *   * * * *  ${widget.payments![index].cardNumber}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index == 0
                        ? Text(t('finance.created_at') + '2/22/2222')
                        : Text(""),
                    if (isPrimary)
                      Text(t('finance.primary'),
                          style: TextStyle(
                            color: Color(0xff2D9CDB),
                            fontWeight: FontWeight.bold,
                          )),
                    if (isBackup)
                      Text(t('finance.backup_method'),
                          style: TextStyle(
                            color: Color(0xff2D9CDB),
                            fontWeight: FontWeight.bold,
                          )),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  void _showOptionsDrawer(BuildContext context, bool primary, bool backup,
      bool credit, String? uid, int index, int? userId) {
    final widgets = [
      ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {
          editMethod(context, PaymentMethodAction.delete, uid, index, userId);
          Navigator.pop(context);
        },
        title: Text(t('finance.modal_delete')),
        leading: Icon(Icons.delete, color: Colors.redAccent),
      ),
      ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {
          editMethod(
              context, PaymentMethodAction.setPrimary, uid, index, userId);
          Navigator.pop(context);
        },
        title: Text(t('finance.modal_set_primary')),
        leading: Icon(
          Icons.star,
          color: Color(0xffF2C94C),
        ),
      ),
      ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {
          editMethod(
              context, PaymentMethodAction.setBackup, uid, index, userId);
          Navigator.pop(context);
        },
        title: Text(t('finance.modal_set_backup')),
        leading: Icon(Icons.restore),
      ),
    ];
    // Not backup, not primary, not credit
    final propertyZero = [
      widgets[0],
      widgets[1],
      widgets[2],
    ];

    // Is primary, not credit, not backup
    final propertyOne = [widgets[0], widgets[2]];

    // Is backup, not primary, not credit
    final propertyTwo = [widgets[0], widgets[1]];

// Is primary, credit, not backup
    final creditZero = [widgets[2]];

// Is backup, credit, not primary
    final creditsOne = [widgets[1]];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: (!backup && !primary && !credit)
            ? propertyZero
            : (primary == true && !credit && !backup)
                ? propertyOne
                : (backup == true && !credit && !primary)
                    ? propertyTwo
                    : (primary == true && credit == true && !backup)
                        ? creditZero
                        : creditsOne,
      ),
    );
  }
}
