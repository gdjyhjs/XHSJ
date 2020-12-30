--[[
	组队副本状态展示
	create by xin 
	2017.12.1

]]

local commom_string =
{
	[1] = gf_localize_string("第<color=#14D472FF>%d</color>波，击杀小怪<color=#14D472FF>%d/%d</color>"),
	[2] = gf_localize_string("第<color=#14D472FF>%d</color>波，击杀Boss<color=#14D472FF>%d/%d</color>"),
	[3] = gf_localize_string("击杀所有怪物，波数：<color=#14D472FF>%d/%d</color>"),
}


local copyStateBase = require("common.viewBase")

local teamCopyState=class(copyStateBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	copyStateBase._ctor(self, "mainui_copy.u3d", item_obj)
end)


-- 资源加载完成
function teamCopyState:on_asset_load(key,asset)
	-- self:set_always_receive(true)
	self:referInit()
	self:hide()
end

function teamCopyState:init_ui()
	
	self:update_state(0,0,0)

	self:start_scheduler_tick()

end

function teamCopyState:get_max_wave()
	local copy_id =  gf_getItemObject("copy"):get_copy_id()
	local map_id = gf_get_config_table("copy")[copy_id].enter_map
	print("wtf map_id:",map_id)
	local data = gf_get_config_table("map.mapMonsters")[map_id][1]

	local wave = 0
	for k,v in pairs(data or {}) do
		print("wtf ffffff:",v.wave)
		if v.wave > wave then
			wave = v.wave
		end
	end
	return wave
end

function teamCopyState:update_state(wave,count,target)
	print("wtf data :",wave,count,target)
	local copy_data = gf_getItemObject("copy")
	local copy_id = copy_data:get_copy_id()
	
	if copy_data:is_material_defence()   then
		local target_count = #(gf_get_config_table("material")[copy_id].refresh_script or {})
		self.refer:Get(1).text = string.format(commom_string[3],wave,target_count)
		return
	end

	if copy_data:is_material_time_treasury() then
		local target_count = self:get_max_wave()
		self.refer:Get(1).text = string.format(commom_string[3],wave,target_count)
		return
	end

	if not self.is_boss then
		self.refer:Get(1).text = string.format(commom_string[1],wave,count,target)
	else
		self.refer:Get(1).text = string.format(commom_string[2],wave,count,target)
	end
end


function teamCopyState:start_scheduler_tick()
	if self.schedule_id_tick then
		self:stop_schedule()
	end
	local update = function()
	end
	self.schedule_id_tick = Schedule(update, 0.1)
end

function teamCopyState:referInit()
	self.action = self.refer:Get(5)
    self.action.from = self.action.transform.localPosition
    self.action.to = self.action.transform.localPosition+Vector3(-265,0,0)
   
end
--isShow  是否显示出来
function teamCopyState:showAction(isShow)
	if not self.action then
		return
	end
	if not isShow then
		self.action:PlayForward()
	else
		self.action:PlayReverse()
	end
end
function teamCopyState:stop_schedule()
	if self.schedule_id_tick then
		self.schedule_id_tick:stop()
		self.schedule_id_tick = nil
	end
end

function teamCopyState:clear()
	
	self:stop_schedule()
end

function teamCopyState:on_hided()
	teamCopyState._base.on_hided(self)
	self:clear()
end

function teamCopyState:dispose()
	teamCopyState._base.dispose(self)
	self:clear()

end

function teamCopyState:on_receive(msg, id1, id2, sid)

	if id1 == ClientProto.FinishScene then
		print("wtf teamCopyState")
		if gf_getItemObject("copy"):is_team() then
			self:init_ui()
		end

	end
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy","CreatureWaveNotifyR") then
			gf_print_table(msg, "wtf CreatureWaveNotifyR:")
			local copy_data = gf_getItemObject("copy")
			if not copy_data:is_material_defence() and not copy_data:is_material_time_treasury() and  not gf_getItemObject("copy"):is_team() then
				return
			end

			if msg.wave == 0 then
				self.is_boss = true
				self.wave = self.wave + 1
			else
				self.wave = msg.wave
			end
			
			self.target = msg.target
			self:update_state(self.wave,0,msg.target)

		elseif id2 == Net:get_id2("copy","CopyScheduleR") then
			gf_print_table(msg, "wtf CopyScheduleR:")
			self:update_state(self.wave or 0,msg.schedule,self.target or 0)
		end
	end

	
end

return teamCopyState

