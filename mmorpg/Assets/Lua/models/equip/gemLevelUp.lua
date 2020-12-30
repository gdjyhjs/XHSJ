--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-01 20:22:35
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local EquipUserData = require("models.equip.equipUserData")

local GemLevelUp=class(UIBase,function(self,item_obj,parent_ui,gem_ui)
    UIBase._ctor(self, "gem_level_up.u3d", item_obj) -- 资源名字全部是小写
    self.parent_ui = parent_ui
    self.gem_ui = gem_ui
end)

-- 资源加载完成
function GemLevelUp:on_asset_load(key,asset)
	self:gem_type_dropdown_valuechange(0)
end

function GemLevelUp:on_click(obj,arg)
	print("宝石升级点击事件，",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "hideBaoshihechengBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd == "baoshihechengBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:gem_level_up_c2s(self.target_gem_id,self.refer:Get("use_grandson_gem").isOn)
	elseif  not Seven.PublicFun.IsNull(arg) then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local cmd = arg.name
		if cmd == "selectGemTypeDropdown" then
			self:gem_type_dropdown_valuechange(arg.value)
		elseif cmd == "selectGemLevelDropdown" then
			self:gem_level_dropdown_valuechange(arg.value)
		end
	end
end

--宝石类型下拉框变化值变化
function GemLevelUp:gem_type_dropdown_valuechange(value)
	self.target_type = EquipUserData:get_gem_type_dropdown_value(value)
	print("宝石类型下拉框变化值变化",value,"要合成的宝石类型",self.target_type)
	self:gem_level_dropdown_valuechange(0)
end

--宝石等级下拉框值变化
function GemLevelUp:gem_level_dropdown_valuechange(value)
	self.target_lv = EquipUserData:gem_level_dropdown_value(value)
	print("宝石等级下拉框值变化",value,"要合成的宝石等级",self.target_lv)
	--获取选择要合成的宝石 id
	print(string.format("要合成的宝石等级 %d 类型 %d",self.target_type or 0,self.target_lv or 0))
	self.target_gem_id = self.item_obj:get_gem_for_type(self.target_type,self.target_lv)
	self.need_gem_id = self.item_obj:get_last_level_gem(self.target_gem_id)
	--修改物品图标
	print(string.format("目标id %d 所需id %d",self.target_gem_id,self.need_gem_id))
	gf_set_item(self.target_gem_id,self.refer:Get("target_gem_ico"))
	gf_set_item(self.need_gem_id,self.refer:Get("need_gem_ico"))

	self:refresh_baoshihecheng_count()
end

function GemLevelUp:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
		if(id2== Net:get_id2("bag", "SmartGemLevelUpR"))then --镶嵌
			if msg.err == 0 then
				self:refresh_baoshihecheng_count()
			end
		end
	end
end

--刷新宝石合成数量
function GemLevelUp:refresh_baoshihecheng_count()
	local bag = LuaItemManager:get_item_obejct("bag")
	self.refer:Get("need_gem_text").text = string.format("%d/3",bag:get_item_count(need_gem_id,Enum.BAG_TYPE.NORMAL))
	self.refer:Get("target_gem_text").text = string.format("1/(已有%d)",bag:get_item_count(target_gem_id,Enum.BAG_TYPE.NORMAL))
end

function GemLevelUp:on_showed()
	StateManager:register_view( self )
end

function GemLevelUp:on_hided()
	StateManager:remove_register_view( self )
	self.gem_ui:select_equip_gem()
end

-- 释放资源
function GemLevelUp:dispose()
    self._base.dispose(self)
 end

return GemLevelUp

