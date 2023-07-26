import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AppbaR extends StatelessWidget {
  const AppbaR({super.key});

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
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        'Journal',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}