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
        //foreach (KeyValuePair<string, List<UMATextRecipe>> item in recipes) {
        //    string SlotName = item.Key;
        //    Debug.Log("��λ���� = " + SlotName);
        //    List<UMATextRecipe> SlotRecipes = item.Value;
        //    foreach (UMATextRecipe utr in SlotRecipes) {
        //        string name;
        //        if (string.IsNullOrEmpty(utr.DisplayValue))
        //            name = utr.name;
        //        else
        //            name = utr.DisplayValue;
        //        Debug.Log("������� = " + name);
        //    }
        //}
        return recipes;
    }

    // �����λ
    public static void SetRecipe(DynamicCharacterAvatar Avatar, UMATextRecipe recipe) {
        Avatar.SetSlot(recipe);
        Avatar.BuildCharacter(true);
    }

    // ��ȡ��ɫ
    public static void GetColors(DynamicCharacterAvatar Avatar) {
        OverlayColorData[] colors = Avatar.CurrentSharedColors;
        foreach (UMA.OverlayColorData ocd in colors) {
            Debug.Log("��ɫ��� = " + ocd.name);
        }
    }

    // ������ɫ
    public static void SetColors(DynamicCharacterAvatar Avatar, string colorName, OverlayColorData ocd) {
        OverlayColorData[] colors = Avatar.CurrentSharedColors;
        Avatar.SetColor(colorName, ocd);
    }


    // ��ȡDNA
    public static void GetDna(DynamicCharacterAvatar Avatar) {
        Dictionary<string, DnaSetter> AllDNA = Avatar.GetDNA();
        foreach (KeyValuePair<string, DnaSetter> ds in AllDNA) {
            Debug.Log("dna = " + ds.Value.Name);
        }
    }


    // ����DNA
    public static void SetDna(DynamicCharacterAvatar Avatar, string dnaName, float value) {
        Avatar.GetDNA()[dnaName].Set(value);
        Avatar.ForceUpdate(true);
    }
}
