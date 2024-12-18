import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // لاستيراد مكتبة الصور

import '../../bottombar.dart';
import '../../enam.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String userName = "";
  String email = "";
  String? imagePath; // مسار الصورة المختارة
  final ImagePicker _picker = ImagePicker(); // لإنشاء أداة اختيار الصور

  // دالة لاسترجاع البيانات من SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Unknown";
      email = prefs.getString('userEmail') ?? "Unknown";
      imagePath = prefs.getString('userImagePath'); // تحميل مسار الصورة
    });
  }

  // دالة لحفظ مسار الصورة في SharedPreferences
  void _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userImagePath', path); // تخزين مسار الصورة
  }

  // دالة لاختيار صورة من الهاتف
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // فتح معرض الصور
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // تحديث المسار في التطبيق
      });
      _saveImagePath(pickedFile.path); // تخزين المسار في SharedPreferences
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // استرجاع البيانات عند تحميل الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      bottomNavigationBar: bottomNavbar(
        selectedMenue: MenuState.profile,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الكارد الخاص بمعلومات المستخدم
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // صورة المستخدم
                    GestureDetector(
                      onTap: _pickImage, // استدعاء اختيار الصورة عند الضغط
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath!)) // الصورة المختارة
                            : NetworkImage(
                                    "https://www.example.com/profile.jpg")
                                as ImageProvider, // صورة افتراضية
                        child: imagePath == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Name:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      userName,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Email:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
