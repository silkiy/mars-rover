import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoCard extends StatelessWidget {
  final dynamic photo;

  const PhotoCard({super.key, required this.photo});

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    try {
      if (await Permission.storage.request().isGranted) {
        var response = await Dio().get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "mars_photo",
        );

        if (result['isSuccess']) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gambar berhasil disimpan!")));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal menyimpan gambar.")));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Izin penyimpanan ditolak!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              photo['img_src'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Camera: ${photo['camera']['full_name']}",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _downloadImage(context, photo['img_src']),
                  icon: const Icon(Icons.download),
                  label: const Text("Download"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
