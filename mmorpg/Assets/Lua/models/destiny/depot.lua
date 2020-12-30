--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-23 17:25:43
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local DestinyTools = require("models.destiny.destinyTools")

local Depot=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "destiny_depot.u3d", item_obj) -- 资源名字全部是小写
    self.destiny_list = nil
end)

function Depot:set_data(destiny_list,sure_fn,inlay_type_list,title_name)
	self.destiny_list = destiny_list --{天命信息}
	self.sure_fn = sure_fn
	self.title_name = title_name
	self.inlay_type_list = inlay_type_list -- 身上镶嵌的天命类型 类型为键 用于判断某个类型是否已经镶嵌
	self.select_index = nil
	if self.init then
		self:set_list()
	end
end

-- 资源加载完成
function Depot:on_asset_load(key,asset)
	self.image_discolor_material = self.refer:Get("image_discolor_material").material
	self.itemRoot = self.refer:Get("itemRoot")
	self.uiTitleTxt = self.refer:Get("uiTitleTxt")
	self.qi_e = self.refer:Get("qi_e")
	self.btnHunt = self.refer:Get("btnHunt")
	self:set_list()
	self.init = true
end

function Depot:set_list()
	if not self.destiny_list or type(self.destiny_list)~="table" then
		self.destiny_list = {}
	end
	self.uiTitleTxt.text = self.title_name or "天命仓库"
	local itemRoot = self.itemRoot
	local count = itemRoot.childCount
	local item = itemRoot:GetChild(0).gameObject
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	-- gf_print_table(self.destiny_list,"所有道具选项")
	local can_select_count = 0
	for i,v in ipairs(self.destiny_list) do
		if i > 1 then
			item = i <= count and itemRoot:GetChild(i-1).gameObject or LuaHelper.InstantiateLocal(item,itemRoot.gameObject)
			item:GetComponent("UnityEngine.UI.Toggle").isOn = false
		else
			LuaHelper.eventSystemCurrentSelectedGameObject = item.gameObject
			item:GetComponent("UnityEngine.UI.Toggle").isOn = true
		end
		-- print("设置道具",item)
		local data = ConfigMgr:get_config("destiny_level")[v.destinyId]
		local icon = item.transform:Find("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = item.transform:Find("bg"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(bg,DestinyTools:get_destiny_bg(data.color))
		gf_setImageTexture(icon,data.icon)
		item.transform:Find("name"):GetComponent("UnityEngine.UI.Text").text = data.name
		item.transform:Find("lv"):GetComponent("UnityEngine.UI.Text").text = data.level
		local attr_str = ""
		if data.type == 0 then
			attr_str = gf_localize_string("只能用来分解")
		else
			if #data.level_attr>0 then
				attr_str = itemSys:get_combat_attr_name(data.level_attr[1],data.level_attr[2])
			end
			if #data.break_attr>0 then
				attr_str = attr_str.."\n"..itemSys:get_combat_attr_name(data.break_attr[1],data.break_attr[2])
			end
		end
		item.transform:Find("attr"):GetComponent("UnityEngine.UI.Text").text = attr_str
		if self.inlay_type_list[data.type] then
			item.transform:Find("own").gameObject:SetActive(data.type~=0)
			icon.material = self.image_discolor_material
			bg.material = self.image_discolor_material
			if i == 1 then
				item:GetComponent("UnityEngine.UI.Toggle").isOn = false
				self.select_index = nil
			end
		else
			item.transform:Find("own").gameObject:SetActive(false)
			icon.material = nil
			bg.material = nil
			can_select_count = can_select_count + 1
		end
		item.name = "objItem"
		item:SetActive(true)
	end
	self.qi_e:SetActive(#self.destiny_list==0)
	self.btnHunt:SetActive(#self.destiny_list==0 or can_select_count==0)
end

function Depot:on_click(obj,arg)
	print("点击选择宝石")
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btnClose" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd=="objItem" then
		if arg.isOn then
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			self.select_index = obj.transform:GetSiblingIndex()+1
		end
	elseif cmd=="btnSure" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.sure_fn then
			self.sure_fn(self.select_index and self.destiny_list[self.select_index] or nil)
		end
	elseif cmd == "btnHunt" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self.item_obj.assets[1]:select_page(3)
		self:dispose()
	end
end

function Depot:on_showed()
    StateManager:register_view( self )
    if self.init then
		self:set_list()
    end
end

function Depot:on_hided()

	StateManager:remove_register_view( self )
end

-- 释放资源
function Depot:dispose()
	self:hide()
	self.init = nil
    self._base.dispose(self)
 end

return Depot

