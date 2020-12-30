--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-06-21 15:00:44
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local chatEnum = require("models.chat.chatEnum")
local chatTools = require("models.chat.chatTools")
local chatRecord = require("models.chat.chatRecord")

local message_max_width=300
local max_obj = 20 -- 同时加载的最大消息数量
local cur_min = 1
local cur_max = max_obj
local new_msg_count = 0
local chat_cache = {} --记录当前聊天的人的聊天记录
local max_name_length = 100 -- 聊天框输入的字符最大值
local last_time = 0

local PrivateChat=class(UIBase,function(self,item_obj) -- chatList 聊天列表
    UIBase._ctor(self, "private_chat.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function PrivateChat:on_asset_load(key,asset)
	self.nosel = self.refer:Get("nosel").sprite
	self.sel = self.refer:Get("sel").sprite

	self.itemCache = {}

    self.chat_list = {} -- 聊天列表{id,id,id}
    self.chat_obj = {} -- 聊天对象{id=信息,id=信息}
    self.new_chat_num = {} -- {id = 数量,id = 数量}

	self:init_ui()
	self.init = true
	-- print("聊天UI初始化完毕",self.roleId)
	self:get_chat_list()
end

--值改变事件
function PrivateChat:on_update()
	if self.init then
		self:on_chat_content_scroll_move(self.refer:Get("chat_content_scroll").verticalNormalizedPosition)
	end
end


-- 初始化获取组件
function PrivateChat:init_ui()
		self.gss_text=self.refer:Get("gss_text")
		self.gss_layout=self.refer:Get("gss_layout")
		self.gss_tf = self.gss_text.transform

	self.item_obj.private_chat_input_field = self.refer:Get("message_input_field")
	self.main_chat_content_tf = self.refer:Get("main_chat_content").transform
	self.chat_content_scroll = self.refer:Get("chat_content_scroll")
end

--取聊天列表
function PrivateChat:get_chat_list()
	self.cur_chat_roleId = self.item_obj.chat_friend
	self.item_obj.chat_friend = nil
	print("要聊天的人",self.cur_chat_roleId)
	-- print("--获取聊天列表")
	local list = chatRecord:load_chat_role()
	gf_print_table(list,"取到聊天列表")
	if self.cur_chat_roleId then
		for i,v in ipairs(list) do
			if v == self.cur_chat_roleId then
				table.remove(list,i)
				gf_print_table(list,"要聊天的人在列表里，从列表移除")
				break
			end
		end
		table.insert(list,1,self.cur_chat_roleId)
		gf_print_table(list,"将要聊天的人插到列表的首位")
	end
	self.chat_list = list -- 保存聊天列表
	self.item_obj:get_friend_list_c2s(list,1)
	self.item_obj:get_chat_list_c2s()
end

-- 添加或将某个玩家设置到聊天列表的最前,并且设置其新消息记录数量
function PrivateChat:set_new_chat_role(roleId,num)
	print("添加或将某个玩家设置到聊天列表的最前,并且设置其新消息记录数量",roleId,num)
	for i,v in ipairs(self.chat_list) do
		if v == roleId then
			table.remove(self.chat_list,i)
			break
		end	
	end
	table.insert(self.chat_list,1,roleId)
	self.new_chat_num[roleId] = num

	--保存新的聊天列表到本地
	chatRecord:save_chat_list(self.chat_list)
end

--更新左侧聊天数量
function PrivateChat:update_left_chat_num()
	local root = self.refer:Get("roleItemRoot")
	for k,v in pairs(self.new_chat_num or {}) do
		local child = root.transform:FindChild("roleItem_"..k)
		if child and v>0 then
			if child:GetComponent(UnityEngine_UI_Image).sprite == self.nosel then -- 未选中的，需要更新数量
				local ref = child:GetComponent("ReferGameObjects")
				if ref then
					ref:Get("new_chat"):SetActive(true)
					ref:Get("new_chat_count_text").text = v
				end
			end
		elseif self.chat_obj[k] and v>0 then -- 创建新的聊天对象
			self:set_new_chat_role(k,v)
			local root = self.refer:Get("roleItemRoot")
			local item = self.refer:Get("roleItem")
			local obj = self:get_item("roleItem",item,root)
			local ref = obj:GetComponent("ReferGameObjects")
			self:set_left_item_info(ref,self.chat_obj[k])
			obj.transform:SetAsFirstSibling()
		end
	end
end

--更新左侧聊天对象的好友状态
function PrivateChat:update_left_friend(roleId,intimacy)
print("更新左侧聊天对象的好友状态",roleId,intimacy)
	local root = self.refer:Get("roleItemRoot")
	local child = root.transform:FindChild("roleItem_"..roleId)
	if child then
		local ref = child:GetComponent("ReferGameObjects")
		if intimacy and intimacy>0 then
			print("显示亲密度")
			local intimacy_text = ref:Get("intimacy_text")
			intimacy_text.text = intimacy
			intimacy_text.gameObject:SetActive(true)
			local add_friend = ref:Get("add_friend")
			add_friend:SetActive(false)
		else
			print("显示加为好友")
			local intimacy_text = ref:Get("intimacy_text")
			intimacy_text.gameObject:SetActive(false)
			local add_friend = ref:Get("add_friend")
			add_friend:SetActive(true)
			add_friend.name = "addFriend_"..roleId
		end
	end
end

function PrivateChat:on_receive( msg, id1, id2, sid )
	if self.init then
	   if id1 == Net:get_id1("friend") then
	        if(id2== Net:get_id2("friend", "ChatR"))then
	        gf_print_table(msg,"服务器返回：新的私聊信息")
	        	if msg.err == 0 then
	        		local roleId = msg.friend and msg.friend.roleId or msg.toRoleId
	        		if roleId == self.cur_chat_roleId then
	        			local message = {roleId = msg.friend and msg.friend.roleId or LuaItemManager:get_item_obejct("game"):getId(),
	        					content = chatTools:chat_text_modification(msg.content,true),
	        					tm = msg.tm,
	        					surfaceTalkBg = msg.surfaceTalkBg,}
	        			--正在聊天的人，直接添加
		            	self:update_message(message)
		            elseif not self.cur_chat_roleId then
		            	--没有正在聊天的人，创建聊天项并且选中
		            	self:set_new_chat_role(msg.friend.roleId,(self.new_chat_num[roleId] or 0)+1)
		            	self.chat_obj[msg.friend.roleId] = msg.friend
		            	self:update_left()
		            else
		            	--正在和其他人聊天，更新新消息数量
		            	self:set_new_chat_role(msg.friend.roleId,(self.new_chat_num[roleId] or 0)+1)
		            	self.chat_obj[msg.friend.roleId] = msg.friend
		            	self:update_left_chat_num()
		            end
		            --更新左侧聊天数量

	            end
	        elseif(id2 == Net:get_id2("friend", "GetChatRecordR"))then
	        gf_print_table(msg,"服务器返回：获取私聊记录")
	        	if msg.roleId == self.cur_chat_roleId then
	            	self:init_message(msg.contentList or {})
	            end
	        elseif(id2 == Net:get_id2("friend", "GetFriendInfoR")) and sid == 1 then
	        gf_print_table(msg,"服务器返回：获取朋友信息")
	        	self.chat_obj = {}
	        	for i,v in ipairs(msg.list or {}) do
	        		self.chat_obj[v.roleId] = v
	        	end
	            -- self.chat_list = msg.list or {}
	        elseif(id2 == Net:get_id2("friend", "GetChatListR"))then
	        gf_print_table(msg,"服务器返回：获取未读私聊列表")
	            for i,v in ipairs(msg.list or {}) do
	            	-- 添加或将某个玩家设置到聊天列表的最前,并且设置其新消息记录数量
	            	self:set_new_chat_role(v.roleId,msg.num[i])
	            	self.chat_obj[v.roleId] = v
	            end
	            self:update_left()

	        elseif id2 == Net:get_id2("friend", "AddFriendR") then
	        gf_print_table(msg,"服务器返回：加了好友")
	        	if self.chat_obj[msg.friend.roleId] then
	        		self:update_left_friend(msg.friend.roleId,msg.friend.intimacy)
	        	end
	        elseif id2 == Net:get_id2("friend", "DeleteFriendR") then
	        gf_print_table(msg,"服务器返回：删了好友")
	        	if self.chat_obj[msg.roleId] then
	        		self:update_left_friend(msg.roleId)
	        	end
	        end
	    end
	end
end

--值改变事件
function PrivateChat:on_input_field_value_changed( obj,arg )
	print("聊天视窗值变化",obj,arg)
	if arg == self.chat_content_scroll.gameObject then
		self:on_update()
	end
end

function PrivateChat:on_click(obj,arg)
 	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	print("点击了私聊",cmd)
	if cmd == "closeBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	-- elseif arg == self.chat_content_scroll then
	-- 	self:on_update()
	elseif cmd == "message_input_field" then -- 输入值的时候
		while(gf_get_string_length(arg.text)>max_name_length)do
			arg.text = string.sub(arg.text,1,-2)
		end		
	elseif cmd=="emojiInputBtn" then --打开表情输入按钮
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:open_emoji_ui(self.item_obj.private_chat_input_field,self.roleId)
	elseif cmd=="goToNewMsg" then --跳到最下
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		obj:SetActive(false)
		self:sel_left_item(self.cur_chat_roleId)
	elseif string.find(cmd,"roleItem_") then --选择聊天的人
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sel_left_item(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"friendTips_") then --玩家tips
	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("player"):show_player_tips(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"closeChat_") then --关闭聊天的人
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:close_chat_player(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"addFriend_") then
	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("social"):apply_friend_c2s(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"messageSend_") and string.find(arg.name,"messageSend_") then
	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sendMessage(tonumber(string.split(cmd,"_")[2])) --发送消息给某个人
	end
end

function PrivateChat:sendMessage(roleId)
	local input_field = self.refer:Get("message_input_field")
	if input_field.text=="" or input_field.text==nil then
		gf_message_tips("发送消息不能为空")

	else
		local c = chatTools:chat_msg_modification(input_field.text)
		input_field.text = ""
		self.item_obj:chat_c2s(roleId,c)
	end
end

function PrivateChat:update_ui(roleId,only_left)
	self.roleId = roleId or self.roleId
	-- print("更新私聊UI",self.roleId)
	if self.init then
		-- print("更新私聊左侧列表")
		self:update_left()
	end
end

function PrivateChat:update_left() --
	print("更新左侧的信息")
	local root = self.refer:Get("roleItemRoot")
	local item = self.refer:Get("roleItem")
	gf_print_table(self.chat_list,"更新左边聊天列表")
	--删除原有项
	while(root.transform.childCount>0)do
		local child = root.transform:GetChild(0).gameObject
		self:repay_item("roleItem",child)
	end
	local chat_count = 0
	--聊天列表
	for i,roleId in ipairs(self.chat_list) do
		local v = self.chat_obj[roleId]
		-- print(roleId,v.name)
		if v then
			chat_count = chat_count + 1
			local obj = self:get_item("roleItem",item,root)
			local ref = obj:GetComponent("ReferGameObjects")
			self:set_left_item_info(ref,v)
		end
	end
	if chat_count>0 then
		if self.cur_chat_roleId then
			self:sel_left_item(self.cur_chat_roleId)
		else
			self:sel_left_item(self.chat_list[1])
		end
	else
		self:sel_left_item()
	end
	--保存新的聊天列表到本地
	chatRecord:save_chat_list(self.chat_list)
end

-- 设置左侧项信息
function PrivateChat:set_left_item_info(ref,roleInfo)
	print("设置左侧项",roleInfo.roleId,roleInfo.name)
	local head_icon = ref:Get("head_ico")
	ref:Get("bg").sprite = self.nosel
	gf_set_head_ico(head_icon,roleInfo.head)
	ref:Get("level_text").text = roleInfo.level
	ref:Get("role_name").text = roleInfo.name
	print("VIP等级",roleInfo.vipLevel,ref:Get("vipText"),ref:Get("vipLvBg"))
	if roleInfo.vipLevel>0 then
		ref:Get("vipText").text = roleInfo.vipLevel
		ref:Get("vipLvBg"):SetActive(true)
	else
		ref:Get("vipLvBg"):SetActive(false)
	end
	if roleInfo.intimacy and roleInfo.intimacy>0 then
		local intimacy_text = ref:Get("intimacy_text")
		intimacy_text.text = roleInfo.intimacy
		intimacy_text.gameObject:SetActive(true)
		local add_friend = ref:Get("add_friend")
		add_friend:SetActive(false)
	else
		local intimacy_text = ref:Get("intimacy_text")
		intimacy_text.gameObject:SetActive(false)
		local add_friend = ref:Get("add_friend")
		add_friend:SetActive(true)
		add_friend.name = "addFriend_"..roleInfo.roleId
	end
	if self.new_chat_num[roleInfo.roleId] then
		ref:Get("new_chat"):SetActive(true)
		ref:Get("new_chat_count_text").text = self.new_chat_num[roleInfo.roleId]
	else
		ref:Get("new_chat"):SetActive(false)
	end
	ref.name = "roleItem_"..roleInfo.roleId
	head_icon.name = "friendTips_"..roleInfo.roleId
	ref:Get("close_player_btn").name = "closeChat_"..roleInfo.roleId
	ref:Get("out_line"):SetActive(roleInfo.logoutTm>0)
end

--选择左侧的某一项
function PrivateChat:sel_left_item(roleId)
	new_msg_count = 0
	print("改变选择左侧的某一项")
	local root = self.refer:Get("roleItemRoot")
	-- 改变原选中
	if self.cur_chat_roleId then
		local child = root.transform:FindChild("roleItem_"..self.cur_chat_roleId)
		if child then
			child:GetComponent(UnityEngine_UI_Image).sprite = self.nosel
		end
	end
	self.cur_chat_roleId = roleId
	--改变当前选中
	if self.cur_chat_roleId then
		local child = root.transform:FindChild("roleItem_"..self.cur_chat_roleId)
		if child then
			print("设置选中项",self.cur_chat_roleId,self.chat_obj[self.cur_chat_roleId].name)
			local ref = child:GetComponent("ReferGameObjects")
			ref:Get("bg").sprite = self.sel
			ref:Get("new_chat"):SetActive(false)
			--获取玩家的聊天历史记录
		end
	end
	self:init_right_info()
end

--初始化右侧信息
function PrivateChat:init_right_info()
	print("初始化右侧的信息")
	self.refer:Get("right_top").gameObject:SetActive(false)
	if self.cur_chat_roleId then
		local roleInfo = self.chat_obj[self.cur_chat_roleId]
		if roleInfo then
			self.refer:Get("right_top").gameObject:SetActive(true)
			self.refer:Get("cur_chat_role_text").text = string.format(gf_localize_string("正在与%s聊天..."),roleInfo.name)
			self.refer:Get("message_send_btn").name = "messageSend_"..roleInfo.roleId
			self.refer:Get("record_btn").name = "recordBtn_"..roleInfo.roleId
			self.refer:Get("goToNewMsg"):SetActive(false)
			self.roleInfo = roleInfo
			-- 获取聊天记录
			self:clear_message()
			self.item_obj:get_chat_record_c2s(self.cur_chat_roleId)
		end
	end
end

--聊天内容
--清空聊天消息
function PrivateChat:clear_message()
	for i = self.main_chat_content_tf.childCount-1,0,-1 do
		local child = self.main_chat_content_tf:GetChild(i)
		if child then
			self:repay_item(child.name,child.gameObject)
		end
	end
	while(self.main_chat_content_tf.childCount>0)do
		local child = self.main_chat_content_tf:GetChild(self.main_chat_content_tf.childCount-1).gameObject
		self:repay_item(child.name,child)
	end
	cur_min = 0
	cur_max = 0
end

--初始化消息
function PrivateChat:init_message(contentList)
	print("初始化消息")
	if not self.cur_chat_roleId then
		self.refer:Get("right_top").gameObject:SetActive(false)
		return
	end
	-- 清空原消息对象
	self:clear_message()
	--获取本地聊天记录，及未读历史记录
	chat_cache =  chatRecord:load_chat_record(self.cur_chat_roleId)
	for i,v in ipairs(contentList) do
		local message = {roleId = v.roleId or self.cur_chat_roleId,
    					content = chatTools:chat_text_modification(v.content,true),
    					tm = v.tm,
	        			surfaceTalkBg = v.surfaceTalkBg,}
    	table.insert(chat_cache,1,message)
	end
	--保存到本地
	chatRecord:save_chat_record_list(chat_cache,self.cur_chat_roleId)
	--通知服务器已读
	self.item_obj:had_read_c2s(self.cur_chat_roleId)

	cur_min = #chat_cache>0 and 1 or 0
	cur_max = #chat_cache>max_obj and max_obj or #chat_cache

	if cur_max==0 then
		print("--初始化完拖到最低")
		self.chat_content_scroll.verticalNormalizedPosition = 0
		return
	end

	for i=cur_min,cur_max do
		local obj = self:add_message(chat_cache[i])
		obj.transform:SetAsFirstSibling()
	end
	print("--初始化完拖到最低")
	self.chat_content_scroll.verticalNormalizedPosition = 0
end

--更新一条消息 chat_cache
function PrivateChat:update_message(msg)
	--添加到缓存
	table.insert(chat_cache,1,msg)
	-- 保存记录到本地
	chatRecord:save_chat_record_list(chat_cache,self.cur_chat_roleId)
	--通知服务器已读
	self.item_obj:had_read_c2s(self.cur_chat_roleId)
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
	-- print(cur_min,cur_max,max_obj)
end

--添加一条消息  --  取出一个消息，创建消息体，显示出来
function PrivateChat:add_message(message)
	gf_print_table(message,"滑动 创建一个消息体")
	local game = LuaItemManager:get_item_obejct("game")
	local is_my_message = game:getId() == message.roleId
	local key = is_my_message and "self_message_item" or "other_message_item"
	local roleInfo = is_my_message and game:getRoleInfo() or self.roleInfo
	local obj = self:get_item(key,self.refer:Get(key),self.main_chat_content_tf.gameObject)
	local ref = obj:GetComponent("ReferGameObjects")
	
	local time_obj = ref:Get("time")
	if time_obj then
		time_obj.text = gf_get_time_stamp(message.tm)
		time_obj.gameObject:SetActive(true)
	end

	local head_ico = ref:Get("head_ico")
	if head_ico then
		gf_set_head_ico(head_ico,roleInfo.head)
	end
	
	local name_text = ref:Get("name_text")
	if name_text then
		name_text.text = roleInfo.name
	end

	local vip_text = ref:Get("vipText")
	if vip_text then
		roleInfo.vipLevel = roleInfo.vipLevel or 1
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
				if skin_root.childCount>=1 then
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
	if type(content) == "string" then
		if string.find(content,"<quad.-/>") == 1 then -- 表情开头加个空格
			content = "　"..content
		end
		if voiceBtn then
			voiceBtn:SetActive(false)
		end
		--文本消息
		local msg_text = ref:Get("msg_text")
		if msg_text then
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
				chat_bg.preferredWidth = x+40
				chat_bg.preferredHeight = y+25
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
			-- gf_print_table(voiceInfo,"语音消息 信息")
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
			local size = LuaHelper.GetStringSize(gf_remove_rich_text(content.content),msg_text,message_max_width)
			local x = size.x
			local y = size.y

			local chat_bg = ref:Get("chat_bg")
			if chat_bg then
				chat_bg.preferredWidth = 350
				chat_bg.preferredHeight = y+72
			end

			local message_text = ref:Get("message_text")
			if message_text then
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
function PrivateChat:on_chat_content_scroll_move(move_value)
	if self.lase_move_value~=move_value then
		self.lase_move_value = move_value
		-- print("滑动",move_value,cur_min,cur_max,#chat_cache)
	end
	if cur_min > 1 and move_value < 0.2 then
		-- print("滑动--添加最下",cur_min,chat_cache[cur_min])
		cur_min = cur_min - 1
		self:add_message(chat_cache[cur_min])
		if cur_max-cur_min >= max_obj then
			-- print("滑动--如果超数量，删除最上")
			local obj = self.main_chat_content_tf:GetChild(0).gameObject
			local key = obj.name
			self:repay_item(key,obj)
			cur_max = cur_max - 1
		end
	self.chat_content_scroll.verticalNormalizedPosition = 0.4

	-- 更新新消息数量
	if new_msg_count >= cur_min then
		new_msg_count = cur_min - 1
		if new_msg_count > 0 then
			self.refer:Get("newMsgCount").text = string.format("%d条未读消息",new_msg_count)
		else
			self.refer:Get("goToNewMsg"):SetActive(false)
		end
	end

	elseif cur_max < #chat_cache and move_value > 0.8 then
		-- print("滑动--添加最上",cur_max,chat_cache[cur_max])
		cur_max = cur_max + 1
		local obj = self:add_message(chat_cache[cur_max])
		obj.transform:SetAsFirstSibling()
		if cur_max-cur_min >= max_obj then
			-- print("滑动--如果超数量，删除最下，")
			local obj = self.main_chat_content_tf:GetChild(self.main_chat_content_tf.childCount-1).gameObject
			local key = obj.name
			self:repay_item(key,obj)
			cur_min = cur_min + 1
		end
		self.chat_content_scroll.verticalNormalizedPosition = 0.6
	end
end

--删除左边聊天的玩家
function PrivateChat:close_chat_player(roleId)
		print("删除左边聊天的玩家",roleId)

	for i,v in ipairs(self.chat_list) do
		if v == roleId then
			table.remove(self.chat_list,i)
			break
		end
	end
	chatRecord:save_chat_list(self.chat_list)

	if roleId then
		local root = self.refer:Get("roleItemRoot")
		local child = root.transform:FindChild("roleItem_"..roleId)
		if child then
			self:repay_item("roleItem",child.gameObject)
		end
	end

	if roleId == self.cur_chat_roleId then
		if #(self.chat_list or {})>0 then
			self:sel_left_item(self.chat_list[1])
		else
			self:sel_left_item()
		end
	end
end

function PrivateChat:on_showed()
	if self.init then
		self:get_chat_list()
	end
	if not self.is_register then
		self.is_register = true
		StateManager:register_view( self )
	end
end
function PrivateChat:on_hided()
	if self.is_register then
		self.is_register = false
		StateManager:remove_register_view( self )
	end
	-- gf_remove_update(self) --注销每帧事件
	if self.cur_chat_roleId then
		-- 保存记录到本地
		chatRecord:save_chat_record_list(chat_cache,self.cur_chat_roleId)
		--通知服务器已读
		self.item_obj:had_read_c2s(self.cur_chat_roleId)
		self.cur_chat_roleId = nil
	end
	--请求服务器  取离线消息的聊天列表  判断是否有未读消息
	self.item_obj:get_chat_list_c2s()
end

-- 释放资源
function PrivateChat:dispose()
	self:hide()
	self.init = nil
	self.item_obj.private_chat_ui = nil
	if self.item_obj.chatRecord then
		self.item_obj.chatRecord.save_all()
	end
	
    self._base.dispose(self)
 end

function PrivateChat:get_item(key,obj,root)
    -- print("获取item",key,obj,root)
    if not self.itemCache[key] then self.itemCache[key] = {} end
    local item = self.itemCache[key][1]
    if item then
        table.remove(self.itemCache[key],1)
    else
        item = LuaHelper.Instantiate(obj)
        item.name = key
        --注册富文本点击
        if key == "other_message_item" or key == "self_message_item" or key == "sys_message_item" then
        	LuaHelper.FindChildComponent(item,"message_text","UnityEngine.UI.Text").OnHrefClickFn = function( arg ) chatTools:text_on_click(arg) end
        end
    end
    item:SetActive(true)
    item.transform:SetParent(root.transform,false)
    return item
end

function PrivateChat:repay_item(key,item)
	-- print("返还",key,item)
	if not self.itemCache[key] then self.itemCache[key] = {} end
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

return PrivateChat

