using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfCharLevel : ConfCharLevelBase
{
    public override void OnInit()
    {
        base.OnInit();
    }

    public void SetName(LanguageText text, int level) {
        ConfCharLevelItem conf = GetItem(level);
        text.Text("{0} {1}",false, new LanguageText.LanguageParam( conf.namefront, true), new LanguageText.LanguageParam(conf.nameback, true));
    }
}
