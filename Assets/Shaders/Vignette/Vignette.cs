using UnityEngine;

[RequireComponent(typeof(Camera))]
public class Vignette : MonoBehaviour
{
  [SerializeField] private Shader shader;
  private Material material;

  void Awake()
  {
    if (material == null) {
      material = new(shader);
    }
  }

  void OnRenderImage(RenderTexture source, RenderTexture destination)
  {
    print("test");
    Graphics.Blit(source, destination, material);
  }
}
