--[[--
-- 登录选服界面
-- @Author:HuangJunShan
-- @DateTime:2017-04-01 12:08:20
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local select_area_key="select_area"

local LoginChannelView=class(UIBase,function(self, item_obj, cb)
    self.cb = cb
    UIBase._ctor(self, "login_channel.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LoginChannelView:on_asset_load(key,asset)
	if self.cb then
		self.cb()
	end
	self.main_ui=self.item_obj.assets[1]
	--设置主ui为父物体
	self.root.transform:SetParent(self.main_ui.root.transform,false)
	--获取组件
	--选择的区服 文本
	self.text_select_area=LuaHelper.FindChildComponent(self.root,"text_select_area","UnityEngine.UI.Text")
	--区服状态图标
	self.img_area_state=LuaHelper.FindChildComponent(self.root,"img_area_state",UnityEngine_UI_Image)
	self.init = true
	self:show()
end

--初始化ui
function LoginChannelView:init_ui()
	--获取默认选区
	local game = LuaItemManager:get_item_obejct("game")
	select_area_key = game.player_account.."_select_area"
	self.item_obj.select_area = PlayerPrefs.GetInt(select_area_key,self.item_obj:get_default_area())
	print("选择默认服",self.item_obj.select_area)
	self:set_select_area(self.item_obj.select_area)
end

--设置选择的区服
function LoginChannelView:set_select_area(area_id)
	self.text_select_area.text=self.item_obj.server_list[area_id].name
end

--点击事件
function LoginChannelView:on_click(item_obj,obj,arg)
	if(obj.name=="btn_into_game")then
		Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN) -- 通用按钮点击音效
		--进入游戏按钮
		local btn = obj:GetComponent("UnityEngine.UI.Button")
		btn.interactable = false
		PLua.Delay(function()
				if not Seven.PublicFun.IsNull(btn) then
					btn.interactable = true
				end
			end,3)
		self:on_click_btn_into_game()
	elseif(obj.name=="btn_area_bg")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--选择区服按钮
		self:on_click_btn_area_bg()
	elseif(obj.name=="btn_change_user")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--切换账号按钮
		self:on_click_btn_change_user()
	end
end

--进入游戏
function LoginChannelView:on_click_btn_into_game()
	-- gf_print_table(self.item_obj.role_list or {},"角色列表")
	-- print("选择的区服",self.item_obj.select_area)
	PlayerPrefs.SetInt(select_area_key,tonumber(self.item_obj.select_area))
	if self.item_obj:get_role(tonumber(self.item_obj.select_area)) then
		print("--有角色直接进入游戏 当前选择的区服 = ",self.item_obj.select_area)
		self.item_obj:login_game_c2s(self.item_obj.select_area)
	else
		print("--没角色进入创建角色界面 当前选择的区服 = ",self.item_obj.select_area)
		StateManager:set_current_state(StateManager.create_role) --改用3D场景， 新增创号状态，切换状态吧
	end
end

--点击了换区按钮
function LoginChannelView:on_click_btn_area_bg()
	print("打开选择区服界面")
	self.main_ui:load_ui("selectServiceAreaView")

end

--换账号按钮	更换用户
function LoginChannelView:on_click_btn_change_user()
	-- 进入登录界面
	self.main_ui:load_ui("loginInternalView", "loginChannelView")
	SdkMgr:logout()
end

function LoginChannelView:on_showed()
	self.active=true
	if self.init then
		--初始化ui
		self:init_ui()
	end
end

function LoginChannelView:on_hided()
	self.active=false
end

-- 释放资源
function LoginChannelView:dispose()
	self.init = nil
    self._base.dispose(self)
 end

return LoginChannelView

