using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace UMAWorld {
    public class ConfLanguage : ConfLanguageBase {
        private Dictionary<string, ConfLanguageItem> _allText;
        public Dictionary<string, ConfLanguageItem> allText
        {
            get
            {
                if (_allText == null) {
                    _allText = new Dictionary<string, ConfLanguageItem>();
                    for (int i = 0; i < allConfList.Count; i++) {
                        ConfLanguageItem item = allConfList[i] as ConfLanguageItem;
                        if (GameConf.isDebug) {
                            if (_allText.ContainsKey(item.key)) {
                                Debug.LogError("多语言表重复字段：" + item.key);
                                continue;
                            }
                        }
                        _allText[item.key] = item;
                    }
                }
                return _allText;
            }
        }

        //获取文本
        public ConfLanguageItem GetItem(string key) {
            return allText.ContainsKey(key) ? g.conf.language.allText[key] : null;
        }
    }
}