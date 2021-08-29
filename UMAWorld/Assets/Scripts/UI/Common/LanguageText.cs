using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
[RequireComponent(typeof(Text))]
public class LanguageText : MonoBehaviour
{
    [System.Serializable]
    public struct LanguageParam {
        public string str;
        public bool useLanguage;
        public LanguageParam(string str, bool useLanguage) {
            this.str = str;
            this.useLanguage = useLanguage;
        }
        public LanguageParam(int str, bool useLanguage) {
            this.str = str.ToString();
            this.useLanguage = useLanguage;
        }
        public LanguageParam(object str, bool useLanguage) {
            this.str = str.ToString();
            this.useLanguage = useLanguage;
        }

        public override string ToString() {
            return useLanguage ? StaticTools.LS(str) : str;
        }

        public static implicit operator string(LanguageParam language) {
            return language.ToString();
        }

        public static implicit operator LanguageParam(string language) {
            return new LanguageParam(language, false);
        }

        public static implicit operator LanguageParam(int language) {
            return new LanguageParam(language.ToString(), false);
        }
    }

    [SerializeField]
    private string m_text;
    [SerializeField]
    private LanguageParam[] m_params;
    [SerializeField]
    private bool m_useLanguage = true;

    public string text
    {
        set
        {
            m_useLanguage = true;
            m_params = null;
            m_text = value;
                SetText();
        }
        get{return m_text; }
    }

    public void Text(string str, bool useLanguage = true) {
        m_useLanguage = useLanguage;
        m_params = null;
        m_text = str;
        SetText();
    }

    public void Text(string str, params LanguageParam[] p) {
        m_useLanguage = true;
        m_text = str;
        m_params = p;
        SetText();
    }

    public void Text(string str,bool useLanguage, params LanguageParam[] p) {
        m_useLanguage = useLanguage;
        m_text = str;
        m_params = p;
        SetText();
    }

    public void ChangeParam(params LanguageParam[] p) {
        m_params = p;
        SetText();
    }

    private Text uitext;
    private void Awake() {
        uitext = StaticTools.GetOrAddComponent<Text>(gameObject);
    }

    public void OnEnable() {
        SetText();
    }

    public void Rest() {
        if (uitext == null)
            uitext = GetComponent<Text>();
        SetText();
    }

    private void SetText() {
        if (uitext == null)
            return;
        string content = m_useLanguage ? StaticTools.LS(m_text) : m_text;
        //Debug.Log(name+"   m_text= " + m_text + "   m_useLanguage=" + m_useLanguage + "   content=" + content);
        if (m_params != null) {
            int param_len = m_params.Length;
            if (param_len > 0 && param_len < 11) {
                switch (param_len) {
                    case 1:
                        uitext.text = string.Format(content, m_params[0]);
                        break;
                    case 2:
                        uitext.text = string.Format(content, m_params[0], m_params[1]);
                        break;
                    case 3:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2]);
                        break;
                    case 4:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]);
                        break;
                    case 5:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]
                            , m_params[4]);
                        break;
                    case 6:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]
                            , m_params[4], m_params[5]);
                        break;
                    case 7:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]
                            , m_params[4], m_params[5], m_params[6]);
                        break;
                    case 8:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]
                            , m_params[4], m_params[5], m_params[6], m_params[7]);
                        break;
                    case 9:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]
                            , m_params[4], m_params[5], m_params[6], m_params[7], m_params[8]);
                        break;
                    case 10:
                        uitext.text = string.Format(content, m_params[0], m_params[1], m_params[2], m_params[3]
                            , m_params[4], m_params[5], m_params[6], m_params[7], m_params[8], m_params[9]);
                        break;

                }
            } else {
                for (int i = 0; i < param_len; i++) {
                    content = content.Replace("{" + i + "}", m_params[i]);
                }
                uitext.text = content;
            }
        } else {
            uitext.text = content;
        }
    }

}
