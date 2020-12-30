using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using SLua;


namespace Seven.UI.PageScroller
{
	[CustomLuaClass]
	public class PageScroller : ScrollRect {
		/// <summary>
		/// 最大页数
		/// </summary>
		private int maxPageIndex = 3;
		private int minPageIndex = 1;

		/// <summary>
		/// 页的父亲（需要自己在下面设置3个页）
		/// </summary>
		public LuaFunction OnUpdateFn;//页面刷新回调
		public float speed = 8f;

		private int curPage;//当前页面
		private int lastPage = -1;//上个页面

		private float targetPos;

		private List<PageCell> pageCellList = new List<PageCell> ();//页面控件列表
		private LuaTable data;//滑动界面数据

		/// <summary>
		/// 用于返回一个页码，-1说明page的数据为0
		/// </summary>
		public System.Action<int,int> OnPageChanged;

		protected override void Awake ()
		{
			if(gameObject.GetComponent<PageMark>() == null)
				gameObject.AddComponent<PageMark> ();

			InitPageCell ();
			curPage = minPageIndex;
			targetPos = -1;
			SetPageIndex (curPage);
			base.Awake ();
		}

		//初始化页面控件
		void InitPageCell()
		{
			pageCellList.Clear ();

			if (content.childCount >= 3) {
				for (int i = 0; i < content.childCount; i++) {
					pageCellList.Add(content.GetChild(i).gameObject.GetComponent<PageCell> ());
				}
				return;
			}

			//初始孩子（必须是3个孩子）
			GameObject pageCell = content.GetChild (0).gameObject;
			pageCellList.Add(pageCell.GetComponent<PageCell> ());

			for (int i = 0; i < 2; i++) {
				pageCell = GameObject.Instantiate (content.GetChild (0).gameObject);
				pageCell.name = content.GetChild (0).gameObject.name;
				pageCell.transform.parent = content;
				pageCellList.Add(pageCell.GetComponent<PageCell> ());
			}
		}

		protected override void LateUpdate ()
		{
			base.LateUpdate ();
			if (targetPos != -1 && Mathf.Abs (targetPos - horizontalNormalizedPosition) > 0.05f) {
				horizontalNormalizedPosition += (targetPos - horizontalNormalizedPosition) * speed * Time.deltaTime;
			}else if (targetPos != -1) {
				horizontalNormalizedPosition = targetPos;
				targetPos = -1;
			}
		}

		public override void OnEndDrag (PointerEventData eventData)
		{
			base.OnEndDrag (eventData);
			SetEndDrag ();
		}

		private void SetEndDrag(){
			if (curPage == minPageIndex && horizontalNormalizedPosition > 0.05f) 
				curPage += 1;	
			else if (curPage == maxPageIndex && horizontalNormalizedPosition < 0.95f) 
				curPage -= 1;
			else if (curPage > minPageIndex && curPage < maxPageIndex) {
				if (horizontalNormalizedPosition > 0.55f) {
					if (curPage + 1 != maxPageIndex) {
						content.GetChild (0).SetAsLastSibling ();
						horizontalNormalizedPosition = horizontalNormalizedPosition - 0.55f;
					}
					curPage += 1;
				} else if (horizontalNormalizedPosition < 0.45f) {
					if (curPage - 1 != minPageIndex) {
						content.GetChild (2).SetAsFirstSibling ();
						horizontalNormalizedPosition = horizontalNormalizedPosition + 0.45f;
					}
					curPage -= 1;
				}
			}
			SetPageIndex (curPage);
		}

		public void ChangePageIndex(int value){
			if (curPage == minPageIndex && value >0) 
				curPage += value;	
			else if (curPage == maxPageIndex && value < 0) 
				curPage += value;
			else if (curPage > minPageIndex && curPage < maxPageIndex) {
				if (value > 0) {
					if (curPage + value != maxPageIndex) {
						content.GetChild (0).SetAsLastSibling ();
						horizontalNormalizedPosition = horizontalNormalizedPosition - 0.5f;
					}
					curPage += value;
				} else if (value < 0) {
					if (curPage + value != minPageIndex) {
						content.GetChild (2).SetAsFirstSibling ();
						horizontalNormalizedPosition = horizontalNormalizedPosition + 0.5f;
					}
					curPage += value;
				}
			}
			SetPageIndex (curPage);
		}

		/// <summary>
		/// 设置当前页
		/// </summary>
		/// <param name="p">页数</param>
		public int SetPageIndex(int p){
			if (p < minPageIndex)
				p = minPageIndex;
			else if (p > maxPageIndex)
				p = maxPageIndex;

			curPage = p;
			if (curPage == minPageIndex) {
				targetPos = 0f;
			} else if (curPage == maxPageIndex) {
				targetPos = 1f;
			} else {
				targetPos = 0.5f;
			}

			if (curPage != lastPage) {
				if (OnUpdateFn != null) {
					PageCell pageCell = GetCurPage().GetComponent<PageCell>();
					for (int i = 0; i < pageCell.cellCount; i++) {
						Cell cell = pageCell.GetCell(i);
						int index = cell.index + (curPage - 1) * pageCell.cellCount;
						if(data!=null)
							cell.data = data [index];
						cell.page = curPage;
						OnUpdateFn.call (cell);
					}
				}
				if(OnPageChanged != null)
					OnPageChanged (maxPageIndex, curPage-1);
			}
			lastPage = curPage;

			return p;
		}
		/// <summary>
		/// 获取当前页的GameObject
		/// </summary>
		public GameObject GetCurPage(){
			if (curPage == minPageIndex) {
				return content.GetChild (0).gameObject;
			} else if (curPage == maxPageIndex) {
				if (maxPageIndex < 3){
					return content.GetChild (1).gameObject;
				}
				else{
					return content.GetChild (2).gameObject;
				}
			} else {
				return content.GetChild (1).gameObject;
			}
		}
		/// <summary>
		/// 获取上一页的GameObject（如果当前页是第一页，则获取到下下页）
		/// </summary>
		public GameObject GetLastPage(){
			if (curPage == minPageIndex) {
				return content.GetChild (2).gameObject;
			} else if (curPage == maxPageIndex) {
				return content.GetChild (1).gameObject;
			} else {
				return content.GetChild (0).gameObject;
			}
		}
		/// <summary>
		/// 获取下一页的GameObject （如果当前页是最后一页，则获取到上上页）
		/// </summary>
		public GameObject GetNextPage(){
			if (curPage == minPageIndex) {
				return content.GetChild (1).gameObject;
			} else if (curPage == maxPageIndex) {
				return content.GetChild (0).gameObject;
			} else {
				return content.GetChild (2).gameObject;
			}
		}

		/// <summary>
		/// 获取页面上的cell index从1开始
		/// </summary>
		/// <param name="index">Index.</param>
		public Cell GetItem(int index)
		{
			PageCell pageCell = GetCurPage ().GetComponent<PageCell>();
			return pageCell.GetCell (--index);
		}

		/// <summary>
		/// 设置页数
		/// </summary>
		/// <param name="page">Page.</param>
		public void SetPage(int page)
		{
			maxPageIndex = page;
			if (page == 1) {
				content.GetChild (1).gameObject.SetActive (false);
				content.GetChild (2).gameObject.SetActive (false);
			} else if (page == 2) {
				content.GetChild (1).gameObject.SetActive (true);
				content.GetChild (2).gameObject.SetActive (false);
			} else {
				content.GetChild (1).gameObject.SetActive (true);
				content.GetChild (2).gameObject.SetActive (true);
			}
			lastPage = -1;
			SetPageIndex (1);
		}

		public void SetData(LuaTable data)
		{
			this.data = data;
			int page = data.length () / pageCellList [0].cellCount;
			if (data.length () == 0 || 0 < data.length () % pageCellList [0].cellCount){
				page = page + 1;
			}
			SetPage (page);
		}
	}
}