// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:oshinstar_app/modules/finance/blocs/finance/finance_bloc.dart';
// import 'package:oshinstar_app/modules/finance/blocs/finance/finance_state.dart';
// import 'package:oshinstar_app/modules/finance/models/filter_by.dart';
// import 'package:oshinstar_app/modules/finance/models/filter_transactions_filter.dart';
// import 'package:oshinstar_app/modules/finance/models/time_period.dart';
// import 'package:oshinstar_app/modules/finance/models/transaction.dart';
// import 'package:oshinstar_app/modules/global/blocs/app/app_bloc.dart';
// import 'package:oshinstar_app/modules/languages/localization_mixins.dart';
// import 'package:oshinstar_app/widgets_____/_widgets.dart';
// import 'package:oshinstar_app/modules/finance/models/date_range.dart';

// class TransactionsFragment extends StatefulWidget {
//   @override
//   _TransactionsFragmentState createState() => _TransactionsFragmentState();
// }

// class _TransactionsFragmentState extends State<TransactionsFragment>
//     {
//   ScrollController _listViewController = new ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     
//     // });

//      _setListViewListener();
//       _fetchTransactions();
//   }

//   void _fetchTransactions() {
//     if (context == null) return;

//     var userId =  230 ;// TODO
//     var financeBloc = BlocProvider.of<FinanceBloc>(context);

//     if (financeBloc.state.transactions.isEmpty) {
//       financeBloc.filterTransactions(userId, financeBloc.state.filter);
//     }
//   }

//   void _refresh(BuildContext context) {
//     var userId = BlocProvider.of<AppBloc>(context).state.user.id;
//     var filter = BlocProvider.of<FinanceBloc>(context).state.filter;

//     BlocProvider.of<FinanceBloc>(context).filterTransactions(userId, filter);
//   }

//   void _setListViewListener() {
//     _listViewController.addListener(() {
//       if (_listViewController.position.pixels ==
//           _listViewController.position.maxScrollExtent) {
//         var financeBloc = BlocProvider.of<FinanceBloc>(context);
//         var userId = BlocProvider.of<AppBloc>(context).state.user.id;
//         if (!financeBloc.state.loading &&
//             financeBloc.state.canLoadMoreTransactions) {
//           financeBloc.loadMoreTransactions(
//               userId, financeBloc.state.filter.page + 1);
//         }
//       }
//     });
//   }

//   List<FilterBy> _filterByOptions(BuildContext context) => [
//         FilterBy(
//             name: Translation().t(context, 'finance.all_transactions'),
//             value: 'all',
//             isAny: true),
//         FilterBy(name: Translation().t(context, 'finance.deposit'), value: 'deposit'),
//         FilterBy(name: Translation().t(context, 'finance.transfer_credit'), value: 'credit'),
//         FilterBy(
//             name: Translation().t(context, 'finance.promotions'),
//             value: 'promotions',
//             isDepositType: true),
//         FilterBy(
//             name: Translation().t(context, 'finance.credit_withdraw'),
//             value: 'credit_withdraw')
//       ];

//   void _showFilterByModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//           children: _filterByOptions(context)
//               .map((e) => ListTile(
//                     title: Text(e.name),
//                     onTap: () => _handleTapFilterBy(context, e),
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//   }

//   void _handleTapFilterBy(BuildContext context, FilterBy filterBy) {
//     var userId = BlocProvider.of<AppBloc>(context).state.user.id;

//     var filter = BlocProvider.of<FinanceBloc>(context).state.filter;

//     if (filterBy.isDepositType) {
//       BlocProvider.of<FinanceBloc>(context).filterTransactions(
//         userId,
//         filter.copyWith(depositType: filterBy.value, transactionType: 'all'),
//       );
//     } else {
//       BlocProvider.of<FinanceBloc>(context).filterTransactions(
//         userId,
//         filter.copyWith(depositType: 'all', transactionType: filterBy.value),
//       );
//     }

//     Navigator.of(context).pop();
//   }

//   String _getFilterName(FilterTransactionsFilter filter) {
//     if (filter.transactionType != null && filter.transactionType != 'all') {
//       return _filterByOptions(context)
//           .firstWhere((element) => element.value == filter.transactionType)
//           ?.name;
//     }

//     if (filter.depositType != null && filter.depositType != 'all') {
//       return _filterByOptions(context)
//           .firstWhere((element) => element.value == filter.depositType)
//           ?.name;
//     }

//     return null;
//   }

//   List<TimePeriod> _timePeriodOptions(BuildContext context) => [
//         TimePeriod(name: Translation().t(context, 'finance.all'), isAny: true),
//         TimePeriod(
//             name: Translation().t(context, 'finance.one_week'), value: DateRange(days: 7)),
//         TimePeriod(
//             name: Translation().t(context, 'finance.one_month'), value: DateRange(days: 30)),
//         TimePeriod(
//             name: Translation().t(context, 'finance.15_days'), value: DateRange(days: 15)),
//         TimePeriod(
//             name: Translation().t(context, 'finance.custom_range_of_dates'), isCustom: true),
//       ];

//   void _showPeriodTimeModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//           children: _timePeriodOptions(context)
//               .map((e) => ListTile(
//                     onTap: () => _handleTapTimePeriod(context, e),
//                     title: Text(e.name),
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//   }

//   void _handleTapTimePeriod(BuildContext context, TimePeriod timePeriod) async {
//     var userId = BlocProvider.of<AppBloc>(context).state.user.id;
//     var financeBloc = BlocProvider.of<FinanceBloc>(context);

//     if (timePeriod.isCustom) {
//       var now = DateTime.now();

//       final DateTimeRange picked = await showDateRangePicker(
//         context: context,
//         builder: (context, child) {
//           return Theme(
//             child: child,
//             data: ThemeData.light()
//                 .copyWith(primaryColor: Theme.of(context).primaryColor),
//           );
//         },
//         initialDateRange: DateTimeRange(
//           end: now,
//           start: now.subtract(Duration(days: 10)),
//         ),
//         firstDate: new DateTime(2019),
//         lastDate: now,
//       );

//       if (picked != null && picked.start != null && picked.end != null) {
//         financeBloc.filterTransactions(
//             userId,
//             financeBloc.state.filter.copyWith(
//               dateFrom: picked.start.toUtc().toString(),
//               dateTo: picked.end.add(Duration(hours: 23)).toUtc().toString(),
//             ));
//         Navigator.of(context).pop();
//         return;
//       } else {
//         return;
//       }
//     }

//     if (timePeriod?.isAny == true) {
//       financeBloc.filterTransactions(
//         userId,
//         financeBloc.state.filter.copyWith(dateFrom: 'all', dateTo: 'all'),
//       );
//       Navigator.of(context).pop();
//       return;
//     }

//     var dateFrom = timePeriod.value.dateFrom ??
//         DateTime.now()
//             .subtract(Duration(days: timePeriod.value.days))
//             .toUtc()
//             .toString();

//     financeBloc.filterTransactions(
//       userId,
//       financeBloc.state.filter.copyWith(
//         dateFrom: dateFrom,
//         dateTo: 'all',
//       ),
//     );
//     Navigator.of(context).pop();
//   }

//   String _getTimePeriodName(FilterTransactionsFilter filter) {
//     if (filter.dateFrom == null || filter.dateFrom == 'all')
//       return Translation().t(context, 'finance.all');

//     var dateString = Translation().t(context, 'finance.from') +
//         ' ' +
//         new DateFormat('d MMMM yyyy').format(DateTime.parse(filter.dateFrom));

//     if (filter.dateTo != null && filter.dateTo != 'all') {
//       dateString += Translation().t(context, 'finance.to') +
//           ' ' +
//           new DateFormat('d MMMM yyyy').format(DateTime.parse(filter.dateTo));
//     }

//     return dateString;
//   }

//   Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
//     var formattedDate =
//         new DateFormat('d MMMM yyyy').format(DateTime.parse(transaction.date));

//     var subtitle = 'Missing transaction type descriptions';

//     if (transaction.type == 'credit') {
//       subtitle = Translation().t(context, 'finance.transaction_type_description_credit');
//     }

//     if (transaction.type == 'credit_withdraw') {
//       subtitle =
//           Translation().t(context, 'finance.transaction_type_description_credit_withdraw');
//     }

//     if (transaction.type == 'spent') {
//       subtitle = Translation().t(context, 'finance.transaction_type_description_spent');
//     }

//     if (transaction.type == 'credit_transfer') {
//       subtitle =
//           Translation().t(context, 'finance.transaction_type_description_credit_transfer');
//       transaction.amount = transaction.amount.abs();
//     }

//     if (transaction.type == 'deposit') {
//       subtitle = Translation().t(context, 'finance.transaction_type_description_deposit');
//     }

//     if (transaction.type == 'deposit' &&
//         transaction.depositType == 'credit_transfer') {
//       subtitle = Translation().t(context,
//           'finance.transaction_type_description_transfered_to_balance');
//     }

//     return _buildListItem(
//       context: context,
//       title: formattedDate,
//       status: transaction.status,
//       subtitle: subtitle,
//       amount: transaction.amount,
//       positive: transaction.amount > 0,
//     );
//   }

//   Widget _buildListItem({
//     @required BuildContext context,
//     @required String title,
//     @required String subtitle,
//     @required num amount,
//     @required bool positive,
//     @required String status,
//     VoidCallback onTap,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(top: 25),
//       child: ListTile(
//         title: Text('$title ${status != null ? '($status)' : ''}'),
//         subtitle: Text(subtitle),
//         onTap: onTap,
//         trailing: Container(
//           child: Text(
//             '\$ ' + amount.abs().toString(),
//             style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: positive ? Color(0xff27AE60) : Color(0xffEB5757)),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FinanceBloc, FinanceState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             ListTile(
//               title: Text(Translation().t(context, 'finance.filter_by')),
//               subtitle: Text(_getFilterName(state.filter) ??
//                   Translation().t(context, 'finance.all_transactions')),
//               onTap: () => _showFilterByModal(context),
//             ),
//             ListTile(
//               title: Text(Translation().t(context, 'finance.time_period')),
//               subtitle: Text(_getTimePeriodName(state.filter)),
//               onTap: () => _showPeriodTimeModal(context),
//             ),
//             InkWell(
//               onTap: () => _refresh(context),
//               child: Container(
//                 alignment: Alignment.centerLeft,
//                 padding: EdgeInsets.only(left: 16),
//                 margin: EdgeInsets.only(bottom: 10, top: 5),
//                 child: Text(
//                   Translation().t(context, 'finance.refresh_label'),
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ),
//             Divider(height: 3),
//             if (state.transactions.isEmpty && state.loading)
//               Container(
//                 margin: EdgeInsets.only(top: 50),
//                 child: CircularCenteredLoader(),
//               ),
//             if (state.transactions.isEmpty && !state.loading)
//               ListTile(
//                 title: Text(Translation().t(context, 'finance.no_transaction_found')),
//               ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(top: 10),
//                 child: ListView.builder(
//                   key: new PageStorageKey('transactions_view_list'),
//                   controller: _listViewController,
//                   itemCount: state.transactions.length,
//                   itemBuilder: (context, index) {
//                     var item = _buildTransactionItem(
//                         context, state.transactions[index]);

//                     if (index == state.transactions.length - 1 &&
//                         state.canLoadMoreTransactions == true) {
//                       return Column(
//                         children: [item, CircularCenteredLoader()],
//                       );
//                     }

//                     return item;
//                   },
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
