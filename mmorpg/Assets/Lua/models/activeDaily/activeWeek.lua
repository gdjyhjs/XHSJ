--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-08 17:10:29
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveWeek=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "activity_calendar.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function ActiveWeek:on_asset_load(key,asset)
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	StateManager:register_view(self)
	local week_day = os.date("%w",__NOW) --当前星期几
	self.refer:Get("img_"..week_day):SetActive(true)
	self:refresh(self.item_obj.week_data)
end
function ActiveWeek:on_click(obj,arg)
	if obj.name == "weekdaily_close" then 
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

function ActiveWeek:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(-self.scroll_table.headIndex ,-self.scroll_table.headIndex + 10 - 1 ) --显示列表
end

function ActiveWeek:update_item(item,index,data)
	if data.code ~=0 then
		item:Get(1).text = data.name
		if	data.day_time[1] == 0 and data.day_time[3] == 24 then
			item:Get(2).text =gf_localize_string("全天")
		elseif data.day_time[1] ==-1 then
			item:Get(2).text =gf_localize_string("全天")
		else
			local txt = string.format('%02d:%02d',data.day_time[1],data.day_time[2]).."-"..string.format('%02d:%02d',data.day_time[3],data.day_time[4])
			if #data.day_time>4 then
				txt = txt.."\n"
				txt = txt ..string.format('%02d:%02d',data.day_time[5],data.day_time[6]).."-"..string.format('%02d:%02d',data.day_time[7],data.day_time[8])
			end
			item:Get(2).text =	txt
		end
	else
		item:Get(1).gameObject:SetActive(false)
		item:Get(2).gameObject:SetActive(false)
	end 
end
-- 释放资源
function ActiveWeek:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return ActiveWeek

