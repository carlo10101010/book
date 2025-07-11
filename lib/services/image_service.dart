import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

/// Image service for handling book cover images
/// 
/// This service provides functionality to:
/// - Pick images from gallery or camera
/// - Compress images for efficient storage
/// - Convert images to base64 for API transmission
/// - Display images in the UI
class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  /// 
  /// Returns the selected image file or null if cancelled
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Limit width for performance
        maxHeight: 800, // Limit height for performance
        imageQuality: 80, // Compress to 80% quality
      );
      
      return image != null ? File(image.path) : null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Take a photo using the camera
  /// 
  /// Returns the captured image file or null if cancelled
  static Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      return image != null ? File(image.path) : null;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  /// Convert image file to base64 string
  /// 
  /// [imageFile] - The image file to convert
  /// Returns base64 encoded string with data URI prefix
  static Future<String?> imageToBase64(File imageFile) async {
    try {
      // Read the image file as bytes
      final Uint8List bytes = await imageFile.readAsBytes();
      
      // Convert to base64
      final String base64String = base64Encode(bytes);
      
      // Get file extension for proper MIME type
      final String extension = imageFile.path.split('.').last.toLowerCase();
      final String mimeType = _getMimeType(extension);
      
      // Return with data URI prefix
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      debugPrint('Error converting image to base64: $e');
      return null;
    }
  }

  /// Convert base64 string back to image widget
  /// 
  /// [base64String] - The base64 encoded image string
  /// Returns a widget that displays the image
  static Widget base64ToImageWidget(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.book,
          color: Colors.grey[600],
          size: 40,
        ),
      );
    }

    try {
      // Remove data URI prefix if present
      String imageData = base64String;
      if (base64String.startsWith('data:')) {
        imageData = base64String.split(',')[1];
      }

      // Decode base64 to bytes
      final Uint8List bytes = base64Decode(imageData);
      
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.error,
                color: Colors.red[600],
                size: 40,
              ),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Error displaying base64 image: $e');
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.error,
          color: Colors.red[600],
          size: 40,
        ),
      );
    }
  }

  /// Get MIME type based on file extension
  /// 
  /// [extension] - File extension (jpg, png, etc.)
  /// Returns appropriate MIME type string
  static String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default to JPEG
    }
  }

  /// Show image picker dialog
  /// 
  /// [context] - Build context for showing dialog
  /// Returns the selected image file or null if cancelled
  static Future<File?> showImagePickerDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Book Cover'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop(await pickImageFromGallery());
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () async {
                  Navigator.of(context).pop(await takePhotoWithCamera());
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Validate image file size
  /// 
  /// [imageFile] - The image file to validate
  /// [maxSizeMB] - Maximum size in MB (default: 5MB)
  /// Returns true if file size is acceptable
  static Future<bool> validateImageSize(File imageFile, {double maxSizeMB = 5.0}) async {
    try {
      final int fileSize = await imageFile.length();
      final double sizeInMB = fileSize / (1024 * 1024);
      
      return sizeInMB <= maxSizeMB;
    } catch (e) {
      debugPrint('Error validating image size: $e');
      return false;
    }
  }
} 