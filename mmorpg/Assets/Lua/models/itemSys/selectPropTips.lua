--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-01 17:01:03
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SelectPropTips=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "select_prop_tips.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function SelectPropTips:on_asset_load(key,asset)
	self.image_discolor_material = self.refer:Get("image_discolor_material").material
	self.itemRoot = self.refer:Get("itemRoot")
	self:set_list()
	self.init = true
end

function SelectPropTips:set_list()
	if not self.item_obj.select_prop_list or type(self.item_obj.select_prop_list)~="table" then
		self:hide()
		return
	end
	local itemRoot = self.itemRoot
	local count = itemRoot.childCount
	local item = itemRoot:GetChild(0).gameObject
	local bag = LuaItemManager:get_item_obejct("bag")
	gf_print_table(self.item_obj.select_prop_list,"所有道具选项")
	for i,v in ipairs(self.item_obj.select_prop_list) do
		if i > 1 then
			item = i <= count and itemRoot:GetChild(i-1).gameObject or LuaHelper.InstantiateLocal(item,itemRoot.gameObject)
		end
		-- print("设置道具",item)
		local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = item:GetComponent(UnityEngine_UI_Image)
		gf_set_item(v,icon,bg)
		local have_count = bag:get_item_count(v,ClientEnum.BAG_TYPE.BAG)
		-- print("设置拥有数量",item.transform:FindChild("count"),have_count)
		item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text").text = have_count
		if have_count>1 then
			icon.material = nil
			bg.material = nil
			item.name = "select_"..v
		else
			icon.material = self.image_discolor_material
			bg.material = self.image_discolor_material
			item.name = nil
		end
		item:SetActive(true)
	end
	for i=#self.item_obj.select_prop_list+1,count do
		itemRoot:GetChild(i-1).gameObject:SetActive(false)
	end
end

function SelectPropTips:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "cancleTips" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif string.find(cmd,"select_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.sel_propId = tonumber(string.split(cmd,"_")[2])
		self:hide()
	end
end

function SelectPropTips:on_showed()
    StateManager:register_view( self )
    if self.init then
		self:set_list()
    end
end

function SelectPropTips:on_hided()
	if self.item_obj.select_prop_fn then
		self.item_obj.select_prop_fn(self.sel_propId)
	end
	self.sel_propId = nil
	self.item_obj.select_prop_list = nil
	self.item_obj.select_prop_fn = nil

	StateManager:remove_register_view( self )
end

-- 释放资源
function SelectPropTips:dispose()
	self:hide()
	self.init = nil
    self._base.dispose(self)
 end

return SelectPropTips

