using UnityEngine;
using System.Collections;

namespace UnityEngine.UI
{
    [System.Serializable]
    public class LoopScrollPrefabSource 
    {
		public LoopItem loopItem;
        public int poolSize = 5;

        private bool inited = false;
        public virtual GameObject GetObject()
        {
            if(!inited)
            {
				SG.ResourceManager.Instance.InitPool(loopItem.gameObject, poolSize);
                inited = true;
				loopItem.gameObject.SetActive (false);
            }
			return SG.ResourceManager.Instance.GetObjectFromPool(loopItem.gameObject);
        }

		public void Dispose()
		{
			SG.ResourceManager.Instance.RemovePool (loopItem.name);
		}
    }
}
