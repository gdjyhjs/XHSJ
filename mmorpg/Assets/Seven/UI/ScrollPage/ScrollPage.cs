using UnityEngine;
using System.Collections.Generic;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System;
using SLua;
namespace Seven
{
	[SLua.CustomLuaClass]
	public class ScrollPage : MonoBehaviour, IBeginDragHandler, IEndDragHandler
	{
	    ScrollRect rect;
	    //页面：0，1，2，3  索引从0开始
	    //每页占的比列：0/3=0  1/3=0.333  2/3=0.6666 3/3=1
	    //float[] pages = { 0f, 0.333f, 0.6666f, 1f };
	    List<float> pages = new List<float>();
	    int currentPageIndex = 0;

	    //滑动速度
	    public float smooting = 4;
		//页面item
		public PageItem pageItem;
		/// <summary>
		/// 用于返回一个页码，-1说明page的数据为0
		/// </summary>
		public System.Action<int,int> OnPageChanged;
		public System.Action OnSetPage;
		//页数
		public int pageNum = 1;

		//拖动多少距离就翻页
		public int pageDistance = 50;

		//数据
		LuaTable _data;//data
		public LuaTable data
		{
			get { return _data; }
			set
			{
				_data = value;
			}
		}

		public LuaFunction onItemRender;
		public LuaFunction onPageChangedFn;

		//页面item保存列表
		List<PageItem> listPageItem = new List<PageItem>();

	    //滑动的起始坐标
	    float targethorizontal = 0;
	    //是否拖拽结束
		bool isDrag = false;
	    float startime = 0f;
	    float delay = 0.1f;

		void Awake()
		{
			rect = transform.GetComponent<ScrollRect>();
			//rect.horizontalNormalizedPosition = 0;     
			startime = Time.time;
			InitScollPage ();
		}

	    // Use this for initialization
//	    void Start()
//	    {
//	        rect = transform.GetComponent<ScrollRect>();
//	        //rect.horizontalNormalizedPosition = 0;     
//	        startime = Time.time;
//			InitScollPage ();
//	    }
	    
	    void Update()
	    {
	        if (Time.time < startime + delay) return;
	        UpdatePages();
	        //如果不判断。当在拖拽的时候要也会执行插值，所以会出现闪烁的效果
	        //这里只要在拖动结束的时候。在进行插值
	        if (!isDrag && pages.Count>0)
	        {
	            rect.horizontalNormalizedPosition = Mathf.Lerp(rect.horizontalNormalizedPosition, targethorizontal, Time.deltaTime * smooting);
	            
	        }
	    }

		//初始化滑动界面
		void InitScollPage()
		{ 
			for(int i=0; i<pageNum; i++)
			{
				listPageItem.Add(CreatePageItem());
			}
			UpdatePages();
		}

		PageItem CreatePageItem()
		{
			PageItem t = GameObject.Instantiate<PageItem>(pageItem);
			t.gameObject.SetActive(true);
			t.transform.SetParent(pageItem.transform.parent);
			t.transform.localScale = Vector3.one;
			t.transform.localPosition = Vector3.zero;
			t.Init ();
			return t;
		}

		void DeletAllPage()
		{
			for (int i = 0; i < listPageItem.Count; i++) 
			{
				Destroy (listPageItem [i].gameObject);
			}
			listPageItem.Clear ();
		}

		public void SetPage(int page)
		{
			pageNum = page;
			OnSetPage ();
			DeletAllPage ();
			InitScollPage ();
			RefreshPage (1);
		}

		public int GetCurrentPageIndex()
		{
			return currentPageIndex;
		}

		//刷新滑动界面 
		//@need_refresh 是否需要只刷新数据不切换到次页数 用于下一页提前刷新
		public void RefreshPage(int index,bool need_refresh = true)
		{
			index = index - 1;

			List<Item> listItem = listPageItem[index].ItemList();
			int offIndex = index * listItem.Count + 1;
			for(int i=0; i<listItem.Count; i++)
			{
				int curIndex = offIndex + i;
				listItem [i].index = curIndex;
				listItem [i].page = index + 1;
				if (onItemRender != null) {
					if (data != null) {
						listItem [i].data = data [curIndex];
						onItemRender.call (listItem [i], curIndex, index+1, data [curIndex]);
					}
					else
						onItemRender.call (listItem [i], curIndex, index+1);
				}
			}

			if(need_refresh)
			{
				currentPageIndex = index;
				OnPageChanged(pages.Count, index);
				if (onPageChangedFn != null)
					onPageChangedFn.call (index);
				targethorizontal = pages[index];
			}
			
		}

		[SLua.DoNotToLua]
	    public void OnBeginDrag(PointerEventData eventData)
	    {
	        isDrag = true;
	    }

		[SLua.DoNotToLua]
	    public void OnEndDrag(PointerEventData eventData)
	    {
	        isDrag = false;

			float dx = eventData.position.x - eventData.pressPosition.x;
	        float posX = rect.horizontalNormalizedPosition;
			int index = currentPageIndex;

			if (Math.Abs (dx) > pageDistance) 
			{
				if (dx > 0)
					index -= 1;
				else
					index += 1;
			}

			if (index > pageNum - 1)
				index = pageNum - 1;

			if (index < 0)
				index = 0;
			
	        if(index!=currentPageIndex)
	        {
				RefreshPage (index+1);
	        }

	        /*
	         因为这样效果不好。没有滑动效果。比较死板。所以改为插值
	         */
	        //rect.horizontalNormalizedPosition = page[index];


	        targethorizontal = pages[index];
	    }

	    void UpdatePages()
	    {
	        // 获取子对象的数量
	        int count = this.rect.content.childCount;
	        int temp = 0;
	        for(int i=0; i<count; i++)
	        {
	            if(this.rect.content.GetChild(i).gameObject.activeSelf)
	            {
	                temp++;
	            }
	        }
	        count = temp;
	        
	        if (pages.Count!=count)
	        {
	            if (count != 0)
	            {
	                pages.Clear();
	                for (int i = 0; i < count; i++)
	                {
	                    float page = 0;
	                    if(count!=1)
	                        page = i / ((float)(count - 1));
	                    pages.Add(page);
	                    //Debug.Log(i.ToString() + " page:" + page.ToString());
	                }
	            }
	        }
	    }

		/// <summary>
		/// This function is called when the MonoBehaviour will be destroyed.
		/// </summary>
	//	void OnDestroy()
	//	{
	//		
	//	}

	}
}
