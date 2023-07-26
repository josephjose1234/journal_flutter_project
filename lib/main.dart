import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'homepage.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensures necessary Widgets are properly initialized.
  final database = openDatabase(
    join(await getDatabasesPath(), 'names.db'),
    onCreate: (db, version) {
      // onCreate is called if the database did not exist prior to calling.
      return db.execute(
        'CREATE TABLE names(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,content TEXT ,mood TEXT,date TEXT)',
        // Creating a table with key, name, etc.
      );
    },
    version: 1,
  );
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      builder: (context, _) => MyApp(
        databas: database,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<Database> databas;
  MyApp({required this.databas});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //hides debug banner;
      home: HomePage(databa:databas),
    );
  }
}
