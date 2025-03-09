import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:async';

final _databaseHelper = DatabaseHelper();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _databaseHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  final _textControllerPlanName = TextEditingController();
  final _textControllerPlanDetails = TextEditingController();
  // final _textControllerPlanDate = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future openPlanDialog() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text('Create New Plan'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              TextField(
                controller: _textControllerPlanName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Name new plan',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textControllerPlanName.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              TextField(
                controller: _textControllerPlanDetails,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Details',
                  hintText: 'Give plan details',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textControllerPlanDetails.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${selectedDate.toLocal()}".split(' ')[0]),
                    IconButton(
                      onPressed: () {
                        _selectDate(context, setState);
                      },
                    icon: const Icon(Icons.calendar_month),
                  ),
                  ],
                )
              ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _selectDate(context, setState);
                  //   },
                  //   child: const Text('Select date'),
                  // ),
            ],
          );
        },
      ),
    ),
  );

  Future<void> _selectDate(BuildContext context, setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('List Manager Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                openPlanDialog();
              }, 
              child: Text('Add New Plan'))
          ],
        ),
      ),
    );
  }
}
