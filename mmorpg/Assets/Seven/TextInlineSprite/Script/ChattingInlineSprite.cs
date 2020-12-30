﻿using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Text.RegularExpressions;

namespace Seven.TextInlineSprite
{
	public class ChattingInlineSprite : MonoBehaviour {
		/// <summary>
		/// 用正则取（#name）
		/// </summary>
		private static readonly Regex m_inputTagRegex =new Regex(@"<#(.+?)>", RegexOptions.Singleline);

	    public Text scrollViewText;
	    private InlineSpriteManager inlineSpriteManager;
	    private RectTransform Content;
	    public InputField inputText;
		public UnityEngine.UI.Button sendBtn;
	    public Scrollbar scrollbarVertical;
	    public GameObject emojiPanel;
		public UnityEngine.UI.Button emojiButton;
		private UnityEngine.UI.Button[] emojiBtns;

		public GameObject goprefab;
		public GameObject goprefab_left;
		public GameObject goContent;

	    // Use this for initialization
	    void Start () {
	//        inlineSpriteManager = scrollViewText.GetComponent<InlineSpriteManager>();
	//        Content = scrollViewText.transform.parent.GetComponent<RectTransform>();
	        sendBtn.onClick.AddListener(ClickSendMessageBtn);
	        emojiButton.onClick.AddListener(ClickEmojiBtn);
			emojiBtns = emojiPanel.GetComponentsInChildren<UnityEngine.UI.Button>();
			scrollbarVertical.onValueChanged.AddListener (ScrollBarValueChanged);
	        Debug.Log(emojiBtns.Length);
	        for (int i = 0; i < emojiBtns.Length; i++)
	        {
	            GameObject emojiTempGo = emojiBtns[i].gameObject;
	            emojiBtns[i].onClick.AddListener(delegate () { ClickEmojiBtns(emojiTempGo); });
	        }
	    }

		bool isAddMessage = false;
		void ScrollBarValueChanged(float value){
			if (isAddMessage) {
				scrollbarVertical.value = 0;
				isAddMessage = false;
			}
		}

		//list<>
		float chatHeight=10.0f;
		float PlayerHight=64.0f;
	    void ClickSendMessageBtn()
	    {
			//old
	//        scrollViewText.text +="<color=blue>A say: </color>"+inputText.text + "\n";
	//        inputText.text = "";
	//
	//        if (scrollViewText.preferredHeight <= Content.sizeDelta.y)
	//            scrollViewText.rectTransform.sizeDelta = new Vector2(scrollViewText.rectTransform.sizeDelta.x, Content.sizeDelta.y);
	//        else
	//        {
	//            scrollViewText.rectTransform.sizeDelta = new Vector2(scrollViewText.rectTransform.sizeDelta.x, scrollViewText.preferredHeight);
	//            Content.sizeDelta = new Vector2(Content.sizeDelta.x, scrollViewText.preferredHeight);
	//            scrollbarVertical.value = 0.0f;
	//        }
			//new
			if (inputText.text.Trim () == null || inputText.text.Trim () == "")
				return;

			GameObject tempChatItem = Instantiate(goprefab) as GameObject;
			tempChatItem.transform.parent = goContent.transform;
			tempChatItem.transform.localScale = Vector3.one;
			InlieText tempChatText = tempChatItem.transform.Find("Text").GetComponent<InlieText>();

			#region 解析输入表情正则
			string _TempInputText = "";
			int _TempMatchIndex = 0;
			foreach (Match match in m_inputTagRegex.Matches(inputText.text.Trim())){
				_TempInputText += inputText.text.Trim().Substring(_TempMatchIndex, match.Index - _TempMatchIndex);
				_TempInputText += "<quad name=" + match.Groups[1].Value + " size=56 width=1" + " />";
				_TempMatchIndex = match.Index + match.Length;
			}
			_TempInputText += inputText.text.Trim().Substring(_TempMatchIndex, inputText.text.Trim().Length - _TempMatchIndex); 
			#endregion 

			tempChatText.text = _TempInputText;
			if (tempChatText.preferredWidth + 20.0f < 105.0f) {
				tempChatItem.GetComponent<RectTransform> ().sizeDelta = new Vector2 (105.0f, tempChatText.preferredHeight + 50.0f); 
			} else if (tempChatText.preferredWidth + 20.0f > tempChatText.rectTransform.sizeDelta.x) {
				tempChatItem.GetComponent<RectTransform> ().sizeDelta = new Vector2 (tempChatText.rectTransform.sizeDelta.x + 20.0f, tempChatText.preferredHeight + 50.0f); 
			} else {
				tempChatItem.GetComponent<RectTransform>().sizeDelta = new Vector2(tempChatText.preferredWidth + 20.0f, tempChatText.preferredHeight + 50.0f); 
			}

			tempChatItem.SetActive(true);
			tempChatText.SetVerticesDirty();
			tempChatItem.GetComponent<RectTransform>().anchoredPosition = new Vector3(-10.0f, -chatHeight);
			chatHeight += tempChatText.preferredHeight + 50.0f + PlayerHight + 10.0f;
			if (chatHeight > goContent.GetComponent<RectTransform> ().sizeDelta.y) {
				goContent.GetComponent<RectTransform>().sizeDelta = new Vector2(goContent.GetComponent<RectTransform>().sizeDelta.x, chatHeight); 
			}
			isAddMessage = true;
			inputText.text = "";
	    }

		void AutoTalk(){
			string[] emojiTextName = new string[] { "sick", "watermelon", "run", "die", "angry", "bleeding", "nurturing","idle" }; 
			string strTalk = "按下F1,我会自动说话:<quad name="+ emojiTextName[Random.Range(0, emojiTextName.Length)]+" size=56 width=1 />,show一个emoji"; 

			GameObject tempChatItem = Instantiate(goprefab_left) as GameObject; 
			tempChatItem.transform.parent = goContent.transform; 
			tempChatItem.transform.localScale = Vector3.one; 
			InlieText tempChatText = tempChatItem.transform.Find("Text").GetComponent<InlieText>(); 
			tempChatText.text = strTalk; 
			if (tempChatText.preferredWidth + 20.0f < 105.0f) { 
				tempChatItem.GetComponent<RectTransform>().sizeDelta = new Vector2(105.0f, tempChatText.preferredHeight + 50.0f); 
			} else if (tempChatText.preferredWidth + 20.0f > tempChatText.rectTransform.sizeDelta.x){ 
				tempChatItem.GetComponent<RectTransform>().sizeDelta = new Vector2(tempChatText.rectTransform.sizeDelta.x + 20.0f, tempChatText.preferredHeight + 50.0f); 
			} else{ 
				tempChatItem.GetComponent<RectTransform>().sizeDelta = new Vector2(tempChatText.preferredWidth + 20.0f, tempChatText.preferredHeight + 50.0f); 
			}

			tempChatItem.SetActive(true); 
			tempChatText.SetVerticesDirty(); 
			tempChatItem.GetComponent<RectTransform>().anchoredPosition = new Vector3(10.0f, -chatHeight); 
			chatHeight += tempChatText.preferredHeight + 50.0f + PlayerHight + 10.0f; 
			if (chatHeight > goContent.GetComponent<RectTransform>().sizeDelta.y) { 
				goContent.GetComponent<RectTransform>().sizeDelta = new Vector2(goContent.GetComponent<RectTransform>().sizeDelta.x, chatHeight); 
			} 

			//while (scrollbarVertical.value > 0.01f)
			//{
			//    scrollbarVertical.value = 0.0f; 
			//} 
			isAddMessage = true; 
		}

	    void ClickEmojiBtn()
	    {
	        emojiPanel.SetActive(!emojiPanel.activeSelf);
	    }

	    void ClickEmojiBtns(GameObject go)
	    {
	        //inputText.text += "<quad name=" + go.GetComponent<Image>().sprite.name +" size=20 width=1" + " />";
			inputText.text += "<#" + go.name + ">";
	    }

	    // Update is called once per frame
	    void Update () {
	        if (Input.GetKeyDown(KeyCode.Return) && inputText.text != string.Empty){
	            ClickSendMessageBtn();
	        }

			if (Input.GetKeyDown (KeyCode.F1))
				AutoTalk ();
		}
	}
}