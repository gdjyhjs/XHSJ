using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GuiBaseUI;
using UnityEngine.EventSystems;
using UnityEngine.Events;

public class RoleUI : MonoBehaviour
{
    public Text t_name;
    public Text t_pope;
    public Text t_race;
    public Text t_identity;
    public Text t_sex;
    public Text t_level;
    public Text t_interest;


    /// <summary>
    /// 内在性格
    /// </summary>
    public Text t_intrinsic;
    /// <summary>
    /// 外在性格
    /// </summary>
    public Text[] t_external;

    /// <summary>
    /// 先天气运
    /// </summary>
    public Text[] t_xiantian;

    /// <summary>
    /// 后天气运
    /// </summary>
    public Text[] t_houtian;


    

    void UpdateUI() {

    }
}
