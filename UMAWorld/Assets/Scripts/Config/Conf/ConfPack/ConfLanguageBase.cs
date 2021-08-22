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
		allConfBase.Add(new ConfLanguageItem(1, "simplified Chinese", "简体中文", "Simplified Chinese"));
		allConfBase.Add(new ConfLanguageItem(2, "English", "英文", "English"));
		allConfBase.Add(new ConfLanguageItem(3, "Race", "种族", "Race"));
		allConfBase.Add(new ConfLanguageItem(4, "StartGame", "开始游戏", "StartGame"));
		allConfBase.Add(new ConfLanguageItem(5, "Dress", "装扮", "Dress"));
		allConfBase.Add(new ConfLanguageItem(6, "Body", "身体", "Body"));
		allConfBase.Add(new ConfLanguageItem(7, "Face", "脸部", "Face"));
		allConfBase.Add(new ConfLanguageItem(8, "Sleek", "光滑", "Sleek"));
		allConfBase.Add(new ConfLanguageItem(9, "HumanFemale", "人类女性", "Human Female"));
		allConfBase.Add(new ConfLanguageItem(10, "HumanMale", "人类男性", "Human Male"));
		allConfBase.Add(new ConfLanguageItem(11, "Elf Female", "精灵女性", "Elf Female"));
		allConfBase.Add(new ConfLanguageItem(12, "Elf Male", "精灵男性", "Elf Male"));
		allConfBase.Add(new ConfLanguageItem(13, "Buzzcut", "寸头", "Buzzcut"));
		allConfBase.Add(new ConfLanguageItem(14, "Military Cut", "时髦", "Military Cut"));
		allConfBase.Add(new ConfLanguageItem(15, "HairX", "后梳", "HairX"));
		allConfBase.Add(new ConfLanguageItem(16, "MaleShortHair", "短发", "MaleShortHair"));
		allConfBase.Add(new ConfLanguageItem(17, "The Rebel", "光头", "The Rebel"));
		allConfBase.Add(new ConfLanguageItem(18, "The Pompadour", "长发", "The Pompadour"));
		allConfBase.Add(new ConfLanguageItem(19, "The Middle-Ager", "地中海", "The Middle-Ager"));
		allConfBase.Add(new ConfLanguageItem(20, "Feet", "脚", "Feet"));
		allConfBase.Add(new ConfLanguageItem(21, "Tall Shoes Black", "黑色", "Tall Shoes Black"));
		allConfBase.Add(new ConfLanguageItem(22, "Tall Shoes", "白色", "Tall Shoes"));
		allConfBase.Add(new ConfLanguageItem(23, "Mystic Robe Shoes", "布鞋", "Mystic Robe Shoes"));
		allConfBase.Add(new ConfLanguageItem(24, "MaleChallengerBoots", "长靴", "MaleChallengerBoots"));
		allConfBase.Add(new ConfLanguageItem(25, "Complexion", "局面", "Complexion"));
		allConfBase.Add(new ConfLanguageItem(26, "Smooth", "光滑的", "Smooth"));
		allConfBase.Add(new ConfLanguageItem(27, "Chest", "上身", "Chest"));
		allConfBase.Add(new ConfLanguageItem(28, "chest", "胸部", "Chest"));
		allConfBase.Add(new ConfLanguageItem(29, "MaleHoodie", "男帽衫", "MaleHoodie"));
		allConfBase.Add(new ConfLanguageItem(30, "Mystic Robe", "神秘长袍", "Mystic Robe"));
		allConfBase.Add(new ConfLanguageItem(31, "Shirt 1", "衬衫1", "Shirt 1"));
		allConfBase.Add(new ConfLanguageItem(32, "Shirt 2", "衬衫2", "Shirt 2"));
		allConfBase.Add(new ConfLanguageItem(33, "Shirt 3", "衬衫3", "Shirt 3"));
		allConfBase.Add(new ConfLanguageItem(34, "Shirt 4", "衬衫4", "Shirt 4"));
		allConfBase.Add(new ConfLanguageItem(35, "trunk", "躯干", "trunk"));
		allConfBase.Add(new ConfLanguageItem(36, "MaleChallengerTorso", "挑战者", "MaleChallengerTorso"));
		allConfBase.Add(new ConfLanguageItem(37, "ClothRobeRecipe", "布袍", "ClothRobeRecipe"));
		allConfBase.Add(new ConfLanguageItem(38, "Legs", "下身", "Legs"));
		allConfBase.Add(new ConfLanguageItem(39, "MaleSweatPants", "运动裤", "Sweat Pants"));
		allConfBase.Add(new ConfLanguageItem(40, "Old Jeans", "旧牛仔裤", "Old Jeans"));
		allConfBase.Add(new ConfLanguageItem(41, "Jeans", "牛仔裤", "Jeans"));
		allConfBase.Add(new ConfLanguageItem(42, "WrappedPants", "裹身裤", "WrappedPants"));
		allConfBase.Add(new ConfLanguageItem(43, "Shorts", "短裤", "Shorts"));
		allConfBase.Add(new ConfLanguageItem(44, "Irresistable Underwear", "花短裤", "Irresistable Underwear"));
		allConfBase.Add(new ConfLanguageItem(45, "MakeMeFatJeans", "牛仔裤", "MakeMeFatJeans"));
		allConfBase.Add(new ConfLanguageItem(46, "Hands", "手", "Hands"));
		allConfBase.Add(new ConfLanguageItem(47, "Hands high quality", "高质量的手", "Hands high quality"));
		allConfBase.Add(new ConfLanguageItem(48, "Gloves of Hammer", "锤子手套", "Gloves of Hammer"));
		allConfBase.Add(new ConfLanguageItem(49, "MaleChallengerGloves", "男性挑战者手套", "MaleChallengerGloves"));
		allConfBase.Add(new ConfLanguageItem(50, "AlternateHead", "候补负责人", "AlternateHead"));
		allConfBase.Add(new ConfLanguageItem(51, "Low Poly Head", "低聚头", "Low Poly Head"));
		allConfBase.Add(new ConfLanguageItem(52, "Head", "头", "Head"));
		allConfBase.Add(new ConfLanguageItem(53, "head", "头部", "Head"));
		allConfBase.Add(new ConfLanguageItem(54, "Beard", "胡须", "Beard"));
		allConfBase.Add(new ConfLanguageItem(55, "Devilish Goatee", "口子胡", "Devilish Goatee"));
		allConfBase.Add(new ConfLanguageItem(56, "Bums Beard", "络腮胡", "Bums Beard"));
		allConfBase.Add(new ConfLanguageItem(57, "Manly Beard", "浓密络腮胡", "Manly Beard"));
		allConfBase.Add(new ConfLanguageItem(58, "Eyebrows", "眉毛", "Eyebrows"));
		allConfBase.Add(new ConfLanguageItem(59, "Brow 1", "浏览器1", "Brow 1"));
		allConfBase.Add(new ConfLanguageItem(60, "Brow 2", "浏览器2", "Brow 2"));
		allConfBase.Add(new ConfLanguageItem(61, "High-Res Brows", "高分辨率眉毛", "High-Res Brows"));
		allConfBase.Add(new ConfLanguageItem(62, "High-Res Brows 2", "高分辨率眉毛2", "High-Res Brows 2"));
		allConfBase.Add(new ConfLanguageItem(63, "Eyes", "眼睛", "Eyes"));
		allConfBase.Add(new ConfLanguageItem(64, "Alligator Eyes", "鳄鱼眼睛", "Alligator Eyes"));
		allConfBase.Add(new ConfLanguageItem(65, "Alligator Eyes Alt Test", "鳄鱼眼睛替代测试", "Alligator Eyes Alt Test"));
		allConfBase.Add(new ConfLanguageItem(66, "Cat Eyes", "猫眼", "Cat Eyes"));
		allConfBase.Add(new ConfLanguageItem(67, "Cat Eyes Alt", "猫眼Alt", "Cat Eyes Alt"));
		allConfBase.Add(new ConfLanguageItem(68, "large Eyes", "大眼睛", "large Eyes"));
		allConfBase.Add(new ConfLanguageItem(69, "Old Face", "老面孔", "Old Face"));
		allConfBase.Add(new ConfLanguageItem(70, "TrollFace", "巨魔脸", "TrollFace"));
		allConfBase.Add(new ConfLanguageItem(71, "AlienHeadMorph", "异形头变形", "AlienHeadMorph"));
		allConfBase.Add(new ConfLanguageItem(72, "Helmet", "头盔", "Helmet"));
		allConfBase.Add(new ConfLanguageItem(73, "Mystic Robe Hood", "神秘长袍帽", "Mystic Robe Hood"));
		allConfBase.Add(new ConfLanguageItem(74, "Underwear", "内衣", "Underwear"));
		allConfBase.Add(new ConfLanguageItem(75, "Default Underwear", "默认内衣", "Default Underwear"));
		allConfBase.Add(new ConfLanguageItem(76, "Ears", "耳朵", "Ears"));
		allConfBase.Add(new ConfLanguageItem(77, "BlendShapeRecipe", "混合形状配方", "BlendShapeRecipe"));
		allConfBase.Add(new ConfLanguageItem(78, "ElfEarsMorph", "精灵耳朵变形", "ElfEarsMorph"));
		allConfBase.Add(new ConfLanguageItem(79, "Physique", "体形", "Physique"));
		allConfBase.Add(new ConfLanguageItem(80, "OverweightMale", "超重男性", "OverweightMale"));
		allConfBase.Add(new ConfLanguageItem(81, "Shoulders", "肩膀", "Shoulders"));
		allConfBase.Add(new ConfLanguageItem(82, "MaleChallengerShouderPads", "男性挑战者手垫", "MaleChallengerShouderPads"));
		allConfBase.Add(new ConfLanguageItem(83, "Skin", "皮肤", "Skin"));
		allConfBase.Add(new ConfLanguageItem(84, "Hair", "头发", "Hair"));
		allConfBase.Add(new ConfLanguageItem(85, "Pants", "裤子", "Pants"));
		allConfBase.Add(new ConfLanguageItem(86, "skinGreenness", "皮肤绿色", "skinGreenness"));
		allConfBase.Add(new ConfLanguageItem(87, "skinBlueness", "皮肤发青", "skinBlueness"));
		allConfBase.Add(new ConfLanguageItem(88, "skinRedness", "皮肤发红", "skinRedness"));
		allConfBase.Add(new ConfLanguageItem(89, "breastCleavage", "乳沟", "breastCleavage"));
		allConfBase.Add(new ConfLanguageItem(90, "height", "高度", "height"));
		allConfBase.Add(new ConfLanguageItem(91, "headSize", "头部尺寸", "headSize"));
		allConfBase.Add(new ConfLanguageItem(92, "headWidth", "头部宽度", "headWidth"));
		allConfBase.Add(new ConfLanguageItem(93, "neckThickness", "颈部厚度", "neckThickness"));
		allConfBase.Add(new ConfLanguageItem(94, "armLength", "臂长", "armLength"));
		allConfBase.Add(new ConfLanguageItem(95, "forearmLength", "前臂长度", "forearmLength"));
		allConfBase.Add(new ConfLanguageItem(96, "armWidth", "臂宽", "armWidth"));
		allConfBase.Add(new ConfLanguageItem(97, "forearmWidth", "前臂宽度", "forearmWidth"));
		allConfBase.Add(new ConfLanguageItem(98, "handsSize", "手的大小", "handsSize"));
		allConfBase.Add(new ConfLanguageItem(99, "feetSize", "脚大小", "feetSize"));
		allConfBase.Add(new ConfLanguageItem(100, "legSeparation", "腿部间距", "legSeparation"));
		allConfBase.Add(new ConfLanguageItem(101, "upperMuscle", "上部肌肉", "upperMuscle"));
		allConfBase.Add(new ConfLanguageItem(102, "lowerMuscle", "下肌肉", "lowerMuscle"));
		allConfBase.Add(new ConfLanguageItem(103, "upperWeight", "上部重量", "upperWeight"));
		allConfBase.Add(new ConfLanguageItem(104, "lowerWeight", "重量", "lowerWeight"));
		allConfBase.Add(new ConfLanguageItem(105, "legsSize", "腿部尺寸", "legsSize"));
		allConfBase.Add(new ConfLanguageItem(106, "belly", "腹部", "belly"));
		allConfBase.Add(new ConfLanguageItem(107, "waist", "腰", "waist"));
		allConfBase.Add(new ConfLanguageItem(108, "gluteusSize", "臀肌大小", "gluteusSize"));
		allConfBase.Add(new ConfLanguageItem(109, "earsSize", "耳朵大小", "earsSize"));
		allConfBase.Add(new ConfLanguageItem(110, "earsPosition", "耳朵的位置", "earsPosition"));
		allConfBase.Add(new ConfLanguageItem(111, "earsRotation", "耳朵旋转", "earsRotation"));
		allConfBase.Add(new ConfLanguageItem(112, "noseSize", "鼻子大小", "noseSize"));
		allConfBase.Add(new ConfLanguageItem(113, "noseCurve", "鼻子曲线", "noseCurve"));
		allConfBase.Add(new ConfLanguageItem(114, "noseWidth", "鼻头宽度", "noseWidth"));
		allConfBase.Add(new ConfLanguageItem(115, "noseInclination", "鼻子倾斜", "noseInclination"));
		allConfBase.Add(new ConfLanguageItem(116, "nosePosition", "鼻头位置", "nosePosition"));
		allConfBase.Add(new ConfLanguageItem(117, "nose", "鼻子", "nose"));
		allConfBase.Add(new ConfLanguageItem(118, "nosePronounced", "突出鼻子", "nosePronounced"));
		allConfBase.Add(new ConfLanguageItem(119, "noseFlatten", "压平鼻子", "noseFlatten"));
		allConfBase.Add(new ConfLanguageItem(120, "chin", "下巴", "chin"));
		allConfBase.Add(new ConfLanguageItem(121, "chinSize", "下巴尺寸", "chinSize"));
		allConfBase.Add(new ConfLanguageItem(122, "chinPronounced", "下巴大小", "chinPronounced"));
		allConfBase.Add(new ConfLanguageItem(123, "chinPosition", "下巴位置", "chinPosition"));
		allConfBase.Add(new ConfLanguageItem(124, "mandibleSize", "下颌骨大小", "mandibleSize"));
		allConfBase.Add(new ConfLanguageItem(125, "jawsSize", "颌骨大小", "jawsSize"));
		allConfBase.Add(new ConfLanguageItem(126, "jawsPosition", "颌骨位置", "jawsPosition"));
		allConfBase.Add(new ConfLanguageItem(127, "cheekSize", "脸颊大小", "cheekSize"));
		allConfBase.Add(new ConfLanguageItem(128, "cheekPosition", "脸颊位置", "cheekPosition"));
		allConfBase.Add(new ConfLanguageItem(129, "lowCheekPronounced", "低脸颊大小", "lowCheekPronounced"));
		allConfBase.Add(new ConfLanguageItem(130, "lowCheekPosition", "低脸颊位置", "lowCheekPosition"));
		allConfBase.Add(new ConfLanguageItem(131, "foreheadSize", "前额大小", "foreheadSize"));
		allConfBase.Add(new ConfLanguageItem(132, "foreheadPosition", "前额位置", "foreheadPosition"));
		allConfBase.Add(new ConfLanguageItem(133, "lipsSize", "嘴唇大小", "lipsSize"));
		allConfBase.Add(new ConfLanguageItem(134, "mouth", "嘴巴", "mouth"));
		allConfBase.Add(new ConfLanguageItem(135, "mouthSize", "嘴巴大小", "mouthSize"));
		allConfBase.Add(new ConfLanguageItem(136, "eyeRotation", "眼睛旋转", "eyeRotation"));
		allConfBase.Add(new ConfLanguageItem(137, "eyeSize", "眼睛大小", "eyeSize"));
		allConfBase.Add(new ConfLanguageItem(138, "breastSize", "乳房大小", "breastSize"));
		allConfBase.Add(new ConfLanguageItem(139, "eyeSpacing", "眼间距", "eyeSpacing"));
		allConfBase.Add(new ConfLanguageItem(140, "Undies", "内衣", "Undies"));
		allConfBase.Add(new ConfLanguageItem(141, "Ladies Intimate Wear", "内衣2", "Ladies Intimate Wear"));
		allConfBase.Add(new ConfLanguageItem(142, "FemaleHandsMid", "女性双手中间", "Female Hands Mid"));
		allConfBase.Add(new ConfLanguageItem(143, "FemaleTankTop", "背心", "Female Tank Top"));
		allConfBase.Add(new ConfLanguageItem(144, "FemaleSportPants", "高腰裤", "Female Sport Pants"));
		allConfBase.Add(new ConfLanguageItem(145, "Pants 1", "低腰裤", "Pants 1"));
		allConfBase.Add(new ConfLanguageItem(146, "Pants 2", "花裤子", "Pants 2"));
		allConfBase.Add(new ConfLanguageItem(147, "FemaleLongHair", "中分", "Long Hair"));
		allConfBase.Add(new ConfLanguageItem(148, "FemalePonyTail", "马尾1", "Pony Tail"));
		allConfBase.Add(new ConfLanguageItem(149, "Hair 1", "双马尾", "Hair 1"));
		allConfBase.Add(new ConfLanguageItem(150, "Hair 2", "短发", "Hair 2"));
		allConfBase.Add(new ConfLanguageItem(151, "Hair 3", "梨花头", "Hair 3"));
		allConfBase.Add(new ConfLanguageItem(152, "BoneyTail", "马尾2", "Boney Tail"));
		allConfBase.Add(new ConfLanguageItem(153, "High Tops - Black", "黑色", "High Tops Black"));
		allConfBase.Add(new ConfLanguageItem(154, "High Tops - Turquoise", "松绿", "High Tops Turquoise"));
		allConfBase.Add(new ConfLanguageItem(155, "High Tops - White", "白色", "High Tops White"));
		allConfBase.Add(new ConfLanguageItem(156, "Color", "颜色", "Color"));
		allConfBase.Add(new ConfLanguageItem(157, "Lipstick", "口红", "Lipstick"));
		allConfBase.Add(new ConfLanguageItem(158, "Shirt", "衬衫", "Shirt"));
		allConfBase.Add(new ConfLanguageItem(159, "Pants Accent", "裤子花纹", "Pants Accent"));
		allConfBase.Add(new ConfLanguageItem(160, "HairAccent", "发饰", "HairAccent"));
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
	
