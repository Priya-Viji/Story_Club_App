import 'package:flutter_test/flutter_test.dart';
import 'package:story_club/cloudinary_service.dart';

void main() {
  test('provides fallback upload presets for Cloudinary uploads', () {
    final service = CloudinaryService();

    final presets = service.getUploadPresetCandidates();

    expect(presets.first, 'story_club');
    expect(presets, contains('ml_default'));
  });
}
