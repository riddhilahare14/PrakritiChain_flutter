import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/species_list_page.dart';
import 'pages/collection_form_page.dart';
import 'pages/offline_queue_page.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('pending_collections'); // simple box for offline queue
  SyncService.start(); // start listener to auto-sync when online
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrakritiCollector',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => SpeciesListPage(),
        '/collect': (context) => CollectionFormPage(),
        '/queue': (context) => OfflineQueuePage(),
      },
    );
  }
}
