using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MouseSoftware;

public class DetachTrees : MonoBehaviour 
{
	public KeyCode key = KeyCode.Space;
	[Range(1f,50f)]
	public float radius = 10f;

	void Update () 
	{
		if (Input.GetKeyDown (key)) 
		{
			EasyTerrain.DetachTreesFromTerrain (transform.position, radius);
		}	
	}
}
