namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfLanguageItem : ConfBaseItem
{
	public string key;				//文本索引
	public string ch;				//中文|支持空字符串
	public string en;				//英文|支持空字符串

	public ConfLanguageItem()
	{
	}

	public ConfLanguageItem(int id, string key, string ch, string en)
	{
		this.id = id;
		this.key = key;
		this.ch = ch;
		this.en = en;
	}	

	public ConfLanguageItem Clone()
	{
	    return base.CloneBase() as ConfLanguageItem;
	}
}
public class ConfLanguageBase : ConfBase
{
	private List<ConfLanguageItem> _allConfList = new List<ConfLanguageItem>();
	public IReadOnlyList<ConfLanguageItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "Language";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfLanguageItem(1, "ok", "确定", "OK"));
		allConfBase.Add(new ConfLanguageItem(2, "simplified Chinese", "简体中文", "Simplified Chinese"));
		allConfBase.Add(new ConfLanguageItem(3, "English", "英文", "English"));
		allConfBase.Add(new ConfLanguageItem(4, "Race", "种族", "Race"));
		allConfBase.Add(new ConfLanguageItem(5, "StartGame", "开始游戏", "StartGame"));
		allConfBase.Add(new ConfLanguageItem(6, "Dress", "装扮", "Dress"));
		allConfBase.Add(new ConfLanguageItem(7, "Body", "身体", "Body"));
		allConfBase.Add(new ConfLanguageItem(8, "Face", "脸部", "Face"));
		allConfBase.Add(new ConfLanguageItem(9, "Sleek", "光滑", "Sleek"));
		allConfBase.Add(new ConfLanguageItem(10, "HumanFemale", "人类女性", "Human Female"));
		allConfBase.Add(new ConfLanguageItem(11, "HumanMale", "人类男性", "Human Male"));
		allConfBase.Add(new ConfLanguageItem(12, "Elf Female", "精灵女性", "Elf Female"));
		allConfBase.Add(new ConfLanguageItem(13, "Elf Male", "精灵男性", "Elf Male"));
		allConfBase.Add(new ConfLanguageItem(14, "Buzzcut", "寸头", "Buzzcut"));
		allConfBase.Add(new ConfLanguageItem(15, "Military Cut", "时髦", "Military Cut"));
		allConfBase.Add(new ConfLanguageItem(16, "HairX", "后梳", "HairX"));
		allConfBase.Add(new ConfLanguageItem(17, "MaleShortHair", "短发", "MaleShortHair"));
		allConfBase.Add(new ConfLanguageItem(18, "The Rebel", "光头", "The Rebel"));
		allConfBase.Add(new ConfLanguageItem(19, "The Pompadour", "长发", "The Pompadour"));
		allConfBase.Add(new ConfLanguageItem(20, "The Middle-Ager", "地中海", "The Middle-Ager"));
		allConfBase.Add(new ConfLanguageItem(21, "Feet", "脚", "Feet"));
		allConfBase.Add(new ConfLanguageItem(22, "Tall Shoes Black", "黑色", "Tall Shoes Black"));
		allConfBase.Add(new ConfLanguageItem(23, "Tall Shoes", "白色", "Tall Shoes"));
		allConfBase.Add(new ConfLanguageItem(24, "Mystic Robe Shoes", "布鞋", "Mystic Robe Shoes"));
		allConfBase.Add(new ConfLanguageItem(25, "MaleChallengerBoots", "长靴", "MaleChallengerBoots"));
		allConfBase.Add(new ConfLanguageItem(26, "Complexion", "局面", "Complexion"));
		allConfBase.Add(new ConfLanguageItem(27, "Smooth", "光滑的", "Smooth"));
		allConfBase.Add(new ConfLanguageItem(28, "Chest", "上身", "Chest"));
		allConfBase.Add(new ConfLanguageItem(29, "chest", "胸部", "Chest"));
		allConfBase.Add(new ConfLanguageItem(30, "MaleHoodie", "男帽衫", "MaleHoodie"));
		allConfBase.Add(new ConfLanguageItem(31, "Mystic Robe", "神秘长袍", "Mystic Robe"));
		allConfBase.Add(new ConfLanguageItem(32, "Shirt 1", "衬衫1", "Shirt 1"));
		allConfBase.Add(new ConfLanguageItem(33, "Shirt 2", "衬衫2", "Shirt 2"));
		allConfBase.Add(new ConfLanguageItem(34, "Shirt 3", "衬衫3", "Shirt 3"));
		allConfBase.Add(new ConfLanguageItem(35, "Shirt 4", "衬衫4", "Shirt 4"));
		allConfBase.Add(new ConfLanguageItem(36, "trunk", "躯干", "trunk"));
		allConfBase.Add(new ConfLanguageItem(37, "MaleChallengerTorso", "挑战者", "MaleChallengerTorso"));
		allConfBase.Add(new ConfLanguageItem(38, "ClothRobeRecipe", "布袍", "ClothRobeRecipe"));
		allConfBase.Add(new ConfLanguageItem(39, "Legs", "下身", "Legs"));
		allConfBase.Add(new ConfLanguageItem(40, "MaleSweatPants", "运动裤", "Sweat Pants"));
		allConfBase.Add(new ConfLanguageItem(41, "Old Jeans", "旧牛仔裤", "Old Jeans"));
		allConfBase.Add(new ConfLanguageItem(42, "Jeans", "牛仔裤", "Jeans"));
		allConfBase.Add(new ConfLanguageItem(43, "WrappedPants", "裹身裤", "WrappedPants"));
		allConfBase.Add(new ConfLanguageItem(44, "Shorts", "短裤", "Shorts"));
		allConfBase.Add(new ConfLanguageItem(45, "Irresistable Underwear", "花短裤", "Irresistable Underwear"));
		allConfBase.Add(new ConfLanguageItem(46, "MakeMeFatJeans", "牛仔裤", "MakeMeFatJeans"));
		allConfBase.Add(new ConfLanguageItem(47, "Hands", "手", "Hands"));
		allConfBase.Add(new ConfLanguageItem(48, "Hands high quality", "高质量的手", "Hands high quality"));
		allConfBase.Add(new ConfLanguageItem(49, "Gloves of Hammer", "锤子手套", "Gloves of Hammer"));
		allConfBase.Add(new ConfLanguageItem(50, "MaleChallengerGloves", "男性挑战者手套", "MaleChallengerGloves"));
		allConfBase.Add(new ConfLanguageItem(51, "AlternateHead", "候补负责人", "AlternateHead"));
		allConfBase.Add(new ConfLanguageItem(52, "Low Poly Head", "低聚头", "Low Poly Head"));
		allConfBase.Add(new ConfLanguageItem(53, "Head", "头", "Head"));
		allConfBase.Add(new ConfLanguageItem(54, "head", "头部", "Head"));
		allConfBase.Add(new ConfLanguageItem(55, "Beard", "胡须", "Beard"));
		allConfBase.Add(new ConfLanguageItem(56, "Devilish Goatee", "口子胡", "Devilish Goatee"));
		allConfBase.Add(new ConfLanguageItem(57, "Bums Beard", "络腮胡", "Bums Beard"));
		allConfBase.Add(new ConfLanguageItem(58, "Manly Beard", "浓密络腮胡", "Manly Beard"));
		allConfBase.Add(new ConfLanguageItem(59, "Eyebrows", "眉毛", "Eyebrows"));
		allConfBase.Add(new ConfLanguageItem(60, "Brow 1", "浏览器1", "Brow 1"));
		allConfBase.Add(new ConfLanguageItem(61, "Brow 2", "浏览器2", "Brow 2"));
		allConfBase.Add(new ConfLanguageItem(62, "High-Res Brows", "高分辨率眉毛", "High-Res Brows"));
		allConfBase.Add(new ConfLanguageItem(63, "High-Res Brows 2", "高分辨率眉毛2", "High-Res Brows 2"));
		allConfBase.Add(new ConfLanguageItem(64, "Eyes", "眼睛", "Eyes"));
		allConfBase.Add(new ConfLanguageItem(65, "Alligator Eyes", "鳄鱼眼睛", "Alligator Eyes"));
		allConfBase.Add(new ConfLanguageItem(66, "Alligator Eyes Alt Test", "鳄鱼眼睛替代测试", "Alligator Eyes Alt Test"));
		allConfBase.Add(new ConfLanguageItem(67, "Cat Eyes", "猫眼", "Cat Eyes"));
		allConfBase.Add(new ConfLanguageItem(68, "Cat Eyes Alt", "猫眼Alt", "Cat Eyes Alt"));
		allConfBase.Add(new ConfLanguageItem(69, "large Eyes", "大眼睛", "large Eyes"));
		allConfBase.Add(new ConfLanguageItem(70, "Old Face", "老面孔", "Old Face"));
		allConfBase.Add(new ConfLanguageItem(71, "TrollFace", "巨魔脸", "TrollFace"));
		allConfBase.Add(new ConfLanguageItem(72, "AlienHeadMorph", "异形头变形", "AlienHeadMorph"));
		allConfBase.Add(new ConfLanguageItem(73, "Helmet", "头盔", "Helmet"));
		allConfBase.Add(new ConfLanguageItem(74, "Mystic Robe Hood", "神秘长袍帽", "Mystic Robe Hood"));
		allConfBase.Add(new ConfLanguageItem(75, "Underwear", "内衣", "Underwear"));
		allConfBase.Add(new ConfLanguageItem(76, "Default Underwear", "默认内衣", "Default Underwear"));
		allConfBase.Add(new ConfLanguageItem(77, "Ears", "耳朵", "Ears"));
		allConfBase.Add(new ConfLanguageItem(78, "BlendShapeRecipe", "混合形状配方", "BlendShapeRecipe"));
		allConfBase.Add(new ConfLanguageItem(79, "ElfEarsMorph", "精灵耳朵变形", "ElfEarsMorph"));
		allConfBase.Add(new ConfLanguageItem(80, "Physique", "体形", "Physique"));
		allConfBase.Add(new ConfLanguageItem(81, "OverweightMale", "超重男性", "OverweightMale"));
		allConfBase.Add(new ConfLanguageItem(82, "Shoulders", "肩膀", "Shoulders"));
		allConfBase.Add(new ConfLanguageItem(83, "MaleChallengerShouderPads", "男性挑战者手垫", "MaleChallengerShouderPads"));
		allConfBase.Add(new ConfLanguageItem(84, "Skin", "皮肤", "Skin"));
		allConfBase.Add(new ConfLanguageItem(85, "Hair", "头发", "Hair"));
		allConfBase.Add(new ConfLanguageItem(86, "Pants", "裤子", "Pants"));
		allConfBase.Add(new ConfLanguageItem(87, "skinGreenness", "皮肤绿色", "skinGreenness"));
		allConfBase.Add(new ConfLanguageItem(88, "skinBlueness", "皮肤发青", "skinBlueness"));
		allConfBase.Add(new ConfLanguageItem(89, "skinRedness", "皮肤发红", "skinRedness"));
		allConfBase.Add(new ConfLanguageItem(90, "breastCleavage", "乳沟", "breastCleavage"));
		allConfBase.Add(new ConfLanguageItem(91, "height", "高度", "height"));
		allConfBase.Add(new ConfLanguageItem(92, "headSize", "头部尺寸", "headSize"));
		allConfBase.Add(new ConfLanguageItem(93, "headWidth", "头部宽度", "headWidth"));
		allConfBase.Add(new ConfLanguageItem(94, "neckThickness", "颈部厚度", "neckThickness"));
		allConfBase.Add(new ConfLanguageItem(95, "armLength", "臂长", "armLength"));
		allConfBase.Add(new ConfLanguageItem(96, "forearmLength", "前臂长度", "forearmLength"));
		allConfBase.Add(new ConfLanguageItem(97, "armWidth", "臂宽", "armWidth"));
		allConfBase.Add(new ConfLanguageItem(98, "forearmWidth", "前臂宽度", "forearmWidth"));
		allConfBase.Add(new ConfLanguageItem(99, "handsSize", "手的大小", "handsSize"));
		allConfBase.Add(new ConfLanguageItem(100, "feetSize", "脚大小", "feetSize"));
		allConfBase.Add(new ConfLanguageItem(101, "legSeparation", "腿部间距", "legSeparation"));
		allConfBase.Add(new ConfLanguageItem(102, "upperMuscle", "上部肌肉", "upperMuscle"));
		allConfBase.Add(new ConfLanguageItem(103, "lowerMuscle", "下肌肉", "lowerMuscle"));
		allConfBase.Add(new ConfLanguageItem(104, "upperWeight", "上部重量", "upperWeight"));
		allConfBase.Add(new ConfLanguageItem(105, "lowerWeight", "重量", "lowerWeight"));
		allConfBase.Add(new ConfLanguageItem(106, "legsSize", "腿部尺寸", "legsSize"));
		allConfBase.Add(new ConfLanguageItem(107, "belly", "腹部", "belly"));
		allConfBase.Add(new ConfLanguageItem(108, "waist", "腰", "waist"));
		allConfBase.Add(new ConfLanguageItem(109, "gluteusSize", "臀肌大小", "gluteusSize"));
		allConfBase.Add(new ConfLanguageItem(110, "earsSize", "耳朵大小", "earsSize"));
		allConfBase.Add(new ConfLanguageItem(111, "earsPosition", "耳朵的位置", "earsPosition"));
		allConfBase.Add(new ConfLanguageItem(112, "earsRotation", "耳朵旋转", "earsRotation"));
		allConfBase.Add(new ConfLanguageItem(113, "noseSize", "鼻子大小", "noseSize"));
		allConfBase.Add(new ConfLanguageItem(114, "noseCurve", "鼻子曲线", "noseCurve"));
		allConfBase.Add(new ConfLanguageItem(115, "noseWidth", "鼻头宽度", "noseWidth"));
		allConfBase.Add(new ConfLanguageItem(116, "noseInclination", "鼻子倾斜", "noseInclination"));
		allConfBase.Add(new ConfLanguageItem(117, "nosePosition", "鼻头位置", "nosePosition"));
		allConfBase.Add(new ConfLanguageItem(118, "nose", "鼻子", "nose"));
		allConfBase.Add(new ConfLanguageItem(119, "nosePronounced", "突出鼻子", "nosePronounced"));
		allConfBase.Add(new ConfLanguageItem(120, "noseFlatten", "压平鼻子", "noseFlatten"));
		allConfBase.Add(new ConfLanguageItem(121, "chin", "下巴", "chin"));
		allConfBase.Add(new ConfLanguageItem(122, "chinSize", "下巴尺寸", "chinSize"));
		allConfBase.Add(new ConfLanguageItem(123, "chinPronounced", "下巴大小", "chinPronounced"));
		allConfBase.Add(new ConfLanguageItem(124, "chinPosition", "下巴位置", "chinPosition"));
		allConfBase.Add(new ConfLanguageItem(125, "mandibleSize", "下颌骨大小", "mandibleSize"));
		allConfBase.Add(new ConfLanguageItem(126, "jawsSize", "颌骨大小", "jawsSize"));
		allConfBase.Add(new ConfLanguageItem(127, "jawsPosition", "颌骨位置", "jawsPosition"));
		allConfBase.Add(new ConfLanguageItem(128, "cheekSize", "脸颊大小", "cheekSize"));
		allConfBase.Add(new ConfLanguageItem(129, "cheekPosition", "脸颊位置", "cheekPosition"));
		allConfBase.Add(new ConfLanguageItem(130, "lowCheekPronounced", "低脸颊大小", "lowCheekPronounced"));
		allConfBase.Add(new ConfLanguageItem(131, "lowCheekPosition", "低脸颊位置", "lowCheekPosition"));
		allConfBase.Add(new ConfLanguageItem(132, "foreheadSize", "前额大小", "foreheadSize"));
		allConfBase.Add(new ConfLanguageItem(133, "foreheadPosition", "前额位置", "foreheadPosition"));
		allConfBase.Add(new ConfLanguageItem(134, "lipsSize", "嘴唇大小", "lipsSize"));
		allConfBase.Add(new ConfLanguageItem(135, "mouth", "嘴巴", "mouth"));
		allConfBase.Add(new ConfLanguageItem(136, "mouthSize", "嘴巴大小", "mouthSize"));
		allConfBase.Add(new ConfLanguageItem(137, "eyeRotation", "眼睛旋转", "eyeRotation"));
		allConfBase.Add(new ConfLanguageItem(138, "eyeSize", "眼睛大小", "eyeSize"));
		allConfBase.Add(new ConfLanguageItem(139, "breastSize", "乳房大小", "breastSize"));
		allConfBase.Add(new ConfLanguageItem(140, "eyeSpacing", "眼间距", "eyeSpacing"));
		allConfBase.Add(new ConfLanguageItem(141, "Undies", "内衣", "Undies"));
		allConfBase.Add(new ConfLanguageItem(142, "Ladies Intimate Wear", "内衣2", "Ladies Intimate Wear"));
		allConfBase.Add(new ConfLanguageItem(143, "FemaleHandsMid", "女性双手中间", "Female Hands Mid"));
		allConfBase.Add(new ConfLanguageItem(144, "FemaleTankTop", "背心", "Female Tank Top"));
		allConfBase.Add(new ConfLanguageItem(145, "FemaleSportPants", "高腰裤", "Female Sport Pants"));
		allConfBase.Add(new ConfLanguageItem(146, "Pants1", "裤子", "Pants"));
		allConfBase.Add(new ConfLanguageItem(147, "Pants 1", "低腰裤", "Pants 1"));
		allConfBase.Add(new ConfLanguageItem(148, "Pants 2", "花裤子", "Pants 2"));
		allConfBase.Add(new ConfLanguageItem(149, "FemaleLongHair", "中分", "Long Hair"));
		allConfBase.Add(new ConfLanguageItem(150, "FemalePonyTail", "马尾1", "Pony Tail"));
		allConfBase.Add(new ConfLanguageItem(151, "Hair 1", "双马尾", "Hair 1"));
		allConfBase.Add(new ConfLanguageItem(152, "Hair 2", "短发", "Hair 2"));
		allConfBase.Add(new ConfLanguageItem(153, "Hair 3", "梨花头", "Hair 3"));
		allConfBase.Add(new ConfLanguageItem(154, "BoneyTail", "马尾2", "Boney Tail"));
		allConfBase.Add(new ConfLanguageItem(155, "High Tops - Black", "黑色", "High Tops Black"));
		allConfBase.Add(new ConfLanguageItem(156, "High Tops - Turquoise", "松绿", "High Tops Turquoise"));
		allConfBase.Add(new ConfLanguageItem(157, "High Tops - White", "白色", "High Tops White"));
		allConfBase.Add(new ConfLanguageItem(158, "Color", "颜色", "Color"));
		allConfBase.Add(new ConfLanguageItem(159, "Lipstick", "口红", "Lipstick"));
		allConfBase.Add(new ConfLanguageItem(160, "Shirt", "衬衫", "Shirt"));
		allConfBase.Add(new ConfLanguageItem(161, "Pants Accent", "裤子花纹", "Pants Accent"));
		allConfBase.Add(new ConfLanguageItem(162, "Hair Accessory", "发饰", "Hair Accessory"));
		allConfBase.Add(new ConfLanguageItem(163, "HairAccent", "发饰", "HairAccent"));
		allConfBase.Add(new ConfLanguageItem(164, "InputName", "请输入名字", "Please Input Name"));
		allConfBase.Add(new ConfLanguageItem(165, "fireBall", "火球术", "fireBall"));
		allConfBase.Add(new ConfLanguageItem(166, "HP", "生命", "HP"));
		allConfBase.Add(new ConfLanguageItem(167, "MP", "内力", "MP"));
		allConfBase.Add(new ConfLanguageItem(168, "sunny", "晴", "sunny"));
		allConfBase.Add(new ConfLanguageItem(169, "cloudy", "多云", "cloudy"));
		allConfBase.Add(new ConfLanguageItem(170, "drizzle", "小雨", "drizzle"));
		allConfBase.Add(new ConfLanguageItem(171, "downpour", "大雨", "downpour"));
		allConfBase.Add(new ConfLanguageItem(172, "storm", "暴雨", "storm"));
		allConfBase.Add(new ConfLanguageItem(173, "fineSnow", "小雪", "fine snow"));
		allConfBase.Add(new ConfLanguageItem(174, "majorSnow", "大雪", "major snow"));
		allConfBase.Add(new ConfLanguageItem(175, "blizzard", "暴雪", "blizzard"));
		allConfBase.Add(new ConfLanguageItem(176, "sandstorm", "沙暴", "sandstorm"));
		allConfBase.Add(new ConfLanguageItem(177, "haze", "雾霾", "haze"));
		allConfBase.Add(new ConfLanguageItem(178, "morning", "上午", "morning"));
		allConfBase.Add(new ConfLanguageItem(179, "afternoon", "下午", "afternoon"));
		allConfBase.Add(new ConfLanguageItem(180, "night", "夜晚", "night"));
		allConfBase.Add(new ConfLanguageItem(181, "showDate", "混沌历 {0}年{1}{2}日", "Chaotic {1} {2},{0}"));
		allConfBase.Add(new ConfLanguageItem(182, "showTime", "{0}:{1}", "{0}：{1}"));
		allConfBase.Add(new ConfLanguageItem(183, "Jan", "1月", "Jan"));
		allConfBase.Add(new ConfLanguageItem(184, "Feb", "2月", "Feb"));
		allConfBase.Add(new ConfLanguageItem(185, "Mar", "3月", "Mar"));
		allConfBase.Add(new ConfLanguageItem(186, "Apr", "4月", "Apr"));
		allConfBase.Add(new ConfLanguageItem(187, "May", "5月", "May"));
		allConfBase.Add(new ConfLanguageItem(188, "Jun", "6月", "Jun"));
		allConfBase.Add(new ConfLanguageItem(189, "Jul", "7月", "Jul"));
		allConfBase.Add(new ConfLanguageItem(190, "Aug", "8月", "Aug"));
		allConfBase.Add(new ConfLanguageItem(191, "Sept", "9月", "Sept"));
		allConfBase.Add(new ConfLanguageItem(192, "Oct", "10月", "Oct"));
		allConfBase.Add(new ConfLanguageItem(193, "Nov", "11月", "Nov"));
		allConfBase.Add(new ConfLanguageItem(194, "Dec", "12月", "Dec"));
		allConfBase.Add(new ConfLanguageItem(195, "January", "一月", "January"));
		allConfBase.Add(new ConfLanguageItem(196, "February", "二月", "February"));
		allConfBase.Add(new ConfLanguageItem(197, "March", "三月", "March"));
		allConfBase.Add(new ConfLanguageItem(198, "April", "四月", "April"));
		allConfBase.Add(new ConfLanguageItem(199, "June", "六月", "June"));
		allConfBase.Add(new ConfLanguageItem(200, "July", "七月", "July"));
		allConfBase.Add(new ConfLanguageItem(201, "August", "八月", "August"));
		allConfBase.Add(new ConfLanguageItem(202, "September", "九月", "September"));
		allConfBase.Add(new ConfLanguageItem(203, "October", "十月", "October"));
		allConfBase.Add(new ConfLanguageItem(204, "November", "十一月", "November"));
		allConfBase.Add(new ConfLanguageItem(205, "December", "十二月", "December"));
		allConfBase.Add(new ConfLanguageItem(206, "Weather", "天气", "Weather"));
		allConfBase.Add(new ConfLanguageItem(207, "role", "角色", "role"));
		allConfBase.Add(new ConfLanguageItem(208, "race", "种族", "race"));
		allConfBase.Add(new ConfLanguageItem(209, "gender", "性别", "gender"));
		allConfBase.Add(new ConfLanguageItem(210, "name", "名字", "name"));
		allConfBase.Add(new ConfLanguageItem(211, "level", "境界", "level"));
		allConfBase.Add(new ConfLanguageItem(212, "health", "生命", "health"));
		allConfBase.Add(new ConfLanguageItem(213, "magic", "内力", "magic"));
		allConfBase.Add(new ConfLanguageItem(214, "health_restore", "生命回复", "health restore"));
		allConfBase.Add(new ConfLanguageItem(215, "magic_restore", "内力回复", "magic restore"));
		allConfBase.Add(new ConfLanguageItem(216, "attack", "攻击", "attack"));
		allConfBase.Add(new ConfLanguageItem(217, "defend", "防御", "defend"));
		allConfBase.Add(new ConfLanguageItem(218, "move_speed", "移动速度", "move speed"));
		allConfBase.Add(new ConfLanguageItem(219, "resist_fire", "火抗性", "resist fire"));
		allConfBase.Add(new ConfLanguageItem(220, "resist_forzen", "冰抗性", "resist forzen"));
		allConfBase.Add(new ConfLanguageItem(221, "resist_lighting", "雷抗性", "resist lighting"));
		allConfBase.Add(new ConfLanguageItem(222, "resist_poison", "毒抗性", "resist poison"));
		allConfBase.Add(new ConfLanguageItem(223, "maohao", "：", ":"));
		allConfBase.Add(new ConfLanguageItem(224, "SmallLevel1", "初期", "chuqi"));
		allConfBase.Add(new ConfLanguageItem(225, "SmallLevel2", "中期", "zhongqi"));
		allConfBase.Add(new ConfLanguageItem(226, "SmallLevel3", "后期", "houqi"));
		allConfBase.Add(new ConfLanguageItem(227, "SmallLevel4", "巅峰", "dianfeng"));
		allConfBase.Add(new ConfLanguageItem(228, "SmallLevel5", "大圆满", "yuanman"));
		allConfBase.Add(new ConfLanguageItem(229, "BigLevel1", "练气期", "lianqi"));
		allConfBase.Add(new ConfLanguageItem(230, "BigLevel2", "筑基期", "zhuji"));
		allConfBase.Add(new ConfLanguageItem(231, "BigLevel3", "结丹期", "jiedan"));
		allConfBase.Add(new ConfLanguageItem(232, "BigLevel4", "金丹期", "jindan"));
		allConfBase.Add(new ConfLanguageItem(233, "BigLevel5", "元婴期", "yuanying"));
		allConfBase.Add(new ConfLanguageItem(234, "BigLevel6", "化神期", "huashen"));
		allConfBase.Add(new ConfLanguageItem(235, "BigLevel7", "洞虚期", "dongxu"));
		allConfBase.Add(new ConfLanguageItem(236, "BigLevel8", "合道期", "hedao"));
		allConfBase.Add(new ConfLanguageItem(237, "BigLevel9", "大乘期", "dacheng"));
		allConfBase.Add(new ConfLanguageItem(238, "BigLevel10", "渡劫期", "dujie"));
		allConfBase.Add(new ConfLanguageItem(239, "Man", "男", "Man"));
		allConfBase.Add(new ConfLanguageItem(240, "Woman", "女", "Woman"));
		allConfBase.Add(new ConfLanguageItem(241, "Human", "人类", "Human"));
		allConfBase.Add(new ConfLanguageItem(242, "Elf", "精灵", "Elf"));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfLanguageItem);
	}

	public ConfLanguageItem GetItem(int id)
	{
		return GetItemObject<ConfLanguageItem>(id);
	}
	
}
	

}