import 'package:vector_math/vector_math_64.dart' as vector;

String toObj({
  required List<vector.Vector3> vertices,
  required List<List<int>> triangleIndices,
}) {
  final encodedVertices = vertices
      .map((v) => 'v ${v.x} ${v.y} ${v.z}')
      .reduce((value, element) => '$value\n$element');
  final encodedTriangleIndices = triangleIndices
      .map((tri) => 'l v${tri[0]} v${tri[1]} v${tri[2]}')
      .reduce((value, element) => '$value\n$element');
  return '$encodedVertices\n$encodedTriangleIndices';
}
