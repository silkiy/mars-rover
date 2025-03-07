import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = "gEsztaQzZEy8MfmmhT6Js4TQrJpy4vopA2tcboYb";

class NasaApiService {
  Future<Map<String, List<dynamic>>> fetchPhotos() async {
    List<String> rovers = ["curiosity", "opportunity", "spirit"];
    Map<String, List<dynamic>> tempGroupedPhotos = {};

    for (String rover in rovers) {
      final response = await http.get(
        Uri.parse(
          "https://api.nasa.gov/mars-photos/api/v1/rovers/$rover/photos?sol=1000&api_key=$apiKey",
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> photos = jsonDecode(response.body)['photos'];

        for (var photo in photos) {
          String date = photo['earth_date'];

          if (!tempGroupedPhotos.containsKey(date)) {
            tempGroupedPhotos[date] = [];
          }

          // Batasi hanya 20 foto per tanggal
          if (tempGroupedPhotos[date]!.length < 20) {
            tempGroupedPhotos[date]!.add(photo);
          }
        }
      }
    }

    return tempGroupedPhotos;
  }
}
