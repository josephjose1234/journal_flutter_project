import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class Search extends StatefulWidget { //for showing search bar only not working
  const Search({
    super.key,
    required this.themeProvider,
  });
  final ThemeProvider themeProvider;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

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
    return Column(children: [
      GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? const Color.fromRGBO(42, 42, 46, 1)
                  : const Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
                hintStyle: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
                hintText: 'Search..',
                border: InputBorder.none),
          ),
        ),
      ),
    ]);
  }
}