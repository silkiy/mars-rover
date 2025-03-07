import 'package:flutter/material.dart';
import 'dart:math';
import '../services/nasa_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<dynamic>> groupedPhotos = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    NasaApiService nasaApiService = NasaApiService();
    Map<String, List<dynamic>> data = await nasaApiService.fetchPhotos();

    setState(() {
      groupedPhotos = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mars Rover Photos")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : groupedPhotos.isEmpty
              ? const Center(child: Text("No photos available"))
              : ListView(
                padding: const EdgeInsets.all(8.0),
                children:
                    groupedPhotos.entries.map((entry) {
                      String date = entry.key;
                      List<dynamic> photos = entry.value;

                      List<dynamic> limitedPhotos = photos.sublist(
                        0,
                        min(photos.length, 20),
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          title: Text("📅 $date"),
                          children:
                              limitedPhotos.map((photo) {
                                return ListTile(
                                  leading: Image.network(
                                    photo['img_src'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(photo['rover']['name']),
                                  subtitle: Text(photo['camera']['full_name']),
                                );
                              }).toList(),
                        ),
                      );
                    }).toList(),
              ),
    );
  }
}
