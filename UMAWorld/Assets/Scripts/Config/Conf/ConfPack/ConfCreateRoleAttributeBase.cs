using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace UMAWorld {
    public class ConfCreateRoleAttributeItem : ConfBaseItem {
        public string key;              //文本索引
        public string ch;               //中文|支持空字符串
        public string en;               //英文|支持空字符串

        public ConfCreateRoleAttributeItem() {
        }

        public ConfCreateRoleAttributeItem(int id, string key, string ch, string en) {
            this.id = id;
            this.key = key;
            this.ch = ch;
            this.en = en;
        }

        public ConfCreateRoleAttributeItem Clone() {
            return base.CloneBase() as ConfCreateRoleAttributeItem;
        }
    }
    public class ConfCreateRoleAttributeBase : ConfBase {
        private List<ConfCreateRoleAttributeItem> _allConfList = new List<ConfCreateRoleAttributeItem>();
        public IReadOnlyList<ConfCreateRoleAttributeItem> allConfList
        {
            get { return _allConfList; }
        }

        public override void Init() {
            confName = "CreateRoleAttribute";
            allConfBase = new List<ConfBaseItem>();

        }

        private void Init1() {
        }

        public override void AddItem(int id, ConfBaseItem item) {
            base.AddItem(id, item);
            _allConfList.Add(item as ConfCreateRoleAttributeItem);
        }

        public ConfCreateRoleAttributeItem GetItem(int id) {
            return GetItemObject<ConfCreateRoleAttributeItem>(id);
        }

    }

}