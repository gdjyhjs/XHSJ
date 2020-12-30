--[[--
--登录初始化
-- @Author:HuangJunShan
-- @DateTime:2017-03-31 16:38:27
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local timer=0

local LoginInitView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "login_init.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成 --做一些初始化
function LoginInitView:on_asset_load(key,asset)
	print("LoginInitView登录初始化加载完毕")
	--ui初始化
	self:init_ui()
	--用来保存子UI
	self.ui_array = {}
	--注册
	self:register()
	--加载logo ui
	self:load_ui("loginInternalView")
	self.float_item = LuaItemManager:get_item_obejct("floatTextSys") -- 飘字
	self.ccmp = LuaItemManager:get_item_obejct("cCMP") -- 飘字


    print("播放背景音乐")
    Sound:set_bg_music("bg_1")
    Sound:clear_source()
    Sound:clear_clip()
end

--飘字
function LoginInitView:float_text(string)
	self.float_item:tishi(string)
end

--弹框
function LoginInitView:c_cmp(string)
	self.ccmp.assets[1]:add_message(string)
end

function LoginInitView:init_ui()
	
end

--加载ui
function LoginInitView:load_ui(show_name, hide_name)
	-- print(string.format(">>>切换ui 显示%s 隐藏%s",show_name,hide_name))

	
	-- if not self.count then self.count = 0 end
	-- self.count = self.count + 1
	-- print("切换次数",self.count)
	-- if self.count > 200 then
	-- 	return
	-- end

	local load_end = function()
		if hide_name and self.ui_array[hide_name] then
			print("隐藏",self.ui_array[hide_name])
			self.ui_array[hide_name]:hide()
		end
	end

	if(self.ui_array[show_name])then
		print("显示",self.ui_array[show_name])
		self.ui_array[show_name]:show()
		load_end()
	else
		local ui=require("models.login."..show_name)
		self.ui_array[show_name]=ui(self.item_obj, load_end)
		self.ui_array[show_name].ui_key=show_name
	end
end

--卸载ui
function LoginInitView:unload_ui(name)
	self.ui_array[name]:dispose()
	self.ui_array[name]=nil
end

--卸载所有子ui
function LoginInitView:unload_allui()
	for k,v in pairs(self.ui_array) do
		self:unload_ui(k)
	end
end

--注册事件
function LoginInitView:register()
	self.item_obj:register_event("login_init_view_on_click", handler(self, self.on_click))
	self.item_obj:register_event("login_init_view_value_change", handler(self, self.on_value_changed))
end

--点击事件
function LoginInitView:on_click(item_obj,obj,arg)
	print("login:点击了按钮：",obj.name)
	for k,v in pairs(self.ui_array) do
		if v.active and v.on_click and v.is_show then
			v:on_click(item_obj,obj,arg)
		end
	end

	if(obj.name=="btn_gonggao")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--公告按钮
		LuaItemManager:get_item_obejct("announcement"):add_to_state()
	elseif(obj.name=="btn_kefu")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--客服按钮
		require("models.setting.customerServiceView")()
	elseif(obj.name=="")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--反馈按钮
	end

end

--值改变事件
function LoginInitView:on_value_changed(item_obj,obj,arg)
	for k,v in pairs(self.ui_array or {}) do
		if v.active and v.on_value_changed then
			v:on_value_changed(item_obj,obj,arg)
		end
	end
end

function LoginInitView:on_receive( msg, id1, id2, sid )
	for k,v in pairs(self.ui_array or {}) do
		if v.active and v.on_receive then
			v:on_receive(item_obj,obj,arg)
		end
	end
end

function LoginInitView:on_showed()
	-- 连接登录服
	if not SdkMgr:is_sdk() then
		Net:connect(NetConfig.host, NetConfig.port)
	end
end

-- 释放资源
function LoginInitView:dispose()
	--卸载所有子ui
	self:unload_allui()
	
	self.item_obj:register_event("login_init_on_click", nil)
	self.item_obj:register_event("login_init_view_value_change", nil)
    self._base.dispose(self)
 end

return LoginInitView

