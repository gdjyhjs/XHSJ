using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using SLua;

namespace Seven.TextInlineSprite
{
	//[ExecuteInEditMode]
	[SLua.CustomLuaClass]
	public class InlieText : Text , IPointerClickHandler {

	    /// <summary>
	    /// 用正则取标签属性 名称-大小-宽度比例
	    /// </summary>
	    private static readonly Regex m_spriteTagRegex =
			new Regex(@"<quad name=(.+?) size=(\d*\.?\d+%?) width=(\d*\.?\d+%?)(\s*)/>", RegexOptions.Singleline);
	    /// <summary>
	    /// 需要渲染的图片信息列表
	    /// </summary>
	    private List<InlineSpriteInfor> listSprite;
	    /// <summary>
	    /// 图片资源
	    /// </summary>
	    private SpriteAsset m_spriteAsset;
	    /// <summary>
	    /// 标签的信息列表
	    /// </summary>
	    private List<SpriteTagInfor> listTagInfor;
	    /// <summary>
	    /// 图片渲染组件
	    /// </summary>
	    private SpriteGraphic m_spriteGraphic;
	    /// <summary>
	    /// CanvasRenderer
	    /// </summary>
	    private CanvasRenderer m_spriteCanvasRenderer;

		#region 动画标签解析
		//最多动态表情数量
		int AnimNum=8;
		List<int> m_AnimIndex;
		Dictionary<int, SpriteTagInfor[]> m_AnimSpiteTag;
		Dictionary<int, InlineSpriteInfor[]> m_AnimSpriteInfor;
		#endregion

		#region 初始化
	    /// <summary>
	    /// 初始化 
	    /// </summary>
	    protected override void OnEnable()
	    {
	        //在编辑器中，可能在最开始会出现一张图片，就是因为没有激活文本，在运行中是正常的。可根据需求在编辑器中选择激活...
	        base.OnEnable();

			//对齐几何
			alignByGeometry = true;

	        if (m_spriteGraphic == null)
	            m_spriteGraphic = GetComponentInChildren<SpriteGraphic>();
	        if (m_spriteCanvasRenderer == null)
	            m_spriteCanvasRenderer = m_spriteGraphic.GetComponentInChildren<CanvasRenderer>();
			if (m_spriteGraphic != null)
				m_spriteAsset = m_spriteGraphic.m_spriteAsset;

			//更新定点
			SetVerticesDirty();
	    }

		string m_OutputText;
	    /// <summary>
	    /// 在设置顶点时调用
	    /// </summary>
		[SLua.DoNotToLua]
	    public override void SetVerticesDirty()
	    {
	        base.SetVerticesDirty();

			//解析超链接
			m_OutputText = GetOutputText();

	        //解析标签属性
			listTagInfor = new List<SpriteTagInfor>();
			m_AnimIndex = new List<int> ();
			m_AnimSpiteTag = new Dictionary<int, SpriteTagInfor[]>();

			//原来的单张图片
//	        foreach (Match match in m_spriteTagRegex.Matches(text))
//	        {
//	            SpriteTagInfor tempSpriteTag = new SpriteTagInfor();
//	            tempSpriteTag.name = match.Groups[1].Value;
//	            tempSpriteTag.index = match.Index;
//	            tempSpriteTag.size = new Vector2(float.Parse(match.Groups[2].Value)*float.Parse(match.Groups[3].Value), float.Parse(match.Groups[2].Value));
//	            tempSpriteTag.Length = match.Length;
//	            listTagInfor.Add(tempSpriteTag);
//	        }
			//现在支持多张图片动态图片
			foreach (Match match in m_spriteTagRegex.Matches(m_OutputText)) 
			{ 
				if (m_spriteAsset == null) 
					return; 
				#region 解析动画标签 
				List<string> tempListName = new List<string>(); 
				for (int i = 0; i < m_spriteAsset.listSpriteInfor.Count; i++) 
				{ 
					// Debug.Log((m_spriteAsset.listSpriteInfor[i].name)); 
					if (m_spriteAsset.listSpriteInfor[i].name.Contains(match.Groups[1].Value)) 
					{ 
						tempListName.Add(m_spriteAsset.listSpriteInfor[i].name); 
					} 
				} 
				if (tempListName.Count > 0) 
				{ 
					SpriteTagInfor[] tempArrayTag = new SpriteTagInfor[tempListName.Count]; 
					for (int i = 0; i < tempArrayTag.Length; i++) 
					{ 
						tempArrayTag[i] = new SpriteTagInfor(); 
						tempArrayTag[i].name = tempListName[i]; 
						tempArrayTag[i].index = match.Index; 
						tempArrayTag[i].size = new Vector2(float.Parse(match.Groups[2].Value) * float.Parse(match.Groups[3].Value), float.Parse(match.Groups[2].Value)); 
						tempArrayTag[i].Length = match.Length; 
					} 
					listTagInfor.Add(tempArrayTag[0]); 
					m_AnimSpiteTag.Add(listTagInfor.Count - 1, tempArrayTag); 
					m_AnimIndex.Add(listTagInfor.Count - 1); 
				} 
				#endregion 
			} 


	        Vector2 extents = rectTransform.rect.size;

	    }
		#endregion

		#region 绘制模型
	    readonly UIVertex[] m_TempVerts = new UIVertex[4];
	    /// <summary>
	    /// 绘制模型
	    /// </summary>
	    /// <param name="toFill"></param>
	    protected override void OnPopulateMesh(VertexHelper toFill)
	    {
	        //  base.OnPopulateMesh(toFill);

	        if (font == null)
	            return;

			//我们不在乎字体纹理的变化,而我们所做的更新。
			// cachedTextGenerator的最终结果将为这个例子中是有效的。
			//否则我们可以得到诸如619238。
	        m_DisableFontTextureRebuiltCallback = true;

	        Vector2 extents = rectTransform.rect.size;

	        var settings = GetGenerationSettings(extents);
			cachedTextGenerator.Populate(m_OutputText, settings);

	        Rect inputRect = rectTransform.rect;

			//获取本地空间文本的文本对齐锚点
	        Vector2 textAnchorPivot = GetTextAnchorPivot(alignment);
	        Vector2 refPoint = Vector2.zero;
	        refPoint.x = (textAnchorPivot.x == 1 ? inputRect.xMax : inputRect.xMin);
	        refPoint.y = (textAnchorPivot.y == 0 ? inputRect.yMin : inputRect.yMax);

			//确定分数像素来抵消文本网格。
	        Vector2 roundingOffset = PixelAdjustPoint(refPoint) - refPoint;

			//将偏移量应用到顶点
	        IList<UIVertex> verts = cachedTextGenerator.verts;
	        float unitsPerPixel = 1 / pixelsPerUnit;

			//最后4个，总是一条新线。
	        int vertCount = verts.Count - 4;

	        toFill.Clear();

	        //清除乱码
	        for (int i = 0; i < listTagInfor.Count; i++)
	        {
	            //UGUIText的<quad/>标签，表现为乱码，我这里将他的uv全设置为0,即可清除乱码
	            for (int m = listTagInfor[i].index * 4; m < listTagInfor[i].index * 4 +4; m++)
	            {
	                UIVertex tempVertex = verts[m];
	                tempVertex.uv0 = Vector2.zero;
	                verts[m] = tempVertex;
	            }
	        }

	            if (roundingOffset != Vector2.zero)
	        {
	            for (int i = 0; i < vertCount; ++i)
	            {
	                int tempVertsIndex = i & 3;
	                m_TempVerts[tempVertsIndex] = verts[i];
	                m_TempVerts[tempVertsIndex].position *= unitsPerPixel;
	                m_TempVerts[tempVertsIndex].position.x += roundingOffset.x;
	                m_TempVerts[tempVertsIndex].position.y += roundingOffset.y;
	                if (tempVertsIndex == 3)
	                    toFill.AddUIVertexQuad(m_TempVerts);
	            }
	        }
	        else
	        {
	            for (int i = 0; i < vertCount; ++i)
	            {
	                int tempVertsIndex = i & 3;
	                m_TempVerts[tempVertsIndex] = verts[i];
	                m_TempVerts[tempVertsIndex].position *= unitsPerPixel;
	                if (tempVertsIndex == 3)
	                    toFill.AddUIVertexQuad(m_TempVerts);
	            }
	        }

	        //计算标签 计算偏移值后 再计算标签的值
	        List<UIVertex> vertsTemp = new List<UIVertex>();
	        for (int i = 0; i < vertCount; i++)
	        {
	            UIVertex tempVer=new UIVertex();
	            toFill.PopulateUIVertex(ref tempVer,i);
	            vertsTemp.Add(tempVer);
	        }
	        CalcQuadTag(vertsTemp);

	        m_DisableFontTextureRebuiltCallback = false;
	        
	        //绘制图片
	        DrawSprite();

			#region 处理超链接的包围盒
			UIVertex vert = new UIVertex();
			foreach (var hrefInfo in m_HrefInfos) {
				hrefInfo.boxes.Clear();
				if(hrefInfo.startIndex >= toFill.currentVertCount){
					continue;
				}
				//将超链接里面的文本定点索引坐标加入到包围框
				toFill.PopulateUIVertex(ref vert, hrefInfo.startIndex);
				var pos = vert.position;
				var bounds = new Bounds(pos, Vector3.zero);
				for (int i = hrefInfo.startIndex, m = hrefInfo.endIndex; i < m; i++){
					if (i >= toFill.currentVertCount){
						break;
					}

					toFill.PopulateUIVertex(ref vert,i);
					pos = vert.position;
					if(pos.x<bounds.min.x){//换行重新店家包围框
						hrefInfo.boxes.Add(new Rect(bounds.min,bounds.size));
						bounds=new Bounds(pos,Vector3.zero);
					}
					else{
						bounds.Encapsulate(pos);//拓展包围框
					}
				}
				hrefInfo.boxes.Add(new Rect(bounds.min,bounds.size));
			}

			#endregion

			#region 处理超链接的下划线 -- 拉伸实现
//			TextGenerator _UnderlineText = new TextGenerator();
//			_UnderlineText.Populate("_",settings);
//			IList<UIVertex> _TUT = _UnderlineText.verts;
//	
//			foreach(var hrefInfo in m_HrefInfos){
//				if(hrefInfo.startIndex >= toFill.currentVertCount){
//					continue;
//				}
//	
//				for (int i = 0; i < hrefInfo.boxes.Count; i++) {
//					Vector3 _StartBoxPos = new Vector3(hrefInfo.boxes[i].x, hrefInfo.boxes[i].y, 0.0f);
//					Vector3 _EndBoxPos = _StartBoxPos + new Vector3(hrefInfo.boxes[i].width, 0.0f , 0.0f );
//					AddUnderlineQuad(toFill,_TUT,_StartBoxPos,_EndBoxPos);
//				}
//			}
			#endregion
	    }
		#endregion

		#region 添加下划线
		void AddUnderlineQuad(VertexHelper _VToFill, IList<UIVertex> _VTUT, Vector3 _VStartPos, Vector3 _VEndPos){
			Vector3[] _TUnderlinePos = new Vector3[4]{_VStartPos,_VEndPos,
				_VEndPos+new Vector3(0,fontSize*0.2f,0),_VStartPos+new Vector3(0,fontSize*0.2f,0)};

			for (int i = 0; i < 4; i++) {
				int tempVertsIndex = i & 3;
				m_TempVerts [tempVertsIndex] = _VTUT [i % 4];
				//m_TempVerts [tempVertsIndex].color = Color.blue;

				m_TempVerts [tempVertsIndex].position = _TUnderlinePos [i];

				if (tempVertsIndex == 3)
					_VToFill.AddUIVertexQuad (m_TempVerts);
			}
		}
		#endregion

	    /// <summary>
	    /// 解析quad标签  主要清除quad乱码 获取表情的位置
	    /// </summary>
	    /// <param name="verts"></param>
	    void CalcQuadTag(IList<UIVertex> verts)
	    {
			m_AnimSpriteInfor = new Dictionary<int,InlineSpriteInfor[]> ();
	        //通过标签信息来设置需要绘制的图片的信息
	        listSprite = new List<InlineSpriteInfor>();
	        for (int i = 0; i < listTagInfor.Count; i++)
	        {
	            //的<quad/>标签，表现为乱码，我这里将他的uv全设置为0,清除乱码
	            for (int m = listTagInfor[i].index * 4; m < listTagInfor[i].index * 4 + 18*4; m++)
	            {
	                UIVertex tempVertex = verts[m];
	                tempVertex.uv0 = Vector2.zero;
	                verts[m] = tempVertex;
	            }

	            InlineSpriteInfor tempSprite = new InlineSpriteInfor();

	            //获取表情的第一个位置,则计算他的位置为quad占位的第四个点   顶点绘制顺序:       
	            //                                                                              0    1
	            //                                                                              3    2
	            //tempSprite.textpos = verts[((listTagInfor[i].index+1) * 4) - 1].position;
				tempSprite.textpos = verts[((listTagInfor[i].index-1) * 4) + 2].position;

	            //设置图片的位置
	            tempSprite.vertices = new Vector3[4];
	            tempSprite.vertices[0] = new Vector3(0, 0, 0) + tempSprite.textpos;
	            tempSprite.vertices[1] = new Vector3(listTagInfor[i].size.x, listTagInfor[i].size.y, 0) + tempSprite.textpos;
	            tempSprite.vertices[2] = new Vector3(listTagInfor[i].size.x, 0, 0) + tempSprite.textpos;
	            tempSprite.vertices[3] = new Vector3(0, listTagInfor[i].size.y, 0) + tempSprite.textpos;

	            //计算其uv
	            Rect spriteRect = m_spriteAsset.listSpriteInfor[0].rect;
	            for (int j = 0; j < m_spriteAsset.listSpriteInfor.Count; j++)
	            {
	                //通过标签的名称去索引spriteAsset里所对应的sprite的名称
	                if (listTagInfor[i].name == m_spriteAsset.listSpriteInfor[j].name)
	                    spriteRect = m_spriteAsset.listSpriteInfor[j].rect;
	            }
	            Vector2 texSize = new Vector2(m_spriteAsset.texSource.width, m_spriteAsset.texSource.height);

	            tempSprite.uv = new Vector2[4];
	            tempSprite.uv[0] = new Vector2(spriteRect.x / texSize.x, spriteRect.y / texSize.y);
	            tempSprite.uv[1] = new Vector2((spriteRect.x + spriteRect.width) / texSize.x, (spriteRect.y + spriteRect.height) / texSize.y);
	            tempSprite.uv[2] = new Vector2((spriteRect.x + spriteRect.width) / texSize.x, spriteRect.y / texSize.y);
	            tempSprite.uv[3] = new Vector2(spriteRect.x / texSize.x, (spriteRect.y + spriteRect.height) / texSize.y);

	            //声明三角顶点所需要的数组
	            tempSprite.triangles = new int[6];
	            listSprite.Add(tempSprite);

				if (m_AnimSpiteTag [i] != null) {
					SpriteTagInfor[] tempTagInfor = m_AnimSpiteTag [i];
					InlineSpriteInfor[] tempSpriteInfor =new InlineSpriteInfor[tempTagInfor.Length];
					for (int j = 0; j < tempTagInfor.Length; j++) {
						tempSpriteInfor[j] =new InlineSpriteInfor();

						tempSpriteInfor[j].textpos = verts[((tempTagInfor[j].index + 1) * 4) - 1].position;
						//设置图片的位置
						tempSpriteInfor [j].vertices = new Vector3[4] {new Vector3 (0, 0, 0) + tempSpriteInfor [j].textpos,
							new Vector3 (tempTagInfor [j].size.x, tempTagInfor [j].size.y, 0) + tempSpriteInfor [j].textpos,
							new Vector3 (tempTagInfor [j].size.x, 0, 0) + tempSpriteInfor [j].textpos,
							new Vector3 (0, tempTagInfor [j].size.y, 0) + tempSpriteInfor [j].textpos
						};

						//计算其uv
						Rect newSpriteRect = m_spriteAsset.listSpriteInfor[0].rect;
						for (int m = 0; m < m_spriteAsset.listSpriteInfor.Count; m++) {
							//通过标签的名称去索引spriteAsset里所对应的sprite的名称
							if (tempTagInfor[j].name == m_spriteAsset.listSpriteInfor[m].name)
								newSpriteRect = m_spriteAsset.listSpriteInfor[m].rect;
						}
						Vector2 newTexSize = new Vector2(m_spriteAsset.texSource.width, m_spriteAsset.texSource.height);
						tempSpriteInfor[j].uv = new Vector2[4]{new Vector2(newSpriteRect.x / newTexSize.x, newSpriteRect.y / newTexSize.y),
							new Vector2((newSpriteRect.x + newSpriteRect.width) / newTexSize.x, (newSpriteRect.y + newSpriteRect.height) / newTexSize.y),
							new Vector2((newSpriteRect.x + newSpriteRect.width) / newTexSize.x, newSpriteRect.y / newTexSize.y),
							new Vector2(newSpriteRect.x / newTexSize.x, (newSpriteRect.y + newSpriteRect.height) / newTexSize.y)
						};

						//声明三角定点所需的数组
						tempSpriteInfor[j].triangles = new int[6];
					}
					m_AnimSpriteInfor.Add(i, tempSpriteInfor);
				}
	        }
	    }
	    
	    /// <summary>
	    /// 绘制图片
	    /// </summary>
	    void DrawSprite()
	    {
	        Mesh m_spriteMesh = new Mesh();

	        List<Vector3> tempVertices = new List<Vector3>();
	        List<Vector2> tempUv = new List<Vector2>();
	        List<int> tempTriangles = new List<int>();
	        
			if (listSprite == null)
				return;
	        for (int i = 0; i < listSprite.Count; i++)
	        {
	            for (int j = 0; j < listSprite[i].vertices.Length; j++)
	            {
	                tempVertices.Add(listSprite[i].vertices[j]);
	            }
	            for (int j = 0; j < listSprite[i].uv.Length; j++)
	            {
	                tempUv.Add(listSprite[i].uv[j]);
	            }
	            for (int j = 0; j < listSprite[i].triangles.Length; j++)
	            {
	                tempTriangles.Add(listSprite[i].triangles[j]);
	            }
	        }
	        //计算顶点绘制顺序
	        for (int i = 0; i < tempTriangles.Count; i++)
	        {
	            if (i % 6 == 0)
	            {
	                int num = i / 6;
	                tempTriangles[i] = 0 + 4 * num;
	                tempTriangles[i + 1] = 1 + 4 * num;
	                tempTriangles[i + 2] = 2 + 4 * num;

	                tempTriangles[i + 3] = 1 + 4 * num;
	                tempTriangles[i + 4] = 0 + 4 * num;
	                tempTriangles[i + 5] = 3 + 4 * num;
	            }
	        }

	        m_spriteMesh.vertices = tempVertices.ToArray();
	        m_spriteMesh.uv = tempUv.ToArray();
	        m_spriteMesh.triangles = tempTriangles.ToArray();

	        if (m_spriteMesh == null)
	            return;

	        m_spriteCanvasRenderer.SetMesh(m_spriteMesh);
	        m_spriteGraphic.UpdateMaterial();
	    }

		float fTime = 0.0f;
		int iIndex = 0;
		void Update(){
			fTime += Time.deltaTime;
			if (fTime >= 0.1f) {
				for (int i = 0; i < m_AnimIndex.Count; i++) {
					if (iIndex >= m_AnimSpriteInfor [m_AnimIndex [i]].Length) {
						listSprite [m_AnimIndex [i]] = m_AnimSpriteInfor [m_AnimIndex [i]] [0];
					} else {
						listSprite[m_AnimIndex[i]] = m_AnimSpriteInfor[m_AnimIndex[i]][iIndex];
					}
				}
				DrawSprite();
				iIndex++;
				if (iIndex >= AnimNum){
					iIndex = 0;
				}
				fTime = 0.0f;
			}
		}

		#region 超链接
		/// <summary>
		/// 超链接信息列表
		/// </summary>
		private readonly List<HrefInfo> m_HrefInfos = new List<HrefInfo>();

		/// <summary>
		/// 文本构造器
		/// </summary>
		private static readonly StringBuilder s_TextBuilder = new StringBuilder();

		/// <summary>
		/// 超链接正则
		/// </summary>
		private static readonly Regex s_HrefRegex=
			new Regex(@"<a href=([^>\n\s]+)>(.*?)(</a>)", RegexOptions.Singleline);

		[System.Serializable]
		[SLua.DoNotToLua]
		public class HrefClickEvent : UnityEvent<string> { }

		[SerializeField]
		private HrefClickEvent m_OnHrefClick = new HrefClickEvent();

		/// <summary>
		/// 超链接点击事件
		/// </summary>
		/// <value>The on href click.</value>
		[SLua.DoNotToLua]
		public HrefClickEvent onHrefClick {
			get{ return m_OnHrefClick; }
			set{ m_OnHrefClick = value; }
		}

		/// <summary>
		/// 获取超链接解析后的最后输出文本
		/// </summary>
		/// <returns>The output text.</returns>
		protected string GetOutputText(){
			s_TextBuilder.Length = 0;
			m_HrefInfos.Clear ();
			var indexText = 0;
			foreach (Match match in s_HrefRegex.Matches(text)) {
				s_TextBuilder.Append(text.Substring(indexText, match.Index - indexText));
				s_TextBuilder.Append("<color=blue>");  // 超链接颜色

				var group = match.Groups[1];
				var hrefInfo = new HrefInfo {
					startIndex = s_TextBuilder.Length * 4, // 超链接里的文本起始顶点索引
					endIndex = (s_TextBuilder.Length + match.Groups [2].Length - 1) * 4 + 3,
					name = group.Value
				};
				m_HrefInfos.Add(hrefInfo);

				s_TextBuilder.Append(match.Groups[2].Value);
				s_TextBuilder.Append("</color>");
				indexText = match.Index + match.Length;
			}
			s_TextBuilder.Append(text.Substring(indexText, text.Length - indexText));
			return s_TextBuilder.ToString();
		}

		/// <summary>
		/// 点击事件监测是否点击到超链接文本
		/// </summary>
		/// <param name="eventData">Event data.</param>
		[SLua.DoNotToLua]
		public void OnPointerClick(PointerEventData eventData){
			Vector2 lp;
			RectTransformUtility.ScreenPointToLocalPointInRectangle(
				rectTransform, eventData.position, eventData.pressEventCamera, out lp);
			foreach (var hrefInfo in m_HrefInfos) {
				var boxes = hrefInfo.boxes;
				for (var i = 0; i < boxes.Count; ++i) {
					if (boxes [i].Contains (lp)) {
						m_OnHrefClick.Invoke(hrefInfo.name);
						if (OnHrefClickFn != null)
							OnHrefClickFn.call (hrefInfo.name);
						return;
					}
				}
			}
			if (OnTextClickFn != null) {
				OnTextClickFn.call ();
			}
		}

		public LuaFunction OnHrefClickFn;
		public LuaFunction OnTextClickFn;

		/// <summary>
		/// 超链接信息类
		/// </summary>
		private class HrefInfo{
			public int startIndex;
			public int endIndex;
			public string name;
			public readonly List<Rect> boxes = new List<Rect> ();
		}
		#endregion

	}

	[System.Serializable]
	public class SpriteTagInfor
	{
	    /// <summary>
	    /// sprite名称
	    /// </summary>
	    public string name;
	    /// <summary>
	    /// 对应的字符索引
	    /// </summary>
	    public int index;
	    /// <summary>
	    /// 大小
	    /// </summary>
	    public Vector2 size;

	    public int Length;
	}


	[System.Serializable]
	public class InlineSpriteInfor
	{
	    // 文字的最后的位置
	    public Vector3 textpos;
	    // 4 顶点 
	    public Vector3[] vertices;
	    //4 uv
	    public Vector2[] uv;
	    //6 三角顶点顺序
	    public int[] triangles;
	}
}
