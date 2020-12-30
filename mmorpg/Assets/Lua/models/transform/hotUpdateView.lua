--[[--
-- 热更界面
-- @Author:Seven
-- @DateTime:2017-04-26 17:53:32
--]]
local LuaHelper=Hugula.Utils.LuaHelper
local UGUIEvent=Hugula.UGUIExtend.UGUIEvent 

local HotUpdateView = {}
local m = 1024 * 1024

function HotUpdateView:init()
	local ui = LuaHelper.Find("regeng")
	local refr = LuaHelper.GetComponent(ui, "Hugula.ReferGameObjects")
	self.mid_txt = refr:Get(2) -- 中间
	self.left_txt = refr:Get(4) -- 左边的文字
	self.right_txt = refr:Get(3) -- 右边文字
	self.progressbar_slider = refr:Get(1)
	self.left_txt.text = ""
	self.right_txt.text = ""

	self.slider_obj = LuaHelper.FindChild(ui, "Slider")
	self.slider_obj:SetActive(false)

	self.is_slider_visible = false

	self.last_load = 0


	self.error  = refr:Get("error")
	self.error_txt = refr:Get("error_txt")

	local on_click = function( sender, arg )
		self:on_click(sender, arg)
	end
	UGUIEvent.onClickFn=on_click
end

function HotUpdateView:on_click( sender, arg )
	print(sender,arg)
	local cmd = sender.name
	if cmd == "close_btn" or cmd == "sure_btn" then
		self.error:SetActive(false)
		if self.error_cb then
			self.error_cb()
		end
	end
end

-- 显示错误
function HotUpdateView:show_error( visible, content, cb )
	self.error:SetActive(visible)
	self.error_txt.text = content
	self.error_cb = cb
end

function HotUpdateView:set_left_txt( txt )
	self.left_txt.text = text or ""
end

function HotUpdateView:set_mid_txt( txt )
	self.mid_txt.text = txt or ""
end

function HotUpdateView:set_right_txt( txt )
	self.right_txt = txt or ""
end

function HotUpdateView:set_per( per )
	self:show_slider()
	self.progressbar_slider.value = per
end

function HotUpdateView:show_slider()
	if not self.is_slider_visible then
		self.is_slider_visible = true
		self.slider_obj:SetActive(true)
	end
end

function HotUpdateView:set_progress_txt(step, cur, total)
	local txt = ""
	if step == 1 then
		txt = gf_localize_string("初始化...")

	elseif step == 2 then
		txt = gf_localize_string("对比本地版本信息。")

	elseif step == 3 then
		txt = gf_localize_string("加载服务器版本信息。")

	elseif step == 4 then-- 热更进度条
		local per = cur/total
		if per >= 1 then
			txt = gf_localize_string("更新完毕，进入游戏！")
			self.slider_obj:SetActive(false)
			
		elseif per == 0 then
			txt = gf_localize_string("开始从服务器加载新的资源")
		else
			txt = gf_localize_string(string.format("正在下载更新：%0.2f M/ %0.2f M ...", cur/m, total/m))
		end

		local speed = 0
		if self.last_time then
			speed = (cur - self.last_load)/(os.clock() - self.last_time)
		end

		self:set_per(cur/total)
		self:set_right_txt(gf_localize_string(string.format("总进度%%%0.1f", per)))
		self:set_left_txt(gf_localize_string(string.format("下载速度：%%%0.1fKB/S", speed)))
		self.last_load = cur
		self.last_time = os.clock()

	elseif step == 5 then
		txt = gf_localize_string("进入游戏...")
		self.slider_obj:SetActive(false)

	elseif step == 6 then

	elseif step == 7 then
		txt = gf_localize_string("请更新app版本！")

	elseif step == 8 then
		txt = gf_localize_string("文件下载失败，重新下载?")

	elseif step == 9 then
		txt = gf_localize_string("校验列表对比中")

	elseif step == 10 then
		txt = gf_localize_string("加载服务器校验列表")

	elseif step == 11 then
		txt = gf_localize_string("清理旧的缓存")
		
	end

	self:set_mid_txt(txt)
	print(txt)
	return txt
end

return HotUpdateView
