using UnityEngine;
using UnityEngine.UI;
[ExecuteInEditMode]
[RequireComponent(typeof(Text))]
public class LanguageText : MonoBehaviour
{
    [SerializeField]
    private string m_text;
    public string text
    {
        set
        {
            m_text = value;
            if (uitext != null)
                uitext.text = StaticTools.LS(m_text);
        }
        get{return m_text; }
    }
    private Text uitext;
    private void Awake() {
        uitext = GetComponent<Text>();
    }
    public void OnEnable() {
        uitext.text = StaticTools.LS(m_text);
    }
    public void Rest() {
        uitext = GetComponent<Text>();
        uitext.text = StaticTools.LS(m_text);
    }
}
