
--[[
	公告编辑界面  属性
	create at 17.10.31
	by xin
]]
local model_name = "alliance"

local res = 
{
	[1] = "legion_change_notice.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("名字中含有敏感词汇，请重新输入"),
}


local legionNoticeEdit = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionNoticeEdit:on_asset_load(key,asset)
    self:init_ui()
end

function legionNoticeEdit:init_ui()
	self.refer:Get(2).text = gf_getItemObject("legion"):get_info().introduction
	self.refer:Get(3).text = gf_getItemObject("legion"):get_info().introduction
end

--鼠标单击事件
function legionNoticeEdit:on_click( obj, arg)
	local event_name = obj.name
	print("legionNoticeEdit click",event_name)
    if event_name == "legion_notice_close_btn" or event_name == "release_notice_cancle_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "release_notice_send_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if checkChar(self.refer:Get(1).text or "") then
			gf_message_tips(commom_string[1])
			return 
		end
    	gf_getItemObject("legion"):modify_info_c2s( announcement, qqGroup ,titles,self.refer:Get(3).text)

    end
end

function legionNoticeEdit:on_showed()
	StateManager:register_view(self)
end

function legionNoticeEdit:clear()
	StateManager:remove_register_view(self)
end

function legionNoticeEdit:on_hided()
	self:clear()
end
-- 释放资源
function legionNoticeEdit:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionNoticeEdit:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ModifyInfoR") then

			self:dispose()
		end
	end
end

return legionNoticeEdit