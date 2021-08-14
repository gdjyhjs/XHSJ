using UMA.CharacterSystem;
using UMA;
using UnityEngine;
using UnityEngine.UI;
using System.Runtime.Serialization.Formatters.Binary;

public class UICreateRole : MonoBehaviour
{
    public DynamicCharacterAvatar Avatar;
    public UMARandomAvatar Randomizer;

    public GameObject btnPrefab;
    public Transform list1;
    public Transform list2;

    private string bigTyp;
    private string subTyp;
    private string smallTyp;

    string[] races = new string[]{
        "HumanMale",
        "HumanFemale",
        "Elf Female",
        "Elf Male",
    };

    private void Start() {
        UMATools.SaveUMA(Avatar, "DefaultUMA");
    }

    public void GenerateANewUMA()
    {
        Randomizer.Randomize(Avatar);
        Avatar.BuildCharacter(true);
    }

    public void StartGame()
    {
        UMATools.SaveUMA(Avatar);
    }

    public void RestUMA() {
        UMATools.LoadUMA(Avatar);
    }

    public void OnClickRace() {
        subTyp = "";
        smallTyp = "";
        StaticTools.DestoryChilds(list1);
        StaticTools.DestoryChilds(list2);

        if (bigTyp == "OnClickRace") {
            bigTyp = "";
        } else {
            bigTyp = "OnClickRace";
            for (int i = 0; i < races.Length; i++) {
                string face = races[i];
                GameObject go = Instantiate(btnPrefab, list1);
                go.GetComponentInChildren<Text>().text = StaticTools.LS(face);
                go.GetComponent<Button>().onClick.AddListener(() => {
                    UMATools.ChangeRace(Avatar, face);
                });
                go.SetActive(true);
            }
        }
    }

    public void OnClickWardrobes() {
    }

    public void OnClickBody() {
    }

    public void OnClickFace() {
    }
}
