--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-28 15:06:31
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local res_err = {
	[200] = "提交成功,感谢您的宝贵意见",
	[400] = "提交失败",
}
local CustomerServiceView=class(UIBase,function(self)
	self.item_obj = LuaItemManager:get_item_obejct("setting")
    UIBase._ctor(self, "customer_service.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CustomerServiceView:on_asset_load(key,asset)
	self.choose_toggle = {}
	self.choose_toggle[1] = self.refer:Get(1)
	self.choose_toggle[2] = self.refer:Get(2)
	self.choose_toggle[3] = self.refer:Get(3)
	self.txt_question = {}
	self.txt_question[1] = self.refer:Get(4)
	self.txt_question[2] = self.refer:Get(5)
	self.txt_question[3] = self.refer:Get(6)
	StateManager:register_view(self)
end


function CustomerServiceView:on_click(obj,arg)
	local cmd  = obj.name
	print()
	if cmd == "customer_service_commit_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		-- self.refer:Get("describeInputField").text ="系统机型"..UnityEngine.SystemInfo.deviceModel.."\n"..
		-- "显卡名称"..UnityEngine.SystemInfo.graphicsDeviceName.."\n"..
		-- "系统名称"..UnityEngine.SystemInfo.operatingSystem.."\n"..
		-- "处理器名称"..UnityEngine.SystemInfo.processorType
		self:submit_question()
	elseif cmd == "toggleSuggest" or cmd == "toggleFeedback" or cmd == "toggleCommitBUG" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	elseif cmd == "customer_service_close_btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "describeInputField"  then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("哦哦",arg.text)
		arg.text = filterChar(arg.text)
	elseif cmd == "contactInputField" then 
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("哦哦",arg.text)
		arg.text = filterChar(arg.text)
	elseif cmd == "titleInputField" then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("哦哦",arg.text)
		arg.text = filterChar(arg.text)
	end
end

function CustomerServiceView:submit_question()
	local tp = 0
	local title = ""
	local contact = ""
	local content = ""
	local choose = nil
	for k,v in pairs(self.choose_toggle) do
		if v.isOn then
			choose = true
			tp = k
			break
		end
	end
	if not choose then
		gf_message_tips("还未勾选意见项，不能提交")
		gf_mask_show(false)
		return
	end
	for k,v in pairs(self.txt_question) do
		if v.text == "" then
			if k == 1 then
				gf_message_tips("标题为空，不能提交")
			elseif k == 2 then
				gf_message_tips("联系方式为空，不能提交")
			elseif k == 3 then
				gf_message_tips("描述为空，不能提交")
			end
			gf_mask_show(false)
			return
		end
	end
	title =self.txt_question[1].text  
	contact=self.txt_question[2].text 
	content=self.txt_question[3].text
	-- gf_message_tips("")
	gf_mask_show(false)

	local url = "http://192.168.0.127:81/index.php/index/suggest/index"
	local roleid = LuaItemManager:get_item_obejct("game"):getId()
	local serverid = LuaItemManager:get_item_obejct("game"):getServerId()
	local userid = SdkMgr:get_uid() or 0
	local curl = string.format("%s?type=%s&title=%s&contact=%s&content=%s&roleid=%s&serverid=%s&userid=%s",url,tp,title,contact,content,roleid,serverid,userid)
	local on_req_comp = function(req)
		print("啊啊1",req.data)
		gf_mask_show(false)
		local err = json:decode(req.data).code
		print("啊啊2",err)
		LuaHelper.eventSystemCurrentSelectedGameObject = self.txt_question[3].gameObject
		self.refer:Get(8).text =""
		gf_message_tips(res_err[err] or res_err[400])
	end
	local on_err = function()
		gf_mask_show(false)
		gf_message_tips(res_err[400])
	end
	print("啊啊3",curl)
	Loader:get_http_data(curl,nil,String,on_req_comp,on_err)


	-- self.refer:Get(7):sendtxtToPhp(self.refer:Get(7).url.."?name=lyj&pwd=aaaa8888")
	-- self:dispose()
end

-- 释放资源
function CustomerServiceView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return CustomerServiceView

