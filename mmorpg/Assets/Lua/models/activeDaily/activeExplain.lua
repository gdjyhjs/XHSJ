--[[--
--活动说明
-- @Author:Seven
-- @DateTime:2017-07-08 10:03:33
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExplain=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "daily_tip.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function ActiveExplain:on_asset_load(key,asset)
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	-- self.item_obj:register_event("activeExplain_view_on_press_down", handler(self, self.on_press_down))
	-- self.item_obj:register_event("activeExplain_view_on_press_up", handler(self, self.on_press_up))
	-- self.item_obj:register_event("activeExplain_view_on_drag", handler(self, self.on_drag))
	local data = self.item_obj.cur_choose_data
	self:update_pos(data.code)
	self.refer:Get("txt_daily_name").text= data.name
	if data.show_times == 0 then
		self.refer:Get("txt_active_times").text= ""
	elseif data.show_times ~=999 then
		self.refer:Get("txt_active_times").text= data.current_times .."/"..data.show_times
	else
		self.refer:Get("txt_active_times").text= gf_localize_string("无限")
	end
	if	data.day_time[1] == 0 and data.day_time[3] == 24 then
		self.refer:Get("txt_time").text =gf_localize_string("全天")
	elseif data.day_time[1] ==-1 then
		self.refer:Get("txt_time").text =gf_localize_string("全天")
	else
		self.refer:Get("txt_time").text =string.format('%02d:%02d',data.day_time[1],data.day_time[2]).."-"..string.format('%02d:%02d',data.day_time[3],data.day_time[4])
		if #data.day_time>4 then
			self.refer:Get("txt_time").text=self.refer:Get("txt_time").text.."、".. string.format('%02d:%02d',data.day_time[5],data.day_time[6]).."-"..string.format('%02d:%02d',data.day_time[7],data.day_time[8])
		end
	end
	self.refer:Get("txt_form").text = data.form
	self.refer:Get("txt_level").text = data.level
	self.refer:Get("txt_desc").text = data.desc
	self.refer:Get("txt_value").text = data.max_active_times * data.per_active_val
	self:refresh(data.reward)
	gf_setImageTexture(self.refer:Get("icon"),data.icon)
end

function ActiveExplain:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "reward_item(Clone)" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- LuaItemManager:get_item_obejct("itemSys"):common_show_item_info(arg.data)
	end
end

-- function ActiveExplain:on_press_up(obj,click_pos)
-- 	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
-- 	if cmd == "reward_item(Clone)"then
-- 		-- LuaItemManager:get_item_obejct("itemSys"):hide_item_tips()
-- 	end
-- end
-- function ActiveExplain:on_press_down(obj,click_pos)
	
-- end

-- function ActiveExplain:on_drag(obj,position)
-- 	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
-- 	if cmd == "reward_item(Clone)" then
-- 		
-- 		print("日常按下了")
-- 	end
-- end

--更新位置
function ActiveExplain:update_pos(d_id)
	for k,v in pairs(self.item_obj.current_data) do
		if v.code == d_id then
			if k%2 ~=0 then
				self.refer:Get("daily_content").localPosition = Vector2(-39,24)
			else
				self.refer:Get("daily_content").localPosition = Vector2(365,24)
			end
		end
	end
end

function ActiveExplain:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(-self.scroll_table.headIndex ,-self.scroll_table.headIndex + 10 - 1 ) --显示列表
end

function ActiveExplain:update_item(item,index,data)
	gf_set_item(data,item:Get("icon"),item:Get("reward_item"))
	gf_set_press_prop_tips(item:Get("reward_item").gameObject,data)
end

-- 释放资源
function ActiveExplain:dispose()
	-- self.item_obj:register_event("activeExplain_view_on_press_down", nil)
	-- self.item_obj:register_event("activeExplain_view_on_press_up",  nil)
	-- self.item_obj:register_event("activeExplain_view_on_drag", nil)
    self._base.dispose(self)
 end

return ActiveExplain

