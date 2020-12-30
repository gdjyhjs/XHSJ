--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-03 09:56:55
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local heroData = require("models.hero.dataUse")
local chatTools = require("models.chat.chatTools")
local chatEnum = require("models.chat.chatEnum")

local message_max_width=258.1
local sys_message_max_width=400
local max_obj = 20 -- 同时加载的最大消息数量
local cur_min = 1
local cur_max = max_obj
local new_msg_count = 0
local chat_cache = {}
local max_name_length = 96 -- 聊天框输入的字符最大值
-- function set_sys_message_max_width(value)
-- 	sys_message_max_width = value
-- end

local PublicChat=class(UIBase,function(self,item_obj,open)
	if self:is_visible() then
		return
	end
    UIBase._ctor(self, "public_chat.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function PublicChat:on_asset_load(key,asset)
	if self.init then
		return
	end
	--修改聊天视窗适应
	self.refer:Get("main_chat_content_layoutElemen").minHeight = self.refer:Get("canvas").sizeDelta.y - 90
	print("视窗大小",self.refer:Get("main_chat_content_layoutElemen").minHeight)

	self.itemCache = {}
	self:init_ui()

	self.init=true
end

function PublicChat:init_ui()
	if not self.init then
		self.gss_text=self.refer:Get("gss_text")
		self.gss_layout=self.refer:Get("gss_layout")
		self.gss_tf = self.gss_text.transform

		-- print("--主聊天界面 聊天窗口 内容部分 消息")
		self.message_input_field=self.refer:Get("message_input_field") --输入框
		self.message_input_field.characterLimit = max_name_length

		self.item_obj.public_chat_input_field = self.message_input_field --给主ui设置聊天框
		--页签部分
		self.channel_change_btn_list = {}
		local chat_channel = ConfigMgr:get_config("chat_channel")
		local channel_change_btn = self.refer:Get("channel_change_btn")
		local channel_change_text = channel_change_btn:GetComponentInChildren("UnityEngine.UI.Text")

		self.main_chat_content_tf = self.refer:Get("main_chat_content") -- 主内容

		self.chat_content_scroll = self.refer:Get("chat_content_scroll") -- 滑动窗口
		print("<color=red>获取滑动窗口",self.chat_content_scroll,"</color>")

		-- local chat_content_scroll = LuaHelper.FindChild(self.root,"chat_content_scroll")
		local game = LuaItemManager:get_item_obejct("game")
		for i,v in ipairs(chat_channel) do  --创建频道
			channel_change_text.text = v.name
			self.channel_change_btn_list[i]={}
			local parent = channel_change_btn.transform.parent
			if parent.childCount > i then
				self.channel_change_btn_list[i].obj = parent:GetChild(i).gameObject
			else
				self.channel_change_btn_list[i].obj = LuaHelper.InstantiateLocal(channel_change_btn,parent.gameObject)
			end
			self.channel_change_btn_list[i].obj.name="channelChangePage_"..i
			self.channel_change_btn_list[i].btn = self.channel_change_btn_list[i].obj:GetComponent("UnityEngine.UI.Button")
			self.channel_change_btn_list[i].select = LuaHelper.FindChild(self.channel_change_btn_list[i].obj,"select")
		end

		self:level_up_open_channel_page(game.role_info.level)

		--获取录音按钮
		self.record_btn = self.refer:Get("record_btn")
		--默认选择频道
		self:change_channel(self.item_obj.curent_channel)
	end
end

--值改变事件
function PublicChat:on_input_field_value_changed( obj,arg )
	print("聊天视窗值变化",obj,arg)
	if arg == self.chat_content_scroll.gameObject then
		self:on_update()
	end
end

--点击事件
function PublicChat:on_click(obj, arg)
	print("点击了聊天视窗",obj, arg)
 	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
 -- 	if arg==self.chat_content_scroll then
	-- 	self:on_update()
	-- else
	if cmd=="exitMainChatBtn" then --退出主聊天界面
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
		--LuaItemManager:get_item_obejct("mainui"):get_ui().child_ui.chat:close_main_chat()
	elseif cmd=="horn_btn" then --喇叭
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.chat.trumpet")(self.item_obj)
	elseif cmd=="emoji_input_btn" then --打开表情输入按钮
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:open_emoji_ui(self.message_input_field)
	elseif cmd=="goToNewMsg" then --跳到最下
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		obj:SetActive(false)
		self:change_channel(self.item_obj.curent_channel)
	elseif cmd == "message_input_field" then -- 输入值的时候
		if self.message_input_field == arg then
			while(gf_get_string_length(arg.text)>max_name_length)do
				arg.text = string.sub(arg.text,1,-2)
			end
		end
	elseif string.find(cmd,"headIco_") and arg then --显示其他玩家tips
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("player"):show_player_tips(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"channelChangePage_") then --选频按钮
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		self:change_channel(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"friendTips_") then --玩家tips
	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("player"):show_player_tips(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd, "toModule_") then -- 功能跳转
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
		gf_open_model(tonumber(string.split(cmd,"_")[2]))
	elseif cmd=="message_send_btn" then --消息发送
	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:send_message()
	end
end
--值改变事件
function PublicChat:on_update()
	if self.init and self.chat_content_scroll then
		self:on_chat_content_scroll_move(self.chat_content_scroll.verticalNormalizedPosition)
	end
end
--升级更新启用的频道标签
function PublicChat:level_up_open_channel_page(lv)
	for i,v in ipairs(ConfigMgr:get_config("chat_channel")) do
		if lv>=v.page_level then
			self.channel_change_btn_list[i].obj:SetActive(true)
		end
	end
end
--变化频道选择
function PublicChat:change_channel(channel)
	if self.channel_change_btn_list.cur then
		self.channel_change_btn_list.cur.select:SetActive(false) --隐藏旧频道
		self.channel_change_btn_list.cur.btn.interactable = true
	end
	self.item_obj.curent_channel=channel --更改当前选择的频道
	self.channel_change_btn_list.cur=self.channel_change_btn_list[channel]
	self.channel_change_btn_list.cur.select:SetActive(true) --显示新频道
	self.channel_change_btn_list.cur.btn.interactable = false

	self.record_btn.name="recordBtn_"..channel --修改录音按钮名字
	new_msg_count = 0
	self:init_message() --初始化聊天内容


	--判断频道是否能发言
	if channel == Enum.CHAT_CHANNEL.TEAM and not LuaItemManager:get_item_obejct("team"):is_in_team() then
		-- self:change_can_chat(false,ClientEnum.MODULE_TYPE.TEAM)
		self:change_can_chat(true)
	elseif channel == Enum.CHAT_CHANNEL.ARMY_GROUP and not LuaItemManager:get_item_obejct("legion"):is_in() then
		-- self:change_can_chat(false,ClientEnum.MODULE_TYPE.LEGION)
		self:change_can_chat(true)
	elseif channel >= Enum.CHAT_CHANNEL.SYSTEM then
		self:change_can_chat(false,ClientEnum.MODULE_TYPE.LEGION)
	else
		self:change_can_chat(true)
	end
end

--变更可发言和跳转的状态
function PublicChat:change_can_chat(b,modeId)
	if b then
		self.refer:Get("sendChatObj"):SetActive(true)
		self.refer:Get("goToModel"):SetActive(false)
	else
		self.refer:Get("sendChatObj"):SetActive(false)
		self.refer:Get("goToModel"):SetActive(false)
		-- local go = self.refer:Get("goToModel")
		-- go:SetActive(true)
		-- go.name = "toModule_"..modeId
		-- go:GetComponentInChildren("UnityEngine.UI.Text").text = modeId == ClientEnum.MODULE_TYPE.LEGION and "寻找队伍" or "加入军团"
	end
end

--发送消息
function PublicChat:send_message(channel)
	if not channel then
		channel = self.item_obj.curent_channel
	end 
	if self.message_input_field.text=="" or self.message_input_field.text==nil then
		gf_message_tips("发送消息不能为空")
	elseif channel == Enum.CHAT_CHANNEL.TEAM and not LuaItemManager:get_item_obejct("team"):is_in_team() then
		gf_message_tips("没有加入队伍")
	elseif channel == Enum.CHAT_CHANNEL.ARMY_GROUP and not LuaItemManager:get_item_obejct("legion"):is_in() then
		gf_message_tips("没有加入军团")
	else
		self.item_obj:send_message_c2s(self.message_input_field.text,channel)
	end
end

--清空消息
function PublicChat:clear_message()
	for i = self.main_chat_content_tf.childCount-1,0,-1 do
		local obj = self.main_chat_content_tf:GetChild(i).gameObject
		self:repay_item(obj.name,obj)
	end
	cur_min = 0
	cur_max = 0
end

--初始化消息
function PublicChat:init_message()
	self:clear_message()
	chat_cache = self.item_obj:get_all_chat_record(self.item_obj.curent_channel)
	cur_min = #chat_cache>0 and 1 or 0
	cur_max = #chat_cache>max_obj and max_obj or #chat_cache

	if cur_max==0 then
		self.chat_content_scroll.verticalNormalizedPosition = 0
		return
	end

	for i=cur_min,cur_max do
		local obj = self:add_message(chat_cache[i])
		obj.transform:SetAsFirstSibling()
	end
	--初始化完拖到最低
	self.chat_content_scroll.verticalNormalizedPosition = 0
end

--更新一条消息
function PublicChat:update_message(msg)
	--添加到缓存
	table.insert(chat_cache,1,msg)
	--如果是拖到最低的，则加载，否则添加一个新消息数量
	print("当前滑动位置",self.chat_content_scroll.verticalNormalizedPosition)
	if self.chat_content_scroll.verticalNormalizedPosition < 0.05 and new_msg_count==0 then
		cur_min = 1
		self:add_message(msg)
		if cur_max >= max_obj then
			-- print("取第一个对象删除,父亲是",self.main_chat_content_tf)
			local obj = self.main_chat_content_tf:GetChild(0).gameObject
			local key = obj.name
			-- print(key,obj)
			self:repay_item(key,obj)
		else
			cur_max = cur_max + 1
		end
		
		self.chat_content_scroll.verticalNormalizedPosition = 0 --初始化完拖到最低
	else
		cur_min = cur_min + 1
		cur_max = cur_max + 1
		new_msg_count = new_msg_count + 1
		self.refer:Get("goToNewMsg"):SetActive(true)
		self.refer:Get("newMsgCount").text = string.format("%d条未读消息",new_msg_count)
	end
	print(cur_min,cur_max,max_obj)
end

--添加一条消息  --  取出一个消息，创建消息体，显示出来
function PublicChat:add_message(message)
	gf_print_table(message,"滑动 创建一个消息体")
	local key = "sys_message_item" --message.roleInfo and ( and "self_message_item" or "other_message_item") or "sys_message_item"
	-- if message.channel < Enum.CHAT_CHANNEL.SYSTEM then --小于系统枚举，属玩家发言 -- 有玩家信息，就是人说话，否则就是系统发的
		if message.roleInfo then
			local game = LuaItemManager:get_item_obejct("game")
			if message.roleInfo.roleId == game:getId() then
				key = "self_message_item"
			else
				key = "other_message_item"
			end
		-- else
			print("<color=red>频道发言没有玩家信息</color>")
		-- 	return
		end
	-- end
	print(key)
	local obj = self:get_item(key,self.refer:Get(key),self.main_chat_content_tf.gameObject)
	local ref = obj:GetComponent("ReferGameObjects")
	local data = ConfigMgr:get_config("chat_channel")[message.channel]
	local roleInfo = message.roleInfo
	gf_print_table(message,"消息体")
	local channel_bg = ref:Get("channel_bg")
	if channel_bg then
		-- channel_bg.color = gf_get_color2(data.font_color) -- 改标签颜色
		gf_setImageTexture(channel_bg,data.label_cion) -- 改标签图片
	end

	local channel_text = ref:Get("channel_text")
	if channel_text then
		channel_text.text = data.name
	end
	
	local head_ico = ref:Get("head_ico")
	if head_ico then
		gf_set_head_ico(head_ico,roleInfo.head)
		head_ico.name = "friendTips_"..roleInfo.roleId
	end
	
	local name_text = ref:Get("name_text")
	if name_text then
		name_text.text = roleInfo.name
	end

	local vip_text = ref:Get("vipText")
	if vip_text then
		vip_text.text = roleInfo.vipLevel
		vip_text.transform.parent.gameObject:SetActive(roleInfo.vipLevel>0)
	end

	local chat_bg_img = ref:Get("chat_bg_img")
	local skin_root = ref:Get("chat_frame_skin")
	local font_color = nil
	if message.surfaceTalkBg and message.surfaceTalkBg>0 then -- 使用外观
		local data = ConfigMgr:get_config("surface")[message.surfaceTalkBg]
		if chat_bg_img then
			if data and data.chat_img then
				gf_setImageTexture(chat_bg_img,data.chat_img)
				font_color = data.font_color
			else
				print("<color=red>使用气泡外观出错</color> 外观id：",message.surfaceTalkBg)
			end
		end
		if skin_root then
			if data and data.chat_prefab then
				if skin_root.childCount>0 then
					skin_root:GetChild(0).gameObject:SetActive(false)
				end
				local obj = skin_root:FindChild(data.chat_prefab)
				if obj then
					obj.gameObject:SetActive(true)
					obj:SetAsFirstSibling()
				else
					Loader:get_resource(data.chat_prefab..".u3d",nil,"UnityEngine.GameObject",function(s)
						obj = LuaHelper.InstantiateLocal(s.data)
						obj.transform:SetParent(skin_root,false)
						obj.name = data.chat_prefab
						obj.transform:SetAsFirstSibling()
					end,function()
						print("<color=red>使用气泡外观装饰出错</color> 外观id：",message.surfaceTalkBg,data.chat_prefab)
					end)
				end
			end
		end
	else -- 使用默认外观
		if chat_bg_img then
			if key == "self_message_item" then
				gf_setImageTexture(chat_bg_img,"img_social_bg_01")
			else
				gf_setImageTexture(chat_bg_img,"img_social_bg_02")
			end
		end
		if skin_root then
			if skin_root.childCount>1 then
				skin_root:GetChild(0).gameObject:SetActive(false)
			end
		end
	end
	
	local voiceBtn = ref:Get("voiceBtn")

	local content = message.content
	print("内容内容内容内容",content)
	if type(content) == "string" then
		if string.find(content,"<quad.-/>") == 1 then -- 表情开头加个空格
			content = "　"..content
		end
		if voiceBtn then
			voiceBtn:SetActive(false)
		end
		--文本消息
		local msg_text = ref:Get("msg_text")
		print("是否获取到文本框 写入内容",msg_text)
		if msg_text then
			print("为文本设置内容",content)
			if font_color then
				msg_text.text = "<color=#"..font_color..">"..content.."</color>"
			else
				msg_text.text = content
			end
			local max_width = key == "sys_message_item" and sys_message_max_width or (message_max_width)
			self.gss_layout.enabled = false
			self.gss_text.text = gf_remove_rich_text(content,8)
			UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.gss_tf) -- 立即重建布局
			if self.gss_tf.sizeDelta.x > max_width then
				self.gss_layout.preferredWidth = max_width
				self.gss_layout.enabled = true
				UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.gss_tf) -- 立即重建布局
			end

			local size = self.gss_tf.sizeDelta
			local x = size.x
			local y = size.y

			local chat_bg = ref:Get("chat_bg")
			if chat_bg then
				chat_bg.preferredWidth = x+30
				chat_bg.preferredHeight = y+30
			end

			local message_text = ref:Get("message_text")
			if message_text then
				message_text.sizeDelta = Vector2(message_text.sizeDelta.x,y)
				message_text.anchoredPosition = Vector2(message_text.anchoredPosition.x, -13 - y/2)
			end

			local layout_element = ref:Get("layout_element")
			if layout_element then
				layout_element.preferredWidth = x
				layout_element.preferredHeight = y
			end
		end
		
	elseif type(content) == "table" then
		if voiceBtn then
			voiceBtn:SetActive(true)
			--语音消息
			local voiceInfo = content
			gf_print_table(voiceInfo,"语音消息 信息")
			voiceBtn.name = "playVoice_"..voiceInfo.fileid.."_"..voiceInfo.time

			local voiceico1 = ref:Get("voiceico1")
			if voiceico1 then
				voiceico1:SetActive(true)
			end
			local voiceico2 = ref:Get("voiceico2")
			if voiceico2 then
				voiceico2:SetActive(true)
			end
			local voiceico3 = ref:Get("voiceico3")
			if voiceico3 then
				voiceico3:SetActive(true)
			end
			local new_message_ico = ref:Get("new_message_ico")
			if new_message_ico then
				new_message_ico:SetActive(not self.item_obj:get_gvoice_is_read(voiceInfo.fileid))
			end
			local timelong_text = ref:Get("timelong_text")
			if timelong_text then
				timelong_text.text = voiceInfo.time.."''"
			end
		end

		local msg_text = ref:Get("msg_text")
		if msg_text then
			if font_color then
				msg_text.text = "<color=#"..font_color..">"..content.content.."</color>"
			else
				msg_text.text = content.content
			end
			local size = LuaHelper.GetStringSize(gf_remove_rich_text(content.content),msg_text,key == "sys_message_item" and sys_message_max_width or message_max_width)
			local x = size.x
			local y = size.y

			local chat_bg = ref:Get("chat_bg")
			if chat_bg then
				chat_bg.preferredWidth = 350
				chat_bg.preferredHeight = y+72
			end

			local message_text = ref:Get("message_text")
			if message_text then
				-- print("设置文本框大小",x,y)
				message_text.sizeDelta = Vector2(message_text.sizeDelta.x,y)
				message_text.anchoredPosition = Vector2(message_text.anchoredPosition.x, -53 - y/2)
			end

			local layout_element = ref:Get("layout_element")
			if layout_element then
				layout_element.preferredWidth = x
				layout_element.preferredHeight = y
			end
		end
	end

	return obj
end
--聊天内容框滑动时
function PublicChat:on_chat_content_scroll_move(move_value)
	if self.lase_move_value~=move_value then
		self.lase_move_value = move_value
		print("滑动",move_value,cur_min,cur_max,#chat_cache)
	end
	if cur_min > 1 and move_value <= 0 then
		print("滑动--添加最下",cur_min,chat_cache[cur_min])
		cur_min = cur_min - 1
		self:add_message(chat_cache[cur_min])
		if cur_max-cur_min >= max_obj then
			print("滑动--如果超数量，删除最上")
			local obj = self.main_chat_content_tf:GetChild(0).gameObject
			local key = obj.name
			self:repay_item(key,obj)
			cur_max = cur_max - 1
		end
	self.chat_content_scroll.verticalNormalizedPosition = 0.01

	-- 更新新消息数量
	if new_msg_count >= cur_min then
		new_msg_count = cur_min - 1
		if new_msg_count > 0 then
			self.refer:Get("newMsgCount").text = string.format("%d条未读消息",new_msg_count)
		else
			self.refer:Get("goToNewMsg"):SetActive(false)
		end
	end

	elseif cur_max < #chat_cache and move_value >= 1 then
		print("滑动--添加最上",cur_max,chat_cache[cur_max])
		cur_max = cur_max + 1
		local obj = self:add_message(chat_cache[cur_max])
		obj.transform:SetAsFirstSibling()
		if cur_max-cur_min >= max_obj then
			print("滑动--如果超数量，删除最下，")
			local obj = self.main_chat_content_tf:GetChild(self.main_chat_content_tf.childCount-1).gameObject
			local key = obj.name
			self:repay_item(key,obj)
			cur_min = cur_min + 1
		end
		self.chat_content_scroll.verticalNormalizedPosition = 0.99
	end
end

function PublicChat:on_receive( msg, id1, id2, sid )
	if not self.init then
		return
	end
    if(id1==Net:get_id1("base"))then
		if id2 == Net:get_id2("base", "UpdateLvlR") then
			self:level_up_open_channel_page(msg.level)
        end
    elseif id1 == ClientProto.UpdateChatMessage then
    	if chatTools:is_receive_chat(self.item_obj.curent_channel,msg.channel) then
    		self:update_message(msg)
    		LuaHelper.eventSystemCurrentSelectedGameObject = self.root
    		if msg.roleInfo and msg.roleInfo.roleId == LuaItemManager:get_item_obejct("game"):getId() then
				self.message_input_field.text=""
			end
	    end
    end
end

function PublicChat:on_showed()
	if not self.is_register then
		self.is_register = true
		StateManager:register_view(self)
	end
	if self.init then
		--默认选择频道
		self:change_channel(self.item_obj.curent_channel)
	end
end

function PublicChat:on_hided()
	if self.is_register then
		self.is_register = nil
		StateManager:remove_register_view(self)
	end
end

-- 释放资源
function PublicChat:dispose()
	if self.is_register then
		self.is_register = nil
		StateManager:remove_register_view(self)
	end
	StateManager:remove_register_view(self)
	self.channel_change_btn_list = nil
	self.item_obj.public_chat_ui = nil
    self._base.dispose(self)
end

function PublicChat:get_item(key,obj,root)
    print("获取item",key,obj,root)
    if not self.itemCache[key] then self.itemCache[key] = {} end
    local item = self.itemCache[key][1]
    if item then
        table.remove(self.itemCache[key],1)
    else
        item = LuaHelper.Instantiate(obj)
        item.name = key
        if key == "other_message_item" or key == "self_message_item" or key == "sys_message_item" then
        	local text = LuaHelper.FindChildComponent(item,"message_text","UnityEngine.UI.Text")
        	-- print("--注册图文混排文本点击",text,text.transform:GetInstanceID())
        	text.OnHrefClickFn = function( arg )
	        		-- print("点击了图文混排文本")
	        		chatTools:text_on_click(arg)
	        	end
        	-- text.OnTextClickFn = function() print("点击了图文混排文本") end
        end
    end
    item:SetActive(true)
    item.transform:SetParent(root.transform,false)
    return item
end

function PublicChat:repay_item(key,item)
	print("返还",key,item)
    if not self.itemCache[key] then self.itemCache[key] = {} end
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

return PublicChat

