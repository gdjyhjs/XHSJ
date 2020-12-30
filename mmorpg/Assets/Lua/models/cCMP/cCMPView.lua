--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-26 15:16:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local CCMPView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "ccmp.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CCMPView:on_asset_load(key,asset)
    self.item_obj:register_event("ccmp_on_click", handler(self, self.on_click))
    self.item_obj:register_event("ccmp_value_change", handler(self, self.value_change))

	self.txt_content=LuaHelper.FindChildComponent(self.root,"contentTxt","UnityEngine.UI.Text")
	self.check_toggle=LuaHelper.FindChildComponent(self.root,"check_toggle","UnityEngine.UI.Toggle")
	self.check_content_text=LuaHelper.FindChildComponent(self.root,"check_content_text","UnityEngine.UI.Text")
	self.check_input=LuaHelper.FindChildComponent(self.root,"check_input","UnityEngine.UI.InputField")
	self.check_input_prompt_message=LuaHelper.FindChildComponent(self.root,"prompt_message","UnityEngine.UI.Text")
	self.ok_check_button=LuaHelper.FindChildComponent(self.root,"sureBtn","UnityEngine.UI.Button")
	self.only_ok_check_button=LuaHelper.FindChildComponent(self.root,"sureBtn2","UnityEngine.UI.Button")
	self.only_ok_check_button.gameObject.name="sureBtn"
	self.cancle_check_button=LuaHelper.FindChildComponent(self.root,"cancleBtn","UnityEngine.UI.Button")
	self.messages={}
	self.sending=false
	self:hide()

	-- 测试 范例
	-- local function test(a)
	-- 	print(a)
	-- end
	-- for i=1,10 do
	-- 	self:add_message("第"..i.."条消息",test,"sure:"..i,test,"cancle"..i)
	-- end
end

function CCMPView:on_click(item_obj,obj,arg)
	local p = self.messages.cur.check_c
	if p then
		if type(self.messages.cur.default_value) == "boolean" then
			p = self.check_toggle.isOn
		elseif type(self.messages.cur.default_value) == "string" then
			p = self.check_input.text
		end
	end
	if obj.name=="sureBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if(self.messages.cur)then
			if(self.messages.cur.sure_fun~=nil)then
				print("执行确认方法")
				self.messages.cur.sure_fun(self.messages.cur.sp,self.messages.cur.check_c and  self.check_toggle.isOn,self.check_input.text)
			end
			self.messages.cur=nil
		end
		self:message_cmp()
	elseif obj.name=="cancleBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		if(self.messages.cur)then
			if(self.messages.cur.cancle_fun)then
				self.messages.cur.cancle_fun(self.messages.cur.cp,self.messages.cur.check_c and self.check_toggle.isOn)
			end
		end
		self.messages.cur=nil
		self:message_cmp()
	elseif obj.name == "exit_ccmp" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		if(self.messages.cur)then
			if(self.messages.cur.xcancel_func)then
				self.messages.cur.xcancel_func()
			end
		end
		self.messages.cur=nil
		self:message_cmp()
	elseif obj.name == "check_toggle" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	end
end

function CCMPView:value_change(item_obj,obj,arg)
	self:set_button_interactable()
end

--添加消息	显示内容	确认按钮回调方法，参数	取消按钮回调方法，参数
function CCMPView:add_message(content,sure_fun,sp,cancle_fun,cp,check_c,default_value,ok_must_check,cancle_muse_check,sure_btn_name,cancle_btn_name,xcancel_func,auto_sure_time,auto_cancle_time)
	local item = {}
	item.content=content
	item.sure_fun=sure_fun
	item.sp=sp
	item.cancle_fun=cancle_fun
	item.cp=cp
	item.check_c=check_c
	item.default_value=default_value
	item.ok_must_check=ok_must_check
	item.cancle_muse_check=cancle_muse_check
	item.sure_btn_name=sure_btn_name
	item.cancle_btn_name=cancle_btn_name
	item.xcancel_func = xcancel_func
	item.auto_sure_time=auto_sure_time
	item.auto_cancle_time = auto_cancle_time
	self.messages[#self.messages+1]=item

	if not self.sending then
		self:message_cmp()
	end
end

--一个弹框   框是一个个弹的，上一个被点掉才会弹下一个
function CCMPView:message_cmp()
	self:stop_timer() -- 停止计时器

	self:hide()
	if #self.messages>0 then
		self.sending=true
		self.ok_check_button.interactable=true
		self.cancle_check_button.interactable=true
		self.messages.cur=self.messages[1]
		self.txt_content.text=self.messages.cur.content or ""
		self:set_text_style()
		--修改按钮名字
		self.ok_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=self.messages.cur.sure_btn_name or "确认"
		self.only_ok_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=self.messages.cur.sure_btn_name or "确认"
		self.cancle_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=self.messages.cur.cancle_btn_name or "取消"
		print("--判断单确认按钮还是 一对按钮",not self.messages.cur.cancle_fun,not self.messages.cur.cp)
		if not self.messages.cur.cancle_fun and not self.messages.cur.cp then
			self.ok_check_button.gameObject:SetActive(false)
			self.cancle_check_button.gameObject:SetActive(false)
			self.only_ok_check_button.gameObject:SetActive(true)
		else
			self.ok_check_button.gameObject:SetActive(true)
			self.cancle_check_button.gameObject:SetActive(true)
			self.only_ok_check_button.gameObject:SetActive(false)
		end
		if self.messages.cur.check_c then
			--有确认项
			if self.messages.cur.default_value==nil then
				self.messages.cur.default_value = false --默认false
			end
			if type(self.messages.cur.default_value) == "boolean" then
				LuaHelper.eventSystemCurrentSelectedGameObject = self.check_toggle.gameObject
				self.check_toggle.isOn=self.messages.cur.default_value	--默认勾选？
				self.check_content_text.text=self.messages.cur.check_c
				self.check_toggle.gameObject:SetActive(true)
				self.check_input.gameObject:SetActive(false)
			elseif type(self.messages.cur.default_value) == "string" then
				self.check_input.text=""
				self.check_input_prompt_message.text=self.messages.cur.default_value
				self.check_toggle.gameObject:SetActive(false)
				self.check_input.gameObject:SetActive(true)

			end
			self:set_button_interactable()
		else
			self.check_toggle.gameObject:SetActive(false)
			self.check_input.gameObject:SetActive(false)
		end

		self:open_timer()-- 如果需要计时器

		-- ok
		table.remove(self.messages,1)
		self:show()
	else
		self.sending=false
	end
end

--设置按钮是否可被点击
function CCMPView:set_button_interactable()
	if self.messages.cur and self.messages.cur.check_c then
		if type(self.messages.cur.default_value) == "boolean" then
			if self.messages.cur.ok_must_check then
				self.ok_check_button.interactable=self.check_toggle.isOn
			end
			if self.messages.cur.cancle_muse_check then
				self.cancle_check_button.interactable=self.check_toggle.isOn
			end
		elseif type(self.messages.cur.default_value) == "string" then
			if self.messages.cur.ok_must_check then
				self.ok_check_button.interactable=self.check_input.text==self.messages.cur.check_c
			end
			if self.messages.cur.cancle_muse_check then
				self.cancle_check_button.interactable=self.check_input.text==self.messages.cur.check_c
			end
		end
	end
end

--设置文本框格式
function CCMPView:set_text_style()
	local t = self.txt_content
	local textWidth = LuaHelper.GetStringWidth(t.text,t)
	if string.find(t.text,"\n") or textWidth<t.transform.sizeDelta.x then
		-- 居中
		t.alignment = 1
	else
		-- 左对齐
		t.alignment = 0
	end
end

-- 释放资源
function CCMPView:dispose()
    self.item_obj:register_event("ccmp_on_click", nil)
    self._base.dispose(self)
end

-- 判断打开计时器
function CCMPView:open_timer()
	local t = self.messages.cur.auto_sure_time or self.messages.cur.auto_cancle_time
	if t then
		local cb = function()
			t = t - 1
			if t<0 then
				if self.messages.cur.auto_sure_time then
					if(self.messages.cur)then
						if(self.messages.cur.sure_fun~=nil)then
							print("执行确认方法")
							self.messages.cur.sure_fun(self.messages.cur.sp,self.messages.cur.check_c and  self.check_toggle.isOn,self.check_input.text)
						end
						self.messages.cur=nil
					end
					self:message_cmp()
				elseif self.messages.cur.auto_cancle_time then
					if(self.messages.cur)then
						if(self.messages.cur.cancle_fun)then
							self.messages.cur.cancle_fun(self.messages.cur.cp,self.messages.cur.check_c and self.check_toggle.isOn)
						end
					end
					self.messages.cur=nil
					self:message_cmp()
				end
			else
				if self.messages.cur.auto_sure_time then
					self.ok_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=(self.messages.cur.sure_btn_name or "确认").."("..t..")"
					self.only_ok_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=(self.messages.cur.sure_btn_name or "确认").."("..t..")"
				elseif self.messages.cur.auto_cancle_time then
					self.cancle_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=(self.messages.cur.cancle_btn_name or "取消").."("..t..")"
				end
			end
		end

		if self.messages.cur.auto_sure_time then
			self.ok_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=(self.messages.cur.sure_btn_name or "确认").."("..t..")"
			self.only_ok_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=(self.messages.cur.sure_btn_name or "确认").."("..t..")"
		elseif self.messages.cur.auto_cancle_time then
			self.cancle_check_button:GetComponentInChildren("UnityEngine.UI.Text").text=(self.messages.cur.cancle_btn_name or "取消").."("..t..")"
		end

		self.down_timer = Schedule(cb,1)
	end
end

-- 判断关闭计时器
function CCMPView:stop_timer()
	if self.down_timer then
		self.down_timer:stop()
		self.down_timer = nil
	end
end

return CCMPView