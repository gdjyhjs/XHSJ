using UMA.CharacterSystem;
using UMA;
using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

public class UICreateRole : MonoBehaviour
{

    public DynamicCharacterAvatar Avatar;
    public UMARandomAvatar Randomizer;

    public GameObject btnPrefab;
    public GameObject sliderPrefab;
    public Transform list1;
    public Transform list2;
    public MouseOrbitImproved cam;
    public InputField inputPlayerName;

    [SerializeField]
    GameObject colorPanel;


    string Select2;


    string[] races = new string[]{
        "HumanFemale",
        "HumanMale",
        "Elf Female",
        "Elf Male",
    };
    Dictionary<string, string[]> bodys = new Dictionary<string, string[]>() {
        ["Hands"] = new string[] {
            "armLength",
            "forearmLength",
            "armWidth",
            "forearmWidth",
            "handsSize",
        },
        ["Feet"] = new string[] {
            "feetSize",
            "legSeparation",
            "legsSize",
        },
        ["trunk"] = new string[] {
            "height",
            "upperMuscle",
            "lowerMuscle",
            "upperWeight",
            "lowerWeight",
            "belly",
            "waist",
            "gluteusSize",
        },
        ["chest"] = new string[] {
            "breastSize",
            "breastCleavage",
        },
    };

    Dictionary<string, string[]> faces = new Dictionary<string, string[]>() {
        ["Eyes"] = new string[] {
            "eyeRotation",
            "eyeSize",
            "eyeSpacing",
        },
        ["mouth"] = new string[] {
            "lipsSize",
            "mouthSize",
        },
        ["nose"] = new string[] {
            "noseSize",
            "noseCurve",
            "noseWidth",
            "noseInclination",
            "nosePosition",
            "nosePronounced",
            "noseFlatten",
        },
        ["Ears"] = new string[] {
            "earsSize",
            "earsPosition",
            "earsRotation",
        },
        ["Head"] = new string[] {
            "headSize",
            "headWidth",
            "neckThickness",
            "foreheadSize",
            "foreheadPosition",
        },
        ["chin"] = new string[] {
            "chinSize",
            "chinPronounced",
            "chinPosition",
            "mandibleSize",
        },
        ["Face"] = new string[] {
            "jawsSize",
            "jawsPosition",
            "cheekSize",
            "cheekPosition",
            "lowCheekPronounced",
            "lowCheekPosition",
        },
    };

    private void Awake() {
        StaticTools.Init();
    }

    private void Start() {
        InitAvatar();
    }

    public void GenerateANewUMA()
    {
        Randomizer.Randomize(Avatar);
        Avatar.BuildCharacter(true);
    }

    public void StartGame()
    {
        if (string.IsNullOrWhiteSpace(inputPlayerName.text)) {
            return;
        }

        string data = UMATools.SaveUMA(Avatar);
        string id = inputPlayerName.text;
        UnitBase player = g.units.NewUnit(id);
        g.units.playerUnitID = id;
        player.appearance.umaData = data;
        g.data.SaveGame(id, 0);
        StaticTools.SetString(DataKey.onPlayerName, id);
        StaticTools.LoadScene("World");
    }

    public void RestUMA() {
        //UMATools.LoadUMA(Avatar);
    }

    
    public void OnClickEnglish() {
        StaticTools.ChangeLanguage("en");
    }

    public void OnClicSChinese() {
        StaticTools.ChangeLanguage("ch");
    }



    public void OnClickRace() {
        colorPanel.gameObject.SetActive(false);
        StaticTools.DestoryChilds(list1);
        StaticTools.DestoryChilds(list2);
        LookBody();
        for (int i = 0; i < races.Length; i++) {
            string face = races[i];
            GameObject go = Instantiate(btnPrefab, list1);
            go.SetActive(true);
            go.GetComponentInChildren<LanguageText>().text = face;
            go.GetComponent<Button>().onClick.AddListener(() => {
                UMATools.ChangeRace(Avatar, face);
                InitAvatar();
            });
        }
    }

    public void OnClickWardrobes() {
        colorPanel.gameObject.SetActive(false);
        StaticTools.DestoryChilds(list1);
        StaticTools.DestoryChilds(list2);
        LookBody();
        Dictionary<string, List<UMATextRecipe>> wardrobes = UMATools.GetWardrobes(Avatar);
        foreach (string slotName in wardrobes.Keys) {
            if (slotName == "Hands" || slotName == "AlternateHead" || slotName == "Complexion" || slotName == "Face" || 
                slotName == "Helmet" || slotName == "Underwear" || slotName == "Ears" || slotName == "Physique" || slotName == "Shoulders"
                || slotName == "Eyebrows" || slotName == "Eyes")
                continue;
            GameObject go = Instantiate(btnPrefab, list1);
            go.SetActive(true);
            go.GetComponentInChildren<LanguageText>().text = slotName;
            go.GetComponent<Button>().onClick.AddListener(() => {
                StaticTools.DestoryChilds(list2);
                if (slotName == "Beard") {
                    GameObject go2 = Instantiate(btnPrefab, list2);
                    go2.SetActive(true);
                    go2.GetComponentInChildren<LanguageText>().text = "Sleek";
                    go2.GetComponent<Button>().onClick.AddListener(() => {
                        UMATools.ClearRecipe(Avatar, slotName);
                    });
                }
                foreach (UMATextRecipe utr in wardrobes[slotName]) {
                    string name;
                    if (string.IsNullOrEmpty(utr.DisplayValue))
                        name = utr.name;
                    else
                        name = utr.DisplayValue;
                    GameObject go2 = Instantiate(btnPrefab, list2);
                    go2.SetActive(true);
                    go2.GetComponentInChildren<LanguageText>().text = name;
                    go2.GetComponent<Button>().onClick.AddListener(() => {
                        UMATools.SetRecipe(Avatar, utr);
                    });
                }
                switch (slotName) {
                    case "Beard":
                    case "Hair":
                        LookHead();
                        break;
                    case "Feet":
                        LookFoot();
                        break;
                    default:
                        LookBody();
                        break;
                }
            });
        }
    }

    public void OnClickBody() {
        colorPanel.gameObject.SetActive(false);
        StaticTools.DestoryChilds(list1);
        StaticTools.DestoryChilds(list2);
        LookBody();
        SetDNA(bodys);
    }

    public void OnClickFace() {
        colorPanel.gameObject.SetActive(false);
        StaticTools.DestoryChilds(list1);
        StaticTools.DestoryChilds(list2);
        LookHead();
        SetDNA(faces);
    }

    private void SetDNA(Dictionary<string, string[]> data) {
        Dictionary<string, DnaSetter> dna = UMATools.GetDna(Avatar);
        foreach (KeyValuePair<string, string[]> item in data) {
            GameObject go = Instantiate(btnPrefab, list1);
            go.SetActive(true);
            go.GetComponentInChildren<LanguageText>().text = item.Key;
            go.GetComponent<Button>().onClick.AddListener(() => {
                StaticTools.DestoryChilds(list2);
                foreach (string item2 in item.Value) {
                    if (Avatar.activeRace.name.Contains("Male") && item2 == "breastCleavage")
                        continue;
                    GameObject go2 = Instantiate(sliderPrefab, list2);
                    go2.SetActive(true);
                    go2.GetComponentInChildren<LanguageText>().text = item2;
                    Slider slider = go2.GetComponentInChildren<Slider>();
                    switch (item2) {
                        case "armLength":
                            slider.minValue = .45f;
                            slider.maxValue = .55f;
                            break;
                        case "feetSize":
                            slider.minValue = .4f;
                            slider.maxValue = .6f;
                            break;
                        case "legsSize":
                            slider.minValue = .4f;
                            slider.maxValue = .7f;
                            break;
                        case "height":
                            slider.minValue = .4f;
                            slider.maxValue = .8f;
                            break;
                        case "nose":
                            slider.minValue = .4f;
                            slider.maxValue = .6f;
                            break;
                        case "earsPosition":
                            slider.minValue = .4f;
                            slider.maxValue = .6f;
                            break;
                        case "headSize":
                            slider.minValue = .45f;
                            slider.maxValue = .55f;
                            break;
                        case "headWidth":
                            slider.minValue = .4f;
                            slider.maxValue = .6f;
                            break;
                        case "chinPronounced":
                            slider.minValue = .3f;
                            slider.maxValue = .7f;
                            break;
                        case "mandibleSize":
                            slider.minValue = .45f;
                            slider.maxValue = .55f;
                            break;
                        case "jawsSize":
                            slider.minValue = .3f;
                            slider.maxValue = .7f;
                            break;
                        default:
                            slider.minValue = 0f;
                            slider.maxValue = 1f;
                            break;
                    }
                    slider.value = dna[item2].Get();
                    slider.onValueChanged.AddListener((value) => {
                        UMATools.SetDna(Avatar, item2, value);
                    });
                }
            });
        }
    }


    private void LookHead() {
        cam.TargetBone = MouseOrbitImproved.targetOpts.Head;
        cam.distance = 0.75f;
    }
    private void LookBody() {
        cam.TargetBone = MouseOrbitImproved.targetOpts.Chest;
        cam.distance = 2;
    }
    private void LookFoot() {
        cam.TargetBone = MouseOrbitImproved.targetOpts.LeftFoot;
        cam.distance = 1;
    }
    public void OnClickColors() {
        colorPanel.gameObject.SetActive(false);
        StaticTools.DestoryChilds(list1);
        StaticTools.DestoryChilds(list2);
        LookHead();
        OverlayColorData[] colors = UMATools.GetColors(Avatar);
        foreach (OverlayColorData item in colors) {
            GameObject go = Instantiate(btnPrefab, list1);
            go.SetActive(true);
            go.GetComponentInChildren<LanguageText>().text = item.name;
            go.GetComponent<Button>().onClick.AddListener(() => {
                colorPanel.gameObject.SetActive(true);
                colorPanel.GetComponent<UIColorPanel>().SetColor(item.channelMask[0], (color)=> {
                    UMATools.SetColors(Avatar, item, color);
                });
            });
        }
    }

    private void InitAvatar() {
        // 随机上衣 裤子 鞋子
        Dictionary<string, List<UMATextRecipe>> wardrobes = UMATools.GetWardrobes(Avatar);
        foreach (string slotName in wardrobes.Keys) {
            if (slotName == "Hands" || slotName == "AlternateHead" || slotName == "Complexion" || slotName == "Face" ||
                slotName == "Helmet" || slotName == "Underwear" || slotName == "Ears" || slotName == "Physique" || slotName == "Shoulders"
                || slotName == "Eyebrows" || slotName == "Eyes")
                continue;

            if (slotName == "Beard" && StaticTools.Random(0, wardrobes[slotName].Count + 1) == 0) {
                UMATools.ClearRecipe(Avatar, slotName);
                continue;
            }
            UMATools.SetRecipe(Avatar, wardrobes[slotName][StaticTools.Random(0, wardrobes[slotName].Count)]);
        }
    }
}
