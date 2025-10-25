import 'package:flutter/material.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// A form view for uploading media
///
/// This is a placeholder implementation as uploading is likely
/// handled through different mechanisms in the app.
class UploadFormView extends StatelessWidget {
  static final _log = loggingService.getLogger('UploadFormView');

  const UploadFormView({super.key});

  @override
  Widget build(BuildContext context) {
    _log.debug('Building UploadFormView');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Media'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Media',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a placeholder for the media upload feature.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _showUploadInfoDialog(context);
              },
              child: const Text('Select Media'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Placeholder'),
          content: const Text(
              'Normally this would launch your device\'s media picker.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
