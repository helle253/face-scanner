// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arkit_face.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ARKitFace _$ARKitFaceFromJson(Map json) => ARKitFace(
      materials: (json['materials'] as List<dynamic>?)
          ?.map((e) => ARKitMaterial.fromJson(e as Map))
          .toList(),
      vertices: (json['vertices'] as List<dynamic>?)
          ?.map((e) => const Vector3Converter().fromJson(e as List))
          .toList(),
      triangleIndices: (json['triangleIndices'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    );

Map<String, dynamic> _$ARKitFaceToJson(ARKitFace instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('materials',
      const ListMaterialsValueNotifierConverter().toJson(instance.materials));
  writeNotNull('vertices',
      instance.vertices?.map(const Vector3Converter().toJson).toList());
  writeNotNull('triangleIndices', instance.triangleIndices);
  return val;
}
