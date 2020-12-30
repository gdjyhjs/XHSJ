--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-03 20:23:31
--]]

local Enum = require("enum.enum")
local ChatTools = require("models.chat.chatTools")
local Chat = class(function ( self, ui, item_obj )
	self.ui = ui
	self.item_obj = item_obj
	self:init()
end)

local max_chat_count = 30 -- 最大聊天框数量
local font_size = 20 -- 文本字体大小
local show_message_count = 0 -- 显示的聊天数量
local cha_window_max_width = 420

function Chat:init()
	--获取聊天数据类
	self.chat_data = LuaItemManager:get_item_obejct("chat")
	local ref = self.ui.refer:Get("chatRef")
	self.gss_text=ref:Get("gss_text")
	self.gss_layout=ref:Get("gss_layout")
	self.gss_tf = self.gss_text.transform
	--获取展开图标tf
	self.chatWindownTf = ref:Get("chatWindownTf")
	self.unfoldTf = ref:Get("unfoldTf")
	self.chatObjs = {}
	local chatObj = ref:Get("chatObj")
	local root = ref:Get("contentRoot")
	self.contenElement = root:GetComponent("UnityEngine.UI.LayoutElement")
	show_message_count = 0
	chatObj:SetActive(true)
	--富文本点击事件
	local function cb( arg )
		ChatTools:text_on_click(arg)
	end
	local function tc()
		self:open_main_chat()
	end
	local t = chatObj:GetComponent("UnityEngine.UI.Text")
	t.OnHrefClickFn=cb
	t.OnTextClickFn=tc
	--创建聊天框
	for i=1,max_chat_count do
		local obj = LuaHelper.InstantiateLocal(chatObj,root)
		local item = {}
		local ref = obj:GetComponent("ReferGameObjects")
		item.obj = obj
		item.chatText = obj:GetComponent("UnityEngine.UI.Text")
		item.channelBg = ref:Get("channel_bg")
		item.channelName = ref:Get("channel_name")
		item.tf = obj.transform
		item.chatText.OnHrefClickFn=cb
		item.chatText.OnTextClickFn=tc
		table.insert(self.chatObjs,1,item)
		obj:SetActive(false)
	end
	-- self.chat_show_hide_objs={}
	-- self.chat_show_hide_objs[#self.chat_show_hide_objs+1]=LuaHelper.FindChild(self.ui.root,"zuoshanghead")
	-- self.chat_show_hide_objs[#self.chat_show_hide_objs+1]=LuaHelper.FindChild(self.ui.root,"leftcenter")
	-- self.chat_show_hide_objs[#self.chat_show_hide_objs+1]=LuaHelper.FindChild(self.ui.root,"joystick")
	-- self.chat_show_hide_objs[#self.chat_show_hide_objs+1]=LuaHelper.FindChild(self.ui.root,"liaotian")

	--更改录音按钮名称
	LuaHelper.FindChild(self.ui.root,"duiyuyinBtn").name="recordBtn_"..Enum.CHAT_CHANNEL.TEAM
	LuaHelper.FindChild(self.ui.root,"junyuyinBtn").name="recordBtn_"..Enum.CHAT_CHANNEL.ARMY_GROUP
	LuaHelper.FindChild(self.ui.root,"shiyuyinBtn").name="recordBtn_"..Enum.CHAT_CHANNEL.WORLD

	self.scroll = ref:Get("chatScroll")
end

function Chat:on_click(item_obj, obj, arg)
	local cmd=obj.name
	if cmd=="unfoldBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:unfold_liaotian()
	elseif cmd == "chatView" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_main_chat()
	end
end

function Chat:on_receive( msg, id1, id2, sid )
 	if id1 == ClientProto.UpdateChatMessage then
 		if ChatTools:is_receive_chat(Enum.CHAT_CHANNEL.MAIN_UI,msg.channel) then
 			if self.gss_tf.gameObject.activeInHierarchy then
 				if self.hide_cache then
 					for i,v in ipairs(self.hide_cache) do
 						self:text_update(v)
 					end
 					self.hide_cache = nil
 				end
				self:text_update(msg)
			else
				if not self.hide_cache then
					self.hide_cache = {}
				end
				self.hide_cache[#self.hide_cache+1] = msg
			end
	    end
 	end
end

--展开聊天框
function Chat:unfold_liaotian()
	if self.unfold then
		self.unfold=false
		self.chatWindownTf.offsetMax = Vector2(self.chatWindownTf.offsetMax.x,149)	--修改聊天框高度
		self.contenElement.preferredHeight = 120
		self.unfoldTf.eulerAngles=Vector3(0,0,90)	--修改按钮朝向
	else
		self.unfold=true
		self.chatWindownTf.offsetMax = Vector2(self.chatWindownTf.offsetMax.x,222)
		self.contenElement.preferredHeight = 188
		self.unfoldTf.eulerAngles=Vector3(0,0,270)
	end
end

function Chat:open_main_chat()
	LuaItemManager:get_item_obejct("chat"):open_public_chat_ui()
end

function Chat:close_main_chat()
	LuaItemManager:get_item_obejct("chat"):open_public_chat_ui(false)
end

function Chat:text_update(chat_info)
	gf_print_table(chat_info,"主界面要添加消息")
	-- local content = type(chat_info.content) == "table" and chat_info.content.content or "♫"
	local content = chat_info.content

	-- 取出第一个聊天框，放到最后面
	local chat_item = self.chatObjs[#self.chatObjs]
	table.remove(self.chatObjs,#self.chatObjs)
	table.insert(self.chatObjs,1,chat_item)
	if show_message_count < max_chat_count then
		show_message_count = show_message_count + 1
		chat_item.channelBg.gameObject:SetActive(true)
		chat_item.obj:SetActive(true)
	else
		chat_item.tf:SetAsLastSibling()
	end
	if chat_info.roleInfo then
		if type(content) == "table" then -- 语音消息
			content = string.format("　　　<a href=%d,%d><color=%s>[%s]</color></a>：%s"
				,ClientEnum.CHAT_TYPE.PLAYER,chat_info.roleInfo.roleId
				,gf_get_text_color(ClientEnum.SET_GM_COLOR.MAINUI_CHAT_NAME)
				,chat_info.roleInfo.name,"<color=#3FD7FF>"..content.time.."秒　♫　</color>"..content.content)
			print("主界面添加消息 消息类型:语音消息 内容",content)
		else

			if string.find(content,"<quad.-/>") == 1 then -- 表情开头加个空格
				content = "　"..content
			end
			
			content = string.format("　　　<a href=%d,%d><color=%s>[%s]</color></a>：%s"
				,ClientEnum.CHAT_TYPE.PLAYER,chat_info.roleInfo.roleId
				,gf_get_text_color(ClientEnum.SET_GM_COLOR.MAINUI_CHAT_NAME)
				,chat_info.roleInfo.name,content)
			print("主界面添加消息 消息类型:文字消息 内容",content)
		end
	else
		content = string.format("　　　%s"
			,content)
		print("主界面添加消息 消息类型:系统消息 内容",content)
	end
	content = string.gsub(content,"size=%d+ width=1/>","size="..(font_size).." width=1/>")
	self.gss_layout.enabled = false
	self.gss_text.text = gf_remove_rich_text(content,8)
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.gss_tf) -- 立即重建布局
	if self.gss_tf.sizeDelta.x > cha_window_max_width then
		self.gss_layout.preferredWidth = cha_window_max_width
		self.gss_layout.enabled = true
		UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.gss_tf) -- 立即重建布局
	end
	local size = self.gss_tf.sizeDelta

	chat_item.tf.sizeDelta = Vector2(cha_window_max_width,size.y+5)
	local data = ConfigMgr:get_config("chat_channel")[chat_info.channel]
	chat_item.chatText.text = content
	local channel_color = gf_get_color2(data.font_color)
	chat_item.chatText.color = channel_color
	chat_item.channelName.text = ChatTools:get_chat_label_name(chat_info.channel)
	gf_setImageTexture(chat_item.channelBg,data.label_cion) -- 改标签图片
	-- chat_item.channelBg.color = channel_color -- 不知道为什么手机上图标一直显示白色的那张，这里顺便改一下颜色
	-- gf_error_tips("频道"..chat_info.channel.." 颜色"..data.font_color.." 图标"..chat_info.channel)
	-- local chat_emoji_size = ConfigMgr:get_config("t_misc").chat_emoji_size
	-- chat_item.channelBg.transform.anchoredPosition = Vector2(24,-chat_emoji_size+8)

	--聊天置底
	self.scroll.verticalNormalizedPosition = 0
end

return Chat