import 'dart:math';

class GeofenceUtils {
  // Parses a WKT POLYGON((lng lat, lng lat, ...))
  static List<List<double>> parseWktPolygon(String wkt) {
    final inside = wkt.substring(wkt.indexOf('((') + 2, wkt.indexOf('))'));
    final parts = inside.split(',');
    return parts.map((p) {
      final nums = p.trim().split(RegExp(r'\s+'));
      // WKT often is "lon lat"
      final lon = double.parse(nums[0]);
      final lat = double.parse(nums[1]);
      return [lat, lon];
    }).toList();
  }

  // Ray-casting to test lat/lon inside polygon
  static bool pointInPolygon(double lat, double lon, List<List<double>> poly) {
    int i, j = poly.length - 1;
    bool inside = false;
    for (i = 0; i < poly.length; i++) {
      final xi = poly[i][0], yi = poly[i][1];
      final xj = poly[j][0], yj = poly[j][1];
      final intersect = ((yi > lon) != (yj > lon)) &&
          (lat < (xj - xi) * (lon - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
      j = i;
    }
    return inside;
  }

  // Convenience: check WKT with lat/lon
  static bool isInsideWkt(String wkt, double lat, double lon) {
    final poly = parseWktPolygon(wkt);
    return pointInPolygon(lat, lon, poly);
  }
}
