import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker _picker = ImagePicker();
  @override
  Future<List<String>?> selectMultiplePhotos() {
    // TODO: implement selectMultiplePhotos
    throw UnimplementedError();
  }

  @override
  Future<String?> selectPhoto() async {
    // Pick an image.
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // le digo que quiero un 80% de calidad de la imagen
    );
    if (photo == null) return null;
    //debugPrint('Tenemos una imagen ${photo.path}');
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    // Capture a photo.
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      //imageQuality: 80, // le digo que quiero un 80% de calidad de la imagen
      // que abra por defecto la cámara trasera, aunque el usuario lo puede cambiar después
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;
    //debugPrint('Tenemos una imagen ${photo.path}');
    return photo.path;
  }
}
