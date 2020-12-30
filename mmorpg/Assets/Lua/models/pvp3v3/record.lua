--[[
	3v3系统主界面
	create at 17.9.19
	by xin
]]

local model_name = "copy"

local res = 
{
	[1] = "3v3_statistics.u3d",
	[2] = "rvr_defeated",
	[3] = "rvr_success",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local record = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("pvp3v3")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function record:on_asset_load(key,asset)
	gf_getItemObject("pvp3v3"):send_to_get_record_c2s()
	gf_mask_show(true)
end

function record:init_ui()
	gf_mask_show(false)

	local record_data = gf_getItemObject("pvp3v3"):get_record_data()

	self:init_scroll_view(record_data.list)
	self:init_state(record_data)
end

function record:init_scroll_view(data)
	local scroll_view = self.refer:Get(4)
	
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		scroll_rect_item:Get(1).text = index
		scroll_rect_item:Get(2).text = data_item.kill
		scroll_rect_item:Get(3).text = data_item.score

		gf_setImageTexture(scroll_rect_item:Get(4), data_item.win and res[3] or res[2])
	end
	
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
end

function record:init_state(record_data)
	--胜场
	self.refer:Get(1).text = record_data.winCount
	--败场
	self.refer:Get(2).text = record_data.failCount
	--排名
	self.refer:Get(3).text = record_data.rank
end

--鼠标单击事件
function record:on_click( obj, arg)
	local event_name = obj.name
	print("record click",event_name)
    if event_name == "team_close_button_nearby" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    end
end

function record:on_showed()
	StateManager:register_view(self)
end

function record:clear()
	StateManager:remove_register_view(self)
end

function record:on_hided()
	self:clear()
end
-- 释放资源
function record:dispose()
	self:clear()
    self._base.dispose(self)
end

function record:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "TeamRecordListR") then
			self:init_ui(msg)
		end
	end
end

return record