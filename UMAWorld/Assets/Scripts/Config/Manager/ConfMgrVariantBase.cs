using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfMgrVariantBase
{
	public ConfLanguage language { get { g.game.conf.language.onGetItemObjectHandler = GetItemObjectHandler(g.game.conf.language); return g.game.conf.data.language; } }		//多语言表.xlsx
	public ConfSkill skill { get { g.game.conf.skill.onGetItemObjectHandler = GetItemObjectHandler(g.game.conf.skill); return g.game.conf.data.skill; } }		//技能表.xlsx

    public virtual ReturnAction<ConfBaseItem, int> GetItemObjectHandler(ConfBase confBase)
    {
        return null;
    }
}
