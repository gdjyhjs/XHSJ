--[[
	新 军团创建界面 属性
	create at 17.10.30
	by xin
]]
local model_name = "alliance"
local dataUse = require("models.legion.dataUse")
local res = 
{
	[1] = "create_legion.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("名称不能为空"),
	[2] = gf_localize_string("旗号不能为空"),
	[3] = gf_localize_string("详情描述不能为空"),
	[4] = gf_localize_string("输入中带有屏蔽字，请重新输入"),
	[5] = gf_localize_string("缘聚七煞，不忘初心"),
}


local legionCreate = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionCreate:on_asset_load(key,asset)
    self:init_ui()
end

function legionCreate:init_ui()
	self.type = 1

	-- 费用
	local gold = ConfigMgr:get_config("t_misc").alliance.buildCost[2]
	local cion = gf_format_count(ConfigMgr:get_config("t_misc").alliance.buildCost[1])

	self.refer:Get(4).text = gold
	self.refer:Get(5).text = cion

	self.pre_flag = math.random(1,5)

	gf_setImageTexture(self.refer:Get(6), dataUse.getFlagByColor(self.pre_flag))

	self.refer:Get(8).text = commom_string[5]
end

function legionCreate:create_click()
	print("self.type:",self.type)
	local name = self.refer:Get(1).text or ""
	local flag = self.refer:Get(2).text or ""
	local details = self.refer:Get(3).text or ""
	local pre_details = self.refer:Get(8).text or ""

	if name == "" then
		gf_message_tips(commom_string[1])
		return
	end
	if flag == "" then
		gf_message_tips(commom_string[2])
		return
	end
	if details == "" and pre_details == "" then
		gf_message_tips(commom_string[3])
		return
	end
	if checkChar(name) or checkChar(flag) or checkChar(details == "" and pre_details or details) then
		gf_message_tips(commom_string[4])
		return
	end
	local resType = self.type == 1 and ServerEnum.BASE_RES.GOLD or ServerEnum.BASE_RES.COIN

	gf_getItemObject("legion"):build_c2s(name,1,flag,resType,details == "" and pre_details or details)
end

function legionCreate:cion_click(arg)
	print("res type1:",arg.isOn)
	if arg.isOn then
		self.type = 2
	end
end

function legionCreate:gold_click(arg)
	print("res type2:",arg.isOn)
	if arg.isOn then
		self.type = 1
	end
end

function legionCreate:legion_flag_change()
	local pre_flag = math.random(1,5)

	while true do
		if pre_flag ~= self.pre_flag then
			break
		end
		pre_flag = math.random(1,5)
	end
	self.pre_flag = pre_flag
	print("self.pre_flag:",self.pre_flag)
	gf_setImageTexture(self.refer:Get(6), dataUse.getFlagByColor(self.pre_flag))
end

--鼠标单击事件
function legionCreate:on_click( obj, arg)
	local event_name = obj.name
	print("legionCreate click",event_name)
    if event_name == "legion_create_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:create_click()

    elseif event_name == "legion_create_closeBtn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "cion" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:cion_click(arg)

    elseif event_name == "gold" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:gold_click(arg)

    elseif event_name == "legion_flag" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:legion_flag_change()
    elseif event_name == "legion_flag1" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.refer:Get(7).text = self.refer:Get(2).text
    end
end

function legionCreate:on_showed()
	StateManager:register_view(self)
end

function legionCreate:clear()
	StateManager:remove_register_view(self)
end

function legionCreate:on_hided()
	self:clear()
end
-- 释放资源
function legionCreate:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionCreate:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "BuildR") then
			if msg.err == 0 then
				self:dispose()
			end

		end
	end
end

return legionCreate