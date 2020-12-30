--[[
	组队申请界面
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local aType = 
{
	friend = 1,
	guild = 2,
	nearby = 3,
}

local commomString = 
{
	[1] = gf_localize_string("貌似没有可以帮助你的好友在线哦！"),
	[2] = gf_localize_string("似乎没有可以帮助你的军团成员在线哦！"),
	[3] = gf_localize_string("附近冷冷清清的，也许你该到别处转转！"),
	[4] = gf_localize_string("战力：%d"),
	[5] = gf_localize_string("你尚未加入军团，无法邀请军团成员。"),
}

local res = 
{
	[1] = "team_9.u3d", 
}


--@bType 选中项 
local applyView=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("team")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


function applyView:dataInit()
end

-- 资源加载完成
function applyView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.tag = aType.friend
	gf_getItemObject("social"):get_friend_list_c2s()
	self.refer:Get(2):SetActive(true)
end

function applyView:init_scrollview(viewData)
	LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(false)
	if not next(viewData or {}) then
		LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(true)
		local tips = LuaHelper.FindChild(self.root.transform,"bg").transform:FindChild("bgtext").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		tips.text = commomString[self.tag]
	end
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
 	local scroll_rect_table = refer:Get(1)
  		
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true) --显示项
		local refer = scroll_rect_item.gameObject:GetComponent("Hugula.ReferGameObjects")
		
		local p_node = scroll_rect_item.transform:FindChild("Image (1)")
		local name_text = p_node.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text")
		name_text.text = data_item.name

		local name_text = p_node.transform:FindChild("power"):GetComponent("UnityEngine.UI.Text")
		name_text.text = string.format(commomString[4],data_item.power)

		local name_text = p_node.transform:FindChild("level"):GetComponent("UnityEngine.UI.Text")
		name_text.text = data_item.level

		local name_text = p_node.transform:FindChild("team_invite").transform:FindChild("value"):GetComponent("UnityEngine.UI.Text")
		name_text.text = data_item.roleId
		print("data_item.roleId:",data_item.roleId)
		local head = p_node.transform:FindChild("Image (1)"):GetComponent(UnityEngine_UI_Image)
		gf_set_head_ico(head, data_item.head)

	end

  	scroll_rect_table.data = viewData --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据

end


function applyView:closeButtonClick()
	self:dispose()
end


--点击
function applyView:on_click(obj,arg)
	local eventName = obj.name
	if  eventName == "team_friend" then
	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.refer:Get(3):SetActive(false)
		self.refer:Get(4):SetActive(false)
		arg:SetActive(true)
		self.tag = aType.friend
		--获取在线好友
		gf_getItemObject("social"):get_friend_list_c2s()
	
	elseif eventName == "team_guild" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.refer:Get(2):SetActive(false)
		self.refer:Get(4):SetActive(false)
		arg:SetActive(true)
		self.tag = aType.guild
		
		if not gf_getItemObject("legion"):is_in() then
			self:init_scrollview({})
			local tips = LuaHelper.FindChild(self.root.transform,"bg").transform:FindChild("bgtext").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
			tips.text = commomString[5]
			return
		end

		--获取在线军团成员
		gf_getItemObject("legion"):get_member_list_c2s()
	
	elseif eventName == "team_nearby" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.refer:Get(2):SetActive(false)
		self.refer:Get(3):SetActive(false)
		arg:SetActive(true)
		self.tag = aType.nearby
		-- self:init_scrollview({})
    	
    	gf_getItemObject("team"):sendToGetNearMan()

    elseif eventName == "team_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:closeButtonClick()
    
    elseif eventName == "team_invite" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local roleId = tonumber(arg:GetComponent("UnityEngine.UI.Text").text)
    	gf_getItemObject("team"):sendToInvite(roleId)

    end
end

function applyView:get_on_line_member(list)
	local tb = {}
	local myRoldId = gf_getItemObject("game"):getId()

	local myTeamData = gf_getItemObject("team"):getTeamData()
	gf_print_table(myTeamData, "myTeamData wtf:")
	local temp = {}
	for i,v in ipairs(myTeamData.members or {}) do
		temp[v.roleId] = v
	end

	for i,v in ipairs(list or {}) do
		if v.logoutTm <= 0 and v.roleId ~= myRoldId and not temp[v.roleId] then
			table.insert(tb,v)
		end
	end
	return tb
end

function applyView:on_receive(msg, id1, id2, sid)	
	if id1 == Net:get_id1("friend") then
		if id2 == Net:get_id2("friend", "GetFriendListR") then
			gf_print_table(msg, "GetFriendListR")
			self:init_scrollview(self:get_on_line_member(msg.list))
		end
	end

	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetMemberListR") then
			gf_print_table(msg, "GetMemberListR")
			self:init_scrollview(self:get_on_line_member(msg.memberList))
		end
	end
	if id1 == Net:get_id1("team") then
		if id2 == Net:get_id2("team", "GetNearRoleListR") then
			gf_print_table(msg, "GetNearRoleListR")
			self:init_scrollview(msg.roleList)
		end
	end
	
end
-- 释放资源
function applyView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return applyView

