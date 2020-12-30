--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-01 09:34:28
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local HotupdateCmpView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "hotupdate_cpm.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成 --做一些初始化
function HotupdateCmpView:on_asset_load(key,asset)
	self.main_ui=self.item_obj.assets[1]
	--初始化ui
	self:init_ui()
end

--初始化ui
function HotupdateCmpView:init_ui()
	-- --初始化图片
	-- --热更新弹窗背景图片
	-- LuaHelper.FindChildComponent(self.root,"img_hotupdate_cpm",UnityEngine_UI_Image).sprite=
	-- LuaHelper.GetResources("test/Texture/002-mainmenu/bg_弹框","UnityEngine.Sprite")
	-- --热更新确认按钮图片
	-- LuaHelper.FindChildComponent(self.root,"btn_hotupdate_sure",UnityEngine_UI_Image).sprite=
	-- LuaHelper.GetResources("test/Texture/001-startmenu/btn_公共蓝1","UnityEngine.Sprite")

	--初始化文字
	--热更新弹窗文本
	LuaHelper.FindChildComponent(self.root,"text_hotupdate_cpm","UnityEngine.UI.Text").text= 
	string.format(gf_localize_string([[游戏资源有新版本[下载大小%0.2fM]
更新后才能进入游戏
点击确定开始下载]]),self.main_ui.ui_array["logoView"]:detection_update_size())
	--热更新确认按钮文本
-- 	LuaHelper.FindChildComponent(self.root,"text_hotupdate_sure","UnityEngine.UI.Text").text= gf_localize_string("确认")
end

--点击事件
function HotupdateCmpView:on_click(item_obj,obj,arg)
	if(obj.name=="btn_hotupdate_sure")then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--开始热更新 加载更新进度条ui,卸载自己的ui
		self.main_ui:load_ui("hotUpdateLoadingView")
		self.main_ui:unload_ui(self.ui_key)
	end
end

function HotupdateCmpView:on_showed()
	self.active=true
end

function HotupdateCmpView:on_hided()
	self.active=false
end

-- 释放资源
function HotupdateCmpView:dispose()
    self._base.dispose(self)
 end

return HotupdateCmpView

