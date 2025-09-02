import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'local_storage.dart';
import 'api_service.dart';
import '../models/collection_model.dart';

class SyncService {
  static void start() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _trySync();
      }
    });
    // Try once at startup
    _trySync();
  }

  static bool _syncing = false;

  static Future<void> _trySync() async {
    if (_syncing) return;
    _syncing = true;
    final pending = LocalStorage.getAllPending();
    for (var i = 0; i < pending.length; i++) {
      try {
        final p = Map<String, dynamic>.from(pending[i]);
        // If photoPath is present and local, upload first
        if (p['photoPath'] != null && (p['photoPath'] as String).isNotEmpty) {
          final file = File(p['photoPath']);
          if (await file.exists()) {
            final up = await ApiService.uploadPhoto(file);
            // put storageHash back into payload and remove local path
            p['photoStorageHash'] = up['storageHash'];
            p.remove('photoPath');
          }
        }
        final ok = await ApiService.submitCollection(p);
        if (ok) {
          await LocalStorage.removeAt(i);
          i--; // because list shifts left
        }
      } catch (e) {
        // stop further sync attempts for now to avoid tight loop; they will auto-retry when connectivity changes
        break;
      }
    }
    _syncing = false;
  }
}
