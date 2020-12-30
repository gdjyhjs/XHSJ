using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using SLua;


namespace Seven{
	[CustomLuaClass]
	public class SlidePage : ScrollRect {
		/// <summary>
		/// 最大页数
		/// </summary>
		public int maxPageIndex = 3;
		public int minPageIndex = 1;
		/// <summary>
		/// 页的父亲（需要自己在下面设置3个页）
		/// </summary>
		public Transform content;
		public LuaFunction endDragFn;
		public float speed = 8f;
		private int curPage;
		private float targetPos;

		protected override void Awake ()
		{
			curPage = minPageIndex;
			targetPos = -1;
			SetPageIndex (curPage);
			base.Awake ();
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

			if (endDragFn != null) {
				endDragFn.call (curPage);
			}

			return p;
		}
		/// <summary>
		/// 获取当前页的GameObject
		/// </summary>
		public GameObject GetCurPage(){
			if (curPage == minPageIndex) {
				return content.GetChild (0).gameObject;
			} else if (curPage == maxPageIndex) {
				return content.GetChild (2).gameObject;
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
	}
}