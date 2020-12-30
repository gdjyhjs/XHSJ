------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--	asset 
--	author pu
------------------------------------------------
local CUtils=CUtils
local LuaHelper=LuaHelper
local UIParent = LuaHelper.Find("UI").transform

Asset = class(function(self, url, preload, level)
    self.base = false
    self.url = url
    self.asset_name = CUtils.GetAssetName(url) --asset name
    self.assetbundle_url = CUtils.GetRightFileName(url) --real use url
    self.key = CUtils.GetAssetBundleName(self.assetbundle_url) --以assetbundle name为key
   -- print("Asset url=",url,"assetbundle_url=",self.assetbundle_url,"asset_name=",self.asset_name)
    
    self.items = {}
    self.root = nil
    self.refer = nil --ReferGameObjects
    self.preload = preload
    self._is_loaded = false -- 是否加载
    self.is_dispose = false

    self.is_show = false -- 是否正在显示

    self.last_show = false -- 用来记录父亲隐藏时的显示状态

    self.hide_time = -1 -- 打开时间
    self.level = level or self.level or UIMgr.LEVEL_0 -- ui释放等级，默认是关闭后释放
    self.is_hide_mainui = false -- 打开时候是否隐藏主ui
    self.temp_hide = false

    UIMgr:add_asset(self)
end)

function Asset:add_child(asset)
	if 	self.children == nil then self.children = {} end
	local index = #self.children
	table.insert(self.children,asset)
	asset.parent = self
	asset.index = index --position
	asset.level = self.level
end
--慎用
function Asset:remove_children()
	local temp = gf_get_table(self.children or {})
	for k,v in ipairs(temp) do
		v:dispose()
	end
	self.children = {}
end
function Asset:on_loaded(key, asset)
	self._is_loaded = true
    print("隐藏吗",self.temp_hide)
	if self.temp_hide then
		self.temp_hide = false
		print("ui加载完成，隐藏有隐藏状态的",self.url)
		self:hide()
	end

	if self.parent then
		if self.parent.is_dispose then
			self:dispose()

		elseif not self.parent:is_visible() then
			self:hide()
		end
	end

	if self.is_dispose then
		self:dispose()
	end
end

function Asset:is_loaded()
	return self._is_loaded
end

-- 设置开始加重
function Asset:start_load()
	self.is_start_load = true
end

--清理引用
function Asset:_clear()
	self.root = nil
	self.refer = nil
	table.clear(self.items)
	self.ui_parent_joint = nil
	self.ui_joint = nil
	self.is_dispose = false
	self._is_loaded = false
end

--销毁
function Asset:dispose()
	self.is_dispose = true
	if not self._is_loaded then
		return
	end

	if self.is_hide_mainui then
		self:set_mainui_visible(true)
	end
	self.is_hide_mainui = false
	
	if self.is_bg_visible and self.is_show then
		self:show_bg_view(false)
	end
	
	UIMgr:remove_asset(self)
	if self.children then
		local temp = gf_get_table(self.children)
		for k,v in ipairs(temp) do
			v:dispose()
		end
	end

	if self.root then
		LuaHelper.Destroy(self.root)
	end
	
	self.ui_parent_joint = nil
	self.ui_joint = nil

	
	--从父类中移除
	if self.parent then
		for i,v in ipairs(self.parent.children or {}) do
			if v == self then
				table.remove(self.parent.children,i)
				break
			end
		end
	end

	self.parent = nil
	self.children = nil
	self.root = nil
	self.refer = nil
	self.is_show = false
	self.hide_time = -1
	self.temp_hide = false
	self._is_loaded = false
	if self.is_clone ~= true then gf_game_object_atlas[self.key] = nil	end
	table.clear(self.items)

	print("Asset.dispose",self.key,self.asset_name)
end

function Asset:show(not_show_children)

	LuaItemManager:get_item_obejct("guide"):show_hightlight(self)
	if self.is_show then
		send_message(self, "on_showed")
		return
	end

	

	UIMgr:add_asset(self)

	self.is_show = true
	if self.root then self.root:SetActive(true) end

	--ui重排
	if self.root then
		--重设hierarchy中的顺序
		local count = UIParent.childCount + gf_get_node_show_children_count(UIParent)
    	self.root.transform:SetAsLastSibling()--SetSiblingIndex(count + 1)
    	print("wtf resort set hierarchy layer:",self.root.name,count ,UIParent.childCount)
		gf_resort_layer()
	    -- gf_set_to_top_layer(self.root)

	end

	if self.children and not not_show_children then
		for k,v in pairs(self.children) do
			if v.last_show then
				v:show()
			end
		end
	end

	if self.is_hide_mainui then
		self:set_mainui_visible(false)
	end

	
	

	send_message(self, "on_showed")

	if self.is_bg_visible then
		self:show_bg_view(self.is_bg_visible)
	end
end

function Asset:hide(not_show_children)

	if not self:is_loaded() and self.is_start_load and not self.is_dispose then -- 如果没加载完成，保存隐藏状态
		print("ui没加载完成，保存隐藏状态",self.url)
		self.temp_hide = true
	end

	if not self.is_show then
		send_message(self, "on_hided")
		return
	end

	if self.is_bg_visible then
		self:show_bg_view(not self.is_bg_visible)
		-- self.is_bg_visible = true
	end

	self.is_show = false
	self.hide_time = Net:get_server_time_s()
	if self.root then self.root:SetActive(false) end

	if self.children and not not_show_children then
		for k,v in pairs(self.children) do
			v.last_show = v.is_show
			v:hide()
		end
	end

	if self.is_hide_mainui then
		self:set_mainui_visible(true)
	end

	send_message(self, "on_hided")
end

function Asset:is_visible()
	return self.is_show
end

function Asset:set_visible( visible )
	if visible then
		self:show()
	else
		self:hide()
	end
end

function Asset:copy_to(asse)
	
	-- if asse.parent == nil then
		asse.items = {}
		for k,v in pairs(self.items) do
			asse.items[k]=v
		end
		asse.refer = self.refer
		asse.root = self.root
		asse.ui_parent_joint = self.ui_parent_joint
		asse.is_dispose = false
		self.is_clone = nil
	-- else
	-- 	local root = LuaHelper.Instantiate(self.root)
	-- 	root.name = self.root.name
	-- 	local eachFn =function(i,obj)
	-- 		asse.items[obj.name]=obj
	-- 	end
	-- 	LuaHelper.ForeachChild(root,eachFn)
	-- 	asse.is_clone = true
	-- 	asse.root = root
	-- end
	return asse
end

--是否是预加载
function Asset:is_preload()
	return self.preload
end

function Asset:set_preload( flag )
	self.preload = flag
end

function Asset:set_level( level )
	self.level = level
end

-- 设置总是接收协议（隐藏也会接收，普通情况只有显示会接收）
function Asset:set_always_receive( receive )
	self._is_always_receive = receive
end

function Asset:is_always_receive()
	return self._is_always_receive
end

-- 显示或者隐藏主ui
function Asset:set_mainui_visible( visible )
	-- Net:receive({visible = visible}, ClientProto.HidOrShowMainUI)
end

-- 显示或者隐藏主ui
function Asset:hide_mainui( hide )
	-- if self:is_loaded() then
	-- 	self:set_mainui_visible(false)
	-- end

	-- self.is_hide_mainui = hide or true
end

-- 显示ui底板
function Asset:set_bg_visible( visible )
	self.is_bg_visible = visible
	
end

function Asset:show_bg_view(visible)
	if visible then
		LuaItemManager:get_item_obejct("uimask"):on_focus()
	else
		LuaItemManager:get_item_obejct("uimask"):on_blur()
	end
end

function Asset:__tostring()
    return string.format("asset.key = %s ,url =%s ", self.key,self.url)
end