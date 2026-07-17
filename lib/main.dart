import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icahs_hwr/core/auth_wrapper.dart';
import 'package:icahs_hwr/core/dependancy_injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  DependancyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Ward Rotation',
      theme: ThemeData(
        appBarTheme: AppBarThemeData(
          backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: AuthWrapper(),
    );
  }
}
