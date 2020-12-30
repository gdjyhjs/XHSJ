--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-15 23:40:16
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GemUpgrade=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "gem_upgrade.u3d", item_obj) -- 资源名字全部是小写
    self.itemId = itemId
    self.targetId = targetId
    self.needCount = needCount
    self.equipType = equipType
    self.idx = idx
end)

function GemUpgrade:set_data(itemId,targetId,needCount,equipType,idx)
    self.itemId = itemId
    self.targetId = targetId
    self.needCount = needCount
    self.equipType = equipType
    self.idx = idx
    if self.init then
    	self:init_ui()
    end
end

-- 资源加载完成
function GemUpgrade:on_asset_load(key,asset)
	self.init = true
	self:init_ui()
    StateManager:register_view( self )
end

function GemUpgrade:init_ui()
	if not self.itemId then
		return
	end
	local bag = LuaItemManager:get_item_obejct("bag")
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local obj = {}
	local data = {}
	data[1] = ConfigMgr:get_config("item")[self.itemId]
	data[1] = ConfigMgr:get_config("item")[self.itemId]
	data[2] = ConfigMgr:get_config("item")[self.targetId]
	obj[1] = self.refer:Get("item")
	obj[2] = self.refer:Get("target")
	for i=1,2 do
		local icon = obj[i]:Find("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = obj[i]:GetComponent(UnityEngine_UI_Image)
		gf_set_item(data[i].code,icon,bg)
		obj[i]:Find("name"):GetComponent("UnityEngine.UI.Text").text = itemSys:give_color_for_string(data[i].name,data[i].color)
		local attr = ""
		for i,v in ipairs(data[i].effect) do
			if i>1 then
				attr = attr .. "\n"
			end
			attr = attr .. itemSys:get_combat_attr_name(v[1],v[2])
		end
		obj[i]:Find("attr"):GetComponent("UnityEngine.UI.Text").text = attr
	end
	local count = bag:get_item_count(data[1].code,ServerEnum.BAG_TYPE.NORMAL)
	local str = "%d/%d"
	obj[1]:Find("count"):GetComponent("UnityEngine.UI.Text").text = string.format(str,count,self.needCount)
	obj[2]:Find("count"):GetComponent("UnityEngine.UI.Text").text = 1
end

function GemUpgrade:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd=="upgradeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("升级宝石")
		self.item_obj:gem_level_up_inLay_c2s(self.equipType,self.itemId,self.idx)
		gf_mask_show(true)
		self:dispose()
	end
end

-- 释放资源
function GemUpgrade:dispose()
	self.init = nil
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return GemUpgrade

