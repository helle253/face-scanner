import 'package:vector_math/vector_math_64.dart' as vector;

String encodeToObj({
  required List<vector.Vector3> vertices,
  required List<List<int>> triangleIndices,
}) {
  final encodedVertices = vertices
      .map((v) => 'v ${v.x} ${v.y} ${v.z}')
      .reduce((value, element) => '$value\n$element');
  final encodedTriangleIndices = triangleIndices
      .map((tri) => 'f ${tri[0] + 1} ${tri[1] + 1} ${tri[2] + 1}')
      .reduce((value, element) => '$value\n$element');
  return '$encodedVertices\n$encodedTriangleIndices';
}
