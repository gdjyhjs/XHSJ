--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-06-15 17:38:50
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Keyboard = LuaItemManager:get_item_obejct("keyboard")
Keyboard.priority = ClientEnum.PRIORITY.KEYBOARD
--UI资源
Keyboard.assets=
{
    View("keyboardView", Keyboard) 
}

local pivots = {
	center=Vector2(0.5,0.5),
	top=Vector2(0.5,1),
	bottom=Vector2(0.5,0),
	left=Vector2(0,0.5),
	right=Vector2(1,0.5),
	leftTop=Vector2(0,1),
	leftBottom=Vector2(0,0),
	rightTop=Vector2(1,1),
	rightBottom=Vector2(1,0),
}

--position 传字符串 参考pivots
function Keyboard:get_pivots(position)
	return pivots[position] or pivots["center"]
end

--点击事件
function Keyboard:on_click(obj,arg)
	self:call_event("keyboard_view_on_click", false, obj, arg)
end

--初始化函数只会调用一次
function Keyboard:initialize()
	print("键盘 数据初始化完毕")
end

function Keyboard:get_ui(ui)
	if ui then
		self.ui = ui
	end
	return self.ui or self.assets[1]
end

--[[通用小键盘
inputText(必填) 文本 		类型：UnityEngine.UI.Text 需要修改的文本

maxValue 		最大值		类型：整数

minValue		最小值		类型：整数

pos				位置		可选类型1：UnityEngine.Vector2 		
							可选类型2：字符串 
							默认"center"		定义轴心相对锚点的位置

pivot			轴心		可选类型1：UnityEngine.Vector2 		
							可选类型2：字符串 
							默认"center"		定义键盘的中心点，以设置坐标，默认在中心

anchor			锚点		可选类型1：UnityEngine.Vector2 
							可选类型2：字符串 
							默认"leftBottom"	锚点为屏幕左下

initValue		初始值		类型：字符串或整数

exit_fun		退出方法	类型：function(文本字符串,自定义参数)

ep				退出方法的参数

maxBtnValue		如果max按钮需要独立一个值作为最大值，就传这里吧

--默认小键盘出现在屏幕正中间  锚点在屏幕左下边，轴心在自身中间，位置在屏幕中间，即相对屏幕左下边640,360的位置
]]
function Keyboard:use_number_keyboard(inputText,maxValue,minValue,pos,pivot,anchor,initValue,exit_fun,ep,maxBtnValue)
	print("文本",inputText)
	print("最大值",maxValue)
	print("最小值",minValue)
	print("位置",pos)
	print("轴心",pivot)
	print("锚点",anchor)
	print("初始值",initValue)
	print("退出方法",exit_fun)
	print("退出方法的参数",ep)
	print("如果max按钮需要独立一个值作为最大值，就传这里吧",maxBtnValue)

	if self:get_ui() then
		self:get_ui():use_number_keyboard(inputText,maxValue,minValue,pos,pivot,anchor,initValue,exit_fun,ep,maxBtnValue)
	end
end

--[[


local a=UnityEngine.GameObject.Find("txt_open_time")
a=a:GetComponent("UnityEngine.UI.Text")
local b = LuaItemManager:get_item_obejct("keyboard")

b:use_number_keyboard(a,nil,nil,nil,nil,nil,nil,function(c,b)
print("xxxxxxxxxxxxxxxxxxxxxx")
	print(c,b)
end,1111)

]]