import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import '../services/geofence_utils.dart';
import '../services/local_storage.dart';
import '../services/api_service.dart';

class CollectionFormPage extends StatefulWidget {
  @override
  _CollectionFormPageState createState() => _CollectionFormPageState();
}

class _CollectionFormPageState extends State<CollectionFormPage> {
  Map<String, dynamic>? species;
  double? quantityKg;
  Map<String, dynamic> quality = {};
  String? photoPath;
  double? lat, lng;
  bool saving = false;

  final picker = ImagePicker();
  final uuid = Uuid();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map<String, dynamic>) species = args;
  }

  Future<bool> _ensurePermissions() async {
    final cam = await Permission.camera.request();
    final loc = await Permission.locationWhenInUse.request();
    return cam.isGranted && loc.isGranted;
  }

  Future<void> _takePhoto() async {
    final ok = await _ensurePermissions();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera/Location permission needed')));
      return;
    }
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) setState(() => photoPath = picked.path);
  }

  Future<void> _getLocation() async {
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = pos.latitude;
      lng = pos.longitude;
    });
  }

  bool _checkGeofence() {
    final wkt = species?['geoFence'] as String?;
    if (wkt == null || lat == null || lng == null) return true; // no fence => allow
    try {
      return GeofenceUtils.isInsideWkt(wkt, lat!, lng!);
    } catch (e) {
      return true; // fallback to allow but consider logging
    }
  }

  Future<void> _saveOrSubmit() async {
    if (species == null || lat == null || lng == null || quantityKg == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all required fields')));
      return;
    }
    final inside = _checkGeofence();
    if (!inside) {
      // If outside fence, show warning but let user decide to continue or not
      final proceed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Outside geofence'),
          content: Text('You are outside allowed harvesting area for this species. Do you want to continue?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Continue')),
          ],
        ),
      );
      if (proceed != true) return;
    }

    setState(() => saving = true);
    // Build payload
    final collection = {
      'batchId': uuid.v4(),
      'speciesCode': species!['speciesCode'],
      'location': {'lat': lat, 'lng': lng},
      'quantityKg': quantityKg,
      'initialQualityMetrics': quality.isEmpty ? null : quality,
      'photoPath': photoPath,
      'collectorId': 'CURRENT_USER_ID', // TODO: replace with real user id
      'collectionTime': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      // Try upload & submit immediately if online
      final connectivity = await (Connectivity().checkConnectivity());
      if (connectivity != ConnectivityResult.none) {
        // If photo exists, upload first
        if (photoPath != null) {
          final uploaded = await ApiService.uploadPhoto(File(photoPath!));
          collection['photoStorageHash'] = uploaded['storageHash'];
          collection.remove('photoPath');
        }
        final ok = await ApiService.submitCollection(collection);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Collection submitted')));
          Navigator.pop(context);
        } else {
          // fallback to local save
          await LocalStorage.addPending(collection);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved offline (server returned error)')));
          Navigator.pop(context);
        }
      } else {
        // Save locally
        await LocalStorage.addPending(collection);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved offline')));
        Navigator.pop(context);
      }
    } catch (e) {
      // On any error save locally
      await LocalStorage.addPending(collection);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved offline (error)')));
      Navigator.pop(context);
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collect — ${species?['commonName'] ?? ''}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.my_location),
              label: Text(lat == null ? 'Get GPS location' : 'Location: ${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}'),
              onPressed: _getLocation,
            ),
            SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Quantity (kg)'),
              onChanged: (v) => quantityKg = double.tryParse(v),
            ),
            SizedBox(height: 12),
            Text('Quality metrics (optional)'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Moisture %'),
              keyboardType: TextInputType.number,
              onChanged: (v) => quality['moisture'] = double.tryParse(v ?? '') ?? null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Notes'),
              onChanged: (v) => quality['notes'] = v,
            ),
            SizedBox(height: 12),
            if (photoPath != null) Image.file(File(photoPath!)),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text('Take Photo'),
                  onPressed: _takePhoto,
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text('Save / Submit'),
                  onPressed: saving ? null : _saveOrSubmit,
                ),
              ],
            ),
            if (saving) Padding(padding: EdgeInsets.only(top:12), child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
