using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 外观
public class Appearance
{
    public enum Sex {
        Man,
        Woman,
    }
    public enum Race {
        Human,
        Elf,
    }
    public string umaData;
    public string name;
    public Sex sex;
    public Race race;
}
