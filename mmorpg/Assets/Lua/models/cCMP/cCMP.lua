--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-26 15:16:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local CCMP = LuaItemManager:get_item_obejct("cCMP")
CCMP.priority = ClientEnum.PRIORITY.CCMP

--UI资源
CCMP.assets=
{
    View("cCMPView", CCMP)
}

--点击事件
function CCMP:on_click(obj,arg)
	self:call_event("ccmp_on_click", false, obj, arg)
	return true
end

--值改变事件
function CCMP:on_input_field_value_changed( obj,arg )
	self:call_event("ccmp_value_change",false,obj,arg)
end

--每次显示时候调用
function CCMP:on_showed( ... )

end

--初始化函数只会调用一次
function CCMP:initialize()
	
end

--[[
content 	string		弹框提示内容 		必填 
sure_fun 	function	确认按钮方法回调 	可选 
btn_name 	string		确认按钮改名 		可选
]]
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):only_ok_message("你掉线了")
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):only_ok_message("你掉线了",function() print("哈哈") end,"哈哈")
-- 只有确认按钮的弹框
function CCMP:only_ok_message(content,sure_fun,btn_name,auto_sure_time)
	self:add_message(content,sure_fun,nil,nil,nil,nil,nil,nil,nil,btn_name,nil,nil,auto_sure_time)
end


--[[
content 		string		弹框提示内容 		必填
sure_fun 		function	确认按钮方法回调 	可选 
cancle_fun  	function 	取消方法回调		可选 
sure_btn_name 	string		确认按钮改名 		可选 
cancle_btn_name string		取消按钮改名 		可选 
]]
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message("确认要丢弃物品吗")
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message("确认要丢弃物品吗",function() print("哈哈") end,function() print("呵呵") end,"哈哈","呵呵")
-- 有确认按钮和取消按钮的弹框
function CCMP:ok_cancle_message(content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name,one_btn,auto_sure_time,auto_cancle_time)
	self:add_message(content,sure_fun,nil,cancle_fun,one_btn==nil and 0 or nil,nil,nil,nil,nil,sure_btn_name,cancle_btn_name,nil,auto_sure_time,auto_cancle_time)
end


--[[
content 		string		弹框提示内容 			必填
default_value	boolean		默认是否勾选			可选
tips_content	string		勾选按钮前面的提示内容	可选
sure_fun 		function	确认按钮方法回调 		可选 
cancle_fun  	function 	取消方法回调			可选
sure_btn_name 	string		确认按钮改名 			可选 
cancle_btn_name string		取消按钮改名 			可选 
]]
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):toggle_message("确认请勾选",false)
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):toggle_message("1111",false,"确认请勾选",function(a,b) print(b) end,function(a,b) print(b) end,"哈哈","呵呵")
-- 带勾选框的提示框
function CCMP:toggle_message(content,default_value,tips_content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name,one_btn,auto_sure_time,auto_cancle_time)
	if default_value ==nil then
		default_value = false
	end
	self:add_message(content,sure_fun,nil,cancle_fun,one_btn==nil and 0 or nil,tips_content or "",default_value,nil,nil,sure_btn_name,cancle_btn_name,nil,auto_sure_time,auto_cancle_time)
end

--[[
content 		string		弹框提示内容 			必填
input_value		string		需要输入的内容			必填
tips_content	string		输入框的提示内容		可选
sure_fun 		function	确认按钮方法回调 		可选
cancle_fun  	function 	取消方法回调			可选
sure_btn_name 	string		确认按钮改名 			可选
cancle_btn_name string		取消按钮改名 			可选
]]
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):check_text_message("贵重物品丢弃请输入“删除”","删除")
-- 例子1 ： LuaItemManager:get_item_obejct("cCMP"):check_text_message("贵重物品丢弃请出入“删除”","删除","确认请勾选",function(a,b) print("确认") end,function(a,b) print("取消") end,"哈哈","呵呵")
-- 带输入框(需要输入特定文字确认)的提示框
function CCMP:check_text_message(content,input_value,tips_content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name,one_btn,auto_sure_time,auto_cancle_time)
	self:add_message(content,sure_fun,nil,cancle_fun,one_btn==nil and 0 or nil,input_value,tips_content,true,nil,sure_btn_name,cancle_btn_name,nil,auto_sure_time,auto_cancle_time)
end
































--[[
20170613更新   cancle_fun和cp 都为空的话，就只有确认按钮。如果不需要取消方法但需要取消按钮，让cancle_fun和cp为空 cp不为空。

普通提示框
local ccmp=LuaItemManager:get_item_obejct("cCMP")
local fun=function(a)
	print(a[1],a[2])
end
ccmp:add_message("公告：一些内容",fun,{"你好","大家好"},nil,0)


带勾选框的提示框
local ccmp=LuaItemManager:get_item_obejct("cCMP")
local fun=function(a,b)
	print(a,b)
end
ccmp:add_message("公告：一些内容",fun,nil,nil,nil,"今日不在提示",false)

--带输入框的提示框
local ccmp=LuaItemManager:get_item_obejct("cCMP")
local fun=function(a,b)
	print(a)
end
ccmp:add_message("确认要删除物品吗?请在下面输入\"删除\",以表决心,不可反悔!",fun,nil,nil,nil,"我要删除","请输入内容删除",true)
]]
--添加提示框消息
--（内容string，确认方法function，确认方法参数，取消方法function，取消方法参数，确认内容string，默认值bool=勾选/string=输入框，确认按钮必须确认bool，取消按钮必须确认bool）	




--这是统一方法，为了方便使用请使用上面的方法
--返回的方法参数（用户参数,空或勾选bool或输入的文本内容）
function CCMP:add_message(content,sure_fun,sp,cancle_fun,cp,check_c,default_value,ok_must_check,cancle_muse_check,sure_btn_name,cancle_btn_name,xcancel_func,auto_sure_time,auto_cancle_time)
	--print("CMMP~~~~~~~~~~~~~~",content,sure_fun,sp,cancle_fun,cp,check_c,default_value,ok_must_check,cancle_muse_check)
	self.assets[1]:add_message(content,sure_fun,sp,cancle_fun,cp,check_c,default_value,ok_must_check,cancle_muse_check,sure_btn_name,cancle_btn_name,xcancel_func,auto_sure_time,auto_cancle_time)
end
