import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/homepage.dart';
import '../Addons/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Chat App',
        theme: lightTheme(),
        darkTheme: darkTheme(),
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        getPages: [
          GetPage(name: '/', page: () => const HomeScreen()),
          // GetPage(name: '/chat', page: () => const ChatScreen()),
        ]);
  }
}
