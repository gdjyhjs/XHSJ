--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-03 10:54:07
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Vector2 = UnityEngine.Vector2
local Input = UnityEngine.Input
local Screen = UnityEngine.Screen
local Enum = require("enum.enum")
local MapUserData = require("models.map.mapUserData")
local map_size = 1.465

local MapView=class(Asset,function(self,item_obj)
	self:set_level(UIMgr.LEVEL_STATIC)
    Asset._ctor(self, "small_map.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function MapView:on_asset_load(key,asset)
	print("小地图资源加载完毕")
	self:init_ui()
end

-- 设置地图大小
function MapView:set_map_size(value)
	map_size = value or map_size
	if self.tf_min_map then
		self.tf_min_map.sizeDelta = self.tf_min_map.sizeDelta*map_size
	end
end

-- 获取地图大小
function MapView:get_map_size()
	return map_size
end

-- 初始化获取ui
function MapView:init_ui()
	local ref = self.refer
	--获取地图数据
	self.map = LuaItemManager:get_item_obejct("map")
    --获取地图名文本
    self.text_scene_name=ref:Get("text_scene_name")
    --获取坐标位置文本
    self.text_position=ref:Get("text_position")
	--获取玩家图片
	self.tf_player_mark=ref:Get("player_mark")
	--获取小地图图片
	self.img_min_map=ref:Get("img_min_map")
	--获取小地图tf
	self.tf_min_map=self.img_min_map.transform
	--获取小地图的mark
	self.tf_map_mark = self.refer:Get("map_mark")
	--初始化地图
	self:set_map()
	self.init = true
	print("小地图初始化完毕")
end

function MapView:set_team_mark(idx,pos)
	if not self.team_mark_list then
		self.team_mark_list = {}
	end
	if pos and not self.team_mark_list[idx] then
		local mark = LuaHelper.Instantiate(self.tf_player_mark.gameObject)
		mark.transform:SetParent(self.tf_player_mark.parent,false)
		mark.transform.localScale = mark.transform.localScale*0.7
		self.team_mark_list[idx] = mark
	elseif pos and self.team_mark_list[idx] then
		self.team_mark_list[idx].transform.localPosition = pos
	elseif self.team_mark_list[idx] then
		self.team_mark_list[idx].transform.localPosition = Vector3(10000,10000,0)
	end
end

-- 初始化计算地图位置数据
function MapView:init_map_data(mapSize)
	-- local data = self.mapdata
	-- --求 地图：场景 的缩放比例
	-- local width_ratio = math.abs(data.map_pos1_x-data.map_pos2_x)/math.abs(data.scene_pos1_x/10-data.scene_pos2_x/10)
	-- local height_ratio = math.abs(data.map_pos1_y-data.map_pos2_y)/math.abs(data.scene_pos1_y/10-data.scene_pos2_y/10)
	-- self.mapdata.map_left_pos = data.scene_pos1_x/10 - data.map_pos1_x / width_ratio
	-- self.mapdata.map_right_pos = data.scene_pos1_x/10 + (mapSize.x - data.map_pos1_x) / width_ratio
	-- self.mapdata.map_bottom_pos = data.scene_pos1_y/10 - data.map_pos1_y / height_ratio
	-- self.mapdata.map_top_pos = data.scene_pos1_y/10 + (mapSize.y - data.map_pos1_y) / height_ratio
	-- print("小地图数据计算结果：",self.mapdata.map_left_pos,self.mapdata.map_bottom_pos,self.mapdata.map_right_pos,self.mapdata.map_top_pos)
	self.data_pos = {}
	for i=1,#self.mapdata.scene_pos,2 do
		local data = {}
		data.scene_pos = Vector2(self.mapdata.scene_pos[i]/10,self.mapdata.scene_pos[i+1]/10)
		data.map_pos = Vector2(self.mapdata.map_pos[i],self.mapdata.map_pos[i+1])
		self.data_pos[#self.data_pos+1] = data
	end
end

--初始化小地图
function MapView:set_map()
	-- print("设置主界面小地图")
	self:clear_mark()
	local mapId = LuaItemManager:get_item_obejct("game"):getRoleInfo().mapId
	self.item_obj.mapId = mapId
	self.mapdata = ConfigMgr:get_config("mapinfo")[mapId]
	self.data_pos = {}
	local set_map_ui = function(ref)
		-- print("加载到小地图图片，开始初始化小地图ui和上面的图标")
		--初始化图片大小
		self.img_min_map:SetNativeSize()	--图片大小
		--初始化图片位置
		self.tf_min_map.localPosition=Vector2(self.tf_min_map.sizeDelta.x/2,self.tf_min_map.sizeDelta.y/2)
		--初始化地图名字
		self.text_scene_name.text=self.mapdata.name
		--初始化地图坐标文本
	    self.text_position.text="0,0"
	    -- 初始化计算地图位置数据
	    self:init_map_data(self.tf_min_map.sizeDelta)
	    --设置小地图缩放
		self:set_map_size()
	    print("--设置NPC和传送阵")
	    local data = ConfigMgr:get_config("map.mapMonsters")[mapId]
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.NPC] or {}) do
	    	local data = ConfigMgr:get_config("npc")[v.code]
	    	if data.touch~=0 then --是可以对话的npc，不是装饰品，才要显示在地图
	    		local item = self:set_mark(Vector2(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.NPC,i)
	    		item:GetComponentInChildren("UnityEngine.UI.Text").text = data.name --设置名称
	    		item.name = string.format("npcBtn_%d_%d_%d_%s",v.pos.x,v.pos.y,v.code,data.name)
	    	end
	    end
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.TRANPORT] or {}) do
	    	local item = self:set_mark(Vector2(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.TRANPORT,i)
	    	item.name = string.format("传送阵_%d_%d_%d",v.pos.x,v.pos.y,v.code)
	    end
	end
	local mapFileName = self.mapdata.fileName
	print("加载地图ui 文件名：",mapFileName)
	gf_setImageTexture(self.img_min_map, mapFileName, set_map_ui)

	if self.mapdata.small_map_off == 1 then
		self.refer:Get("position_bg"):SetActive(true)
		self:register()
	else
		self.refer:Get("position_bg"):SetActive(false)
		self:cancel_register()
	end
end

--设置一个标志 位置 地图对象类型 名字
function MapView:set_mark(pos,map_object_type,key)
	-- 建立保存地图标志的缓存
	if not self.mark_cache then self.mark_cache = {} end
	if not self.mark_cache[map_object_type] then self.mark_cache[map_object_type] = {} end
	--获取标志
	local obj_name = MapUserData:get_obj_key_name(map_object_type)
	local item = self:get_item(obj_name,self.refer:Get(obj_name),self.tf_min_map.gameObject) --获取对象
	item.transform.localPosition = self:scenepos2mimmappos(Vector3(pos.x,0,pos.y)) --设置位置
	self.mark_cache[map_object_type][#self.mark_cache[map_object_type]+1] = item

	return item
end

--清空标志 无参数为清空所有，有参数则清对应类型全部或对应类型一个
function MapView:clear_mark(map_object_type,key)
	if not self.mark_cache then return end
	if map_object_type and self.mark_cache[map_object_type]  then
		local obj_name =  MapUserData:get_obj_key_name(map_object_type)
		if key and self.mark_cache[map_object_type][key] then
			self:repay_item(obj_name,self.mark_cache[map_object_type][key])
			self.mark_cache[map_object_type][key] = nil
		else
			for k,v in pairs(self.mark_cache[map_object_type]) do
				self:repay_item(obj_name,v)
			end
			self.mark_cache[map_object_type] = {}
		end
	elseif not map_object_type and not key then
		for kk,vv in pairs(self.mark_cache) do
			local obj_name = MapUserData:get_obj_key_name(kk)
			for k,v in pairs(vv) do
				self:repay_item(obj_name,v)
			end
			self.mark_cache = {}
		end
	end
end

-- 场景坐标转地图坐标
function MapView:scenepos2mimmappos(scenepos)

	return self.item_obj:scenepos2mappos(scenepos)*map_size
end

--更新地图信息
function MapView:update_mapinfo()
	-- print("小地图更新地图信息")
	--玩家朝向
	self.tf_player_mark.eulerAngles =Vector3(0,0,-self.item_obj:get_player_dir().y)
	--设置坐标文本
	self.text_position.text=string.format("%d,%d",self.item_obj:get_player_pos().x,self.item_obj:get_player_pos().z)
	--设置小地图位置
	local pos = -self:scenepos2mimmappos(self.item_obj:get_player_pos())
	--防止小地图露出边界
	local player_mark_pos = Vector2(0,0)
	if pos.x > -self.tf_map_mark.sizeDelta.x/2 then
		-- print("超出了左边",pos.x - (-self.tf_map_mark.sizeDelta.x/2))
		player_mark_pos = Vector2(pos.x-(-self.tf_map_mark.sizeDelta.x/2),0)
		pos = Vector2(-self.tf_map_mark.sizeDelta.x/2,pos.y)
	elseif pos.x < -self.tf_min_map.sizeDelta.x + self.tf_map_mark.sizeDelta.x/2 then
		-- print("超出了右边",pos.x - (-self.tf_min_map.sizeDelta.x + self.tf_map_mark.sizeDelta.x/2))
		player_mark_pos = Vector2(pos.x - (-self.tf_min_map.sizeDelta.x + self.tf_map_mark.sizeDelta.x/2),0)
		pos = Vector2(-self.tf_min_map.sizeDelta.x + self.tf_map_mark.sizeDelta.x/2,pos.y)
	end
	if pos.y > -self.tf_map_mark.sizeDelta.y/2 then
		-- print("超出了下边")
		player_mark_pos = Vector2(player_mark_pos.x,pos.y - (-self.tf_map_mark.sizeDelta.y/2))
		pos = Vector2(pos.x,-self.tf_map_mark.sizeDelta.y/2)
	elseif pos.y < -self.tf_min_map.sizeDelta.y + self.tf_map_mark.sizeDelta.y/2 then
		-- print("超出了上边")
		player_mark_pos = Vector2(player_mark_pos.x,pos.y - (-self.tf_min_map.sizeDelta.y + self.tf_map_mark.sizeDelta.y/2))
		pos = Vector2(pos.x,-self.tf_min_map.sizeDelta.y + self.tf_map_mark.sizeDelta.y/2)
	end
	-- print("玩家标志位置",player_mark_pos)
	self.tf_min_map.localPosition = Vector2.Lerp(self.tf_min_map.localPosition,pos,0.5)
	self.tf_player_mark.localPosition = -player_mark_pos
	

	local team_info = LuaItemManager:get_item_obejct("team"):getTeamData()
	local members = team_info and team_info.members or {}
	local max_player = ConfigMgr:get_config("game_const").team_member_count.value
	local my_player_id = LuaItemManager:get_item_obejct("game"):getId()
	local my_map_id = LuaItemManager:get_item_obejct("game"):get_map_id()
	for i=1,max_player do
		local mate = members[i]
		if mate and mate.roleId ~= my_player_id and mate.mapId==my_map_id then
			local mate_pos = self:scenepos2mimmappos(Vector3(mate.posX/10,0,mate.posY/10))
			local my_pos = self:scenepos2mimmappos(self.item_obj:get_player_pos())
			mate_pos = mate_pos - my_pos
			self:set_team_mark(i,mate_pos)
		else
			self:set_team_mark(i)
		end
	end
end

--更新
function MapView:on_update(dt)
	if self.init then
		self:update_mapinfo()
		--更新寻路
		if self.item_obj.on_pathfinding and not self.path then
			self:auto_move_start()
		end
	end
	--更新怪物和其他玩家

	-- 测试
	if DEBUG and self.mapdata then
		local map_pos = self.mapdata.map_pos
		local scene_pos = self.mapdata.scene_pos

		if not scene_pos or #scene_pos%8~=0 or not map_pos or #map_pos%8~=0 then
			print("<color=red>江山请注意 地图id =",self.mapdata.mapId,"可能配置错误",scene_pos and #scene_pos,map_pos and #map_pos,"</color>")
			if not scene_pos or #scene_pos%8~=0 then
				print("<color=red>场景坐标有问题","</color>")
			end
			if not map_pos or #map_pos%8~=0 then
				print("<color=red>地图坐标有问题","</color>")
			end
			return
		end

		for i=1,#scene_pos/8 do
			local idx = (i-1)*8

			local color = gf_get_color2(gf_get_color_by_quality(i))

			local pos1_x = scene_pos[idx+1]/10
			local pos1_y = scene_pos[idx+2]/10
			local pos2_x = scene_pos[idx+3]/10
			local pos2_y = scene_pos[idx+4]/10
			local pos3_x = scene_pos[idx+5]/10
			local pos3_y = scene_pos[idx+6]/10
			local pos4_x = scene_pos[idx+7]/10
			local pos4_y = scene_pos[idx+8]/10

			Debug.DrawLine(Vector3(pos1_x,50,pos1_y),Vector3(pos2_x,50,pos2_y),color)
			Debug.DrawLine(Vector3(pos2_x,50,pos2_y),Vector3(pos3_x,50,pos3_y),color)
			Debug.DrawLine(Vector3(pos3_x,50,pos3_y),Vector3(pos4_x,50,pos4_y),color)
			Debug.DrawLine(Vector3(pos4_x,50,pos4_y),Vector3(pos1_x,50,pos1_y),color)

			local pos1_x = map_pos[idx+1]
			local pos1_y = map_pos[idx+2]
			local pos2_x = map_pos[idx+3]
			local pos2_y = map_pos[idx+4]
			local pos3_x = map_pos[idx+5]
			local pos3_y = map_pos[idx+6]
			local pos4_x = map_pos[idx+7]
			local pos4_y = map_pos[idx+8]

			Debug.DrawLine(Vector3(136+pos1_x,78.04+pos1_y,10),Vector3(136+pos2_x,78.04+pos2_y,10),color)
			Debug.DrawLine(Vector3(136+pos2_x,78.04+pos2_y,10),Vector3(136+pos3_x,78.04+pos3_y,10),color)
			Debug.DrawLine(Vector3(136+pos3_x,78.04+pos3_y,10),Vector3(136+pos4_x,78.04+pos4_y,10),color)
			Debug.DrawLine(Vector3(136+pos4_x,78.04+pos4_y,10),Vector3(136+pos1_x,78.04+pos1_y,10),color)

			-- print(idx+1,"条线",color)
		end
	end
end
--开始寻路
function MapView:auto_move_start()
	local path = self:cur_path_pos(self.item_obj:get_path(),10)
	self.path = {}
	for i,v in ipairs(path) do
		local map_object_type = Enum.MAP_OBJECT_TYPE.PATH_POINT
		self.path[i] = self:set_mark(Vector2(v.x,v.z),map_object_type,i)
	end
	

	local update_path = function()
		self:update_drwa_point()
	end
	self.path_timer = Schedule(update_path,0.5)
end

--结束寻路
function MapView:auto_move_end()
	if self.path_timer then
		self.path_timer:stop()
	end
	self:clear_mark(Enum.MAP_OBJECT_TYPE.PATH_POINT)
	self.path = nil
end

--更新寻路
function MapView:update_drwa_point()
	if not self.item_obj.on_pathfinding and self.path then
		-- print("结束寻路")
		self:auto_move_end()
		return
	end

	--判断距离自己最近的点，如果小于20，则删除此点之前所有点
	local myPos = self.tf_player_mark.position
	local minPos = nil
	local index = 0
	for k,v in pairs(self.path) do
		if not minPos then
			minPos = v
			index = k
		else
			if Vector3.Distance(myPos,v.transform.position) < Vector3.Distance(myPos,minPos.transform.position) then
				minPos = v
				index = k
			end
		end
	end
	if minPos then
		-- print("最近的点距离我",Vector3.Distance(myPos,minPos.transform.position))
	else
		-- print("没有最近的点？")
	end
	if minPos and Vector3.Distance(myPos,minPos.transform.position) < 20 then
		local map_object_type = MapUserData:get_obj_key_name(Enum.MAP_OBJECT_TYPE.PATH_POINT)
		for i=1,index do
			local v = self.path[i]
			if v then
				v:SetActive(false)
				self.path[i] = nil
			end
		end
	end
end
--计算匀称路径点
function MapView:cur_path_pos(path,dis)
	local r={}
	local dis = dis or 10
	for i=1,#path do
		if #r<=0 then
			r[#r+1]=path[i]
		else
			while Vector3.Distance(r[#r],path[i])>dis do
				r[#r+1]=r[#r]+(path[i]-r[#r]).normalized*dis
			end
		end
	end
	return r
end

function MapView:set_visible_state()
	local is_show = gf_get_mainui_show_state(ServerEnum.MAINUI_UI_MODLE.MAP)
	print("gf_get_mainui_show_state is_show:",is_show)
	self:set_visible(is_show or false)
end

function MapView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.FinishScene and self.init then --加载场景完成时
        self:set_map()
        self:set_visible_state()
    elseif id1 == ClientProto.OnStopAutoMove then -- 被通知需要终止寻路了
		self:auto_move_end()
    end

end

function MapView:on_click(item_obj,obj,arg)
 	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	print("点击小地图",obj)
	if cmd == "map_mark" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- View("bigMap",self.item_obj)
		require("models.map.bigMap")(self.item_obj)
	end
end

function MapView:get_item(key,obj,root)
    -- print("获取item",key,obj,root)
    if not self.itemCache then self.itemCache = {} end
    if not self.itemCache[key] then self.itemCache[key] = {} end
    local item = self.itemCache[key][1]
    if item then
        table.remove(self.itemCache[key],1)
    else
        item = LuaHelper.Instantiate(obj)
    end
    item:SetActive(true)
    item.transform:SetParent(root.transform)
    return item
end

function MapView:repay_item(key,item)
    item:SetActive(false)
    item.transform:SetParent(self.root.transform)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

-- 释放资源
function MapView:dispose()
	self:clear_mark()
	self.team_mark_list = nil
	self.init = nil
    self:cancel_register()
    self.mark_cache = nil
    self.itemCache = nil
    self._base.dispose(self)
 end

function MapView:register()
	print("注册小地图")
	self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
	gf_register_update(self) --注册每帧事件
end

function MapView:cancel_register()
	print("取消注册小地图")
	self.item_obj:register_event(self.item_obj.event_name, nil)
	gf_remove_update(self) --注销每帧事件
end

return MapView

