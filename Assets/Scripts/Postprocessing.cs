using UnityEngine;

public class Postprocessing : MonoBehaviour
{
    [SerializeField]
    private Material _postprocessMaterial;

    [SerializeField]
    private float _waveSpeed;

    [SerializeField]
    private bool _waveActive;

    private float waveDistance;

    //Use for reading depth
    private void Start()
    {
        Camera cam = GetComponent<Camera>();
        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.Depth;
    }

    private void Update()
    {
        //if the wave is active, make it move away, otherwise reset it
        if (_waveActive)
        {
            waveDistance = waveDistance + _waveSpeed * Time.deltaTime;
        }
        else
        {
            waveDistance = 0;
        }
    }

    //method which is automatically called by unity after the camera is done rendering
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //sync the distance from the script to the shader
        _postprocessMaterial.SetFloat("_WaveDistance", waveDistance);
        //draws the pixels from the source texture to the destination texture
        Graphics.Blit(source, destination, _postprocessMaterial);
    }
}
