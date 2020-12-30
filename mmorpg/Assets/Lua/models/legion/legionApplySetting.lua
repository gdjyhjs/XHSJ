
--[[
	申请设置界面 
	create at 17.11.2
	by xin
]]
local model_name = "alliance"

local res = 
{
	[1] = "legion_apply_setting.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local legionApplySetting = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionApplySetting:on_asset_load(key,asset)
    self:init_ui()
end

function legionApplySetting:init_ui()

	local legion_info = gf_getItemObject("legion"):get_info()
	self.refer:Get(1).text = 0
	self.refer:Get(2).text = 0
	self.power_limit = legion_info.powerLimit
	self.level_limit = legion_info.levelLimit

	self.refer:Get(1).text = self.power_limit
	self.refer:Get(2).text = self.level_limit

end

--选择数量变化时 判断是否超最大或者小于0
function legionApplySetting:sel_power_change(count)
	local max_count = 999999999
	self.power_limit = self.power_limit + count
	if self.power_limit > max_count then
		self.power_limit = max_count
	elseif self.power_limit < 1 then
		self.power_limit = 0
	end
	
	self.refer:Get(1).text = self.power_limit
end
function legionApplySetting:sel_level_change(count)
	local max_count = 10000
	self.level_limit = self.level_limit + count
	if self.level_limit > max_count then
		self.level_limit = max_count
	elseif self.level_limit < 1 then
		self.level_limit = 0
	end
	self.refer:Get(2).text = self.level_limit
end
	
function legionApplySetting:show_key_board(node,max_count,callback)
	gf_getItemObject("keyboard"):use_number_keyboard(node,max_count,0,pos,pivot,anchor,initValue,callback,ep)
end

--鼠标单击事件
function legionApplySetting:on_click( obj, arg)
	local event_name = obj.name
	print("legionApplySetting click",event_name)
    if event_name == "setting_close_btn" or event_name == "cancle_btn"  then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "sure_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_getItemObject("legion"):send_to_modify_join_limit(self.level_limit,self.power_limit)

    elseif event_name == "cutBuyCount" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:sel_power_change(-1)
    elseif event_name == "addBuyCount" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:sel_power_change(1)
    elseif event_name == "cutBuyCount1" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:sel_level_change(-1)
    elseif event_name == "addBuyCount1" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:sel_level_change(1)

    elseif event_name == "buyCount1" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local callback = function(value)
    		print("value:",value)
    		self.power_limit = value
    	end
    	self:show_key_board(self.refer:Get(1),999999999,callback)

    elseif event_name == "buyCount2" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local callback = function(value)
    		print("value:",value)
    		self.level_limit = value
    	end
    	self:show_key_board(self.refer:Get(2),10000,callback)

    end
end

function legionApplySetting:on_showed()
	StateManager:register_view(self)
end

function legionApplySetting:clear()
	StateManager:remove_register_view(self)
end

function legionApplySetting:on_hided()
	self:clear()
end
-- 释放资源
function legionApplySetting:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionApplySetting:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ModifyJoinLimitR") then
			if msg.err ==  0 then
				self:dispose()
			end
		end
	end
end

return legionApplySetting