import 'dart:convert';
import 'dart:io';
import 'package:app/ml/response/disease_info.dart';
import 'package:app/utils/appcolors.dart';
import 'package:app/utils/texttheme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // For getting the filename

class DiseaseDetectionView extends StatefulWidget {
  @override
  _DiseaseDetectionViewState createState() => _DiseaseDetectionViewState();
}

class _DiseaseDetectionViewState extends State<DiseaseDetectionView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  DiseaseInfo? _diseaseInfo;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    const String url =
        'http://172.22.26.21:5000/predict/disease'; // Replace with your API URL

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          filename: basename(_image!.path),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseString);
        setState(() {
          _diseaseInfo = DiseaseInfo.fromJson(jsonResponse);
        });
      } else {
        print('Image upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during image upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors for background and buttons
    final Color backgroundColor = AppColors.kBackground;
    final Color primaryButtonColor = AppColors.kSecondary;
    final Color secondaryButtonColor = AppColors.kSecondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Disease Detection',
          style: TextPref.opensans.copyWith(color: Colors.white),
        ),
        backgroundColor: primaryButtonColor, // AppBar color
      ),
      body: Container(
        color: backgroundColor, // Apply background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Full-width buttons
            children: [
              _image == null
                  ? Text(
                      'No image selected.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  : Image.file(_image!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      secondaryButtonColor, // Secondary color button
                  textStyle: TextStyle(fontSize: 16),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Pick Image from Gallery',
                    style: TextPref.opensans.copyWith(color: Colors.white)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor, // Primary color button
                  textStyle: TextStyle(fontSize: 16),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Upload Image',
                    style: TextPref.opensans.copyWith(color: Colors.white)),
              ),
              SizedBox(height: 16),
              if (_diseaseInfo != null) ...[
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disease Name: ${_diseaseInfo!.diseaseName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: ${_diseaseInfo!.description}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Prevention: ${_diseaseInfo!.prevention}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Supplement: ${_diseaseInfo!.supplement}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
