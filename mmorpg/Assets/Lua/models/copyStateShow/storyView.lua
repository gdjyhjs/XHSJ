--[[--
-- 剧情副本任务栏ui
-- @Author:Seven
-- @DateTime:2017-07-26 19:35:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commom_string =
{
	[1] = gf_localize_string("第%d波怪物来袭"),
	[2] = gf_localize_string("%s后降为%d星"),
	[3] = gf_localize_string("%s后通关失败"),
}

local copyStateBase = require("common.viewBase")

local StoryView=class(copyStateBase,function(self)
	gf_create_model_view("empty")
	local item_obj = LuaItemManager:get_item_obejct("empty")
	self.item_obj = item_obj 
	copyStateBase._ctor(self, "mainui_story_copy.u3d", item_obj)
end)


-- 资源加载完成
function StoryView:on_asset_load(key,asset)
	self:init_ui()
end

function StoryView:init_ui()
	--第一章引导
	if gf_getItemObject("copy"):is_story() and gf_getItemObject("guide"):get_big_step() == (ClientEnum.GUIDE_BIG_STEP.AUTO_ATK - 1) then
		gf_auto_atk(false)
		gf_getItemObject("guide"):guide_continue(ClientEnum.GUIDE_BIG_STEP.AUTO_ATK)
	end

	self.star_list = {}
	for i=1,3 do
		print("set material")
		self.star_list[i] = self.refer:Get("star"..i)
		self.star_list[i].material = nil
	end


	-- self.fill = self.refer:Get("fill")
	-- self.fill.fillAmount = 1.0

	self.time_txt = self.refer:Get(10)
	self:update_view()
	

	-- self.scroll_table = self.refer:Get("scroll_table")
	-- self.scroll_table.onItemRender = handler(self, self.update_item)
end

-- function StoryView:update_bar( percent )
-- 	if self.fill then
-- 		local per = 1-percent
-- 		if per < 0 then
-- 			per = 0
-- 		end
-- 		self.fill.fillAmount = per
-- 	end
-- end

function StoryView:update_star(time)
	if not self.data then
		return
	end

	if  time > self.data.star3_time and time <= self.data.star2_time then
		self.star_list[3].material = self.refer:Get(6).material
		return
	end

	if  time > self.data.star2_time then
		self.star_list[2].material = self.refer:Get(6).material
		self.star_list[3].material = self.refer:Get(6).material
		return
	end
	
end

-- function StoryView:get_stage_time(time)
-- 	if time <= self.data.star3_time and time > self.data.star2_time then
-- 		return self.data.star3_time
-- 	end

-- 	if time <= self.data.star2_time and time > self.data.star1_time then
-- 		return self.data.star2_time
-- 	end
-- 	return self.data.star1_time
-- end

function StoryView:get_stage_total_time(time)
	if time <= self.data.star3_time and time > 0 then
		return self.data.star3_time,2
	end

	if time <= self.data.star2_time and time > self.data.star3_time then
		return self.data.star2_time ,1
	end

	local copy_code = self.copy_id
	print("wtf ffff copy_code:",copy_code)
	local limit_time = gf_get_config_table("copy")[copy_code].time_limit
	return limit_time,0
end

function StoryView:update_time( dt )
	-- print("wtf update time")
	local time = Net:get_server_time_s() - self.time
	if self.time_txt then
		--当前阶段总时间 下一阶段
		local c_total,count = self:get_stage_total_time(time)

		local left = c_total - time

		if left <= 0 then 
			self:stop_schedule()
			require("models.copyEnd.defaultEnd")(2)
			return
		end

		self.time_txt.text = count == 0 and string.format(commom_string[3],gf_convert_time(left)) or string.format(commom_string[2], gf_convert_time(left),count)
	end
	self:update_star(time)
end

function StoryView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function StoryView:update_item( item, index, data )
	-- gf_set_item(data[1], item:Get(1), item:Get(2))
end

function StoryView:get_copy_data()
	local copy_data = gf_getItemObject("copy")
	local copy_id = copy_data:get_copy_id()
	self.copy_id = copy_id
	if copy_data:is_story() then
		return gf_get_config_table("story_copy")[copy_id]
	elseif copy_data:is_material_defence() or copy_data:is_material_time_treasury() then
		return gf_get_config_table("material")[copy_id]
	end
end

function StoryView:update_view()
	local copy = LuaItemManager:get_item_obejct("copy")
	self.data = self:get_copy_data()
	if not self.data then
		return
	end

	local copy_name = gf_get_config_table("copy")[self.copy_id].name

	self.refer:Get(9).text = copy_name

	self.total_time = self.data.star3_time*3
	self.time = copy:get_time() or Net:get_server_time_s()

	for i,v in ipairs(self.star_list) do
		v.material = nil
	end

	self:start_scheduler_tick()

end
-- function StoryView:show_wave_tips(wave)	
-- 	print("wate :",wave)
-- 	self.refer:Get(7).gameObject:SetActive(true)
-- 	self.refer:Get(8).text = string.format(commom_string[1],wave)
-- 	--启动定时器 2秒后关闭界面
	
-- 	self:start_scheduler()
-- end

function StoryView:start_scheduler_tick()
	if self.schedule_id_tick then
		self:stop_schedule()
	end
	local update = function()
		self:update_time()
	end
	self.schedule_id_tick = Schedule(update, 0.1)
end

-- function StoryView:start_scheduler()
-- 	self.close_time = Net:get_server_time_s() + 2
-- 	if self.schedule_id then
-- 		self:stop_schedule()
-- 	end
-- 	local update = function()
-- 		if Net:get_server_time_s() >= self.close_time then
-- 			self.refer:Get(7).gameObject:SetActive(false)
-- 			self:stop_schedule()
-- 		end
-- 	end
-- 	self.schedule_id = Schedule(update, 0.5)
-- end
function StoryView:stop_schedule()
	-- if self.schedule_id then
	-- 	self.schedule_id:stop()
	-- 	self.schedule_id = nil
	-- end
	if self.schedule_id_tick then
		self.schedule_id_tick:stop()
		self.schedule_id_tick = nil
	end
end


function StoryView:on_hided()
	print("wtf story hide")
	self:stop_schedule()
	StoryView._base.on_hided(self)

end

function StoryView:dispose()
	print("wtf story dispose")
	self:stop_schedule()
	StoryView._base.dispose(self)
	 
end

function StoryView:on_receive(msg, id1, id2, sid)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "PassCopyR") then
			self:stop_schedule()
		end
	end
	if id1 == ClientProto.FinishScene then
		if gf_getItemObject("copy"):is_story() then
		else
			-- self:dispose()
		end
	end
end

return StoryView

