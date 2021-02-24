using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseWindow : MonoBehaviour
{
    public virtual void ClickClose() {
        MainUI.instance.OnEsc();
    }
}
