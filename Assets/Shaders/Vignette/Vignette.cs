using UnityEngine;

[RequireComponent(typeof(Camera))]
public class Vignette : MonoBehaviour
{
  [SerializeField] private Shader shader;
  private Material material;

  [Header("Vignette")]
  [SerializeField] private Color color;
  [SerializeField, Range(0.1f, 10f)] private float intensity;
  [SerializeField, Range(0.1f, 10f)] private float smoothness;
  [SerializeField, Range(0.1f, 10f)] private float roundness;
  [SerializeField] private Vector2 size;

  void Awake()
  {
    if (material == null) {
      material = new(shader);
    }
  }

  void OnRenderImage(RenderTexture source, RenderTexture destination)
  {
    material.SetColor("_VignetteColor", color);
    material.SetFloat("_VignetteIntensity", intensity);
    material.SetFloat("_VignetteSmoothness", smoothness);
    material.SetFloat("_VignetteRoundness", roundness);
    material.SetColor("_VignetteSize", new Vector4(size.x, size.y, 0, 0));
    Graphics.Blit(source, destination, material);
  }
}
