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

local leftPanelBase = require("models.mainuiLeftPanel.leftPanelBase")

local teamCopyState=class(leftPanelBase,function(self,item_obj,...)
	self.item_obj = item_obj
	leftPanelBase._ctor(self, "mainui_copy.u3d", item_obj,...)
end)


-- 资源加载完成
function teamCopyState:on_asset_load(key,asset)
	StateManager:register_view( self )
	self:referInit()
	self:init_ui()
	teamCopyState._base.on_asset_load(self,key,asset) 
end

function teamCopyState:init_ui()
	
	-- self:update_state(0,0,0)
	self:dule_wave()

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
	self.tween = self.refer:Get(5)
    self.tween.from = self.tween.transform.localPosition
    self.tween.to = self.tween.transform.localPosition+Vector3(-265,0,0)
   
end
--isShow  是否显示出来

function teamCopyState:stop_schedule()
	if self.schedule_id_tick then
		self.schedule_id_tick:stop()
		self.schedule_id_tick = nil
	end
end

function teamCopyState:clear()
	print("wtf teamCopyState clear")
	StateManager:remove_register_view( self )
end

function teamCopyState:on_hided()
	-- teamCopyState._base.on_hided(self)
	self:clear()
end

function teamCopyState:dispose()
	self:clear()
	self._base.dispose(self)
end

function teamCopyState:dule_wave()
	local msg = gf_getItemObject("copy"):get_wave_data()
	gf_print_table(msg,"wtf dule wate:")
	if not next(msg) then
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
end

function teamCopyState:on_receive(msg, id1, id2, sid)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy","CreatureWaveNotifyR") then
			gf_print_table(msg, "wtf CreatureWaveNotifyR:")
			local copy_data = gf_getItemObject("copy")
			print("wtf fff data:", not copy_data:is_material_defence() , not copy_data:is_material_time_treasury() ,  not gf_getItemObject("copy"):is_team())
			if not copy_data:is_material_defence() and not copy_data:is_material_time_treasury() and  not gf_getItemObject("copy"):is_team() then
				return
			end

			self:dule_wave()

		elseif id2 == Net:get_id2("copy","CopyScheduleR") then
			gf_print_table(msg, "wtf CopyScheduleR:")
			self:update_state(self.wave or 0,msg.schedule,self.target or 0)
		end
	end

	
end

return teamCopyState

