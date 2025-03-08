import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:rootine/pages/plant_diagnosis.dart';

class Camera extends StatefulWidget {
  static final String routeId = 'diagnosisPage';
  final String idToken;

  const Camera({Key? key, required this.idToken}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _setupCameraController() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
        );
        await cameraController!.initialize();
        setState(() {});
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void takePicture(BuildContext context) async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        imageFile = await cameraController!.takePicture();
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlantDiagnosis(
              imagePath: imageFile!.path,
              idToken: widget.idToken,
            ),
          ),
        );
      } catch (e) {
        print("Error taking picture: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CameraPreviewScreen(),
      ),
    );
  }

  Widget CameraPreviewScreen() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: CameraPreview(cameraController!),
        ),
        Positioned(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(100, 0, 0, 0),
              onPressed: () => takePicture(context),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
