--[[--
-- 动画加载基本类
-- @Author:Seven
-- @DateTime:2017-04-20 09:47:06
--]]

local FarPos = Vector3(10000,10000,10000)

local SpriteBase = class(function( self, url, ...)
	self.url = url
	self.sprite_name = CUtils.GetAssetName(url) --asset name
    self.assetbundle_url = CUtils.GetRightFileName(url) --real use url
    self.key = CUtils.GetAssetBundleName(self.assetbundle_url) --以assetbundle name为key


	self.is_clone = false

    self.is_init = false -- 资源是否加载完成
    self.faraway_time = 0
    self.is_dispose = false

    self._param = {...}
    if type(self._param[1]) == "function" then
	    self.loaded_cb = self._param[1] -- 加载完成回调
	    table.remove(self._param, 1)
	end
    
    self.is_show = true -- 是否显示

    self:pre_init()
    
	self:get_resource(url)
end)

---------------------------- public-------------------
function SpriteBase:pre_init()
	
end

-- 子类继承的方法，初始化,动画加载完成后调用
function SpriteBase:init()
	
end

-- 是否加载完成
function SpriteBase:is_loaded()
	return self.is_init
end

function SpriteBase:set_loaded_cb( cb )
	self.loaded_cb = cb
end

-- 隐藏
function SpriteBase:hide()
	self.is_show = false
	if self.root and not Seven.PublicFun.IsNull(self.root) then
		self.root:SetActive(false)
	end

	send_message(self, "on_hided")
end

-- 显示
function SpriteBase:show()
	self.is_show  = true
	if self.root then
		self.root:SetActive(true)
	end
	send_message(self, "on_showed")
end

function SpriteBase:set_visible( visible )
	if visible then
		self:show()
	else
		self:hide()
	end
end

-- 是否显示
function SpriteBase:is_visible()
	return self.is_show
end

-- 设置位置
function SpriteBase:set_position( pos )
	self.position = pos or UnityEngine.Vector3.zero
	if self.is_init and self.transform then
		-- print("设置位置",self.position)
		self.transform.position = self.position
		-- Seven.PublicFun.SetPosition(self.transform, pos)
	end
end

-- 获取位置
function SpriteBase:get_position()
	if not self.transform then
		print_error("ERROR:SpriteBase:get_position 物体已经被删除，还访问",self)
		return Vector3(0,0,0)
	end

	self.position = self.transform.position
	return self.position
end

-- 设置父亲
function SpriteBase:set_parent( parent )
	if not parent then
		return
	end

	self.parent = parent
	if self.is_init then
		-- print("设置父亲:",parent)
		self.transform.parent = parent
	end
end

function SpriteBase:set_scale( vector3 )
	if not vector3 then
		return
	end

	self.scale = vector3
	if self.is_init then
		-- print("set_scale:",scale)
		self.transform.localScale = self.scale
	end
end

function SpriteBase:set_eulerAngles( eulerAngles )
	self.eulerAngles = eulerAngles
	if not self.eulerAngles then
		return
	end
	if self.is_init then
		-- print("set_reulerAngles:",self.eulerAngles)
		self.transform.eulerAngles = self.eulerAngles
	end
end

function SpriteBase:set_local_euler_angles( angles )
	self.transform.localEulerAngles = angles
end

function SpriteBase:dispose()
	self.is_dispose = true
	if not self.is_clone and self.key then
		_gf_sprite_list[self.key] = nil
	end
	
	self.transform = nil
	self.eulerAngles = nil
	
	if self.root then
		LuaHelper.Destroy(self.root)
		self.root = nil
		print("SpriteBase.dispose", self.key, self.sprite_name)
	end
end

-- 远离摄像机
function SpriteBase:faraway()
	self:set_position(FarPos)
	self.faraway_time = Net:get_server_time_s()
end

----------------------------private-------------------
if not _gf_sprite_list then -- 已近加载列表
	_gf_sprite_list = {}
end

if not _gf_loading_sprite_list then
	_gf_loading_sprite_list = {}
end

if not _gf_waiting_sprite_list then
	_gf_waiting_sprite_list = {}
end

function SpriteBase:on_resource_load(req)
	if not req.data then
		print_error("ERROR:加载动物文件出错：",self.key,self.url)
		Loader:get_resource(self.url, handler(self, self.on_resource_load))
		return
	end
	self.req_data = req.data
	local delay_ = function()
		_gf_loading_sprite_list[self.key] = nil -- 清空正在加载列表
		print("加载动画完成",self.req_data,self.url)
		self.root = LuaHelper.Instantiate(self.req_data)
		_gf_sprite_list[req.key] = self.req_data

		self:base_init()

		if _gf_waiting_sprite_list[self.key] then -- 检查是否有等待列表
			for k,v in pairs(_gf_waiting_sprite_list[self.key] or {}) do
				v.is_clone = true
				v.root = LuaHelper.Instantiate(self.req_data)
				v:base_init()
			end
			_gf_waiting_sprite_list[self.key] = nil
		end
	end
	if DEBUG and OPEN_DELAY_MODEL then
		delay(delay_,OPEN_DELAY_MODEL_TIME)
	else
		delay_()
	end
	
end

function SpriteBase:base_init()
	self.is_init = true
	self.root.name = self.sprite_name
	self.transform = self.root.transform

	self:set_position(self.position)
	self:set_parent(self.parent)
	self:set_scale(self.scale)
	self:set_eulerAngles(self.eulerAngles)
	self:init()

	if self.is_show then
		self:show()
	else
		self:hide()
	end
	
	if self.loaded_cb then
		self.loaded_cb(self, unpack(self._param))
	end

	if self.is_dispose then
		self:dispose()
	end

	if self.faraway_time > 0 then
		self:faraway()
	end
end

function SpriteBase:get_resource( url )

	if not _gf_loading_sprite_list[self.key] then
		if not _gf_sprite_list[self.key] or Seven.PublicFun.IsNull(_gf_sprite_list[self.key]) then 
			_gf_loading_sprite_list[self.key] = true
			Loader:get_resource(url, handler(self, self.on_resource_load),function()
				gf_error_tips(string.format("找不到模型：%s",self.url))
			end)
		else
			self.is_clone = true
			self.root = LuaHelper.Instantiate(_gf_sprite_list[self.key])
			self:base_init()
		end
	else

		if not _gf_waiting_sprite_list[self.key] then
			_gf_waiting_sprite_list[self.key] = {}
		end
		table.insert(_gf_waiting_sprite_list[self.key], self)
	end
end

return SpriteBase