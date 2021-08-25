using System.Collections;
using System.Collections.Generic;
using UMA;
using UMA.CharacterSystem;
using UnityEngine;

public static class UMATools {

    // 保存捏人
    public static string SaveUMA(DynamicCharacterAvatar Avatar) {
        return Avatar.GetCurrentRecipe();
    }

    // 读取捏人
    public static void LoadUMA(DynamicCharacterAvatar Avatar, string data) {
        Avatar.LoadFromRecipeString(data);
        Avatar.BuildCharacter(true);
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
        return recipes;
    }

    // 插入槽位
    public static void SetRecipe(DynamicCharacterAvatar Avatar, UMATextRecipe recipe) {
        Avatar.SetSlot(recipe);
        Avatar.BuildCharacter(true);
    }

    // 清除槽位
    public static void ClearRecipe(DynamicCharacterAvatar Avatar, string slotName) {
        Avatar.ClearSlot(slotName);
        Avatar.BuildCharacter(true);
    }

    // 获取颜色
    public static OverlayColorData[] GetColors(DynamicCharacterAvatar Avatar) {
        OverlayColorData[] colors = Avatar.CurrentSharedColors;
        return colors;
    }

    // 设置颜色
    public static void SetColors(DynamicCharacterAvatar Avatar, OverlayColorData ocd, Color color) {
        ocd.channelMask[0] = color;
        Avatar.SetColor(ocd.name, ocd, true);
    }


    // 获取DNA
    public static Dictionary<string, DnaSetter> GetDna(DynamicCharacterAvatar Avatar) {
        return Avatar.GetDNA();
    }


    // 设置DNA
    public static void SetDna(DynamicCharacterAvatar Avatar, string dnaName, float value) {
        Avatar.GetDNA()[dnaName].Set(value);
        Avatar.ForceUpdate(true);
    }
}
