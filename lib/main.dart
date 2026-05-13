import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad/data/db_manager.dart';
import 'package:mad/screen/startup_screen.dart';
import 'package:mad/widgets/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'data/file_storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for Windows/Desktop
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Sqflite DB
  await DbManager.instance.database;

  // File Storage
  final fileStorageManager = FileStorageManager();
  await fileStorageManager.initFileStorage();

  // await fileStorageManager.saveFileStorage();

  await fileStorageManager.readFileStorage();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: app_background,
        ),
      ),
      home: StartupScreen(),
    );
  }
}