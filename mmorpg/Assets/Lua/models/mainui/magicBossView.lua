--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-18 23:22:25
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MagicBossView=class(UIBase,function(self,item_obj)
	self.data = {}
	self.refresh_item_l = {}
	self.time = 1

    UIBase._ctor(self, "mainui_zork_boss.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function MagicBossView:on_asset_load(key,asset)
	self:set_always_receive(true)
	self:set_visible(LuaItemManager:get_item_obejct("boss"):is_magic())
	self:init_ui()
	self:send_msg()
end

function MagicBossView:init_ui()
	self.tween = self.refer:Get("tween")
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("zork_rt").anchoredPosition = Vector2(dx, self.refer:Get("zork_rt").anchoredPosition.y)

	self.scroll = self.refer:Get("loop_scroll")
	self.scroll.onItemRender = handler(self, self.update_item)
end

function MagicBossView:refresh( data )
	self.data = data or {}
	self.refresh_item_l = {}
	self.boss_data = {}
	self.scroll.totalCount = #self:get_map_data()
	self.scroll:RefillCells(0)
end

function MagicBossView:get_map_data()
	if next(self.boss_data or {}) then
		return self.boss_data
	end
	local temp = {}
	local map_id = gf_getItemObject("battle"):get_map_id()
	for i,v in ipairs(self.data or {}) do
		if gf_get_config_table("world_boss")[v.bossCode].map_id == map_id then
			table.insert(temp,v)
		end
	end
	self.boss_data = temp
	return temp
end

function MagicBossView:update_item( item, index )
	local data = self:get_map_data()[index]--self.data[index]
	if not data then
		item.gameObject:SetActive(false)
		return
	else
		item.gameObject:SetActive(true)
	end
	item.data = data

	local boss = ConfigMgr:get_config("creature")[data.bossCode]
	item:Get(1).text = string.format("%s[%d级]" ,boss.name,boss.level)
	
	local active = data.refreshTime == 0 or Net:get_server_time_s() >= data.refreshTime
	if not active then
		item:Get(2).text = gf_convert_time(data.refreshTime - Net:get_server_time_s())
		self.refresh_item_l[item] = item
	end
	item:Get(2).gameObject:SetActive(not active)
	item:Get(3).gameObject:SetActive(active)
end

function MagicBossView:show_view( show )
	if not self.tween then
		return
	end

	if show then
		self.tween:PlayReverse()
	else
		self.tween:PlayForward()
	end
end

function MagicBossView:send_msg()
	if not self:is_loaded() then
		return
	end

	local boss_item = LuaItemManager:get_item_obejct("boss")
	if boss_item:is_magic() then
		print("boss刷新列表请求")
		boss_item:magic_boss_refresh_list_c2s()
	end
end

function MagicBossView:on_update( dt )
	self.time = self.time - dt
	if self.time > 0 then
		return
	end
	self.time = 1

	-- 刷新时间显示
	for k,item in pairs(self.refresh_item_l) do
		local data = self:get_map_data()[item.index]--self.data[item.index]
		local t = Net:get_server_time_s()
		if t >= data.refreshTime then
			item:Get(2).gameObject:SetActive(false)
			item:Get(3).gameObject:SetActive(true)
			self.refresh_item_l[k] = nil
		else
			item:Get(2).text = gf_convert_time(data.refreshTime - Net:get_server_time_s())
		end
	end
end

function MagicBossView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("boss点击",cmd)
	if cmd == "Item" then -- 前往boss所在坐标
		LuaItemManager:get_item_obejct("boss"):move_to_boss(arg.data.bossCode)
	end
end

function MagicBossView:on_receive( msg, id1, id2, sid )
	 if(id1==Net:get_id1("scene"))then
        if id2 == Net:get_id2("scene", "MagicBossRefreshListR") then
        	gf_print_table(msg,"boss刷新列表返回")

        	self:refresh(msg.list or {})
        end

    elseif id1 == ClientProto.PlayerLoaderFinish then
    	self:send_msg()
    end

end

function MagicBossView:register()
	StateManager:register_view( self )
	gf_register_update(self)
end

function MagicBossView:cancel_register()
	StateManager:remove_register_view( self )
	gf_remove_update(self)
end

function MagicBossView:on_showed()
	self:register()
	self:send_msg()
end

function MagicBossView:on_hided()
	self:cancel_register()
end

-- 释放资源
function MagicBossView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return MagicBossView

