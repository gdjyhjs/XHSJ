-- --[[--
--
-- @Author:Seven
-- @DateTime:2017-11-15 22:07:53
--]]
-- 镶嵌宝石达60级以上
-- <color=#E9DDC7FF>攻击：</color>185
-- <color=#E9DDC7FF>生命：</color>185
-- <color=#E9DDC7FF>防御：</color>185

-- 当前镶嵌宝石71级

-- 下级目标：
-- 镶嵌宝石达60级以上

-- <color=#E9DDC7FF>攻击：</color>185
-- <color=#E9DDC7FF>生命：</color>185
-- <color=#E9DDC7FF>防御：</color>185
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GemTarget=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "gem_tip.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function GemTarget:on_asset_load(key,asset)
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local gem_lv = self.item_obj:get_inlay_gem_level()
	local cur_lv,target_lv = self.item_obj:get_gem_target()
	print("当前",cur_lv,"目标",target_lv,"当前",gem_lv)
	local cur_attr_list = ConfigMgr:get_config("equip_gem_totalLv")[cur_lv]
	local list = cur_attr_list and cur_attr_list.attr or {}
	local cur_attr = ""
	local gem_tip_1 = self.refer:Get("gem_tip_1")
	local gem_tip_2 = self.refer:Get("gem_tip_2")
	if #list>0 then
		gem_tip_1.gameObject:SetActive(true)
		gem_tip_2.gameObject:SetActive(true)
		gem_tip_1.text = string.format(gf_localize_string("镶嵌宝石达%d级以上"),cur_lv)
		for i,v in ipairs(list) do
			if i > 1 then
				cur_attr = cur_attr .. "\n"
			end
			cur_attr = cur_attr .. string.format("<color=#E9DDC7FF>%s：</color>%d",itemSys:get_combat_attr_name(v[1]),v[2])
		end
		gem_tip_2.text = cur_attr
	else
		gem_tip_1.gameObject:SetActive(false)
		gem_tip_2.gameObject:SetActive(false)
	end
	self.refer:Get("gem_tip_3").text = string.format(gf_localize_string("当前镶嵌宝石%d级"),gem_lv)
	local target_attr_list = ConfigMgr:get_config("equip_gem_totalLv")[target_lv]
	local list = target_attr_list and target_attr_list.attr or {}
	local target_attr = ""
	local gem_tip_4 = self.refer:Get("gem_tip_4")
	local gem_tip_5 = self.refer:Get("gem_tip_5")
	if #list>0 then
		gem_tip_4.gameObject:SetActive(true)
		gem_tip_5.gameObject:SetActive(true)
		gem_tip_4.text = string.format(gf_localize_string("下级目标：\n镶嵌宝石达%d级以上"),target_lv)
		for i,v in ipairs(list) do
			if i > 1 then
				target_attr = target_attr .. "\n"
			end
			target_attr = target_attr .. string.format("<color=#E9DDC7FF>%s：</color>%d",itemSys:get_combat_attr_name(v[1]),v[2])
		end
		gem_tip_5.text = target_attr
	else
		gem_tip_4.gameObject:SetActive(false)
		gem_tip_5.gameObject:SetActive(false)
	end

	StateManager:register_view( self )
end

function GemTarget:on_click()
	self:dispose()
end

-- 释放资源
function GemTarget:dispose()

	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return GemTarget

