using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfMgrVariantBase
{
	public ConfLanguage language { get { g.game.conf.language.onGetItemObjectHandler = GetItemObjectHandler(g.game.conf.language); return g.game.conf.data.language; } }		//多语言表.xlsx
	public ConfSkill skill { get { g.game.conf.skill.onGetItemObjectHandler = GetItemObjectHandler(g.game.conf.skill); return g.game.conf.data.skill; } }		//技能表.xlsx
	public ConfCreateRoleAttribute createRoleAttribute { get { g.game.conf.createRoleAttribute.onGetItemObjectHandler = GetItemObjectHandler(g.game.conf.createRoleAttribute); return g.game.conf.data.createRoleAttribute; } }		//角色属性.xlsx
	public ConfCharLevel charLevel { get { g.game.conf.charLevel.onGetItemObjectHandler = GetItemObjectHandler(g.game.conf.charLevel); return g.game.conf.data.charLevel; } }		//角色属性.xlsx

    public virtual ReturnAction<ConfBaseItem, int> GetItemObjectHandler(ConfBase confBase)
    {
        return null;
    }
}
