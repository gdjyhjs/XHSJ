--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-22 11:23:02
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Vector2 = UnityEngine.Vector2
local Input = UnityEngine.Input
local Screen = UnityEngine.Screen
local Enum = require("enum.enum")
local MapUserData = require("models.map.mapUserData")

local BigMap=class(UIBase,function(self,item_obj,ui)
	print("地图地图地图地图地图地图地图地图地图地图")
	self:set_bg_visible( true )
	UIBase._ctor(self, "map.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj=item_obj
    self.ui = ui
end)

-- 资源加载完成
function BigMap:on_asset_load(key,asset)
	self.map_path_dis = ConfigMgr:get_config("t_misc").map_path_dis
	-- if self.go_world_map then self.go_world_map:SetActive(false) end
	print("注册场景地图事件")
	gf_register_update(self)--Update事件
	StateManager:register_view( self )
    
	print("地图资源加载完成")
	self:init_ui()
	self.init = true

end

--ui初始化
function BigMap:init_ui()
	self.npcListRoot = self.refer:Get("npcBtnRoot")
	self.npcBtn = self.refer:Get("npcBtn")
	-- print("获取大地图图片")
	self.img_big_map=self.refer:Get("img_big_map")
	--获取大地图tf
	self.tf_big_map=self.img_big_map.transform
	--获取大地图玩家图片
	self.tf_player_mark=self.refer:Get("player_mark")
	--获取地图名字文本
	self.map_name=self.refer:Get("map_name")

	self.path_ico=self.refer:Get("path_ico")
	self.path_end_eff=self.refer:Get("path_end_eff")

	self:set_map()

	self.init = true
end

function BigMap:set_team_mark(idx,pos)
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

function BigMap:init_npc_list()
	local nb = self.refer:Get("def_open_npcBtn")
	LuaHelper.eventSystemCurrentSelectedGameObject = nb.gameObject
	nb.isOn = true
end

--初始化设置大地图
function BigMap:set_map()
	self:clear_mark()
	self.mapdata = self.item_obj.mapdata
	self.mapId = self.mapdata.mapId
	local set_map = function(ref)
		--初始化地图名字
		self.map_name.text=self.mapdata.name
	    --设置NPC和传送阵
	    local data = ConfigMgr:get_config("map.mapMonsters")[self.mapdata.mapId]
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.NPC] or {}) do
	    	local data = ConfigMgr:get_config("npc")[v.code]
	    	if data.touch~=0 then --是可以对话的npc，不是装饰品，才要显示在地图
	    		local item = self:set_mark(Vector2(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.NPC,i)
	    		-- item:GetComponentInChildren("UnityEngine.UI.Text").text = data.name --设置名称
				item.name = string.format("npcBtn_%d_%d_%d_%s",v.pos.x,v.pos.y,v.code,data.name)
	    	end
	    end
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.TRANPORT] or {}) do
	    	local item = self:set_mark(Vector3(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.TRANPORT,i)
	    	item.name = string.format("传送阵_%d_%d_%d",v.pos.x,v.pos.y,v.code)
	    end
	    for i,v in ipairs(data[Enum.MAP_OBJECT_TYPE.CREATURE_CENTER] or {}) do
	    	gf_print_table(v,i..":怪物中心点")
	    	local d = ConfigMgr:get_config("creature")[v.code]
			if bit._and(d.map_show,ClientEnum.CENTER_MAP_SHOW_TYPE.MAP) == ClientEnum.CENTER_MAP_SHOW_TYPE.MAP then
		    	local item = self:set_mark(Vector3(v.pos.x/10,v.pos.y/10),Enum.MAP_OBJECT_TYPE.CREATURE_CENTER,i)
		    	item.name = string.format("creatureCenter_%d_%d",v.pos.x,v.pos.y)
		    	item:GetComponent("UnityEngine.UI.Text").text = string.format("%s(%d级)",d.name,d.level)
		    	local icon = item:GetComponentInChildren(UnityEngine_UI_Image)
		    	local fn = function()
		    			icon:SetNativeSize()
		    		end
		    	local icon_name = (d.type == ServerEnum.CREATURE_TYPE.BOSS or d.type == ServerEnum.CREATURE_TYPE.WORLD_BOSS and "img_monster_local") or "img_main_map_loca3"
		    	gf_setImageTexture(icon,icon_name,fn)
		    end
	    end
	end
	-- Loader:get_resource(self.mapdata.fileName..".u3d",nil,"UnityEngine.Sprite", set_map)
	gf_setImageTexture(self.img_big_map, self.mapdata.fileName, set_map)

	self:init_npc_list()
end

--场景坐标转地图坐标
function BigMap:scenepos2bigmappos(scenepos)
	-- print("计算场景坐标转地图坐标",scenepos)
	-- if not self.ui.data_pos or #self.ui.data_pos<2 then
	-- 	return Vector2(0,0)
	-- end

	-- local scene_pos = Vector2(scenepos.x,scenepos.z)
	-- -- 取到最近的2个参照点
	-- local pos = {}
	-- for i,v in ipairs(self.ui.data_pos) do
	-- 	pos[#pos+1] = {v,Vector2.Distance(scene_pos,v.scene_pos)}
	-- end
	-- table.sort(pos,function(a,b) return a[2]<b[2] end)
	-- -- 取2个点构成一个三角形 保证前2个点不在同一条线上
	-- while(math.abs((pos[2][1].scene_pos.y-pos[1][1].scene_pos.y))<1 or math.abs(pos[2][1].scene_pos.x-pos[1][1].scene_pos.x)<1)do
	-- 	table.remove(pos,2)
	-- 	if #pos <2 then
	-- 		return
	-- 	end
	-- end
	-- local move_vector = scene_pos - pos[1][1].scene_pos -- 相对于点1的移动向量
	-- move_vector = Vector2(move_vector.x*(math.abs(pos[1][1].map_pos.x - pos[2][1].map_pos.x)/math.abs(pos[1][1].scene_pos.x - pos[2][1].scene_pos.x)),move_vector.y*(math.abs(pos[1][1].map_pos.y-pos[2][1].map_pos.y)/math.abs(pos[1][1].scene_pos.y-pos[2][1].scene_pos.y)))

	-- return (pos[1][1].map_pos+move_vector)
	return self.item_obj:scenepos2mappos(scenepos)
end

--地图坐标转场景坐标
function BigMap:bigmappos2scenepos(bigmappos)
	-- if not self.ui.data_pos or #self.ui.data_pos<2 then
	-- 	return Vector2(0,0)
	-- end
	-- -- 取到最近的2个参照点
	-- local pos = {}
	-- for i,v in ipairs(self.ui.data_pos) do
	-- 	pos[#pos+1] = {v,Vector2.Distance(bigmappos,v.scene_pos)}
	-- end
	-- table.sort(pos,function(a,b) return a[2]<b[2] end)
	-- -- 取2个点构成一个三角形 保证前2个点不在同一条线上
	-- while(math.abs((pos[2][1].scene_pos.y-pos[1][1].scene_pos.y))<1 or math.abs(pos[2][1].scene_pos.x-pos[1][1].scene_pos.x)<1)do
	-- 	table.remove(pos,2)
	-- 	if #pos <2 then
	-- 		return
	-- 	end
	-- end
	-- local move_vector = bigmappos - pos[1][1].map_pos -- 相对于点1的移动向量
	-- move_vector = Vector2(move_vector.x/(math.abs(pos[1][1].map_pos.x - pos[2][1].map_pos.x)/math.abs(pos[1][1].scene_pos.x - pos[2][1].scene_pos.x)),move_vector.y/(math.abs(pos[1][1].map_pos.y-pos[2][1].map_pos.y)/math.abs(pos[1][1].scene_pos.y-pos[2][1].scene_pos.y)))
	-- move_vector = pos[1][1].scene_pos + move_vector
	-- move_vector = Vector3(move_vector.x,0,move_vector.y)
	-- return move_vector
	return self.item_obj:mappos2scenepos(bigmappos)
end

--设置一个标志
function BigMap:set_mark(pos,map_object_type,key)
	-- 建立保存地图标志的缓存
	if not self.mark_cache then
		self.mark_cache = {}
	end
	if not self.mark_cache[map_object_type] then
		self.mark_cache[map_object_type] = {}
	end
	--获取标志  -- 取对象名
	-- print(map_object_type)
	local obj_name = MapUserData:get_obj_key_name(map_object_type)
	-- print(obj_name)
	local item = self:get_item(obj_name,self.refer:Get(obj_name),self.tf_big_map.gameObject) --获取对象
	item.transform.localPosition = self:scenepos2bigmappos(Vector3(pos.x,0,pos.y)) --设置位置
	key = key or #self.mark_cache[map_object_type]+1
	self.mark_cache[map_object_type][key] = item

	return item
end

--清空标志 无参数为清空所有，有参数则清对应类型全部或对应类型一个
function BigMap:clear_mark(map_object_type,key)
	if not self.mark_cache then return end
	if map_object_type and self.mark_cache[map_object_type]  then
		 -- 取对象名
		local obj_name =  MapUserData:get_obj_key_name(map_object_type)
		if key and self.mark_cache[map_object_type][key] then
			-- print("清空标志",map_object_type,key)
			self:repay_item(obj_name,self.mark_cache[map_object_type][key])
			self.mark_cache[map_object_type][key] = nil
		elseif self.mark_cache[map_object_type] then
			-- print("清空一组标志",map_object_type)
			for k,v in pairs(self.mark_cache[map_object_type]) do
				self:repay_item(obj_name,v)
			end
			self.mark_cache[map_object_type] = {}
		end
	elseif not map_object_type and not key then
		-- print("清空全部标志")
		for kk,vv in pairs(self.mark_cache) do
			 -- 取对象名
			local obj_name = MapUserData:get_obj_key_name(kk)
			-- print(obj_name)
			for k,v in pairs(vv) do
				-- print(v)
				self:repay_item(obj_name,v)
			end
			self.mark_cache = {}
		end
	end
end

function BigMap:on_click( obj, arg)
	local cmd=obj.name
	print("点击了大地图",cmd)
	if(cmd=="cancleBtn")then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		--关闭大地图
		self.item_obj.open=false
		self:exit_bigmap()
	elseif string.find(cmd,"npcBtn_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- print(arg)
		local s = string.split(cmd,"_")
		local x = s[2]
		local y = s[3]
		self.item_obj:move_to_point(Vector3(x/10,0,y/10))
		-- if not Seven.PublicFun.IsNull(arg) then
			-- self.selectNpcBtnIng = arg
			-- arg.material = nil
		-- end
	elseif(cmd=="toWorldBtn")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--进入世界地图
		self:hide()
		-- View("worldMap",self.item_obj)
		require("models.map.worldMap")(self.item_obj)
		
	elseif(cmd=="img_big_map")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--点了大地图上的某个点
		self:onclick_bigmap()
	elseif string.find(cmd,"creatureCenter_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local s = string.split(cmd,"_")
		local x = s[2]
		local y = s[3]
		local fn = function()
				Net:receive(true, ClientProto.AutoAtk)
			end
		self.item_obj:move_to_point(Vector3(x/10,0,y/10),nil,fn)
	elseif string.find(cmd,"mapObjectBtn_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- 选择了怪物/npc页签
		local isOn = arg.isOn
		arg:GetComponentInChildren("UnityEngine.UI.Text").color = gf_get_color2(gf_get_text_color(isOn and ClientEnum.SET_GM_COLOR.INTERFACE_SELECT or ClientEnum.SET_GM_COLOR.INTERFACE_UNSELECT))
		if isOn then
			self:set_npc_btn(tonumber(string.split(cmd,"_")[2]))
		end
	elseif string.find(cmd,"changeScene_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
		local mapId = tonumber(string.split(cmd,"_")[2])
		local mapinfo = ConfigMgr:get_config( "mapinfo" )[mapId]
		print("地图坐标",mapId,mapinfo.delivery_posx,mapinfo.delivery_posy)
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(mapId,mapinfo.delivery_posx,mapinfo.delivery_posy,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	end
end

--设置npc按钮
function BigMap:set_npc_btn(map_object_type)
	-- if not self.npc_btn_list then
	-- 	self.npc_btn_list={
	-- 		root = self.refer:Get("npcBtnRoot"),
	-- 		sample = self.refer:Get("npcBtn"),
	-- 	}
	-- end
	-- print("设置npc按钮 清空原有项")
	for i=self.npcListRoot.transform.childCount-1,0,-1 do
		self:repay_item("npcBtn",self.npcListRoot.transform:GetChild(i).gameObject)
	end

	local mapId = LuaItemManager:get_item_obejct("game"):getRoleInfo().mapId
	-- print("设置npc按钮 地图id ",mapId)
	local list = ConfigMgr:get_config("map.mapMonsters")[mapId][map_object_type] or {}

	local set_item = function(item,text,name)
		item:GetComponentInChildren("UnityEngine.UI.Text").text = gf_remove_rich_text(text)
		item.name = name
		-- print("设置npc按钮",item,text,name)
	end
	-- print("设置npc按钮 设置的项 个数",#list)
	for i,v in ipairs(list) do
		if map_object_type == Enum.MAP_OBJECT_TYPE.CREATURE_CENTER then

			local d = ConfigMgr:get_config("creature")[v.code]
			if bit._and(d.map_show,ClientEnum.CENTER_MAP_SHOW_TYPE.MAP) == ClientEnum.CENTER_MAP_SHOW_TYPE.MAP then
				local item = self:get_item("npcBtn",self.npcBtn,self.npcListRoot)
				set_item(item,string.format("%s(%d级)",d.name,d.level),string.format("creatureCenter_%d_%d",v.pos.x,v.pos.y))
			elseif bit._and(d.map_show,ClientEnum.CENTER_MAP_SHOW_TYPE.LIST) == ClientEnum.CENTER_MAP_SHOW_TYPE.LIST then
				local item = self:get_item("npcBtn",self.npcBtn,self.npcListRoot)
				set_item(item,string.format("%s(%d级)",d.name,d.level),string.format("npcBtn_%d_%d",v.pos.x,v.pos.y))
			end
		elseif map_object_type == Enum.MAP_OBJECT_TYPE.NPC and ConfigMgr:get_config("npc")[v.code].touch~=0 then
			local item = self:get_item("npcBtn",self.npcBtn,self.npcListRoot)
			set_item(item,ConfigMgr:get_config("npc")[v.code].name,string.format("npcBtn_%d_%d",v.pos.x,v.pos.y))
		end
	end

	self.refer:Get("npcBtnScroll").verticalNormalizedPosition = 1
end

function BigMap:onclick_bigmap()
	local target_point = self:get_mouse_onclick_pos_in_bigmap()
	-- print("点击地图的位置",target_point)
	target_point=self:bigmappos2scenepos(target_point)
	if target_point then
		-- print("--开启自动寻路字样")
		self.item_obj:move_to_point(target_point)
	end
end

function BigMap:get_mouse_onclick_pos_in_bigmap()
	local on_click_pos = Input.mousePosition
	-- print("点击屏幕的点",on_click_pos)
	on_click_pos = on_click_pos - self.tf_big_map.position
	-- print("点击屏幕运算之后的点",on_click_pos)
	on_click_pos = Vector2(on_click_pos.x/self.root.transform.localScale.x,on_click_pos.y/self.root.transform.localScale.y)
	-- print("点击屏幕最终的点",on_click_pos)
	return Vector2(on_click_pos.x,on_click_pos.y)
	-- return (Input.mousePosition - Vector3 (Screen.width / 2, Screen.height / 2, 0))*(720/Screen.height) - self.tf_big_map.position;
end

function BigMap:exit_bigmap()
	self:hide()
end

function BigMap:on_update()
	if self.init then
		-- 更新大地图
		self:update_bigmap_position()
		--更新寻路
		if self.item_obj.on_pathfinding and not self.path then
			self:auto_move_start()
		end
	end
end

--结束寻路
function BigMap:auto_move_end()
	if self.path_timer then
		self.path_timer:stop()
	end
	self:clear_mark(Enum.MAP_OBJECT_TYPE.PATH_POINT)
	self.path = nil
	if self.init then
		self.path_end_eff:SetActive(false)
	end
end

--开始寻路
function BigMap:auto_move_start()
	local p = self.item_obj:get_path()
	local path = self:cur_path_pos(p,self.map_path_dis)
	self.path = {}
	for i,v in ipairs(path) do
		local map_object_type = Enum.MAP_OBJECT_TYPE.PATH_POINT
		self.path[i] = self:set_mark(Vector2(v.x,v.z),map_object_type,i)
	end
	self:update_drwa_point()
	

	local update_path = function()
		self:update_drwa_point()
	end
	self.path_timer = Schedule(update_path,0.5)

	local end_pos = p[#p]
	if end_pos then
		self.path_end_eff:SetActive(true)
		self.path_end_eff.transform.localPosition = self.item_obj:scenepos2mappos(p[#p])
	end
end

--更新寻路
function BigMap:update_drwa_point()
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
	if minPos then
		local map_object_type = MapUserData:get_obj_key_name(Enum.MAP_OBJECT_TYPE.PATH_POINT)
		for i=1,Vector3.Distance(myPos,minPos.transform.position) < 20 and index or index-1 do
			local v = self.path[i]
			if v then
				v:SetActive(false)
				self.path[i] = nil
			end
		end
	end
end
--计算匀称路径点
function BigMap:cur_path_pos(path,dis)
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

--更新大地图
function BigMap:update_bigmap_position()
	--玩家朝向
	self.tf_player_mark.eulerAngles=Vector3(0,0,-self.item_obj:get_player_dir().y)
	-- print("打印位置----自己",self.item_obj:get_player_pos(),self:scenepos2bigmappos(self.item_obj:get_player_pos()))
	--玩家位置
	self.tf_player_mark.localPosition=self:scenepos2bigmappos(self.item_obj:get_player_pos())

	local team_info = LuaItemManager:get_item_obejct("team"):getTeamData()
	local members = team_info and team_info.members or {}
	local max_player = ConfigMgr:get_config("game_const").team_member_count.value
	local my_player_id = LuaItemManager:get_item_obejct("game"):getId()
	local my_map_id = LuaItemManager:get_item_obejct("game"):get_map_id()
	for i=1,max_player do
		local mate = members[i]
		if mate and mate.roleId ~= my_player_id and mate.mapId==my_map_id then
			-- print("打印位置---队友"..i,Vector3(mate.posX/10,0,mate.posY/10),self:scenepos2bigmappos(Vector3(mate.posX/10,0,mate.posY/10)))
			self:set_team_mark(i,self:scenepos2bigmappos(Vector3(mate.posX/10,0,mate.posY/10)))
		else
			self:set_team_mark(i)
		end
	end
end

--每次显示调用
function BigMap:on_showed()

	if self.init then
		if self.mapId == LuaItemManager:get_item_obejct("game"):getRoleInfo().mapId then
			self:init_npc_list()
		else
			self:set_map()
		end
	end
end

-- 释放资源
function BigMap:dispose()
	local map_object_type = MapUserData:get_obj_key_name(Enum.MAP_OBJECT_TYPE.PATH_POINT)
	self:clear_mark(map_object_type)
	self.team_mark_list = nil
	self.init = nil
	self:auto_move_end() --隐藏界面时不绘制寻路图标
    -- self.item_obj:register_event("map_view_on_click", nil)
    gf_remove_update(self)
	StateManager:remove_register_view( self )
    self.itemCache = nil
    self._base.dispose(self)
end

function BigMap:on_hided()
	-- if self.path then
	-- 	self:auto_move_end() --隐藏界面时不绘制寻路图标
	-- end

	if self.init then
		local nb = self.refer:Get("def_open_npcBtn")
		local g = nb:GetComponentInParent("UnityEngine.UI.ToggleGroup")
		-- print("组",g)
		if g then
			g:SetAllTogglesOff()
		end
	end

	-- gf_remove_update(self)
	-- StateManager:remove_register_view( self )
	self:dispose()
end

function BigMap:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.OnStopAutoMove then -- 被通知需要终止寻路了
		self:auto_move_end()
	elseif id1 == ClientProto.FinishScene then --加载场景完成时
        -- self:set_map()
        self:hide()
	end
end

function BigMap:get_item(key,obj,root)
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
    item.transform:SetParent(root.transform,false)
    return item
end

function BigMap:repay_item(key,item)
	if not self.itemCache then self.itemCache = {} end
	if not self.itemCache[key] then self.itemCache[key] = {} end
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

return BigMap