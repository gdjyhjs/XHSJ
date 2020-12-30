using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;

namespace Seven
{
	public class ScrollPageMark : MonoBehaviour
	{
	    public ScrollPage scrollPage;
	    public ToggleGroup toggleGroup;
	    public Toggle togglePrefab;

	    public List<Toggle> toggleList = new List<Toggle>();
		
	    void Awake()
	    {
	        scrollPage.OnPageChanged = OnScrollPageChanged;
			scrollPage.OnSetPage = OnSetPage;
			InitToggle (scrollPage.pageNum);
			if (scrollPage.pageNum > 0)
				toggleList[0].isOn = true;
	    }
		
		public void OnScrollPageChanged(int pageCount, int currentPageIndex)
	    {
			InitToggle (pageCount);

	        if(currentPageIndex>=0)
	        {
	            toggleList[currentPageIndex].isOn = true;
	        }
	    }

		public void OnSetPage()
		{
			for (int i = 0; i < toggleList.Count; i++) 
			{
				Destroy(toggleList[i].gameObject);
			}
			toggleList.Clear ();
			InitToggle (scrollPage.pageNum);
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
