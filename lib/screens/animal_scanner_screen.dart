import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AnimalScannerScreen extends StatefulWidget {
  const AnimalScannerScreen({super.key});

  @override
  State<AnimalScannerScreen> createState() => _AnimalScannerScreenState();
}

class _AnimalScannerScreenState extends State<AnimalScannerScreen> {
  final picker = ImagePicker();
  final labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.55),
  );

  XFile? image;
  List<ImageLabel> labels = const [];
  Map<String, Object?>? details;
  bool scanning = false;
  String? error;

  @override
  void dispose() {
    labeler.close();
    super.dispose();
  }

  Future<void> scan(ImageSource source) async {
    final selected = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (selected == null) return;

    setState(() {
      image = selected;
      labels = const [];
      details = null;
      error = null;
      scanning = true;
    });

    try {
      final found =
          await labeler.processImage(InputImage.fromFilePath(selected.path));
      final ranked = [...found]
        ..sort((a, b) => b.confidence.compareTo(a.confidence));
      final likely = ranked.take(4).toList();
      Map<String, Object?>? knowledge;
      if (likely.isNotEmpty) {
        knowledge = await _loadDetails(likely.first.label);
      }
      if (!mounted) return;
      setState(() {
        labels = likely;
        details = knowledge;
        scanning = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'I could not identify this picture. Try a clear, well-lit animal photo.';
        scanning = false;
      });
    }
  }

  Future<Map<String, Object?>?> _loadDetails(String label) async {
    try {
      final title = Uri.encodeComponent(label.replaceAll(' ', '_'));
      final response = await http.get(
        Uri.parse(
          'https://en.wikipedia.org/api/rest_v1/page/summary/$title',
        ),
        headers: const {
          'Api-User-Agent':
              'CurioVerse/0.1 (educational app; https://github.com/tvc-ext/curioverse)',
        },
      );
      if (response.statusCode != 200) return null;
      return jsonDecode(response.body) as Map<String, Object?>;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal Picture Scanner')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Card(
            color: Color(0xFFE8F5E9),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.privacy_tip_rounded, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Private by design: image recognition runs on this device. Your photo is not uploaded; only the detected label is used to request a public fact summary.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (image == null)
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E1FF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text('🐾', style: TextStyle(fontSize: 100)),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.file(
                File(image!.path),
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: scanning ? null : () => scan(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Take photo'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: scanning ? null : () => scan(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Choose picture'),
                ),
              ),
            ],
          ),
          if (scanning) ...[
            const SizedBox(height: 28),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 10),
            const Center(child: Text('Looking for visual clues…')),
          ],
          if (error != null) ...[
            const SizedBox(height: 18),
            Card(
              color: const Color(0xFFFFE2E2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(error!),
              ),
            ),
          ],
          if (labels.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              'My best guesses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: labels
                  .map(
                    (label) => Chip(
                      avatar: const Icon(Icons.pets_rounded, size: 18),
                      label: Text(
                        '${label.label} · ${(label.confidence * 100).round()}%',
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Text(
              'AI guesses can be wrong. Compare the picture with trusted references.',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ],
          if (details != null) ...[
            const SizedBox(height: 18),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (details!['title'] as String?) ?? labels.first.label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (details!['extract'] as String?) ??
                          'No extra details are available yet.',
                      style: const TextStyle(height: 1.45),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Source: Wikipedia · CC BY-SA',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
