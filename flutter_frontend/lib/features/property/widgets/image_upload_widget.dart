import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme_config.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<File> images;
  final Function(List<File>) onImagesChanged;
  final int maxImages;

  const ImageUploadWidget({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 10,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      
      if (pickedFiles.isNotEmpty) {
        final List<File> newImages = pickedFiles.map((file) => File(file.path)).toList();
        
        // Check if adding these images would exceed the limit
        if (widget.images.length + newImages.length > widget.maxImages) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximum ${widget.maxImages} images allowed'),
              backgroundColor: ThemeConfig.errorColor,
            ),
          );
          return;
        }
        
        setState(() {
          widget.images.addAll(newImages);
        });
        widget.onImagesChanged(widget.images);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  Future<void> _pickSingleImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        if (widget.images.length >= widget.maxImages) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximum ${widget.maxImages} images allowed'),
              backgroundColor: ThemeConfig.errorColor,
            ),
          );
          return;
        }
        
        setState(() {
          widget.images.add(File(pickedFile.path));
        });
        widget.onImagesChanged(widget.images);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      widget.images.removeAt(index);
    });
    widget.onImagesChanged(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Property Images',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeConfig.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${widget.images.length}/${widget.maxImages}',
              style: TextStyle(
                fontSize: 14,
                color: ThemeConfig.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Image Grid
        if (widget.images.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive grid columns based on screen width
              int crossAxisCount = 3;
              if (constraints.maxWidth < 400) {
                crossAxisCount = 2;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 4;
              }
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return _buildImageItem(widget.images[index], index);
                },
              );
            },
          ),
        
        const SizedBox(height: 12),
        
        // Add Image Button
        if (widget.images.length < widget.maxImages)
          GestureDetector(
            onTap: _pickSingleImage,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ThemeConfig.borderColor,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: ThemeConfig.lightBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: ThemeConfig.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add Image',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Add Multiple Images Button
        if (widget.images.length < widget.maxImages)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_box_outlined),
              label: const Text('Add Multiple Images'),
              style: TextButton.styleFrom(
                foregroundColor: ThemeConfig.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(File image, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ThemeConfig.borderColor,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Remove Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        // Primary Image Badge
        if (index == 0)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
