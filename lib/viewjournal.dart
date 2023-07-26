import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class ViewJournal extends StatefulWidget {
  // final int Ind;
  // const ViewJournal({super.key, required this.Ind});
  final Database data;
  final int index;

  ViewJournal({required this.data, required this.index});
  @override
  State<ViewJournal> createState() => _ViewJournalState();
}

class _ViewJournalState extends State<ViewJournal> {
  late int Indx;
  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();
  @override
  void initState() {
    super.initState();
    Indx = widget.index;
    _loadJournalData();
  }

  void _loadJournalData() async { //for loading data from database;
    final db = await widget.data;
    final List<Map<String, dynamic>> journalData = await db.query('names');

    if (journalData.isNotEmpty && Indx >= 0 && Indx < journalData.length) {
      final journalEntry = journalData[Indx];
      setState(() {
        _title.text = journalEntry['title'] ?? 'empty';
        _content.text = journalEntry['content'] ?? 'empty';
      });
    }
  }

  void edited() async {  //for editing data (not working)
    final editJournal =
        Journal(content: _content.text, title: _title.text, date: '11-09-1998');
        final db =await widget.data;
        await db.update(
    'names',
    editJournal.toMap(),
    where: 'id = ?',
    whereArgs: [widget.index],
  );
    Navigator.pop(this.context, editJournal);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set system overlay style based on the selected theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: // themeProvider.isDarkMode ? Colors.black : Colors.white,
            themeProvider.isDarkMode
                ? const Color.fromRGBO(42, 42, 46, 1)
                : const Color.fromRGBO(255, 255, 255, 1),
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      edited();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: const Icon(Icons.arrow_back,
                          size: 30, color: Colors.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      edited();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                controller: _title,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Divider(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                thickness: 1,
              ),
            ),
            //write
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: TextField(
                  controller: _content,
                  maxLines: null,
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
