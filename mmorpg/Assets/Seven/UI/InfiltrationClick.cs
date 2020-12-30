using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Collections.Generic;
using Hugula.UGUIExtend;
namespace Seven{
	public class InfiltrationClick : MonoBehaviour,IPointerClickHandler {
		public int infiltrationCount = 1;

		//监听点击
		public void OnPointerClick(PointerEventData eventData)
		{
			print (eventData.ToString()+" InfiltrationClick");
			PassEvent(eventData,ExecuteEvents.submitHandler);
			//PassEvent(eventData,ExecuteEvents.pointerClickHandler);
		}

		//把事件透下去
		public void  PassEvent<T>(PointerEventData data,ExecuteEvents.EventFunction<T> function)
			where T : IEventSystemHandler
		{
			List<RaycastResult> results = new List<RaycastResult>();
			EventSystem.current.RaycastAll(data, results); 
			GameObject current = data.pointerCurrentRaycast.gameObject;
            int count = 0;
            int infiltration_count = infiltrationCount;
            for (int i =0; i< results.Count;i++)
			{
				if(current!= results[i].gameObject)
				{
					//print (count.ToString () + "渗透点击 InfiltrationClick " + infiltration_count.ToString ()+" == "+results[i].gameObject.ToString());
					if (++count > infiltration_count) {
						count = 0;
						break;
					}
                    Selectable click_ui = results[i].gameObject.GetComponentInParent<Selectable>();
                    GameObject click_go = click_ui == null ? results[i].gameObject : click_ui.gameObject;
                    EventSystem.current.SetSelectedGameObject(click_go);
                    //print ("渗透点击" + click_go.ToString());
                    ExecuteEvents.Execute(click_go, data,function);
                    //RaycastAll后ugui会自己排序，如果你只想响应透下去的最近的一个响应，这里ExecuteEvents.Execute后直接break就行。
                    InfiltrationClick infiltration = click_go.GetComponent<InfiltrationClick>();
                    if (infiltration != null)
                    {
                        infiltration_count = count + infiltration.infiltrationCount < infiltration_count ? infiltration_count : count + infiltration.infiltrationCount;
                    }

                }
			}
		}
	}
}