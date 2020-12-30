--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-22 11:22:57
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Map = LuaItemManager:get_item_obejct("map")
local Battle = LuaItemManager:get_item_obejct("battle")
--UI资源
Map.assets=
{
    View("mapView", Map) 
}

Map.no_show_id = {
	50102101, -- 兽神
}

Map.event_name = "map_view_on_click"
--点击事件
function Map:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

-- 释放资源
function Map:dispose()
    -- self._base.dispose(self)
end

--初始化函数只会调用一次
function Map:initialize()
	self.mapId = nil
	self.on_pathfinding=false --正在寻路
end

-- 设置玩家
-- function Map:set_player_transform( tf )
-- 	self.tf_player = tf
-- end

function Map:get_player_pos()
	-- return Seven.PublicFun.IsNull(self.tf_player) and Vector3(100,0,100) or self.tf_player.position
	return Battle.character and not Seven.PublicFun.IsNull(Battle.character.transform) and Battle.character.transform.position or Vector3(100,0,100)
end

function Map:get_player_dir()
	-- return Seven.PublicFun.IsNull(self.tf_player) and Vector3(100,0,100) or self.tf_player.eulerAngles
	return Battle.character and not Seven.PublicFun.IsNull(Battle.character.transform) and Battle.character.transform.eulerAngles or Vector3(100,0,100)
end

function Map:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.JoystickStartMove -- 开始移动摇杆
	 or id1 == ClientProto.PlayerDie -- 玩家死亡
	 then
		Net:receive({}, ClientProto.OnStopAutoMove)
	elseif id1 == ClientProto.OnStopAutoMove then --停止自动移动
		self:auto_move_end()
	-- elseif id1 == ClientProto.PlayerLoaderFinish then --玩家加载完成
	-- 	self:set_player_transform(msg.transform)
	-- 	self.player = msg
	elseif id1 == ClientProto.FinishScene then -- 进入场景，刷新主ui
		self:load_map_pos()
		self:add_to_state()
	elseif id1 == ClientProto.HidOrShowMainUI then --收到这条协议，显示或者隐藏小地图
		if msg.visible then
			self:show()
		else
			self:hide()
		end

	elseif id1 == ClientProto.FristBattleMainui then
		if msg then
			self:show()
		else
			self:hide()
		end
	end
	-- if self.assets[1].visible then
		-- self.assets[1]:on_receive( msg, id1, id2, sid )
	-- end
end

--移动到某个点(场景的坐标)不是服务器的10倍
function Map:move_to_point(target_point,mapId,fun)
	if self.on_pathfinding then
		Net:receive({}, ClientProto.OnStopAutoMove)
	end
	-- print("开始自动寻路到",target_point,mapId)
	mapId = mapId or LuaItemManager:get_item_obejct("game"):getRoleInfo().mapId
	LuaItemManager:get_item_obejct("battle"):move_to( mapId,target_point.x*10,target_point.z*10, function() 
		Net:receive({}, ClientProto.OnStopAutoMove) 
		if fun then fun() end
		end ,0.5,true)
	if #self:get_path() > 0 then
		--通知显示寻路ui
		Net:receive({visible = true}, ClientProto.ShowMainUIAutoPath)
		--正在寻路中
		self.on_pathfinding = true
	else
		-- gf_message_tips("该位置不可到达")
	end
end

function Map:get_path()
	local chat = LuaItemManager:get_item_obejct("battle"):get_character()
	return chat and chat.path or {}
end

function Map:auto_move_end()
	self.on_pathfinding = false
	Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath)
end

---------------新版本 使用四边形划分区域 测试---------------------------------

--切换场景时,加载出地图的坐标
function Map:load_map_pos()
	self.mapId = LuaItemManager:get_item_obejct("game"):getRoleInfo().mapId
	self.mapdata = ConfigMgr:get_config("mapinfo")[self.mapId]
	if self.mapdata then
		self.data_pos = {}
		for i=1,#self.mapdata.scene_pos,2 do
			local data = {}
			data.scene_pos = Vector2(self.mapdata.scene_pos[i]/10,self.mapdata.scene_pos[i+1]/10)
			data.map_pos = Vector2(self.mapdata.map_pos[i],self.mapdata.map_pos[i+1])
			self.data_pos[#self.data_pos+1] = data
		end
	else
		self.data_pos = {}
	end
end

-- 地图坐标转世界坐标
function Map:mappos2scenepos(pos)
	if #self.data_pos==0 or #self.data_pos%4~=0 then
		-- print("<color=yellow>配置的点不正确</color>")
		return Vector3(0,0,0)
	else 
		-- print("使用四边形划分区域定位位置",scene_pos)
		local lt,lb,rt,rb = self:get_map_quadrilateral(pos)
		if not lt or not lb or not rt or not rb then
			-- print("<color=red>配置文件可能有错误</color>")
			return Vector3(0,0,0)
		end

		local x1 = lt.scene_pos
		local x2 = rt.scene_pos
		local x3 = lb.scene_pos
		local x4 = rb.scene_pos

		local X1 = lt.map_pos
		local X2 = rt.map_pos
		local X3 = lb.map_pos
		local X4 = rb.map_pos

		local converterRegion = require("models.map.converterRegion")
		local mat = converterRegion:setIdentity(X1,X2,X3,X4,x1,x2,x3,x4)
		local x,y = converterRegion:warp(mat,pos.x,pos.y)
		return Vector3(x,0,y)
	end
	return Vector3(0,0,0)
end

-- 世界坐标转地图坐标(场景的坐标)不是服务器的10倍
function Map:scenepos2mappos(pos)
	if #self.data_pos%4~=0 then
		-- print("<color=yellow>配置的点不正确</color>")
		return Vector2(0,0)
	else 
		-- print("使用四边形划分区域定位位置",scene_pos)
		local scene_pos = Vector2(pos.x,pos.z)
		local lt,lb,rt,rb = self:get_quadrilateral(scene_pos)
		if not lt or not lb or not rt or not rb then
			-- print("<color=yellow>配置文件可能有错误</color>")
			return Vector2(0,0)
		end

		local x1 = lt.scene_pos
		local x2 = rt.scene_pos
		local x3 = lb.scene_pos
		local x4 = rb.scene_pos

		local X1 = lt.map_pos
		local X2 = rt.map_pos
		local X3 = lb.map_pos
		local X4 = rb.map_pos

		local converterRegion = require("models.map.converterRegion")
		local mat = converterRegion:setIdentity(x1,x2,x3,x4,X1,X2,X3,X4)
		local x,y = converterRegion:warp(mat,pos.x,pos.z)
		return Vector2(x,y)
	end
	return Vector2(0,0)
end

-- 取两线交叉点
-- function Map:get_intersection(p1,p2,p3,p4)
-- 	local x1 = p1.x
-- 	local y1 = p1.y
-- 	local x2 = p2.x
-- 	local y2 = p2.y
-- 	local x3 = p3.x
-- 	local y3 = p3.y
-- 	local x4 = p4.x
-- 	local y4 = p4.y

-- 	--推算

-- 	k1 = (y2-y1)/(x2-x1)
-- 	b1 = y1 - k1*x1
-- 	k2 = (y4-y3)/(x4-x3)
-- 	b2 = y3 - k2*x3
-- 	x = (b1-b2)/(k2-k1)
-- 	y = k1*x+b1
-- 	return Vector2(x,y)

-- end

-- 从点数据里，取出所在场景的四边形
function Map:get_quadrilateral(point)
	for i=1,#self.data_pos,4 do -- 取自己所在的四边形
		if self:isPointInRect(point,{self.data_pos[i].scene_pos,self.data_pos[i+1].scene_pos,self.data_pos[i+2].scene_pos,self.data_pos[i+3].scene_pos}) then
			-- print("<color=yellow>当前所在四边形</color>",(i+3)/4)
			return self.data_pos[i],self.data_pos[i+1],self.data_pos[i+2],self.data_pos[i+3]
		end
	end
	-- print("<color=yellow>没有在任何四边形内，取第一个</color>")
	return self.data_pos[1],self.data_pos[2],self.data_pos[3],self.data_pos[4]
end

-- 从点数据离，取所在地图的四边形
function Map:get_map_quadrilateral(point)
	for i=1,#self.data_pos,4 do -- 取自己所在的四边形
		if self:isPointInRect(point,{self.data_pos[i].map_pos,self.data_pos[i+1].map_pos,self.data_pos[i+2].map_pos,self.data_pos[i+3].map_pos}) then
			return self.data_pos[i],self.data_pos[i+1],self.data_pos[i+2],self.data_pos[i+3]
		end
	end
	-- print("没有在任何四边形内，取第一个")
	return self.data_pos[1],self.data_pos[2],self.data_pos[3],self.data_pos[4]
end

-- 点是否在四边形内
function Map:isPointInRect(p, poly)
	-- print(p.x,p.y,"判断点是否在四边形内",poly[1].x,poly[1].y,poly[2].x,poly[2].y,poly[3].x,poly[3].y,poly[4].x,poly[4].y)
	local px = p.x
    local py = p.y
    local flag = false

	for i = 1, #poly do
		local j = i==#poly and 1 or i+1
		local sx = poly[i].x
		local sy = poly[i].y
		local tx = poly[j].x
		local ty = poly[j].y

		-- 点与多边形顶点重合
		if((sx == px and sy == py) or (tx == px and ty == py)) then
			return true
		end

		-- 判断线段两端点是否在射线两侧
		if((sy < py and ty >= py) or (sy >= py and ty < py)) then
			-- 线段上与射线 Y 坐标相同的点的 X 坐标
			local x = sx + (py - sy) * (tx - sx) / (ty - sy)

			-- 点在多边形的边上
			if(x == px) then
				return true
			end
			-- 射线穿过多边形的边界
			if(x > px) then
				flag = not flag
			end
		end

	end

	-- 射线穿过多边形边界的次数为奇数时点在多边形内
	return flag and true or false

	--	方法2
	-- local x,y = p.x,p.y
	-- local j = 4
	-- local flag = false
	-- for i=1,4 do
	-- 	if (poly[i].y<y and poly[j].y>=y) or (poly[j].y<y and poly[i].y>=y) then
	-- 		if (poly[i].x+(y-poly[i].y)/(poly[j].y-poly[i].y)*(poly[j].x-poly[i].x)<x) then
	-- 			flag = not flag
	-- 		end
	-- 	end
	-- 	j = i
	-- end
	-- return flag
end