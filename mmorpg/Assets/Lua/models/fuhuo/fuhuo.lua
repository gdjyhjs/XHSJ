--[[--
--
-- @Author:Seven
-- @DateTime:2017-05-08 20:29:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Fuhuo = LuaItemManager:get_item_obejct("fuhuo")
Fuhuo.priority = ClientEnum.PRIORITY.LOADING
--UI资源
Fuhuo.assets=
{
    View("fuhuoView", Fuhuo) 
}

--点击事件
function Fuhuo:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event("fuhuo_view_on_click", false, obj, arg)
	return true
end

--每次显示时候调用
function Fuhuo:on_showed( ... )

end

--初始化函数只会调用一次
function Fuhuo:initialize()
	self:init_info()
end

function Fuhuo:init_info()
	self.newcomerlevel=ConfigMgr:get_config("t_misc").guide_protect_level --新手等级限制
	print("新手等级限制",self.newcomerlevel)
	self.recovermedicine=0
	self.goldlock = 0
	self.recovertime=30 --恢复时间
	self.time = 0 --原地恢复次数
	self.recover_time = 0 --恢复次数
	self.lengque_time=0 --原地恢复冷却时间
	self.isrotate = false
	self.cool_time = 99999 --大于上次才冷却
end
--打开界面加倒计时
function Fuhuo:open_fuhuo_view()
	self.recovertime=30
	local time = self.recovertime+5
	print("复活界面打开")
	self:add_to_state()
	if not self.count_down then
	self.count_down = Schedule(handler(self, function()
					self:recover_piont()
					self.count_down:stop()
					self.count_down = nil
					end), time)
	end
end


--原地复活方法
function Fuhuo:thispoint()
	self.time=self.time+1
	self.recover_time = self.recover_time +1
	print("复活2")
	LuaItemManager:get_item_obejct("battle"):respawn_c2s(2)
	-- self:dispose()
end
--复活点恢复方法
function  Fuhuo:recover_piont()
	self.recover_time = self.recover_time +1
	self.time = 0
	print("复活1")
	LuaItemManager:get_item_obejct("battle"):respawn_c2s(1)
	--[[废除 现在复活点复活由服务器去创建玩家]]
	-- local char = LuaItemManager:get_item_obejct("battle"):get_character()
	-- local mapid = LuaItemManager:get_item_obejct("game"):get_map_id()
	-- local x = ConfigMgr:get_config("mapinfo")[mapid].revive_point[2]
	-- local y = ConfigMgr:get_config("mapinfo")[mapid].revive_point[3]
	-- local ps = LuaItemManager:get_item_obejct("battle"):covert_s2c_position(x,y)
	-- char:set_position(ps)
	-- self:dispose()
end

function Fuhuo:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("scene") then
		if id2== Net:get_id2("scene", "RespawnR") then
			local player = LuaItemManager:get_item_obejct("battle"):get_character()
			if not player or msg.guid ~= player.guid  then
				return
			end
			if self.count_down then
				self.count_down:stop()
				self.count_down = nil
			end
			if self.time == 0 then
				LuaItemManager:get_item_obejct("battle"):get_character():reset_camera()
			end
		end
	end
end