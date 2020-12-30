using UnityEngine;
using System.Collections.Generic;
using Hugula;

namespace Seven
{
	public class PageItem : MonoBehaviour
	{
		List<Item> listItem = new List<Item>();
		public Item item;
		public int count = 0;

		public void Init()
	    {
			if (count > 0) {
				for (int i = 0; i < count; i++)
				{
					Item it;
					if (i == 0)
						it = item;
					else
						it = CreateItem ();
					listItem.Add(it);
					foreach (Transform c in it.transform) {
						it.ObjDic.Add (c.gameObject.name, c.gameObject);
					}
				}
			} else {
				foreach (Transform child in transform) {
					Item item = child.gameObject.GetComponent<Item> ();

					foreach (Transform c in child) {
						item.ObjDic.Add (c.gameObject.name, c.gameObject);
					}

					listItem.Add (item);
				}
			}
	    }

		public List<Item> ItemList()
		{
			return listItem;
		}

		Item CreateItem()
		{
			Item t = GameObject.Instantiate<Item>(item);
			t.gameObject.SetActive(true);
			t.transform.SetParent(item.transform.parent);
			t.transform.localScale = Vector3.one;
			t.transform.localPosition = Vector3.zero;
			return t;
		}

	}
}