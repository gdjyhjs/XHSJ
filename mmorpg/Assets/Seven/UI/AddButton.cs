using UnityEngine;
using UnityEngine.UI;
using Hugula.UGUIExtend;
using UnityEngine.EventSystems;

namespace Seven.UI
{
	public class AddButton : MonoBehaviour
	{
		Button btn;
		// Use this for initialization
		void Start ()
		{
			btn = gameObject.AddComponent<Button> ();

			btn.onClick.AddListener (OnClickBtn);
		}

		void OnClickBtn()
		{
			var g = EventSystem.current.currentSelectedGameObject;
			UGUIEvent.onClickHandle(g, null); 
			GameObject.Destroy (btn);
		}

		void OnDestory()
		{
			GameObject.Destroy (btn);
		}
	}
}

