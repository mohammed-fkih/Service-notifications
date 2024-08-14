import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_water/firebase_options.dart';
import 'package:the_water/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
   const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'المياه النقية',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:  const Directionality(
            textDirection: TextDirection.rtl,
            

            child: Start()));
  }
}
