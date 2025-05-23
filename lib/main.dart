import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/config/router.dart';
import 'package:spectrum_app/providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Spectrum App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
