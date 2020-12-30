using System.Collections.Generic;
namespace UnityEngine.UI
{
	/// author: Kanglai Qian, SoulGame
	/// date: 2016-3-6
	/// a Simple script to support Polygon Sprites for UGUI Image in Unity 5
	/// just drag it to GameObjects with Image attached
	[AddComponentMenu("UI/Effects/PolygonImage", 16)]
//	[RequireComponent(typeof(Image))]
	#if UNITY_5_1
	public class PolygonImage : BaseVertexEffect
	#else
	public class PolygonImage : BaseMeshEffect
	#endif
	{
		protected PolygonImage()
		{ }
		#if UNITY_5_1
		public override void ModifyVertices(List<UIVertex> verts)
		#else
		public override void ModifyMesh(VertexHelper vh)
		#endif
		{
			Image image = GetComponent<Image>();
			if(image.type != Image.Type.Simple)
			{
				return;
			}
			Sprite sprite = image.overrideSprite;
			if(sprite == null || sprite.triangles.Length == 6)
			{
				// only 2 triangles
				return;
			}
			// Kanglai: at first I copy codes from Image.GetDrawingDimensions
			// to calculate Image's dimensions. But now for easy to read, I just take usage of corners.
			#if UNITY_5_1
			if (verts.Count != 4)
			{
			return;
			}
			UIVertex vertice;
			Vector2 lb = verts[0].position;
			Vector2 rt = verts[2].position;
			#else
			if (vh.currentVertCount != 4)
			{
				return;
			}
			UIVertex vertice = new UIVertex();
			vh.PopulateUIVertex(ref vertice, 0);
			Vector2 lb = vertice.position;
			vh.PopulateUIVertex(ref vertice, 2);
			Vector2 rt = vertice.position;
			#endif
			// Kanglai: recalculate vertices from Sprite!
			int len = sprite.vertices.Length;
			var vertices = new List<UIVertex>(len);
			Vector2 Center = sprite.bounds.center;
			Vector2 invExtend = new Vector2(1 / sprite.bounds.size.x, 1 / sprite.bounds.size.y);
			for (int i = 0; i < len; i++)
			{
				vertice = new UIVertex();
				// normalize
				float x = (sprite.vertices[i].x - Center.x) * invExtend.x + 0.5f;
				float y = (sprite.vertices[i].y - Center.y) * invExtend.y + 0.5f;
				// lerp to position
				vertice.position = new Vector2(Mathf.Lerp(lb.x, rt.x, x), Mathf.Lerp(lb.y, rt.y, y));
				vertice.color = image.color;
				vertice.uv0 = sprite.uv[i];
				vertices.Add(vertice);
			}
			len = sprite.triangles.Length;
			#if UNITY_5_1
			verts.Clear();
			for (int i = 0; i < len; i+=3)
			{
			verts.Add(vertices[sprite.triangles[i + 0]]);
			verts.Add(vertices[sprite.triangles[i + 1]]);
			verts.Add(vertices[sprite.triangles[i + 2]]);
			// a degeneration quad :(
			verts.Add(vertices[sprite.triangles[i + 0]]);
			}
			#else
			var triangles = new List<int>(len);
			for (int i = 0; i < len; i++)
			{
				triangles.Add(sprite.triangles[i]);
			}
			vh.Clear();
			vh.AddUIVertexStream(vertices, triangles);
			#endif
		}
	}
}
