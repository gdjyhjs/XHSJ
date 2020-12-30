using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroySelf : MonoBehaviour {

	public void my_destroy()
	{
		Destroy (this.gameObject);
	}
}
