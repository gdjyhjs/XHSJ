--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-05 14:32:37
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Input = UnityEngine.Input
local Screen = UnityEngine.Screen

local TestView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "test.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function TestView:on_asset_load(key,asset)
	self.item_obj:register_event("test_on_click", handler(self, self.on_click))
	self.tf_testbtn=LuaHelper.FindChild(self.root.transform,"debugBtn")

	self.input_c=LuaHelper.FindChildComponent(self.root,"cmdIF","UnityEngine.UI.InputField")
	self.input_t=LuaHelper.FindChildComponent(self.root,"typeIF","UnityEngine.UI.InputField")
	self.input_v=LuaHelper.FindChildComponent(self.root,"valueIF","UnityEngine.UI.InputField")
	self.input_s=LuaHelper.FindChildComponent(self.root,"strIF","UnityEngine.UI.InputField")
	self.input_s1=LuaHelper.FindChildComponent(self.root,"sid1IF","UnityEngine.UI.InputField")
	self.input_s2=LuaHelper.FindChildComponent(self.root,"sid2IF","UnityEngine.UI.InputField")
	self.input_msg=LuaHelper.FindChildComponent(self.root,"msgIF","UnityEngine.UI.InputField")
	self.input_draft=LuaHelper.FindChildComponent(self.root,"draftIF","UnityEngine.UI.InputField")
	self.input_code=LuaHelper.FindChildComponent(self.root,"codeIF","UnityEngine.UI.InputField")
	-- print("准备初始化草发哦")
	self.input_draft.text=UnityEngine.PlayerPrefs.GetString("draftIF") or UnityEngine.PlayerPrefs.GetString("input_draft") or ""
	self.input_msg.text=UnityEngine.PlayerPrefs.GetString("msgIF","")
	self.input_s2.text=UnityEngine.PlayerPrefs.GetString("sid2IF","")
	self.input_s1.text=UnityEngine.PlayerPrefs.GetString("sid1IF","")
	self.input_s.text=UnityEngine.PlayerPrefs.GetString("strIF","")
	self.input_v.text=UnityEngine.PlayerPrefs.GetString("valueIF","")
	self.input_t.text=UnityEngine.PlayerPrefs.GetString("typeIF","")
	self.input_c.text=UnityEngine.PlayerPrefs.GetString("cmdIF","")
	self.input_code.text=UnityEngine.PlayerPrefs.GetString("codeIF","")
	-- print("初始化草稿",self.input_draft.text)
	self.tf_testbtn.eulerAngles= self.tf_testbtn.eulerAngles.z==180 and Vector3(0,0,0) or Vector3(0,0,180)

	self.input_msg.gameObject:SetActive(UnityEngine.PlayerPrefs.GetInt("MhideBtn",1)==1)
	self.input_draft.gameObject:SetActive(UnityEngine.PlayerPrefs.GetInt("DhideBtn",1)==1)
	self.input_code.gameObject:SetActive(UnityEngine.PlayerPrefs.GetInt("ChideBtn",1)==1)

	self.canvas_group=self.root:GetComponentInChildren("UnityEngine.CanvasGroup")
	-- print("获取透明组件")
	-- print(self.canvas_group)
	self.canvas_group.alpha= self.tf_testbtn.eulerAngles.z==180 and 0.05 or 0.8

	-- print("调节字体大小")
	self.msgSlider=LuaHelper.FindChildComponent(self.root,"msgSlider","UnityEngine.UI.Slider")
	self.codeSlider=LuaHelper.FindChildComponent(self.root,"codeSlider","UnityEngine.UI.Slider")
	self.draftSlider=LuaHelper.FindChildComponent(self.root,"draftSlider","UnityEngine.UI.Slider")
	self.msg_text=LuaHelper.FindChildComponent(self.input_msg.gameObject,"Text","UnityEngine.UI.Text")
	self.code_text=LuaHelper.FindChildComponent(self.input_code.gameObject,"Text","UnityEngine.UI.Text")
	self.draft_text=LuaHelper.FindChildComponent(self.input_draft.gameObject,"Text","UnityEngine.UI.Text")
	local msv = UnityEngine.PlayerPrefs.GetInt("msgSlider",20)
	self.msgSlider.value=msv
	self.msg_text.fontSize=msv
	local msv = UnityEngine.PlayerPrefs.GetInt("codeSlider",20)
	self.codeSlider.value=msv
	self.code_text.fontSize=msv
	local msv = UnityEngine.PlayerPrefs.GetInt("draftSlider",20)
	self.draftSlider.value=msv
	self.draft_text.fontSize=msv

	if UnityEngine.PlayerPrefs.GetInt("debugBtn",0)==1 then
		self:test_show()
	end

	if SHOW_PROFILER then
		LuaHelper.Find("Profiler"):GetComponent("ProfilerPanel").enabled=(UnityEngine.PlayerPrefs.GetInt("stateSwitch",1)==1 and true or false)
	end

	self.timer=0
	-- print("--注册每帧事件")
	gf_register_update(self) 
end

-- 释放资源
function TestView:dispose()
    self._base.dispose(self)
    -- gf_remove_update(self)
	self.item_obj:register_event("test_on_click", nil)
 end


 function TestView:on_click(item_obj,obj,arg)
 	print("点击测试",item_obj,obj,arg)
 	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
 	--print("点击作弊器按钮",cmd)
 	if cmd=="addItemBtn" then
 		-- print("添加物品测试")
 		local c = self.input_c.text
 		local t = self.input_t.text
 		local v = self.input_v.text
 		local s = self.input_s.text
 		v = tonumber(v)
 		t = tonumber(t)
 		local msg = {cmd=c,type=t,value=v,str=s}
 		gf_print_table(msg)
 		Net:send(msg,"base","Debug")
 	elseif cmd=="sendBtn" then
 		self:send_msg()
 	elseif string.find(cmd,"IF") then
		UnityEngine.PlayerPrefs.SetString(cmd,arg.text)
 	elseif cmd=="hideBtn" then
 		self:test_show()
 	elseif cmd=="debugBtn" then
 		self:test_show()
 	elseif cmd=="MhideBtn" then
 		self.input_msg.gameObject:SetActive(not self.input_msg.gameObject.activeSelf)
 		UnityEngine.PlayerPrefs.SetInt("MhideBtn",self.input_msg.gameObject.activeSelf and 1 or 0)
 	elseif cmd=="DhideBtn" then
 		self.input_draft.gameObject:SetActive(not self.input_draft.gameObject.activeSelf)
 		UnityEngine.PlayerPrefs.SetInt("DhideBtn",self.input_draft.gameObject.activeSelf and 1 or 0)
 	elseif cmd=="ChideBtn" then
 		self.input_code.gameObject:SetActive(not self.input_code.gameObject.activeSelf)
 		UnityEngine.PlayerPrefs.SetInt("ChideBtn",self.input_code.gameObject.activeSelf and 1 or 0)
 	elseif cmd=="codeBtn" then
 		self:user_code(obj)
 		
 	elseif cmd=="Button" then
 		self:testfunction(obj)

 	elseif cmd == "stateSwitch" then 
 		local profile = LuaHelper.Find("Profiler"):GetComponent("ProfilerPanel")
 		local isShow = profile.enabled 
 		profile.enabled = not isShow
 		UnityEngine.PlayerPrefs.SetInt("stateSwitch",profile.enabled and 1 or 0)

 	elseif cmd == "testScene" then
 		local mapId = 999999
		local mapinfo = ConfigMgr:get_config( "mapinfo" )[mapId]
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(mapId,mapinfo.delivery_posx,mapinfo.delivery_posy,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)

	elseif cmd == "open_ui_delay" then
		self:ui_delay_click()

	elseif cmd == "open_net_delay" then
		self:net_delay_click()
	elseif cmd == "open_model_delay" then
		self:model_delay_click()
 	end

 	if arg and tostring(arg)~="null" then
 		-- print("arg")
 		-- print(tostring(arg))
	 	if arg.name=="msgSlider" then
	 		self.msg_text.fontSize=arg.value
	 		UnityEngine.PlayerPrefs.SetInt("msgSlider",arg.value)
	 	elseif arg.name=="codeSlider" then
	 		self.code_text.fontSize=arg.value
	 		UnityEngine.PlayerPrefs.SetInt("codeSlider",arg.value)
	 	elseif arg.name=="draftSlider" then
	 		self.draft_text.fontSize=arg.value
	 		UnityEngine.PlayerPrefs.SetInt("draftSlider",arg.value)
	 	end
	 end

 end

function TestView:ui_delay_click()
	
	local time = tonumber(self.refer:Get(2).text) or OPEN_DELAY_UI_TIME
	OPEN_DELAY_UI_TIME = time
	OPEN_DELAY_UI = not OPEN_DELAY_UI

	if OPEN_DELAY_UI then
		self.refer:Get(1).text = "关闭ui延迟加载"
	else
		self.refer:Get(1).text = "开启ui延迟加载"
	end
end


function TestView:net_delay_click()
	
	local time = tonumber(self.refer:Get(4).text) or OPEN_DELAY_NET_TIME
	OPEN_DELAY_NET_TIME = time
	OPEN_DELAY_NET = not OPEN_DELAY_NET
	if OPEN_DELAY_NET then
		self.refer:Get(3).text = "关闭网络延迟"
	else
		self.refer:Get(3).text = "开启网络延迟"
	end
end

function TestView:model_delay_click()
	local time = tonumber(self.refer:Get(6).text) or OPEN_DELAY_MODEL_TIME
	OPEN_DELAY_MODEL_TIME = time
	OPEN_DELAY_MODEL = not OPEN_DELAY_MODEL
	if OPEN_DELAY_MODEL then
		self.refer:Get(5).text = "关闭模型延迟"
	else
		self.refer:Get(5).text = "开启模型延迟"
	end
end

 function TestView:send_msg()
 		local sid1=self.input_s1.text
 		local sid2=self.input_s2.text
 		local msg=self.input_msg.text
 		--local str = "local _="..msg..";do return _;end"
 		local str = "do return "..msg..";end"
 		-- print(str)
 		local f = loadstring(str)
 		-- if not f then print("输入有误") return end
 		local msg,s1,s2 = f()
 		-- print(msg,s1,s2)
 		sid1 = s1 or sid1
 		sid2 = s2 or sid2
 		-- print(msg,sid1,sid2)
 		Net:send(msg,sid1,sid2)
end

function TestView:user_code()
	local code = self.input_code.text
	local str=code
	local f = loadstring(str)
	if not f then print("输入有误") return end
	f()
end

 function TestView:on_update(dt)
 	if self.timer and self.timer>0 then
 		self.timer=self.timer-dt
 	end
 	if Input.GetKeyUp ("`") then
 		self.timer = self.timer +1
 		if self.timer>2 then
 			self:test_show()
 		end
 	end
 	if Input.GetMouseButtonDown(0) then
 		local pos = Input.mousePosition
 		if self.timer<=0 and pos.x>Screen.width*0.7 and pos.y>Screen.height*0.7 then
 			self.timer=0.5
 		elseif self.timer>0 and self.timer<1 and pos.x<Screen.width*0.3 and pos.y<Screen.height*0.3 then
 			if self.timer<0.5 then  self.timer=1 else  self.timer=1.5 end
 		elseif self.timer>1 and self.timer<1.5 and pos.x>Screen.width*0.7 and pos.y<Screen.height*0.3 then
 			self.timer=2
 		elseif self.timer>1.5 and pos.x<Screen.width*0.3 and pos.y>Screen.height*0.7 then
 			self.timer=2.5
 		else
 			self.timer=0
 		end
 		if self.timer>2 then
 			self:test_show()
 		end
 	end
 	if Input.GetMouseButtonDown(2) then
 		self:send_msg()
 	end
 end
 function TestView:test_show()
 			print("飘字    获得 test","显示")
 			self.root:SetActive(true)
 			-- self.item_obj:add_to_state()
	self.timer=0
	self.tf_testbtn.eulerAngles= self.tf_testbtn.eulerAngles.z==180 and Vector3(0,0,0) or Vector3(0,0,180)
	self.canvas_group.alpha= self.tf_testbtn.eulerAngles.z==180 and 0.05 or 0.8
	UnityEngine.PlayerPrefs.SetInt("debugBtn",self.tf_testbtn.eulerAngles.z==180 and 0 or 1)
 end

 function TestView:timer_fun()
 	-- print(Time.time)
 end

 function TestView:testfunction(obj)
 		
 end

return TestView