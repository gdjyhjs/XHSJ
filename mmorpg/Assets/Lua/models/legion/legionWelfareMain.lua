--[[
	福利主界面界面  属性
	create at 17.10.31
	by xin
]]
local model_name = "legion"

local res = 
{
	[1] = "legion_battle_common.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}

local res_path = 
{
	[1] = "legionTrain",
	[2] = "legionFlag",
}

local legionWelfareMain = class(UIBase,function(self,arg1,arg2)
	self.arg1 = arg1
	self.arg2 = arg2
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionWelfareMain:on_asset_load(key,asset)
    self:init_ui()
end

function legionWelfareMain:init_ui()
	local p_node = self.refer:Get(1)
	for i=1,2 do
		local node = p_node.transform:FindChild("tag"..i)
		node.transform:FindChild("Image").gameObject:SetActive(false)
	end
	self:tag_click("tag" ..(self.arg1 or 1))
	self.arg1 = nil
end

function legionWelfareMain:tag_click(event)
	local index = string.gsub(event,"tag","")
	index = tonumber(index)

	if self.last_tag then
		self.last_tag.transform:FindChild("Image").gameObject:SetActive(false)
	end

	local p_node = self.refer:Get(1)
	local node = p_node.transform:FindChild("tag"..index)
	node.transform:FindChild("Image").gameObject:SetActive(true)

	self.last_tag = node

	if self.last_view then
		self.last_view:dispose()
	end

	self.last_view = require("models.legion."..res_path[index])(self.arg2)
	self.arg2 = nil
end

--鼠标单击事件
function legionWelfareMain:on_click( obj, arg)
	local event_name = obj.name
	print("legionWelfareMain click",event_name)
    if string.find(event_name,"tag") then 
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN)
   		self:tag_click(event_name)

    end
end

function legionWelfareMain:on_showed()
	StateManager:register_view(self)
end

function legionWelfareMain:clear()
	print("legionWelfareMain clear")
	self.last_tag = nil
	if self.last_view then
		self.last_view:dispose()
		self.last_view = nil
	end
	StateManager:remove_register_view(self)
end

function legionWelfareMain:on_hided()
	self:clear()
end
-- 释放资源
function legionWelfareMain:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionWelfareMain:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "WakeUpHeroR") then
		end
	end
end

return legionWelfareMain