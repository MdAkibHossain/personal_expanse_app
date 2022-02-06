import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/transaction.dart';
import '/widgets/chart.dart';
import '/widgets/new_transaction.dart';
import '/widgets/transaction_list.dart';

void main() {
  //
  // if you not want to allow landscape
  //

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expanse',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: const TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                subtitle1: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      amount: 32,
      title: 'New Shoes',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 322,
      title: 'Weekly Grocires',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 32,
      title: 'New Shoes',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 322,
      title: 'Weekly Grocires',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 32,
      title: 'New Shoes',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 322,
      title: 'Weekly Grocires',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 32,
      title: 'New Shoes',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    ),
    Transaction(
      amount: 322,
      title: 'Weekly Grocires',
      id: DateTime.now().toString(),
      date: DateTime.now(),
    )
  ];
  bool _showChart = false;
  void _addNewTransaction(String nwTitle, double nwAmount, DateTime nwDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: nwTitle,
        amount: nwAmount,
        date: nwDate);
    setState(() {
      _transactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(
              txNew: _addNewTransaction,
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteData(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Transaction> get _recentTransaction {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text('Personal Expense'),
      actions: [
        IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );
    final txListWidgets = SizedBox(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          .7,
      child: TransactionList(
        transaction: _transactions,
        deleteData: _deleteData,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Chat'),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (value) {
                      setState(
                        () {
                          _showChart = value;
                        },
                      );
                    },
                  )
                ],
              ),
            if (!isLandscape)
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    .3,
                child: Chart(recentTransaction: _recentTransaction),
              ),
            if (!isLandscape) txListWidgets,
            if (isLandscape)
              _showChart
                  ? SizedBox(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          .7,
                      child: Chart(recentTransaction: _recentTransaction),
                    )
                  : txListWidgets
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => startAddNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
