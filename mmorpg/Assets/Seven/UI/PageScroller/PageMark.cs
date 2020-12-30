using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;

namespace Seven.UI.PageScroller
{
	public class PageMark : MonoBehaviour
	{
		public PageScroller scrollPage;
		public ToggleGroup toggleGroup;
		public Toggle togglePrefab;

		private List<Toggle> toggleList = new List<Toggle>();

		void Awake()
		{
			if(scrollPage == null)
				scrollPage = GetComponent<PageScroller> ();
			
			if(toggleGroup == null)
				toggleGroup = GetComponentInChildren<ToggleGroup> ();

			if(togglePrefab == null)
				togglePrefab = GetComponentInChildren<Toggle> ();
			
			if(togglePrefab != null)
				togglePrefab.gameObject.SetActive (false);

			scrollPage.OnPageChanged = OnScrollPageChanged;
		}

		public void OnScrollPageChanged(int pageCount, int currentPageIndex)
		{
			if (toggleGroup == null || togglePrefab == null)
				return;
			
			InitToggle (pageCount);

			if(currentPageIndex>=0 && pageCount > 1)
			{
				toggleList[currentPageIndex].isOn = true;
			}
		}

		void InitToggle(int pageCount)
		{
			if(pageCount!=toggleList.Count)
			{
				if(pageCount>toggleList.Count)
				{
					int cc = pageCount - toggleList.Count;
					for(int i=0; i< cc; i++)
					{
						toggleList.Add(CreateToggle());
					}
				}
				else if(pageCount < toggleList.Count)
				{
					while(toggleList.Count > pageCount)
					{
						Toggle t = toggleList[toggleList.Count - 1];
						toggleList.Remove(t);
						DestroyImmediate(t.gameObject);
					}
				}
			}
			if (pageCount == 1) //只有一页不显示
			{
				Toggle t = toggleList[0];
				toggleList.Remove(t);
				DestroyImmediate(t.gameObject);
			}
		}

		Toggle CreateToggle()
		{
			Toggle t = GameObject.Instantiate<Toggle>(togglePrefab);
			t.gameObject.SetActive(true);
			t.transform.SetParent(toggleGroup.transform);
			t.transform.localScale = Vector3.one;
			t.transform.localPosition = Vector3.zero;
			return t;
		}
	}
}
