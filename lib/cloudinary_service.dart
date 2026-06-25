import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class CloudinaryService {
  final String cloudName = 'duduu1rib';
  final String uploadPreset = 'story_club';

  List<String> getUploadPresetCandidates() {
    final configured = uploadPreset.trim();
    return [
      if (configured.isNotEmpty) configured,
      'story_club',
      'ml_default',
    ].toSet().toList();
  }

  String _errorMessageFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    }
    return 'Cloudinary upload failed';
  }

  Future<String?> uploadFile(File file, {required String resourceType}) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    for (final preset in getUploadPresetCandidates()) {
      try {
        final url = 'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload';
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.uri.pathSegments.isNotEmpty
                ? file.uri.pathSegments.last
                : 'upload',
          ),
          'upload_preset': preset,
          'resource_type': resourceType,
        });

        final response = await dio.post(
          url,
          data: formData,
          options: Options(headers: {'Accept': 'application/json'}),
        );

        debugPrint('Cloudinary response status: ${response.statusCode}');
        debugPrint('Cloudinary response body: ${response.data}');

        if (response.statusCode == 200 && response.data is Map) {
          final secureUrl = response.data['secure_url'];
          if (secureUrl is String && secureUrl.isNotEmpty) {
            return secureUrl;
          }
        }

        final errorMessage = _errorMessageFromResponse(response.data);
        if (errorMessage.toLowerCase().contains('preset') ||
            errorMessage.toLowerCase().contains('upload preset')) {
          continue;
        }

        throw Exception(errorMessage);
      } catch (e) {
        debugPrint('Cloudinary upload error for preset $preset: $e');
        if (preset == getUploadPresetCandidates().last) {
          return null;
        }
      }
    }

    return null;
  }

  Future<String?> uploadImage(File file) async {
    return uploadFile(file, resourceType: 'image');
  }

  Future<String?> uploadAudio(File file) async {
    return uploadFile(file, resourceType: 'video');
  }
}
