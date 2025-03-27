import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'; // ✅ Fix for kIsWeb

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Church',
      theme: ThemeData(
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = 400;
            double width = constraints.maxWidth < maxWidth ? constraints.maxWidth : maxWidth;
            return Center(
              child: SizedBox(
                width: width,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear((width / 360).clamp(0.8, 1.2)), // ✅ Fixed
                  ),
                  child: child!,
                ),
              ),
            );
          },
        );
      },
      home: const SplashScreen(),
    );
  }
}
