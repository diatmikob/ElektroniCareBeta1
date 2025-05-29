import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String _cloudName = 'YOUR_CLOUD_NAME'; // Replace with your Cloudinary cloud name
  static const String _uploadPreset = 'YOUR_UPLOAD_PRESET'; // Replace with your upload preset
  
  late final CloudinaryPublic _cloudinary;
  
  CloudinaryService() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  /// Upload image to Cloudinary
  Future<String?> uploadImage({
    required File imageFile,
    String? folder,
    String? publicId,
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder ?? 'elektronicare',
          publicId: publicId,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      
      return response.secureUrl;
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

  /// Upload multiple images to Cloudinary
  Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    String? folder,
  }) async {
    final List<String> uploadedUrls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final url = await uploadImage(
        imageFile: imageFiles[i],
        folder: folder,
        publicId: '${DateTime.now().millisecondsSinceEpoch}_$i',
      );
      
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }

  /// Upload profile image
  Future<String?> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    return await uploadImage(
      imageFile: imageFile,
      folder: 'elektronicare/profiles',
      publicId: 'profile_$userId',
    );
  }

  /// Upload repair request images
  Future<List<String>> uploadRepairImages({
    required List<File> imageFiles,
    required String repairId,
  }) async {
    final List<String> uploadedUrls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final url = await uploadImage(
        imageFile: imageFiles[i],
        folder: 'elektronicare/repairs',
        publicId: '${repairId}_image_$i',
      );
      
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }

  /// Upload technician verification documents
  Future<List<String>> uploadTechnicianDocuments({
    required List<File> documentFiles,
    required String technicianId,
  }) async {
    final List<String> uploadedUrls = [];
    
    for (int i = 0; i < documentFiles.length; i++) {
      final url = await uploadImage(
        imageFile: documentFiles[i],
        folder: 'elektronicare/technician_docs',
        publicId: '${technicianId}_doc_$i',
      );
      
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }

  /// Delete image from Cloudinary
  Future<bool> deleteImage(String publicId) async {
    try {
      await _cloudinary.destroy(publicId);
      return true;
    } catch (e) {
      print('Error deleting image from Cloudinary: $e');
      return false;
    }
  }

  /// Get optimized image URL with transformations
  String getOptimizedImageUrl({
    required String imageUrl,
    int? width,
    int? height,
    String quality = 'auto',
    String format = 'auto',
  }) {
    if (!imageUrl.contains('cloudinary.com')) {
      return imageUrl;
    }

    // Extract public ID from URL
    final uri = Uri.parse(imageUrl);
    final pathSegments = uri.pathSegments;
    final uploadIndex = pathSegments.indexOf('upload');
    
    if (uploadIndex == -1) return imageUrl;

    final publicIdWithExtension = pathSegments.sublist(uploadIndex + 1).join('/');
    final publicId = publicIdWithExtension.split('.').first;

    // Build transformation string
    final transformations = <String>[];
    
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_$format');
    transformations.add('c_fill'); // Crop to fill dimensions

    final transformationString = transformations.join(',');

    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformationString/$publicId';
  }

  /// Get thumbnail URL
  String getThumbnailUrl(String imageUrl, {int size = 150}) {
    return getOptimizedImageUrl(
      imageUrl: imageUrl,
      width: size,
      height: size,
      quality: '80',
    );
  }

  /// Pick and upload image
  Future<String?> pickAndUploadImage({
    required ImageSource source,
    String? folder,
    String? publicId,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality ?? 85,
      );

      if (image == null) return null;

      final File imageFile = File(image.path);
      return await uploadImage(
        imageFile: imageFile,
        folder: folder,
        publicId: publicId,
      );
    } catch (e) {
      print('Error picking and uploading image: $e');
      return null;
    }
  }

  /// Pick and upload multiple images
  Future<List<String>> pickAndUploadMultipleImages({
    String? folder,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
    int? limit,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality ?? 85,
        limit: limit,
      );

      if (images.isEmpty) return [];

      final List<File> imageFiles = images.map((image) => File(image.path)).toList();
      return await uploadMultipleImages(
        imageFiles: imageFiles,
        folder: folder,
      );
    } catch (e) {
      print('Error picking and uploading multiple images: $e');
      return [];
    }
  }
}