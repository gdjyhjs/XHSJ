--[[
	3v3状态界面
	create at 17.9.19
	by xin
]]

local model_name = "copy"

local res = 
{
	[1] = "3v3_score_view.u3d",
}

local res_bg =
{
	"3v3_07","3v3_08",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local state = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("pvp3v3")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function state:on_asset_load(key,asset)
	self.show_list = {}
    self:init_ui()

end

function state:init_ui(msg)
	self:init_score_view()
	self:init_left_time()
end

function state:play_one(data)
	--加入播放队列
	table.insert(self.show_list,data)

	--如果没有定时器启动定时器
	if not self.schedule_id then
		self:start_scheduler()
	end
end

function state:start_scheduler()
	local end_time = self.time
	local function get_one()
		if #self.show_list > 0 then
			self.end_time = Net:get_server_time_s()
			local data = self.show_list[1]
			table.remove(self.show_list,1)
			self:show_state(data)
			return
		end
		self:show_state(data)
		self:stop_schedule()
	end
	local update = function()
		print("wtf update ")
		if not self.end_time then
			get_one()
			
		end
		--如果时间到了
		if self.end_time and (Net:get_server_time_s() - self.end_time) > 5 then
			get_one()
		end
		
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end

function state:show_state(data)
	self.refer:Get(3):SetActive(false)
	self.refer:Get(4):SetActive(false)
	self.refer:Get(7):SetActive(false)

	if not data then
		return
	end

	local is_myself = gf_getItemObject("pvp3v3"):get_is_my_member(data.killerRoleId)

	local item 

	if data.firstBlood then
		item = self.refer:Get(7)

	elseif is_myself then
		item = self.refer:Get(3)

	else
		item = self.refer:Get(4)
		
	end

	item:SetActive(true)

	--击杀者
	local icon = item.transform:FindChild("Image (2)").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	gf_set_head_ico(icon, data.killerHead)
	--被击杀者
	local icon = item.transform:FindChild("Image (3)").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	gf_set_head_ico(icon, data.victimHead)
	
	--名字
	item.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text").text = data.firstBlood and data.victimName or (is_myself and data.victimName or data.killerName)

	if data.firstBlood then
		--击杀者背景
		local icon = item.transform:FindChild("Image (2)"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, is_myself and res_bg[1] or res_bg[2])

		--被击杀者背景
		local icon = item.transform:FindChild("Image (3)"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, is_myself and res_bg[2] or res_bg[1])

		local icon = item:GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, is_myself and "3v3_09" or "3v3_10")


	end
end

function state:stop_schedule()
	if self.schedule_id then
		self.end_time = nil
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function state:stop_time_limit()
	if self.time_schedule_id then
		self.time_schedule_id:stop()
		self.time_schedule_id = nil
	end
end

function state:init_score_view()
	local score = gf_getItemObject("pvp3v3"):get_score() or {}
	--我方
	self.refer:Get(1).text = score[1] or 0
	--敌方
	self.refer:Get(2).text = score[2] or 0

end

function state:init_left_time()
	self.limit_time = gf_getItemObject("copy"):get_tvt_begin_time() + ConfigMgr:get_config("t_misc").pvp_3v3_copy_limit
	local update = function()
		local time = self.limit_time - Net:get_server_time_s()

		self.refer:Get(5).text = gf_convert_time_ms(time)

		if time >= ConfigMgr:get_config("t_misc").pvp_3v3_copy_limit then
			time = time - ConfigMgr:get_config("t_misc").pvp_3v3_copy_limit
			self.refer:Get(5).text = gf_convert_time_ms(time)

			if time <= 3 and not self.refer:Get(6).gameObject.activeSelf then
				self.refer:Get(6):SetActive(true)
			end
			return
		end
		if time < ConfigMgr:get_config("t_misc").pvp_3v3_copy_limit then
			gf_getItemObject("battle"):remove_block()
		end
		if time <= 0 then
			--匹配时间到了
			self:stop_time_limit()
		end
	end
	update()
	self.time_schedule_id = Schedule(update, 0.1)
	
end

--鼠标单击事件
function state:on_click( obj, arg)
	local event_name = obj.name
	print("state click",event_name)
    if event_name == "" then 
    	
    end
end

function state:on_showed()
	StateManager:register_view(self)
end

function state:clear()
	self:stop_schedule()
	self:stop_time_limit()
	StateManager:remove_register_view(self)
end

function state:on_hided()
	self:clear()
end
-- 释放资源
function state:dispose()
	self:clear()
    self._base.dispose(self)
end

function state:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "KillEnemyR") then
			gf_print_table(msg, "KillEnemyR")
			self:play_one(msg)

		elseif id2 == Net:get_id2(model_name,"TeamScoreR") then
        	self:init_score_view()

        elseif id2 == Net:get_id2(model_name,"PassCopyR") then
        	self:dispose()

		end
	end
end

return state