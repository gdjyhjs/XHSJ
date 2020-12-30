--[[--
-- 外观
-- @Author:Seven
-- @DateTime:2017-09-20 11:11:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Surface = LuaItemManager:get_item_obejct("surface")
--UI资源
Surface.assets=
{
    View("surfaceView", Surface) 
}

-- 通过外观id，打开外观界面
function Surface:open_view( surface_id )
	self.surface_id = surface_id
	self:add_to_state()
	if surface_id then
		self.assets[1]:set_surface_id(surface_id)
	end
end

-- 通过类型获取外观数据
function Surface:get_data( ty )
	if not self.config_data[ty] then
		local career = LuaItemManager:get_item_obejct("game"):get_career()
		local data = {}
		for k,v in pairs(ConfigMgr:get_config("surface")) do
			if v.type == ty and v.prefix_surface_id == 0 and (v.career == 0 or v.career == career) then
				v.is_lock = self.unlock_list[v.surface_id] == nil -- 是否解锁
				data[#data+1] = v
			end
		end
		self.config_data[ty] = data

		local sort = function( a, b )
			if a.surface_id < b.surface_id then
				return true
			end
			return false
		end
		table.sort( self.config_data[ty] or {}, sort )
	end

	return self.config_data[ty]
end

-- 判断外观是否解锁
function Surface:is_unlock( surface_id )
	-- print("判断外观是否解锁",surface_id,self.unlock_list[surface_id])
	return self.unlock_list[surface_id] ~= nil
end

-- 通过类型获取拥有的外观
function Surface:get_own_surface( ty )
	if not self.own_list[ty] then
		local list = self:get_data(ty)
		local data = {}
		for i,v in ipairs(list or {}) do
			local have = false
			if self:is_unlock(v.surface_id) then
				data[#data+1] = v
				have = true
			end
			if not have then
				local color_data = self:get_same_diff_color(v.surface_id)
				for j,c in ipairs(color_data or {}) do
					if self:is_unlock(c.surface_id) then
						data[#data+1] = v
						break
					end
				end
			end
		end
		self.own_list[ty] = data
	end

	return self.own_list[ty]
end

-- 通过id获取同一系列（颜色不同的）
function Surface:get_same_diff_color( code )
	print("通过id获取同一系列（颜色不同的）", code)
	if self.same_diff_color_list[code] then
		local sort_fn = function( a, b )
			if a.surface_id < b.surface_id then
				return true
			end
			return false
		end
		table.sort( self.same_diff_color_list[code], sort_fn )
	end
	return self.same_diff_color_list[code] or {}
end

-- 通过类型获取穿在身上的外观id enum.SURFACE_TYPE
function Surface:get_wear_surface_id( ty )
	return self.wear_surface_list[ty] or 0
end

-- 通过类型获取玩家模型
function Surface:get_wear_surface_model( ty )
	local surface_id = self:get_wear_surface_id(ty)
	if surface_id > 0 then
		if ty == ServerEnum.SURFACE_TYPE.TALK_BG then
			return ConfigMgr:get_config("surface")[surface_id].chat_img
		end

		local data = ConfigMgr:get_config("surface")[surface_id]
		return data.model, data.model_img, data.flow_img, data.flow_color, data.flow_speed, data.effect
	end
	return nil, nil, nil, nil, nil, nil
end

-- 判断当前选中外观是否是套装
function Surface:is_suit( surface_id )
	return self.suit_list[surface_id] ~= nil
end

-- 获取套装数据
function Surface:get_suit( surface_id )
	return self.suit_list[surface_id]
end

-- 获取套装配表
function Surface:get_suit_config()
	if not self.suit_config then
		self.suit_config = {}
		local career = LuaItemManager:get_item_obejct("game"):get_career()
		for k,v in pairs(ConfigMgr:get_config("surface_set")) do
			if v.career == career then
				self.suit_config[#self.suit_config+1] = v
			end
		end
	end

	-- 把已经解锁的放前面
	local function sort( a, b )
		if self:get_suit_unlock_count(a) > self:get_suit_unlock_count(b) then
			return true
		end
		return false
	end
	table.sort(self.suit_config, sort)
	return self.suit_config
end

-- 套装解锁数量
function Surface:get_suit_unlock_count( suit_data )
	local count = 0
	for i,v in ipairs(suit_data.element) do
		if self:is_unlock(v) then
			count = count + 1
		end
	end
	return count
end

-- 获取套装对应的外观数据
function Surface:get_suit_surface(suit_data)
	if not self.suit_surface_list then
		self.suit_surface_list = {}
	end

	if not self.suit_surface_list[suit_data.surface_set_id] then
		local surface_list = {}
		for i,v in ipairs(suit_data.element) do
			surface_list[i] = ConfigMgr:get_config("surface")[v]
		end
		self.suit_surface_list[suit_data.surface_set_id] = surface_list
	end

	local sort = function( a, b )
		if self:is_unlock(a.surface_id) and not self:is_unlock(b.surface_id) then
			return true
		end
		return false
	end
	table.sort(self.suit_surface_list[suit_data.surface_set_id], sort)
	return self.suit_surface_list[suit_data.surface_set_id]
end

-- 是否有红点
function Surface:is_have_red_point()
	local career = LuaItemManager:get_item_obejct("game"):get_career()
	for k,v in pairs(ConfigMgr:get_config("surface")) do
		if v.prefix_surface_id == 0 and self:get_red_point(v) and (v.career == 0 or v.career == career) then
			print("外观有红点")
			--Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.COURTYARD, visible=show or false}, ClientProto.ShowHotPoint)
			return true
		end
	end
	return false
end

-- 根据外观数据获取红点
function Surface:get_red_point( data )
	if not data then
		return false
	end

	if not self:is_unlock(data.surface_id) then
		local item_count = self.bag_item:get_item_count(data.need_item[1],ServerEnum.BAG_TYPE.NORMAL)
		local need_count = data.need_item[2]
		print("外观有红点",item_count,need_count)
		if item_count and need_count and item_count >= need_count then
			return true
		end
	else
		local color_list = self:get_same_diff_color(data.surface_id)
		for i,v in ipairs(color_list) do
			if not self:is_unlock(v.surface_id) then
				local item_count = self.bag_item:get_item_count(v.need_item[1],ServerEnum.BAG_TYPE.NORMAL)
				local need_count = v.need_item[2]
				print("外观有红点1",item_count,need_count)
				if item_count and need_count and  item_count >= need_count then
					return true
				end
			end
		end
	end
	return false
end

-- 根据类型获取红点
function Surface:get_red_point_ty( ty )
	local list = self:get_data(ty)
	for k,v in pairs(list) do
		if self:get_red_point(v) then
			return true
		end
	end
	return false
end

--点击事件
function Surface:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

function Surface:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("bag") then
		if id2 == Net:get_id2("bag", "GetSurfaceInfoR") then
			gf_print_table(msg,"wtf receive GetSurfaceInfoR")
			self:get_surface_info_s2c(msg)
			Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.COURTYARD ,visible = self:is_have_red_point()}, ClientProto.ShowHotPoint)
		elseif id2 == Net:get_id2("bag", "ActiveSurfaceR") then
			self:active_surface_s2c(msg)
			Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.COURTYARD ,visible = self:is_have_red_point()}, ClientProto.ShowHotPoint)
			
		elseif id2 == Net:get_id2("bag", "WearSurfaceR") then
			self:wear_surface_s2c(msg)

		elseif id2 == Net:get_id2("bag", "UnWearSurfaceR") then
			self:unwear_surface_s2c(msg)

		elseif id2== Net:get_id2("bag", "GetBagInfoR") then 
		--	Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.COURTYARD ,visible = self:is_have_red_point()}, ClientProto.ShowHotPoint)
		end
	end
end

-- 获取解锁外观
function Surface:get_surface_info_c2s()
	Net:send({}, "bag", "GetSurfaceInfo")
end

function Surface:get_surface_info_s2c( msg )
	gf_print_table(msg, "获取解锁外观")
	self.unlock_list = {} -- 解锁列表
	for i,v in ipairs(msg.surfaceIdArr or {}) do
		self.unlock_list[v] = v
	end
	self.wear_surface_list = msg.wearSurfaceId or {} -- 穿在身上的外观

	self:init_same_diff_color_list()
end

-- 解锁外观
function Surface:active_surface_c2s( surface_id )
	print("解锁外观",surface_id)
	--[[if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end]]
	Net:send({surfaceId = surface_id}, "bag", "ActiveSurface")
end

function Surface:active_surface_s2c( msg )
	gf_print_table(msg, "解锁外观 返回")
	
	self.unlock_list[msg.surfaceId] = msg.surfaceId
	local data = ConfigMgr:get_config("surface")[msg.surfaceId]
	if self.own_list[data.type] then
		if data.prefix_surface_id == 0 then
			data.is_lock = false
			--[[if not self.own_list[data.type] then
				self.own_list[data.type] = {}
			end]]
			table.insert(self.own_list[data.type], data)
		end
	end
	local list = self.config_data[data.type]
	for i,v in ipairs(list or {}) do
		if v.surface_id == msg.surfaceId then
			self.config_data[data.type][i].is_lock = false
			break
		end
	end

	self:wear_surface_c2s(msg.surfaceId) -- 解锁后自动穿戴
end

-- 穿上外观
function Surface:wear_surface_c2s( surface_id )
	print("穿上外观",surface_id)
	Net:send({surfaceId = surface_id}, "bag", "WearSurface")
end

function Surface:wear_surface_s2c( msg )
	gf_print_table(msg, "穿上外观 返回")
	if msg.err and msg.err ~= 0 then
		return
	end
	local data = ConfigMgr:get_config("surface")[msg.surfaceId]
	self.wear_surface_list[data.type] = msg.surfaceId
	gf_print_table(self.wear_surface_list,"身上外观")
end

-- 卸下外观
function Surface:unwear_surface_c2s( type )
	print("卸下外观",type)
	Net:send({type = type}, "bag", "UnWearSurface")
end

function Surface:unwear_surface_s2c( msg )
	gf_print_table(msg, "卸下外观 返回")
	-- if msg.err and msg.err ~= 0 then
	-- 	return
	-- end
	self.wear_surface_list[msg.type] = 0
	gf_print_table(self.wear_surface_list,"玩家身上外观")
end

--每次显示时候调用
function Surface:on_showed( ... )

end

--初始化函数只会调用一次
function Surface:initialize()
	self.config_data = {}
	self.own_list = {}
	self.unlock_list = {} -- 解锁列表
	self.bag_item = LuaItemManager:get_item_obejct("bag")

	self:init_suit()
end

-- 初始化同一系列（颜色不同的）列表
function Surface:init_same_diff_color_list()
	self.same_diff_color_list = {}
	for k,v in pairs(ConfigMgr:get_config("surface")) do
		if v.prefix_surface_id > 0 then
			if not self.same_diff_color_list[v.prefix_surface_id] then
				self.same_diff_color_list[v.prefix_surface_id] = {ConfigMgr:get_config("surface")[v.prefix_surface_id]}
			end
			v.is_lock = self.unlock_list[v.code] == nil -- 是否解锁
			self.same_diff_color_list[v.prefix_surface_id][#self.same_diff_color_list[v.prefix_surface_id]+1] = v
		else
			if not self.same_diff_color_list[v.surface_id] then
				self.same_diff_color_list[v.surface_id] = {v}
			end
		end
	end
end

-- 初始化套装表
function Surface:init_suit()
	self.suit_list = {} -- 套装表
	for k,v in pairs(ConfigMgr:get_config("surface_set")) do
		for i,d in ipairs(v.element) do
			self.suit_list[d] = v
		end
	end
end
