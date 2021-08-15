using System.Collections;
using System.Collections.Generic;
using UMA;
using UMA.CharacterSystem;
using UnityEngine;

public static class UMATools {

    // ��������
    public static void SaveUMA(DynamicCharacterAvatar Avatar, string key = "PlayerUMA") {
        StaticTools.SetString(key, Avatar.GetCurrentRecipe());
    }

    // ��ȡ����
    public static void LoadUMA(DynamicCharacterAvatar Avatar, string key = "PlayerUMA") {
        string str = StaticTools.GetString(key);
        if (string.IsNullOrEmpty(str))
            return;
        Avatar.LoadFromRecipeString(str);
        Avatar.BuildCharacter(false);
    }

    // �������
    public static void ChangeRace(DynamicCharacterAvatar Avatar, string race) {
        Avatar.ChangeRace(race);
        Avatar.gameObject.SetActive(true);
        Avatar.BuildCharacterEnabled = true;
    }
    
    // ��ȡ��λ
    public static Dictionary<string, List<UMATextRecipe>> GetWardrobes(DynamicCharacterAvatar Avatar) {
        Dictionary<string, List<UMATextRecipe>> recipes = Avatar.AvailableRecipes;
        return recipes;
    }

    // �����λ
    public static void SetRecipe(DynamicCharacterAvatar Avatar, UMATextRecipe recipe) {
        Avatar.SetSlot(recipe);
        Avatar.BuildCharacter(true);
    }

    // �����λ
    public static void ClearRecipe(DynamicCharacterAvatar Avatar, string slotName) {
        Avatar.ClearSlot(slotName);
        Avatar.BuildCharacter(true);
    }

    // ��ȡ��ɫ
    public static OverlayColorData[] GetColors(DynamicCharacterAvatar Avatar) {
        OverlayColorData[] colors = Avatar.CurrentSharedColors;
        return colors;
    }

    // ������ɫ
    public static void SetColors(DynamicCharacterAvatar Avatar, OverlayColorData ocd, Color color) {
        ocd.channelMask[0] = color;
        Avatar.SetColor(ocd.name, ocd, true);
    }


    // ��ȡDNA
    public static Dictionary<string, DnaSetter> GetDna(DynamicCharacterAvatar Avatar) {
        return Avatar.GetDNA();
    }


    // ����DNA
    public static void SetDna(DynamicCharacterAvatar Avatar, string dnaName, float value) {
        Avatar.GetDNA()[dnaName].Set(value);
        Avatar.ForceUpdate(true);
    }
}
