using UnityEngine;

[RequireComponent(typeof(MeshRenderer), typeof(MeshFilter))]
public class TestScript : MonoBehaviour
{
  private MeshFilter meshFilter;
  private Mesh mesh;

  [SerializeField] private int resolution = 100;
  [SerializeField] private float size = 10f;

  private Vector3[] vertices;
  private Vector3[] normals;

  void Awake()
  {
    transform.position = new Vector3(-size / 2, 0, -size / 2);

    meshFilter = GetComponent<MeshFilter>();
    meshFilter.mesh = mesh = new Mesh() {
      name = "Test Plane",
      indexFormat = UnityEngine.Rendering.IndexFormat.UInt32,
    };

    GenerateMesh();
  }

  private void GenerateMesh() {
    vertices = new Vector3[(resolution + 1) * (resolution + 1)];
    normals = new Vector3[(resolution + 1) * (resolution + 1)];
    Vector2[] uvs = new Vector2[(resolution + 1) * (resolution + 1)];

    float _step = size / resolution;
    for (int y = 0, i = 0; y <= resolution; y++) {
      for (int x = 0; x <= resolution; x++, i++) {
        vertices[i] = new Vector3(x * _step, 0, y * _step);
        normals[i] = new Vector3(0, 1, 0);
        uvs[i] = new Vector2((float)x / resolution, (float)y / resolution);
      }
    }

    mesh.SetVertices(vertices);
    mesh.SetNormals(normals);
    mesh.SetUVs(0, uvs);

    int[] triangles = new int[(resolution + 1) * (resolution + 1) * 6];
    for (int y = 0, vi = 0, ti = 0; y < resolution; y++, vi++) {
      for (int x = 0; x < resolution; x++, vi++, ti += 6) {
        triangles[ti]     = triangles[ti + 3] = vi;
        triangles[ti + 1] = vi + resolution + 1;
        triangles[ti + 2] = triangles[ti + 4] = vi + resolution + 2;
        triangles[ti + 5] = vi + 1;
      }
    }

    mesh.SetTriangles(triangles, 0);
  }
}
