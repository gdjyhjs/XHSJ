--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-01 10:31:25
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local hotUpdateLoadingView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "hotupdate_loading.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function hotUpdateLoadingView:on_asset_load(key,asset)
	self.main_ui=self.item_obj.assets[1]
	--初始化ui
	self:init_ui()
	--测试数据
	self.load_size=0
	self.init_ok=true
end

--初始化ui
function hotUpdateLoadingView:init_ui()
	-- --初始化图片
	-- --进度条背景图片
	-- LuaHelper.FindChildComponent(self.root,"img_hotupdate_loadling_bg",UnityEngine_UI_Image).sprite=
	-- LuaHelper.GetResources("test/Texture/002-mainmenu/bg_经验条长","UnityEngine.Sprite")
	-- --进度条装载图片
	-- LuaHelper.FindChildComponent(self.root,"img_hotupdate_loadline_fill",UnityEngine_UI_Image).sprite=
	-- LuaHelper.GetResources("test/Texture/002-mainmenu/pic_经验条长","UnityEngine.Sprite")

	-- --初始化文字
	-- --热更新速度文本
	 self.text_hotupdate_speed=LuaHelper.FindChildComponent(self.root,"text_hotupdate_speed","UnityEngine.UI.Text")
	-- self.text_hotupdate_speed.text=string.format(gf_localize_string("下载速度：%0.1fKB/S"),0)
	-- --热更新大小文本
	 self.text_hotupdate_size=LuaHelper.FindChildComponent(self.root,"text_hotupdate_size","UnityEngine.UI.Text")
	-- self.text_hotupdate_size.text= string.format(gf_localize_string("正在下载更新：%0.1fMB/%0.1fMB%s"),0,0,".")
	-- --热更新百分比文本
	 self.text_hotupdate_percentage=LuaHelper.FindChildComponent(self.root,"text_hotupdate_percentage","UnityEngine.UI.Text")
	-- self.text_hotupdate_percentage.text= string.format(gf_localize_string("总进度%0.1f%s"),0,"%")

	--获取组件
	--获取进度条组件
	self.slider_hotupdate_loadling=LuaHelper.FindChildComponent(self.root,"slider_hotupdate_loadling","UnityEngine.UI.Slider")
	
	--获取更新包大小
	self.update_size = self.main_ui.ui_array["logoView"]:detection_update_size()
end

local str = "."
function hotUpdateLoadingView:on_second()
	if(self.init_ok)then
		self.load_size=self.load_size+111.11;
		if	self.load_size>self.main_ui.ui_array["logoView"]:detection_update_size() then self.load_size=self.main_ui.ui_array["logoView"]:detection_update_size() end
		--热更新速度文本
		self.text_hotupdate_speed=LuaHelper.FindChildComponent(self.root,"text_hotupdate_speed","UnityEngine.UI.Text")
		self.text_hotupdate_speed.text=string.format(gf_localize_string("下载速度：%0.1fKB/S"),111111)
		--热更新大小文本
		str = str=="..." and "." or str.."."
		self.text_hotupdate_size=LuaHelper.FindChildComponent(self.root,"text_hotupdate_size","UnityEngine.UI.Text")
		self.text_hotupdate_size.text= string.format(gf_localize_string("正在下载更新：%0.1fMB/%0.1fMB%s"),self.load_size,self.main_ui.ui_array["logoView"]:detection_update_size(),str)
		--热更新百分比文本
		self.text_hotupdate_percentage=LuaHelper.FindChildComponent(self.root,"text_hotupdate_percentage","UnityEngine.UI.Text")
		self.text_hotupdate_percentage.text= string.format(gf_localize_string("总进度%0.1f%s"),self.load_size/self.main_ui.ui_array["logoView"]:detection_update_size()*100,"%")
		--设置进度条
		local load=self.load_size/self.main_ui.ui_array["logoView"]:detection_update_size()
		self.slider_hotupdate_loadling.value=load
		--判断是否更新完了 更新完了进入登录界面
		if(load==1)then
			self.main_ui:into_login()
		end
	end
end

--获取更新进度
function hotUpdateLoadingView:get_update_progress()

end

--获取更新速度
function hotUpdateLoadingView:get_update_speed()
	
end


function hotUpdateLoadingView:on_showed()
	self.active=true
end

function hotUpdateLoadingView:on_hided()
	self.active=false
end

-- 释放资源
function hotUpdateLoadingView:dispose()
    self._base.dispose(self)
 end

return hotUpdateLoadingView

