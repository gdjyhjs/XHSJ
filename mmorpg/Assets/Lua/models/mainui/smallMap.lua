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

local SmallMap = class(function ( self, ui, item_obj )
	self.ui = ui
	self.refer = ui.refer
	self.item_obj = item_obj
	self:init()
end)

function SmallMap:init()

	local ref = self.refer:Get("small_map")
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
	self.map:minmap(self.tf_min_map)

	self.player = nil

	--初始化地图
	self:set_map()	
end

--初始化小地图
function SmallMap:set_map()
	print("设置主界面小地图")
	self:clear_mark()
	local mapId = LuaItemManager:get_item_obejct("game"):getRoleInfo().mapId
	self.mapdata = ConfigMgr:get_config("mapinfo")[mapId]
	local set_map = function(ref)
		--初始化小地图
		self.img_min_map.sprite=ref.data	--设置精灵
		--初始化图片大小
		self.img_min_map:SetNativeSize()
		--初始化图片位置
		self.tf_min_map.localPosition=Vector2(self.tf_min_map.sizeDelta.x/2,self.tf_min_map.sizeDelta.y/2)
		--初始化地图名字
		self.text_scene_name.text=self.mapdata.name
		--初始化地图坐标文本
	    self.text_position.text="0,0"
	    --设置NPC和传送阵
	    local data = ConfigMgr:get_config("map.mapMonsters")[mapId]
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.NPC] or {}) do
	    	local data = ConfigMgr:get_config("npc")[v.code]
	    	if data.touch~=0 then
	    		self:set_mark(Vector2(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.NPC,nil,data.name)
	    	end
	    end
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.TRANPORT] or {}) do
	    	self:set_mark(Vector2(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.TRANPORT)
	    end
	end
	Loader:get_resource(self.mapdata.fileName..".u3d",nil,"UnityEngine.Sprite", set_map)
end

--设置一个标志
function SmallMap:set_mark(pos,map_object_type,mark,name)
		-- 建立保存地图标志的缓存
	if not self.mark then
		self.mark = { [Enum.MAP_OBJECT_TYPE.TRANPORT] = {use={},nouse={}} , 
					[Enum.MAP_OBJECT_TYPE.NPC] = {use={},nouse={}} , 
					[Enum.MAP_OBJECT_TYPE.CREATURE] = {use={},nouse={}}}
	end

	local i =  #self.mark[map_object_type].nouse
	local k = mark or #self.mark[map_object_type].use + 1
	if #self.mark[map_object_type].nouse>0 then
		self.mark[map_object_type].use[k] = self.mark[map_object_type].nouse[i]
		table.remove(self.mark[map_object_type].nouse,i)
	else
		if map_object_type == Enum.MAP_OBJECT_TYPE.NPC then
			self.mark[map_object_type].use[k] = LuaHelper.Instantiate(self.refer:Get("npc_mark"))
			self.mark[map_object_type].use[k].transform:SetParent(self.tf_min_map)
		elseif map_object_type == Enum.MAP_OBJECT_TYPE.TRANPORT then
			self.mark[map_object_type].use[k] = LuaHelper.Instantiate(self.refer:Get("trad_mark"))
			self.mark[map_object_type].use[k].transform:SetParent(self.tf_min_map)
		elseif map_object_type == Enum.MAP_OBJECT_TYPE.CREATURE then
			self.mark[map_object_type].use[k] = LuaHelper.Instantiate(self.refer:Get("creature_mark"))
			self.mark[map_object_type].use[k].transform:SetParent(self.tf_min_map)
		end
	end
	if self.mark[map_object_type].use[k] then
		local p = self:scenepos2mimmappos(Vector3(pos.x,0,pos.y))
		self.mark[map_object_type].use[k].transform.localPosition = p
		if map_object_type == Enum.MAP_OBJECT_TYPE.NPC then --设置名称
			self.mark[map_object_type].use[k]:GetComponentInChildren("UnityEngine.UI.Text").text = name
		end
	end
	return self.mark[map_object_type].use[k]
end

--清空标志 无参数为清空所有，有参数则清对应类型全部或对应类型一个
function SmallMap:clear_mark(map_object_type,mark)
	if not self.mark then
		return
	end
	if map_object_type and mark then
		if self.mark[map_object_type].use[k] then
			local go = self.mark[map_object_type].use[k]
			go:SetActive(false)
			self.mark[map_object_type].nouse[#self.mark[map_object_type].nouse+1] = go
			self.mark[map_object_type].use[k] = nil
		end
	elseif map_object_type then
		for k,v in pairs(self.mark[map_object_type].use) do
			v:SetActive(false)
			self.mark[map_object_type].nouse[#self.mark[map_object_type].nouse+1] = v
		end
		self.mark[map_object_type].use = {}
	else
		for tp,tt in pairs(self.mark) do
			for k,v in pairs(tt.use) do
				v:SetActive(false)
				tt.nouse[#tt.nouse+1] = v
			end
			tt.use = {}
		end
	end
end

--更新
function SmallMap:main_on_update(dt)
	--更新玩家和小地图
	if not self.player or Seven.PublicFun.IsNull(self.player.transform) or not self.player:is_move() then
		return
	end

	self:update_mapinfo(self.player.transform)
	--更新怪物和其他玩家
end

function SmallMap:scenepos2mimmappos(scenepos)
	local x = scenepos.x - self.mapdata.map_left_pos
	local y = scenepos.z - self.mapdata.map_bottom_pos
	local width = self.mapdata.map_right_pos - self.mapdata.map_left_pos
	local height = self.mapdata.map_top_pos - self.mapdata.map_bottom_pos
	x = x / width * self.tf_min_map.sizeDelta.x
	y = y / height * self.tf_min_map.sizeDelta.y
	return Vector2(x,y)
end

--更新地图信息
function SmallMap:update_mapinfo(tf)

	--玩家朝向
	self.tf_player_mark.eulerAngles=Vector3(0,0,-tf.eulerAngles.y)
	--设置小地图位置
	self.tf_min_map.localPosition = -self:scenepos2mimmappos(tf.position)
	--设置坐标文本
	self.text_position.text=string.format("%d,%d",tf.position.x,tf.position.z)
	--路径点
	--self:update_navigation_path()
	-- print(self.map.tf_player.position)
	-- print(-point)
end

function SmallMap:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.FinishScene then
        self:set_map()

    elseif id1 == ClientProto.PlayerLoaderFinish then
		self.player = msg
		self:update_mapinfo(self.player.transform)
		
    end
end

return SmallMap
