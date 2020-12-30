--[[--
-- 游戏的一些设置
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]

-- 调试模式
DEBUG = true

OPEN_DELAY_UI  = false      	--测试功能 实时延迟加载ui
OPEN_DELAY_UI_TIME = 0.5

OPEN_DELAY_NET = false	 	    --测试功能 开启实时网络延迟
OPEN_DELAY_NET_TIME = 0.5

OPEN_DELAY_MODEL = false	 	--测试功能 开启实时模型延迟
OPEN_DELAY_MODEL_TIME = 0.5 		

SHOW_PROFILER = false
UI_RGB_A = false -- uguirab和alpha分离
IS_SDK = false -- 是否带sdk
OPEN_VOICE = false -- 是否开启语音

-- 正式版本去掉打印
if not DEBUG then
	print = function ( ... )
	end
end

UnityEngine_UI_Image = "UnityEngine.UI.Image"
if UI_RGB_A then
	UnityEngine_UI_Image = "UnityEngine.UI.SImage"
end