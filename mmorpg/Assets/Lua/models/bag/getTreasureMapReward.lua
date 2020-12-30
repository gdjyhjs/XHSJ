--[[--
--获取藏宝图奖励 eff_timer
-- @Author:HuangJunShan
-- @DateTime:2017-08-04 10:50:23
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Random = UnityEngine.Random
local Enum = require("enum.enum")

local init = nil
local data = nil
local is_equip = nil
local eff1 = nil
local click_quit = nil
local timer = nil

local GetTreasureMapReward=class(UIBase,function(self,item_obj,_data)
    UIBase._ctor(self, "get_item.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    data = _data
end)

function GetTreasureMapReward:set_data(_data)
	print("设置data",_data)
	data = _data
	if init then
		self:init_ui()
	end
end

-- 资源加载完成
function GetTreasureMapReward:on_asset_load(key,asset)
	print("藏宝图奖励资源加载完成",self,key,asset)
	if not init then
		eff1 = self.refer:Get("eff1")
		click_quit = self.refer:Get("click_quit")
		self:init_ui()
		self:register()
		init = true
	end
	self:init_ui()
end

function GetTreasureMapReward:init_ui()
	if not data or not init then
		return
	end
	eff1:SetActive(false)
	print("初始化挖宝")
	self.item = self.refer:Get("item")
	is_equip = type(data)=="table"
	local childCount = self.item.transform.parent.childCount
	local needCount = 0
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	if is_equip then -- 奖励是的装备
		needCount = #data
	print("已有数量",childCount,"需要数量",needCount)
		for i,v in ipairs(data) do
			gf_print_table(v,"奖励装备",i,i<(childCount) and "获取" or "创建")
			local obj = i<(childCount) and self.item.transform.parent:GetChild(i).gameObject or LuaHelper.Instantiate(self.item)
			local tf = obj.transform
			tf:SetParent(self.item.transform.parent,false)
			gf_set_equip_icon(v,tf:Find("icon"):GetComponent(UnityEngine_UI_Image),tf:GetComponent(UnityEngine_UI_Image))
			tf:Find("count"):GetComponent("UnityEngine.UI.Text").text = nil
			local item_data = ConfigMgr:get_config("item")[v.protoI]
			tf:Find("binding").gameObject:SetActive(item_data.bind==1)
			local name = itemSys:get_equip_prefix_name(item_data.prefix)..item_data.name
			tf:Find("name"):GetComponent("UnityEngine.UI.Text").text = name
			obj:SetActive(true)
		end
	else -- 奖励的是道具
		local d = ConfigMgr:get_config( "treasure_map_event" )[data]
		local param = d.param
		if d.event==ServerEnum.TREASURE_EVENT_TYPE.MONSTER then
			param = param[2]
		end
		needCount = #param
	print("已有数量",childCount,"需要数量",needCount)
		for i,v in ipairs(param) do
			print(v[1],"奖励道具",i,i<(childCount) and "获取" or "创建")
			local obj = i<(childCount) and self.item.transform.parent:GetChild(i).gameObject or LuaHelper.Instantiate(self.item)
			local tf = obj.transform
			tf:SetParent(self.item.transform.parent,false)
			gf_set_item(v[1],tf:Find("icon"):GetComponent(UnityEngine_UI_Image),tf:GetComponent(UnityEngine_UI_Image))
			tf:Find("count"):GetComponent("UnityEngine.UI.Text").text = v[2]
			local item_data = ConfigMgr:get_config("item")[v[1]]
			tf:Find("binding").gameObject:SetActive(item_data.bind==1)
			tf:Find("name"):GetComponent("UnityEngine.UI.Text").text = item_data.name
			obj:SetActive(true)
		end
	end
	for i=needCount+1,childCount-1 do
		self.item.transform.parent:GetChild(i).gameObject:SetActive(false)
	end
	eff1:SetActive(true)

	local set_time = function(t)
		click_quit.text = string.format(gf_localize_string("%d秒后自动关闭"),t)
	end

	local time = 0
	timer = Schedule(function()
		time = time + 1
		if time == 6 then
			self:dispose()
		else
			set_time(6-time)
		end
	end,1)
end

function GetTreasureMapReward:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "CancleBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
		self:dispose()
	elseif cmd == "item(Clone)" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
        local idx = obj.transform:GetSiblingIndex()
        local itemSys = LuaItemManager:get_item_obejct("itemSys")
        if is_equip then
        	-- gf_print_table(data,"是装备")
        	itemSys:equip_browse(data[idx],nil,nil,nil,obj.position)
        else
        	local d = ConfigMgr:get_config( "treasure_map_event" )[data]
        	local param = d.param
			if d.event==ServerEnum.TREASURE_EVENT_TYPE.MONSTER then
				param = param[2]
			end
        	-- gf_print_table(param,"不是装备")
        	-- itemSys:prop_tips(param[idx][1],nil,obj.transform.position)
        end
	end
end

function GetTreasureMapReward:register()
	StateManager:register_view( self )
end

function GetTreasureMapReward:cancel_register()
	StateManager:remove_register_view( self )
end

-- 释放资源
function GetTreasureMapReward:dispose()
	if timer then
		timer:stop()
		timer = nil
	end

	self.item_obj:next_treasure_map()
	init = nil
	self:cancel_register()
    self._base.dispose(self)
 end

return GetTreasureMapReward

