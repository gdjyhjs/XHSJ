using System.Collections;
using System.Collections.Generic;
using UMA;
using UMA.CharacterSystem;
using UnityEngine;

public static class UMATools {

    // 保存捏人
    public static void SaveUMA(DynamicCharacterAvatar Avatar, string key = "PlayerUMA") {
        StaticTools.SetString(key, Avatar.GetCurrentRecipe());
    }

    // 读取捏人
    public static void LoadUMA(DynamicCharacterAvatar Avatar, string key = "PlayerUMA") {
        string str = StaticTools.GetString(key);
        if (string.IsNullOrEmpty(str))
            return;
        Avatar.LoadFromRecipeString(str);
        Avatar.BuildCharacter(false);
    }

    // 变更种族
    public static void ChangeRace(DynamicCharacterAvatar Avatar, string race) {
        Avatar.ChangeRace(race);
        Avatar.gameObject.SetActive(true);
        Avatar.BuildCharacterEnabled = true;
    }
    
    // 获取槽位
    public static Dictionary<string, List<UMATextRecipe>> GetWardrobes(DynamicCharacterAvatar Avatar) {
        Dictionary<string, List<UMATextRecipe>> recipes = Avatar.AvailableRecipes;
        //foreach (KeyValuePair<string, List<UMATextRecipe>> item in recipes) {
        //    string SlotName = item.Key;
        //    Debug.Log("槽位名字 = " + SlotName);
        //    List<UMATextRecipe> SlotRecipes = item.Value;
        //    foreach (UMATextRecipe utr in SlotRecipes) {
        //        string name;
        //        if (string.IsNullOrEmpty(utr.DisplayValue))
        //            name = utr.name;
        //        else
        //            name = utr.DisplayValue;
        //        Debug.Log("配件名字 = " + name);
        //    }
        //}
        return recipes;
    }

    // 插入槽位
    public static void SetRecipe(DynamicCharacterAvatar Avatar, UMATextRecipe recipe) {
        Avatar.SetSlot(recipe);
        Avatar.BuildCharacter(true);
    }

    // 获取颜色
    public static void GetColors(DynamicCharacterAvatar Avatar) {
        OverlayColorData[] colors = Avatar.CurrentSharedColors;
        foreach (UMA.OverlayColorData ocd in colors) {
            Debug.Log("颜色配件 = " + ocd.name);
        }
    }

    // 设置颜色
    public static void SetColors(DynamicCharacterAvatar Avatar, string colorName, OverlayColorData ocd) {
        OverlayColorData[] colors = Avatar.CurrentSharedColors;
        Avatar.SetColor(colorName, ocd);
    }


    // 获取DNA
    public static void GetDna(DynamicCharacterAvatar Avatar) {
        Dictionary<string, DnaSetter> AllDNA = Avatar.GetDNA();
        foreach (KeyValuePair<string, DnaSetter> ds in AllDNA) {
            Debug.Log("dna = " + ds.Value.Name);
        }
    }


    // 设置DNA
    public static void SetDna(DynamicCharacterAvatar Avatar, string dnaName, float value) {
        Avatar.GetDNA()[dnaName].Set(value);
        Avatar.ForceUpdate(true);
    }
}
