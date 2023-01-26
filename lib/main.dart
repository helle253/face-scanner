import 'dart:io';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:cross_file/cross_file.dart';

import 'encoders/encode_to_obj.dart';

void main() {
  runApp(const MaterialApp(home: FaceDetectionPage()));
}

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({Key? key}) : super(key: key);

  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  late ARKitController arkitController;
  ARKitNode? node;
  ARKitFace? face;
  ARKitNode? leftEye;
  ARKitNode? rightEye;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Face Detection Sample')),
        persistentFooterButtons: [
          Center(
            child: TextButton(
              onPressed: onShareButtonPressed,
              child: const Text("Share"),
            ),
          ),
        ],
        body: ARKitSceneView(
          configuration: ARKitConfiguration.faceTracking,
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onShareButtonPressed() async {
    final filePath = '${(await getTemporaryDirectory()).path}/face.obj';
    final f = File(filePath);
    await f.writeAsString(
        encodeToObj(
          vertices: face!.vertices!,
          triangleIndices: face!.triangleIndices!,
        ),
        flush: true);
    final xFile = XFile(filePath, mimeType: 'model/obj', name: 'face.obj');
    await Share.shareXFiles([xFile]);
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is! ARKitFaceAnchor) {
      return;
    }
    final material = ARKitMaterial(fillMode: ARKitFillMode.lines);
    anchor.geometry.materials.value = [material];

    node = ARKitNode(geometry: anchor.geometry);
    arkitController.add(node!, parentNodeName: anchor.nodeName);

    leftEye = _createEye(anchor.leftEyeTransform);
    arkitController.add(leftEye!, parentNodeName: anchor.nodeName);
    rightEye = _createEye(anchor.rightEyeTransform);
    arkitController.add(rightEye!, parentNodeName: anchor.nodeName);
  }

  ARKitNode _createEye(Matrix4 transform) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty.color(Colors.yellow),
    );
    final sphere = ARKitBox(
        materials: [material], width: 0.03, height: 0.03, length: 0.03);

    return ARKitNode(geometry: sphere, position: position);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitFaceAnchor && mounted) {
      final faceAnchor = anchor;
      face = anchor.geometry;
      arkitController.updateFaceGeometry(node!, anchor.identifier);
      _updateEye(leftEye!, faceAnchor.leftEyeTransform,
          faceAnchor.blendShapes['eyeBlink_L'] ?? 0);
      _updateEye(rightEye!, faceAnchor.rightEyeTransform,
          faceAnchor.blendShapes['eyeBlink_R'] ?? 0);
    }
  }

  void _updateEye(ARKitNode node, Matrix4 transform, double blink) {
    final scale = vector.Vector3(1, 1 - blink, 1);
    node.scale = scale;
  }
}
