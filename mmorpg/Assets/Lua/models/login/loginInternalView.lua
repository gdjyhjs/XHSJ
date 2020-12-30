--[[--
-- 内部登录界面
-- @Author:HuangJunShan
-- @DateTime:2017-04-01 12:08:20
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Random = UnityEngine.Random
local Effect = require("common.effect")

local LoginInternalView=class(UIBase,function(self,item_obj, cb)
    self.cb = cb
    UIBase._ctor(self, "login_internal.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LoginInternalView:on_asset_load(key,asset)
	-- 删除热更界面
	local fristView = LuaHelper.Find("regeng")
	if fristView then LuaHelper.Destroy(fristView) end

	if self.cb then
		self.cb()
	end
	
	self.panel = LuaHelper.FindChild(self.root, "panel")
	if SdkMgr:is_sdk() then
		self.panel:SetActive(false)
	end

	print("loginInternalView(内部登录界面)加载完毕")
	self.main_ui=self.item_obj.assets[1]--获取主ui
	--初始化ui
	self:init_ui()

	--加载特效


	--播放特效
	-- self.refer:Get("eff"):SetActive(true)
	-- PLua.Destroy(function() self.refer:Get("eff"):SetActive(true) end , 1 )
	-- PLua.Delay(function()
	-- 		-- self.refer:Get("bg"):SetActive(true)
	-- 		self.refer:Get("eff"):SetActive(false)
	-- 	end , 2 )
	PLua.Delay(function()
			self.refer:Get("bg"):SetActive(true)
			-- self.refer:Get("eff"):SetActive(false)
		end , 0.8 )


	-- --震屏
	-- local tf = self.root.transform
	-- local pos = tf.position
	-- --以下数值是策划配置的
	-- local shake_delay = 0.8 --进入界面后多久震
	-- local shake_time = 0.2 --震动的时间
	-- local shake_dir = 10 --震动的幅度
	-- local shake_min_size = 100 --最小尺寸 百分之几
	-- local shake_max_size = 110 --最大尺寸 百分之几
	-- local open_dir = 0 -- 是否开启移动震屏 1是开启 0是关闭
	-- local open_size = 1 -- 是否开启缩放震屏 1是开启 0是关闭
	-- --以上数值是策划配置的
	-- local shake_f = function()
	-- 	--震屏
	-- 	local timer = Schedule(function()
	-- 		if open_dir == 1 then
	-- 			tf.position = Vector3(pos.x+Random.Range(-shake_dir,shake_dir),pos.y+Random.Range(-shake_dir,shake_dir),pos.z)
	-- 		end
	-- 		if open_size == 1 then
	-- 			tf.localScale = Vector3.one*Random.Range(shake_min_size,shake_max_size)*0.01
	-- 		end
	-- 	end,0.02)
	-- 	PLua.Delay(function()
	-- 		timer:stop()
	-- 		if open_dir == 1 then
	-- 			tf.position = pos
	-- 		end
	-- 		if open_size == 1 then
	-- 			tf.localScale = Vector3.one
	-- 		end
	-- 	end, shake_time)
	-- end
	-- PLua.Delay(shake_f, shake_delay) --震屏
end

--初始化ui
function LoginInternalView:init_ui()
	--设置主ui为父物体
	self.root.transform:SetParent(self.main_ui.root.transform,false)

	--获取组件
	local game = LuaItemManager:get_item_obejct("game")

	--账号输入框
	self.inputfield_account=LuaHelper.FindChildComponent(self.root,"inputfield_account","UnityEngine.UI.InputField")
	--密码输入框
	self.inputfield_password=LuaHelper.FindChildComponent(self.root,"inputfield_password","UnityEngine.UI.InputField")
	print("读取账密记录")
	self.inputfield_account.text=game.player_account
	self.inputfield_password.text=game.palyer_password
end

--点击事件
function LoginInternalView:on_click(item_obj,obj,arg)
	if(obj.name=="btn_into_game")then
		 Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN) -- 通用按钮点击音效
		--进入游戏按钮
		self:on_login()
	elseif(obj.name=="btn_change_area")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--换区按钮
		self:on_click_btn_change_area()
	end
end

--点击了换区按钮
function LoginInternalView:on_click_btn_change_area()
	self.main_ui:load_ui("selectServiceAreaView")

end

-- 登录
function LoginInternalView:on_login()
	print("点击登录。。。")
	if string.find(self.inputfield_account.text,"[^a-zA-Z0-9_]") then
		self.main_ui:float_text("账号只能由数字，字母或下划线组成")
		return
	end
	if string.find(self.inputfield_password.text,"[%z\1-\127\194-\244][\128-\191]") then
		self.main_ui:float_text("密码不能包含中文字符")
		return
	end
	if(#self.inputfield_account.text>3) or SdkMgr:is_sdk() then
		print("玩家账号："..self.inputfield_account.text.."密码："..self.inputfield_password.text)
		self.item_obj:debug_login(self.inputfield_account.text, self.inputfield_password.text)
	else
		print("账号长度不够")
		self.main_ui:float_text("账号长度不够")
	end

end

function LoginInternalView:on_showed()
	self.active=true
	if SdkMgr:is_sdk() then
		SdkMgr:init()
	end
end

function LoginInternalView:on_hided()
	self.active=false
end

-- 释放资源
function LoginInternalView:dispose()
    self._base.dispose(self)
 end

return LoginInternalView

