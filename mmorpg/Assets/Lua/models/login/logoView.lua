--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-31 16:43:33
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LogoView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "logo.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成 --做一些初始化
function LogoView:on_asset_load(key,asset)
	self.main_ui=self.item_obj.assets[1]
	--播放logo
	self:play_logo()
end

--播放logo
function LogoView:play_logo()
	Loader:get_resource("launch_cg.u3d",nil, "UnityEngine.MovieTexture", function(result)
		local movie_texture = result.data
		--获取rawimage组件
		local raw_image = LuaHelper.FindChildComponent(self.root,"rawimage_logo_player","UnityEngine.UI.RawImage")
		--设置播放载体
		raw_image.texture = movie_texture
		--播放视频
		movie_texture:Play()
		--循环播放
		movie_texture.loop = true;
	end)
end

--检测是否需要更新
function LogoView:detection_need_update()
	local need_update=true
	return need_update
end

--检测是否热更新
function LogoView:detection_is_hot_update()
	local is_hot_update = true
	return is_hot_update
end

--检测更新大小
function LogoView:detection_update_size()
	return 125.4
end

--点击事件
function LogoView:on_click(item_obj,obj,arg)
	if(obj.name=="rawimage_logo_player") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--检测更新
		if self:detection_need_update() then
			--检测是否热更新
			if self:detection_is_hot_update() then
				--可以直接界面上下载更新（热更），则弹框：弹出是否要更新的ui
				self:hot_update()
			else
				--需要跳转到外部下载链接（强更），弹框（使用游戏中的通用弹框）：点击确定前往下载
				print("强更")
			end
		else
			--进入登录ui	--加载登录ui，卸载自己
			self.main_ui:into_login()
		end
	end
end

function LogoView:on_showed()
	self.active=true
end

function LogoView:on_hided()
	self.active=false
end

--热更新
function LogoView:hot_update()
	self.main_ui:load_ui("hotUpdateCmpView")
end

-- 释放资源
function LogoView:dispose()
    self._base.dispose(self)
 end

return LogoView

