using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterCreatModel : MonoBehaviour {
	public string name;
	private Vector3 ps;
	private RaycastHit hit;
	public Camera camera;
	// Use this for initialization
	void Start () {
		
	}
	void Update () {  
		if (Input.GetMouseButtonDown(0))  
		{  
			Debug.Log("Input.GetMouseButtonDown response");
			Debug.Log ("aaaaaaa");
			Ray ray = camera.ScreenPointToRay(Input.mousePosition);
			if(Physics.Raycast(ray, out hit))
			{
				ps = hit.point;
				print (ps);
				print("I'm looking at " + hit.transform.name);//输出碰到的物体名字
				ps.y = 0;
			}
			CreatModel();
		}  
	} 


	private void CreatModel(){
		GameObject tf = new GameObject();
		tf.name = name;
		tf.transform.parent=this.transform;
		GameObject GO = GameObject.CreatePrimitive (PrimitiveType.Cube); //new GameObject(name);
		GO.transform.parent =tf.transform;
		tf.transform.position = ps;
	}
}
