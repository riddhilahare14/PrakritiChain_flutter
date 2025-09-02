import 'dart:io';
import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../services/sync_service.dart';
import '../services/api_service.dart';

class OfflineQueuePage extends StatefulWidget {
  @override
  _OfflineQueuePageState createState() => _OfflineQueuePageState();
}

class _OfflineQueuePageState extends State<OfflineQueuePage> {
  List<Map> pending = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    pending = LocalStorage.getAllPending();
    setState(() {});
  }

  Future<void> _forceSyncOne(int index) async {
    final p = Map<String, dynamic>.from(pending[index]);
    try {
      if (p['photoPath'] != null) {
        final up = await ApiService.uploadPhoto(File(p['photoPath']));
        p['photoStorageHash'] = up['storageHash'];
        p.remove('photoPath');
      }
      final ok = await ApiService.submitCollection(p);
      if (ok) {
        await LocalStorage.removeAt(index);
        _load();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server rejected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sync error: $e')));
    }
  }

  Future<void> _deleteOne(int index) async {
    await LocalStorage.removeAt(index);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending uploads (${pending.length})'),
      ),
      body: ListView.builder(
        itemCount: pending.length,
        itemBuilder: (_, i) {
          final p = pending[i];
          return ListTile(
            title: Text(p['speciesCode'] ?? 'Unknown'),
            subtitle: Text('Qty: ${p['quantityKg'] ?? '?'}  Time: ${p['collectionTime'] ?? ''}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.sync), onPressed: () => _forceSyncOne(i)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteOne(i)),
              ],
            ),
          );
        },
      ),
    );
  }
}
