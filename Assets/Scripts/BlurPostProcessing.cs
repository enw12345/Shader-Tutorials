using UnityEngine;

public class BlurPostProcessing : MonoBehaviour
{
	//material that's applied when doing postprocessing
	[SerializeField]
	private Material _postprocessMaterial;

	//method which is automatically called by unity after the camera is done rendering
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		//draws the pixels from the source texture to the destination texture
		var temporaryTexture = RenderTexture.GetTemporary(source.width, source.height);
		Graphics.Blit(source, temporaryTexture, _postprocessMaterial, 0);
		Graphics.Blit(temporaryTexture, destination, _postprocessMaterial, 1);
		RenderTexture.ReleaseTemporary(temporaryTexture);
	}
}

