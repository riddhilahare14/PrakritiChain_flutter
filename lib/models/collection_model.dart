class CollectionModel {
  String batchId; // you can generate or let backend generate
  String speciesCode;
  double latitude;
  double longitude;
  double quantityKg;
  Map<String, dynamic>? initialQualityMetrics;
  String? photoPath; // local path until uploaded
  String collectorId; // current user id
  DateTime collectionTime;

  CollectionModel({
    required this.batchId,
    required this.speciesCode,
    required this.latitude,
    required this.longitude,
    required this.quantityKg,
    this.initialQualityMetrics,
    this.photoPath,
    required this.collectorId,
    required this.collectionTime,
  });

  Map<String, dynamic> toJson() => {
        'batchId': batchId,
        'speciesCode': speciesCode,
        'location': {'lat': latitude, 'lng': longitude},
        'quantityKg': quantityKg,
        'initialQualityMetrics': initialQualityMetrics,
        'photoPath': photoPath,
        'collectorId': collectorId,
        'collectionTime': collectionTime.toUtc().toIso8601String(),
      };

  static CollectionModel fromJson(Map<String, dynamic> j) => CollectionModel(
        batchId: j['batchId'],
        speciesCode: j['speciesCode'],
        latitude: j['location']['lat'] + 0.0,
        longitude: j['location']['lng'] + 0.0,
        quantityKg: (j['quantityKg'] as num).toDouble(),
        initialQualityMetrics: j['initialQualityMetrics'],
        photoPath: j['photoPath'],
        collectorId: j['collectorId'],
        collectionTime: DateTime.parse(j['collectionTime']).toLocal(),
      );
}
