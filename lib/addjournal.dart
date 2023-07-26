import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'data.dart';
import 'package:flutter/widgets.dart';


class AddJournal extends StatefulWidget { //for adda new item to the journal database
  final Future<Database> datab;

  AddJournal({required this.datab});
  

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  void completed() {
    print('kooooooi');
    final newJournal=Journal(content: _content.text,
    title: _title.text,
    date:'11-09-1998'
    );
    Navigator.pop(this.context, newJournal);
  }

  @override
  Widget build(BuildContext context) {
    //themeProvider
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
            //appBar
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      completed();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      completed();
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
            //titile
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                controller: _title,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'title',
                  hintStyle: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            //line
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
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'how was you day??',
                    hintStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
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
