import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePick {
  final _picker = ImagePicker();
  final _defaultQulity = 80;

  Future<File> takePhoto() async {
    var response = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: _defaultQulity,
      preferredCameraDevice: CameraDevice.front
    );
    if (response == null) return null;
    return File(response.path);
  }

}
