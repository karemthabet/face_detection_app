import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  File? _image;
  List<Face> faces = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          "Face Detection",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: (_image == null)
                    ? Icon(
                        Icons.camera_alt_rounded,
                        size: 60,
                        color: Colors.teal,
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Faces detected: ${faces.length}",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                pickImage(source: ImageSource.camera);
              },
              icon: Icon(Icons.camera, color: Colors.white),
              label: Text(
                "Detect from Camera",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                pickImage(source: ImageSource.gallery);
              },
              icon: Icon(Icons.image, color: Colors.white),
              label: Text(
                "Detect from Gallery",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        _image = File(image.path);
        faces = [];
      });

      await detectFaces(_image!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future detectFaces(File image) async {
  final options = FaceDetectorOptions(
    performanceMode: FaceDetectorMode.fast,
    enableLandmarks: false, 
    enableClassification: false, 
  );

  final faceDetector = FaceDetector(options: options);
  final inputImage = InputImage.fromFilePath(image.path);

  final detectedFaces = await faceDetector.processImage(inputImage);
  
  setState(() {
    faces = detectedFaces;
  });

  faceDetector.close();
}

}
