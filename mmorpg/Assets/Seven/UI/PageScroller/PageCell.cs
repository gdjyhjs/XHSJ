using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Seven.UI.PageScroller
{
	public class PageCell : MonoBehaviour
	{
		public int cellCount = 1;

		private List<Cell> cellList = new List<Cell> ();//物品列表
		// Use this for initialization
		void Awake ()
		{
			InitCell ();
		}

		void InitCell()
		{
			GameObject obj = transform.GetChild (0).gameObject;
			Cell cell = obj.GetComponent<Cell> ();
			cell.index = 1;
			cellList.Add (cell);

			for (int i = 0; i < cellCount-1; i++) {
				GameObject child = GameObject.Instantiate(obj);
				child.name = obj.name;
				child.transform.parent = transform;
				child.transform.localScale = new Vector3 (1, 1, 1);
				cell = child.GetComponent<Cell> ();
				cell.index = i + 2;
				cellList.Add (cell);
			}
		}

		public Cell GetCell(int idx)
		{
			return cellList [idx];
		}
	}
}

