using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Hugula;
/// <summary>
/// 转盘
/// </summary>
using SLua;


namespace Seven{
	[SLua.CustomLuaClass]
	public class RotaryTable : MonoBehaviour {
		
		/// <summary>
		/// 水平方向格数
		/// </summary>
		public float hor_count = 5;
		/// <summary>
		/// 垂直方向格数
		/// </summary>
		public float ver_count = 4;
		/// <summary>
		/// 间距
		/// </summary>
		public float spacing = 10;
		/// <summary>
		/// 格子
		/// </summary>
		public GameObject g_item;
		/// <summary>
		/// 转盘最长时间
		/// </summary>
		public float max_time = 8;
		/// <summary>
		/// 转盘最短时间
		/// </summary>
		public float min_time = 3;
		/// <summary>
		/// 加速度
		/// </summary>
		public float _add_speed = 5;
		/// <summary>
		/// 最小速度，多少时间每格
		/// </summary>
		public float _min_speed = 5;
		/// <summary>
		/// 最大速度，每秒几格
		/// </summary>
		public float _max_speed = 60;
		/// <summary>
		/// 结束可提前的误差时间
		/// </summary>
		public float time_error = 1;

		public LuaFunction onEndFn;

		private List<GameObject> all_item;//所有格子的gameObject

		[SerializeField]
		private RectTransform _top;
		[SerializeField]
		private RectTransform _bottom;
		[SerializeField]
		private RectTransform _left;
		[SerializeField]
		private RectTransform _right;
		[SerializeField]
		private Button _start_button;
		private int _sel_index = 0;//当前选择的位置
		private int _target_index = -1;//最终的目标位置
		private float _trun_time = 0; //转动的时间
		private float _all_trun_time = 0; //转动总时长
		private float _next_change_time = 0;//距离下一格变化时间
		private float _speed = 0;

		private void Awake(){
			all_item = new List<GameObject> ();
			InitUI ();
		}

		public void InitUI(){
			RectTransform rtf = g_item.transform as RectTransform;
			float item_width = rtf.sizeDelta.x;
			float item_height = rtf.sizeDelta.y;
			float hor_width = item_width * hor_count + spacing * (hor_count - 1);
			float hor_height = item_height;
			float ver_width = item_width;
			float ver_height = item_height * (ver_count - 2) + spacing * (ver_count - 1);

			_top.localPosition = new Vector2 (0, ver_height / 2 + hor_height / 2);
			_bottom.localPosition = new Vector2 (0, -ver_height / 2 - hor_height / 2);
			_left.localPosition = new Vector2 (-hor_width / 2 + ver_width / 2, 0);
			_right.localPosition = new Vector2 (hor_width / 2 - ver_width / 2, 0);

			HorizontalLayoutGroup t = _top.GetComponent<HorizontalLayoutGroup> ();
			t.spacing = spacing;
			HorizontalLayoutGroup b = _bottom.GetComponent<HorizontalLayoutGroup> ();
			b.spacing = spacing;
			VerticalLayoutGroup l = _left.GetComponent<VerticalLayoutGroup> ();
			l.spacing = spacing;
			l.padding.top = (int)spacing;
			l.padding.bottom = (int)spacing;
			VerticalLayoutGroup r = _right.GetComponent<VerticalLayoutGroup> ();
			r.spacing = spacing;
			r.padding.top = (int)spacing;
			r.padding.bottom = (int)spacing;

			foreach (var item in all_item) {
				Destroy (item);
			}
			all_item.Clear ();
			for (float i = 0; i < hor_count; i++) {
				GameObject item = Instantiate (g_item) as GameObject;
				all_item.Add (item);
				item.transform.SetParent (_top);
				item.name = all_item.Count.ToString();
				item.SetActive (true);
			}
			for (float i = 0; i < ver_count - 2; i++) {
				GameObject item = Instantiate (g_item) as GameObject;
				all_item.Add (item);
				item.transform.SetParent (_right);
				item.name = all_item.Count.ToString();
				item.SetActive (true);
			}
			for (float i = 0; i < hor_count; i++) {
				GameObject item = Instantiate (g_item) as GameObject;
				all_item.Add (item);
				item.transform.SetParent (_bottom);
				item.transform.SetAsFirstSibling ();
				item.name = all_item.Count.ToString();
				item.SetActive (true);
			}
			for (float i = 0; i < ver_count - 2; i++) {
				GameObject item = Instantiate (g_item) as GameObject;
				all_item.Add (item);
				item.transform.SetParent (_left);
				item.transform.SetAsFirstSibling ();
				item.name = all_item.Count.ToString();
				item.SetActive (true);
			}
			_sel_index = 0;
			_target_index = -1;
			(all_item [_sel_index].GetComponent<ReferGameObjects> ().Get ("sel") as GameObject).SetActive (true);
			enabled = false;
		}

		public void StartTurn(int target){
			_target_index = target;
			if (_target_index >= 0 && _target_index < all_item.Count) {
				_trun_time = 0;
				_all_trun_time = max_time;
				_next_change_time = 0;
				_speed = _min_speed;
				enabled = true;
			} else {
				// Debug.LogError ("选择了一个不存在的奖励目标:" + target);
			}
		}

		public void StopTurn(){
			if (_all_trun_time - _trun_time > min_time) {
				_all_trun_time = _trun_time + min_time;
			}
		}

		private void Update(){
			_trun_time += Time.deltaTime;
			_next_change_time -= Time.deltaTime;

			if (_all_trun_time - _trun_time < min_time) {
				if (_start_button.interactable) {
					_start_button.interactable = false;
				}
				if (_speed > _min_speed) {
					_speed -= Time.deltaTime * _add_speed;
				}
			} else {
				if (_speed < _max_speed) {
					_speed += Time.deltaTime * _add_speed;
				}
			}

			if (_trun_time - _all_trun_time > time_error && _sel_index == _target_index) {
				EndTurn ();
			} else if( _next_change_time <= 0 ){

				_next_change_time = 1 / _speed;
				// Debug.LogFormat("------------------设置了下一次转动的时间{0}=({1}-{2})*{3}",_next_change_time ,_all_trun_time , _trun_time, _add_speed);
				SetNextItem ();
			}
			// Debug.LogFormat ("当前已经转动的时间{0}",_trun_time);
			// Debug.LogFormat ("剩余转动的时间{0}", _all_trun_time - _trun_time);
			// Debug.LogFormat ("距离下次变化格子的时间{0}",_next_change_time);
		}

		private void SetNextItem(){
			(all_item [_sel_index].GetComponent<ReferGameObjects> ().Get ("sel") as GameObject).SetActive (false);
			// print ("隐藏原来的:" + 	_sel_index);
			if (_sel_index + 1 < all_item.Count) {
				_sel_index += 1;
			}else{
				_sel_index = 0;
			}
			// print ("显示下一格的:" + _sel_index);
			(all_item [_sel_index].GetComponent<ReferGameObjects> ().Get ("sel") as GameObject).SetActive (true);
		}

		private void EndTurn(){
			if (onEndFn != null) {
				onEndFn.call ();
			}
		}

		public GameObject[] GetAllItem(){
			return all_item.ToArray ();
		}
	}
}