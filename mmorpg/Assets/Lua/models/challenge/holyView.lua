--[[
	圣物系统界面
	create at 17.7.17
	by xin
]]
-- local dataUse = require("models.challenge.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "halidom_strengthen.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("尚未拥有此圣物"),
	[2] = gf_localize_string("材料不足"),
}


local holyView = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("challenge")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function holyView:on_asset_load(key,asset)
	gf_getItemObject("challenge"):send_to_get_holy_data()
end

function holyView:init_ui(holy_info)
	gf_print_table(holy_info, "wtf holy_info1:")
	self.holy_info = holy_info
	self:holy_list_init()

	local holy_info_ = self:get_show_holy()
	gf_print_table(holy_info_, "wtf holy_info2:")
	self:holy_view_init(holy_info_)
end

function holyView:get_show_holy()
	local holy_info = {}
	--寻找显示的圣物
	for i,v in ipairs(ConfigMgr:get_config("holy") or {}) do
		--如果没有
		if not self.holy_info[i] then
			local holyInfo_ = 
			{
				holyCode = v.code,
				level 	= 0,
				coinNum = 0,
			}
			return holyInfo_
		else
			--如果未满级
			if not dataUse.getIsHolyMaxLevel(self.holy_info[i].holyCode,self.holy_info[i].level)  then
				return self.holy_info[i]
			end
		end
	end
	return {}
end

function holyView:holy_view_init(holy_info)
	if not next(holy_info or {}) then
		return
	end
	self:left_view_init(holy_info)
	self:left_view_init_max(holy_info)
end

function holyView:left_view_init(holy_info)
	gf_print_table(holy_info, "wtf holy_info:")
	if not next(holy_info or {}) then
		return
	end
	local level = holy_info.level
	local holy_id = holy_info.holyCode
	self.holy_id = holy_id
	
	local count = holy_info.coinNum

	--现等级圣物
	self:holy_item_init(self.refer:Get(2),holy_id,level)

	--下一等级
	-- if not dataUse.getIsHolyMaxLevel(holy_id,level) then
		
	-- end

	--货币材料
	self:holy_coin_init(holy_id,level,count)

	--属性
	local attr1 = level == 0 and {{1,0},{2,0}} or dataUse.getHolyInfoById(holy_id,level    ).combat_attr_add
	
	if dataUse.getIsHolyMaxLevel(holy_id,level) then
		self.refer:Get(6).text = string.format("%s %d",ConfigMgr:get_config("propertyname")[attr1[1][1]].name,attr1[1][2])
		self.refer:Get(7).text = string.format("%s %d",ConfigMgr:get_config("propertyname")[attr1[2][1]].name,attr1[2][2])
	else
		local attr2 = dataUse.getHolyInfoById(holy_id,level + 1).combat_attr_add
		self:holy_item_init(self.refer:Get(4),holy_id,level + 1)
		self.refer:Get(6).text = string.format("%s %d +%d",ConfigMgr:get_config("propertyname")[attr2[1][1]].name,attr1[1][2],attr2[1][2])
		self.refer:Get(7).text = string.format("%s %d +%d",ConfigMgr:get_config("propertyname")[attr2[2][1]].name,attr1[2][2],attr2[2][2])
	end
	

	--名字
	local holy_infoex = dataUse.getHolyInfo(holy_info.holyCode)
	self.refer:Get(5).text = holy_infoex.name
end 

function holyView:left_view_init_max(holy_info)
	local level = holy_info.level
	local holy_id = holy_info.holyCode
	--如果满级了
	if not dataUse.getIsHolyMaxLevel(holy_id,level) then
		return
	end
	self.refer:Get(9).text = "<color=#F34248>MAX</color>"
end

function holyView:get_hole_data(id)
	gf_print_table(self.holy_info, "wtf self.holy_info:"..id)
	for i,v in ipairs(self.holy_info or {}) do
		if v.holyCode == id then
			return v
		end
	end
	return nil
end

--强化材料
function holyView:holy_coin_init(holy_id,level,count)
	local item = self.refer:Get(3)
	
	if dataUse.getIsHolyMaxLevel(holy_id,level) then
		item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = ""
		-- self.refer:Get(8).interactable = false
		return
	end
	local holy_level_info = dataUse.getHolyInfoById(holy_id,level + 1)
	
	local holy_info = dataUse.getHolyInfo(holy_id)

	--需要数量
	local max = holy_level_info.holy_coin_cost[2]
	local str = "<color=%s>%d</color>/%d"
    local color = count >= max and "#7D5B53" or gf_get_color(Enum.COLOR.RED)

    -- if count >= max then
    -- 	self.refer:Get(8).interactable = true
    -- else
    -- 	self.refer:Get(8).interactable = false
    -- end

    item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = string.format(str,color,count,max)
    --icon 
	local icon = item.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(icon, holy_info.coin_icon)
	--品质框
	local bg = item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
end

function holyView:holy_item_init(item,holy_id,level)
	local holy_info = dataUse.getHolyInfo(holy_id)
	--icon 
	local icon = item.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(icon, holy_info.icon)
	--品质框
	local bg = item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
	--等级
	local level_text = item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	level_text.text = string.format("+%d",level)
end

function holyView:holy_list_init()
	-- data = {1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10}

	local data = ConfigMgr:get_config("holy")

	local index = 1

	local temp = {}
	local tb = {}
	for i,v in ipairs(data or {}) do
		table.insert(tb,v)
		if index == 3 then
			table.insert(temp,tb)
			tb = {}
			index = 0
		end
		index = index + 1
	end
	if index ~= 1 then
		table.insert(temp,tb)
	end

	gf_print_table(temp, "wtf temp:")

	local scroll_rect_table = self.refer:Get(1)
	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		for i=1,3 do
			scroll_rect_item.transform:FindChild("item"..i).gameObject:SetActive(false)
		end
		for i,v in ipairs(data_item or {}) do
			local item = scroll_rect_item.transform:FindChild("item"..i)
			self:update_item(item, v)
		end
	end
	scroll_rect_table.data = temp
	scroll_rect_table:Refresh(-1,-1)

end

function holyView:update_item(item,data)
	local holy_info = dataUse.getHolyInfo(data.code)

	local holy_data = self:get_hole_data(data.code)

	item.gameObject:SetActive(true)
	
	

	local value_text = item.transform:FindChild("value"):GetComponent("UnityEngine.UI.Text")
	value_text.text = data.code

	local text = item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	text.text = holy_info.name

	--是否解锁
	-- if next(holy_data or {}) then
	-- 	item.transform:FindChild("Image").gameObject:SetActive(false)
	-- end

	--货币
	local sitem = item.transform:FindChild("item")
	local icon = sitem.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image)

	gf_setImageTexture(icon, holy_info.icon)

	local bg = sitem.transform:FindChild("bg")
	local bg_img = bg:GetComponent(UnityEngine_UI_Image)

	local level = holy_data and holy_data.level or 0
	if level > 0 then
		local pnode = sitem.transform:FindChild("property")
		pnode.gameObject:SetActive(true)
		local level_text = pnode.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		level_text.text = string.format("+%d",level)
	end

	if data.code == self.holy_id then
		self:set_select(sitem.transform)
	end

end

function holyView:strenght_click()
	local holy_id = self.holy_id
	local holy_data = self:get_hole_data(holy_id)
	if not next(holy_data or {}) then
		gf_message_tips(commom_string[2])
		return
	end
	local holy_level_info = dataUse.getHolyInfoById(holy_id,holy_data.level + 1)
	local max = holy_level_info.holy_coin_cost[2]
	if max > holy_data.coinNum then
		gf_message_tips(commom_string[2])
		return
	end
	gf_getItemObject("challenge"):send_to_get_strenght(self.holy_id)
end

function holyView:set_select(item)
	local select_icon = self.refer:Get(10)
	select_icon:SetActive(true)
	select_icon.transform.parent = item
	select_icon.transform.localPosition = Vector3(0,0,0)

end

function holyView:item_click(event_name,arg)
	local holy_id = arg.transform:FindChild("value"):GetComponent("UnityEngine.UI.Text").text
	holy_id = tonumber(holy_id) or self.bholy_id or 0
	self.holy_id = holy_id

	local item = arg.transform:FindChild("item").transform
	self:set_select(item)

	if next(self:get_hole_data(holy_id) or {}) then
		self:left_view_init(self:get_hole_data(holy_id))
	else
		local holyInfo_ = 
		{
			holyCode = holy_id,
			level 	= 0,
			coinNum = 0,
		}
		self:left_view_init(holyInfo_)
	end
end

--鼠标单击事件
function holyView:on_click( obj, arg)
	print("wtf holyView click",obj.name)
    local event_name = obj.name
    if event_name == "holy_closeBtn" then 
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    elseif event_name == "holy_Strengthen_btn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:strenght_click()

    elseif string.find(event_name,"item") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(event_name,arg)

    end
end

-- 释放资源
function holyView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function holyView:rec_holy_levelup(msg)
	gf_print_table(msg, "wtf StrengthenHolyR:")
	if msg.err == 0 then
		self.bholy_id = msg.holyCode
		gf_getItemObject("challenge"):send_to_get_holy_data()
	end
end


function holyView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then 
		if id2 == Net:get_id2(model_name, "GetHolyInfoR") then
			self:init_ui(msg.holyInfo)
		
		elseif id2 == Net:get_id2(model_name,"StrengthenHolyR") then
			self:rec_holy_levelup(msg)
			 -- 背包-合成、副本-过关斩将-圣物强化、锻造-镶嵌播放的音效
			Sound:play(ClientEnum.SOUND_KEY.PROCESS)
		end
	end
end

return holyView