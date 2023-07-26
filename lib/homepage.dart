import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'search.dart';
import 'data.dart';
import 'appbar.dart';
import 'timeline.dart';
import 'package:sqflite/sqflite.dart';
import 'addJournal.dart';
import 'package:flutter/widgets.dart';
import 'viewJournal.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.databa});//databa:databse passed from main.dart

  final Future<Database> databa;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Journal> journal = [];

  @override
  void initState() {
    super.initState();
    readJournal();
  }

  void navToViewJournal(int index) async {//navigation
    final Db = await widget.databa;

    final editJournal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ViewJournal(
          data: Db,
          index: index,
        ),
      ),
    );
    if (editJournal != null) {
      await Db.transaction((txn) async {
        await Db.update(
          'names',
          editJournal.toMap(),
          where: 'id=?',
          whereArgs: [index],
        );
      });

      print('kpoooi');
    }
  }

  void navToAddJournal() async { //nav to addjournal page;;
  //newJournal is Journal class returning from addJournal;
    final newJournal = await Navigator.push<Journal>(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddJournal(datab: widget.databa),
      ),
    );
    if (newJournal != null) {
      final db = await widget.databa;
      await db.insert('names', newJournal.toMap());
    }
    setState(() {});
  }

  //READ operation
  Future<List<Journal>> readJournal() async {
    final Database db = await widget.databa;
    final List<Map<String, dynamic>> maps = await db.query('names');
    return List.generate(
      maps.length,
      (index) {
        return Journal(
          id: maps[index]['id'] as int?,
          title: maps[index]['title'] as String?,
          content: maps[index]['content'] as String?,
          date: maps[index]['mood'] as String?,
          mood: maps[index]['date'] as String?,
        );
      },
    );
  }

  //DELETE Operation
  Future<void> deleteJournal(int index) async {
    final Database DB = await widget.databa;
    final journalList = await readJournal();
    final journalToDelete = journalList[index];
    await DB.delete(
      'names',
      where: 'id=?',
      whereArgs: [journalToDelete.id],
    );
    refreshJournal();
  }

  //UPDATE operation
  Future<void> refreshJournal() async {
    final journalList = await readJournal();
    setState(() {
      journal = journalList;
    });
  }

  @override
  Widget build(BuildContext context) {
    //themeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set system overlay style based on the selected theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarBrightness:
        //     themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.isDarkMode
            ? Colors.black
            : Color.fromARGB(255, 214, 214, 217),
        body: Stack(  //for stacking the FloatingActionButton
          children: [
            Column(
              children: [
                //AppBar
                AppbaR(),
                //Search
                Search(themeProvider: themeProvider),
                //TimeLine
                TimeLine(),
                //List
                Expanded(
                  child: FutureBuilder<List<Journal>>(
                    future: readJournal(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final journalList = snapshot.data!;
                        return ListView.builder(
                          itemCount: journalList.length,
                          itemBuilder: (context, index) {
                            final journal = journalList[index];
                            return Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkMode
                                    ? const Color.fromRGBO(42, 42, 46, 1)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              journal.title ?? '', //title
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              journal.content ?? '', //content
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal,
                                                color: themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: themeProvider.isDarkMode
                                        ? const Color.fromRGBO(42, 42, 46, 1)
                                        : const Color.fromRGBO(
                                            255, 255, 255, 1),
                                    //for Date and Icons
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Text(
                                            journal.date ?? '', //Date
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            navToViewJournal(index);
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print('kooi');
                                              deleteJournal(index);
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Text('No data available');
                      }
                    },
                  ),
                ),
                //FloatingActionButton
              ],
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  navToAddJournal();
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
