--[[
	副本失败界面
	create at 17.11.22
	by xin
]]

local commom_string = 
{
	[1] = gf_localize_string("很遗憾，你的通关时间超出了最大时限，通关失败"),
}

local end_type = 
{
	normal 		= 1,
	time_up 	= 2,
}

local uiBase = require("models.copyEnd.copyStateBase")

local defaultEnd = class(uiBase,function(self,type)
	self.type = type
	local item_obj = gf_getItemObject("copy")
	uiBase._ctor(self, "copy_default.u3d", item_obj)
end)

function defaultEnd:on_showed()
	defaultEnd._base.on_showed(self)
	if self.type == end_type.time_up then
		self.refer:Get(1).text = commom_string[1]
	end
end

function defaultEnd:clear()
	print("clear wtf")
end
function defaultEnd:on_hided()
	defaultEnd._base.on_hided(self)
end

-- 释放资源
function defaultEnd:dispose()
	defaultEnd._base.dispose(self)
end

function defaultEnd:on_click(arg)
	local event_name = arg.name
	print("defaultEnd event_name ",event_name)
	if event_name == "mask_close" then
		--如果小于两秒 不给点击
	   	if not self:is_can_exit() then
	   		return
	   	end
	    Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
	    LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
		self:dispose()
	end
	
end

function defaultEnd:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "ExitCopyR") then -- 取章节信息
			self:dispose()
		end
	end
end

return defaultEnd