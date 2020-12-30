--[[
	竞技结算界面
	create at 17.7.20
	by xin
]]
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "arena_end.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local pvpEnd = class(UIBase,function(self,msg)
	self.msg = msg
	self.time = Net:get_server_time_s()
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function pvpEnd:on_asset_load(key,asset)
	print("wtf register")
	StateManager:register_view(self)
	self:init_ui()
end        

function pvpEnd:init_ui()
	local data = self.msg
	gf_print_table(data, "wtf data")
	self.refer:Get(1).text = string.format(self.refer:Get(1).text,data[1],data[2])
	self.refer:Get(2).text = string.format(self.refer:Get(2).text,data[3])
	self.refer:Get(3).text = string.format(self.refer:Get(3).text,data[4])
end



--鼠标单击事件
function pvpEnd:on_click( obj, arg)
	print("wtf pvpEnd click",obj.name)
    local event_name = obj.name
    if event_name == "any_touch" then 
    	--如果小于两秒 不给点击
	    if Net:get_server_time_s() - self.time <= ConfigMgr:get_config("t_misc").copy.pass_wait_time then
	    	return
	    end
	    Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()
    	LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
    end
end


function pvpEnd:clear()
	StateManager:remove_register_view(self)
end
function pvpEnd:on_hided()
	self:clear()
end
-- 释放资源
function pvpEnd:dispose()
	self:clear()
    self._base.dispose(self)
end

function pvpEnd:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then 
		if id2 == Net:get_id2("copy", "PassCopyR") then
			
		end
	end
end

return pvpEnd