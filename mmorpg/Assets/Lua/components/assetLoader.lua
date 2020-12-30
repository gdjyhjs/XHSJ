------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------
--Gameobject 资源集合
local RuntimePlatform = UnityEngine.RuntimePlatform
local Application = UnityEngine.Application
local Object = UnityEngine.Object
local LuaHelper = LuaHelper
local LogicHelper = Hugula.LogicHelper
local GAMEOBJECT_ATLAS = GAMEOBJECT_ATLAS
local CUtils = CUtils
local AssetBundleScene = AssetBundleScene
local CRequest = Hugula.Loader.CRequest --内存池
local UIJoint = UIJoint
local UIParentJoint = UIParentJoint

local Loader = Loader
local Asset = Asset
local StateManager = StateManager
local send_message = send_message
local delay = delay

local UICamera -- ui相机
local UIParent = LuaHelper.Find("UI").transform

local AssetLoader=class(function(self,lua_obj)
	self.lua_obj=lua_obj
	self.assets = nil
	self.enable = true
	self._load_count = 0
	self._load_curr = 0
end)


function AssetLoader:create_request(v,on_req_loaded,on_err)
	local req
	if v:is_a(AssetScene) then
		 req = CRequest.Create(v.assetbundle_url,v.asset_name,AssetBundleScene,on_req_loaded,on_err,v,Loader.default_async)
		 if v.is_additive == true then req.isAdditive = true end
	else
		-- print("create request..........",v.asset_name)
		req = CRequest.Create(v.assetbundle_url,v.asset_name,Object,on_req_loaded,on_err,v,Loader.default_async)
	end
	return req
end

-- 初始化画布
function AssetLoader:init_canvas_sort(asset)

	if not UICamera then
		UICamera = LuaHelper.GetComponent(UnityEngine.GameObject.Find("UICamera"),"UnityEngine.Camera")
	end

	if asset:is_a(Asset) then
		--找到所有画布
	    local canvas_array = LuaHelper.GetComponentsInChildren(asset.root, "UnityEngine.Canvas")
	    --设置看向相机
	    for i=1,#canvas_array do
	    	local canvas = canvas_array[i]
	  --       canvas.overrideSorting = true
			-- canvas.sortingOrder = self.lua_obj.priority
			canvas.worldCamera = UICamera
	    end
	end
end

function AssetLoader:on_asset_loaded(key,asset)

	if StateManager:get_state_transform():is_visible() and (self.lua_obj.assets and #self.lua_obj.assets > 0 and self.lua_obj.assets[1].key == asset.key) then
		Net:receive(nil, ClientProto.PoolFinishLoadedOne)
	end

	self.assets[key]=asset
	self._load_curr=self._load_curr+1
    -- self:init_canvas_sort(asset)
    asset:show()

	-- 判断是否需要隐藏，如果父亲已经隐藏
	-- print("UI加载完成 url",asset.url)
	-- print("UI加载完成 dispose",asset.is_dispose)
	
	self.lua_obj:send_message("on_asset_load",key,asset)

	send_message(asset,"on_loaded",key,asset) -- 这个只是在asset基类使用
	if not asset.is_dispose then
		send_message(asset,"on_asset_load",key,asset)
	end

	-- print(string.format("AssetLoader.name=%s  _load_count %s _load_curr %s ,key %s",self.lua_obj.name,self._load_count,self._load_curr,key))
	if self._load_curr >= self._load_count then
		self.lua_obj.is_loading = nil
		self.lua_obj.is_call_assets_loaded = true
		self.lua_obj:send_message("on_assets_load",self.assets)

		local call_showed = function()
			if not self.lua_obj.is_on_blur then
				self.lua_obj:send_message("on_showed")
				self.lua_obj:call_event("on_showed")
			else
				self.lua_obj:auto_mark_dispose() --标记回收
			end
			-- print("on_showed (",lua_obj,") delta time = ",os.clock()-lua_obj._start_time,Time.frameCount)
			if StateManager:is_in_current_state(self.lua_obj) and StateManager:get_current_state():is_all_loaded() then
				StateManager:call_all_item_method()
			end
		end
			
		delay(call_showed,0.01)	
	end

	if self.is_on_blur then 
		asset:hide()
	end

	-- LuaItemManager:get_item_obejct("guide"):show_hightlight(asset)
end

function AssetLoader:on_asset_loaded_error(key,asset)
	_gf_loading_res_list[key] = nil
	
	self.assets[key]=asset
	self._load_curr=self._load_curr+1
	if self._load_curr >= self._load_count then
		self.lua_obj.is_loading = nil
		self.lua_obj:send_message("on_assets_load",self.assets)
		
		if not self.is_on_blur then 
			self.lua_obj:send_message("on_showed")
			self.lua_obj:call_event("on_showed")
		end

		if StateManager:is_in_current_state(self.lua_obj) and StateManager:get_current_state():is_all_loaded() then 
			StateManager:call_all_item_method()
		end 
	end
end

function AssetLoader:load_assets(assets, on_complete, on_progress)
	-- self.lua_obj.is_loading = true

	local req = nil
	local reqs = {}
	local url = "" local key=""
	local asset = nil

	local on_req_loaded=function(req)
		local ass = req.head
		local key = ass.key 

		local waiting_list = _gf_loading_res_list[key]
		_gf_loading_res_list[key] = nil

		if ass:is_a(Asset) then

			local main=req.data 
			local root=LuaHelper.Instantiate(main)
			root.name=main.name

			ass.root=root
			ass.refer = LuaHelper.GetComponent(root,"Hugula.ReferGameObjects") 
			-- 把所有的ui全部放到begin场景先的UI
			ass.root.transform.parent = UIParent

			-- 把加载的资源文件的孩子全部放到Asset的items列表里
			-- local eachFn =function(i,obj)
			-- 	ass.items[obj.name]=obj
			-- end
			-- LuaHelper.ForeachChild(root,eachFn)

			gf_game_object_atlas[key] = ass

		else
			-- 场景加载
			ass.root = ass
			Seven.SceneMgr.SetActiveScene(ass.asset_name)
		end

		local function delay_func()
			-- 预加载
			if ass:is_preload() then
				if not waiting_list or #waiting_list <= 0 then
					ass:hide()
				end
			else
				self:on_asset_loaded(key,ass)
			end

			-- 处理等待列表
			if waiting_list and #waiting_list > 0 then
				for k,v in pairs(waiting_list) do
					ass:copy_to(v.ass)
					v.loader:on_asset_loaded(key, v.ass)
				end
			end
		end
		if DEBUG and OPEN_DELAY_UI then
			delay(delay_func,OPEN_DELAY_UI_TIME)
		else
			delay_func()
		end

	end

	local on_err = function(req) 
		local ass = req.head
		local key = ass.key
		self:on_asset_loaded_error(key,ass)
	end

	for k,v in ipairs(assets) do
		key = v.key 
		local asst=gf_game_object_atlas[key] --print(key,asst)
		if asst and not Seven.PublicFun.IsNull(asst.root) then
			_gf_loading_res_list[v.key] = nil
			asst:copy_to(v)
			if v:is_preload() then
				v:hide()
			else
				self:on_asset_loaded(key,v)
			end
		else
			local r = self:create_request(v,on_req_loaded,on_err)
			table.insert(reqs,r)
		end
	end

    if #reqs>0 then
    	Loader:get_resource(reqs, on_complete, on_progress) 
    else
    	if on_progress then on_progress({progress = 1}) end
    	if on_complete then on_complete() end
    end
end

function AssetLoader:clear()
	--local at = gf_game_object_atlas[self.name]
	for k,v in pairs(self.assets) do
		v:clear()		
	end	
	--gf_game_object_atlas[self.name]=nil
	--if at then LuaHelper.Destroy(at.root) end
--    unload_unused_assets()
end

_gf_loading_res_list = {} -- 正在加载的资源列表
function AssetLoader:load(asts,onall_complete,on_progress)

	self.assets = {}
	local all_assets = {}
	local proload_assets = {}
	
	for k,v in ipairs(asts) do

		if not _gf_loading_res_list[v.key] then -- 判断资源是否正在加载
			_gf_loading_res_list[v.key] = {}
			if v:is_preload() then
				table.insert(proload_assets, v)
			else
				table.insert(all_assets,v)
			end
			if v.children then 
				for k1,v1 in ipairs(v.children) do
					if v1:is_preload() then
						table.insert(proload_assets, v1)
					else
						table.insert(all_assets,v1)  
					end
				end
			end
		else
			-- 资源正在加载,加入等待列表
			table.insert(_gf_loading_res_list[v.key], {ass = v, loader = self})
			print("加入等待列表：",v)
		end
		v:start_load()
	end
	if self.lua_obj and self.lua_obj.is_loading then print("warring something is loading lua_obj="..tostring(self.lua_obj)) end
	self._load_curr = 0
	self._load_count = #all_assets
	self._on_progress = on_progress
	self._onall_complete = onall_complete

	local function on_complete()

		if self._onall_complete then
			self._onall_complete()
		end
		self._onall_complete = nil
		self._on_progress = nil

		if #proload_assets > 0 then
			self:load_assets(proload_assets, on_preloadComplete)
		end
	end

	local function on_progress( arg )
		if self._on_progress then
			self._on_progress(arg)
		end
		-- StateManager:get_state_transform():update_progress(arg)
	end

	if self._load_count > 0 then
		self.lua_obj.is_loading = true
	end
	self:load_assets(all_assets, on_complete, on_progress)
end

function clear_assets()
	for k,v in pairs(gf_game_object_atlas) do
		-- print(k.." is Destroy ")
		if v then v:dispose() end
	end
	gf_game_object_atlas={}
end

return AssetLoader