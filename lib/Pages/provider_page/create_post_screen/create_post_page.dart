import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../Models/post.dart';
import '../services/image_helper.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _squareController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  String _selectedGender = 'all';
  List<String> _utilities = [];
  List<File> _selectedImages = [];

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      Get.snackbar(
        'Warning',
        'Maximum 3 images allowed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final images = await ImageHelper.pickImages(
      maxImages: 3 - _selectedImages.length,
    );
    
    setState(() {
      _selectedImages.addAll(images);
    });
  }

  void _addUtility(String utility) {
    if (_utilities.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tối đa 4 tiện ích')),
      );
      return;
    }
    setState(() {
      _utilities.add(utility);
    });
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    final post = Post(
      id: const Uuid().v4(), // Generate unique ID
      title: _titleController.text,
      content: _contentController.text,
      address: _addressController.text,
      status: 'available',
      square: double.parse(_squareController.text),
      price: double.parse(_priceController.text),
      forGender: _selectedGender,
      providerId: '1', // Should be current user ID
      utilities: _utilities
          .asMap()
          .entries
          .map((e) => Utility(id: (e.key + 1).toString(), name: e.value))
          .toList(),
      images: _selectedImages.map((file) => file.path).toList(),
    );

    // TODO: Add post to the list/database
    print(post.toJson());
    
    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng bài thành công')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng phòng trọ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _squareController,
                      decoration: const InputDecoration(
                        labelText: 'Diện tích (m²)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Nhập diện tích';
                        }
                        final square = double.tryParse(value!);
                        if (square == null || square < 1) {
                          return 'Diện tích không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Giá (VNĐ)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Nhập giá';
                        }
                        final price = double.tryParse(value!);
                        if (price == null || price < 100000) {
                          return 'Giá tối thiểu 100,000đ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Đối tượng',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                  DropdownMenuItem(value: 'male', child: Text('Nam')),
                  DropdownMenuItem(value: 'female', child: Text('Nữ')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Tiện ích (tối đa 4):'),
              Wrap(
                spacing: 8,
                children: [
                  ..._utilities.map((utility) => Chip(
                        label: Text(utility),
                        onDeleted: () {
                          setState(() {
                            _utilities.remove(utility);
                          });
                        },
                      )),
                  if (_utilities.length < 4)
                    ActionChip(
                      label: const Text('+ Thêm'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              title: const Text('Thêm tiện ích'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Tên tiện ích',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (controller.text.isNotEmpty) {
                                      _addUtility(controller.text);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Thêm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Hình ảnh (tối đa 3):'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._selectedImages.map((image) => Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.remove(image);
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                    if (_selectedImages.length < 3)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: const Icon(Icons.add_photo_alternate),
                          onPressed: _pickImage,
                          iconSize: 48,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createPost,
                  child: const Text('Đăng bài'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _addressController.dispose();
    _squareController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
