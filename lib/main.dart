import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:async';
import 'package:list_picker/list_picker.dart';

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

  DateTime selectedDate = DateTime.now();

  final _completionStatusController = TextEditingController();

  Future openPlanDialog() => showDialog(
    barrierDismissible: false,
    context: context, 
    builder: (context) => AlertDialog(
      title: Text('Create New Plan'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textControllerPlanName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name*',
                  hintText: 'Name new plan (required)',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textControllerPlanName.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
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
              SizedBox(height: 3.0),
              ListPickerField(
                label: "Completion Status*",
                items: const ["Unbegun", "Ongoing", "Completed"],
                controller: _completionStatusController,
              ),
              SizedBox(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Date:", style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context, setState);
                      },
                    icon: const Icon(Icons.calendar_month),
                  ),
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      if (_textControllerPlanName.text.isNotEmpty  && _completionStatusController.text.isNotEmpty) {
                        _insert(setState);
                        _textControllerPlanName.clear();
                        _textControllerPlanDetails.clear();
                        selectedDate = DateTime.now();
                        _completionStatusController.clear();
                        Navigator.of(context).pop();
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please include a name and completion status.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _textControllerPlanName.clear();
                      _textControllerPlanDetails.clear();
                      selectedDate = DateTime.now();
                      _completionStatusController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Discard'),
                  ),
                ],
              ),
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

  void _insert(setState) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _textControllerPlanName,
      DatabaseHelper.columnStatus: _completionStatusController,
      DatabaseHelper.columnDetails: _textControllerPlanDetails,
      DatabaseHelper.columnDate: selectedDate,
    };
    final id = await _databaseHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

}
