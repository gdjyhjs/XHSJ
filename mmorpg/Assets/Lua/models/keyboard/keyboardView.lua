--[[--
--
-- @Author:HunagJunShan
-- @DateTime:2017-06-15 17:38:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Vector2 = UnityEngine.Vector2
local Screen = UnityEngine.Screen

local KeyboardView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "keyboard.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function KeyboardView:on_asset_load(key,asset)
	self:hide()
	print("键盘ui加载完毕")
	self.item_obj:register_event("keyboard_view_on_click", handler(self, self.on_click))
	self:init_ui()
end

function KeyboardView:init_ui()
	self.number_keyboard=LuaHelper.FindChild(self.root,"number_keyboard")
	self.number_keyboard:SetActive(false)
	print("键盘初始化完毕")
	print("键盘",self.number_keyboard)
	if self.parm then
		self:use_number_keyboard(self.parm[1],self.parm[2],self.parm[3],self.parm[4],self.parm[5],self.parm[6],self.parm[7],self.parm[8],self.parm[9],self.parm[10])
	else

	end
end

function KeyboardView:use_number_keyboard(inputText,maxValue,minValue,pos,pivot,anchor,initValue,exit_fun,ep,max_btn_value)
	if not self.number_keyboard then
		self.item_obj:add_to_state()
		self.parm={inputText,maxValue,minValue,pos,pivot,anchor,initValue,exit_fun,ep}
		return
	end

	self.cur_keyboard=self.number_keyboard
	self.cur_keyboard:SetActive(true)
	if not pivot then
		pivot = self.item_obj:get_pivots("center")
	elseif type(pivot)=="string" then
		pivot = self.item_obj:get_pivots(pivot) or self.item_obj:get_pivots("center")
	end
	if not anchor then
		anchor = self.item_obj:get_pivots("leftBottom")
	elseif type(anchor)=="string" then
		anchor = self.item_obj:get_pivots(anchor) or self.item_obj:get_pivots("leftBottom")
	end
	if not pos then
		pos = self.item_obj:get_pivots("center")
		pos = Vector2(pos.x*1280,pos.y*720)
	elseif type(pos)=="string" then
		pos = self.item_obj:get_pivots(pos) or self.item_obj:get_pivots("center")
		pos = Vector2(pos.x*1280,pos.y*720)
	end
	print("初始化键盘 最终键盘位置",pos)
	print(self.number_keyboard.transform.anchoredPosition)
	self.number_keyboard.transform.pivot=pivot
	self.number_keyboard.transform.anchorMax=anchor
	self.number_keyboard.transform.anchorMin=anchor
	self.number_keyboard.transform.anchoredPosition=pos

	self.init_value=tonumber(inputText.text)
	self.max_value=maxValue
	self.min_value=minValue
	self.cur_value=initValue or nil
	self.input_text=inputText
	self.max_btn_value=max_btn_value

	self:show()

	self.exit_fun=exit_fun
	self.ep=ep
end

function KeyboardView:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了键盘",cmd)
	if cmd == "exit_keyboard" then --退出
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:exit()

	elseif string.find(cmd,"keyboard_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local cmf = string.split(cmd,"_")[2]
		if cmf == "backspace" then --退格
			self:input_backspace()
		elseif cmf == "max" then --最大值
			self:input_max()
		else
			self:input_value(cmf)
		end
		self:set_value()
	end

end

function KeyboardView:set_value()
	print("设置值",self.cur_value)
	if self.input_text and self.input_text.text then
		self.input_text.text=self.cur_value
	end
end

function KeyboardView:input_backspace()
	if self.cur_value then
		self.cur_value = string.sub(tostring(self.cur_value),1,-2)
	end
end

function KeyboardView:input_max()
	if self.max_value then
		self.cur_value = self.max_btn_value or self.max_value
	end
end

function KeyboardView:input_value(value)
	self.cur_value = self.cur_value and self.cur_value..value or value
	self.cur_value = tonumber(self.cur_value)
	if self.max_value and self.max_value and self.cur_value>self.max_value then
		self.cur_value = self.max_value
	end
	if self.min_value and self.cur_value and self.cur_value<self.min_value then
		self.cur_value = self.min_value
	end
end

function KeyboardView:on_showed()
	
end

function KeyboardView:exit()
	self.cur_keyboard:SetActive(false)
	if self.exit_fun then
		self.exit_fun(self.cur_value or self.init_value or self.max_value or self.min_value or 0,self.ep)
	end
	self.cur_keyboard=nil
	self.init_value=nil
	self.cur_value=nil
	self.max_value=nil
	self.min_value=nil
	self.input_text=nil
	self.cur_keyboard=nil
	self:hide()
end

function KeyboardView:on_hided()
end

-- 释放资源
function KeyboardView:dispose()
    self._base.dispose(self)
 end

return KeyboardView

