using UnityEngine;

public class ClippingPlane : MonoBehaviour
{
    public Material mat;

    // Update is called once per frame
    void Update()
    {
        //create plane
        Plane plane = new Plane(transform.up, transform.position);
        //transfer values from the plane to vector4
        Vector4 planeRepresentation = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);
        //pass vector to shader
        mat.SetVector("_Plane", planeRepresentation);
    }
}
