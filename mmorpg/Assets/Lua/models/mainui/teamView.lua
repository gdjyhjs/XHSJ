--[[
	module:组队界面
	at 2017.5.16
	by xin
]]


local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")

require("models.teamCopy.publicFunc")

local dataUse = require("models.team.dataUse")

local commomString = 
{
	[1] = "",
}

local res = 
{
	[1] = "mainui_team.u3d", 
	[2] = "mainui_10", 
	[3] = "mainui_11", 
}

local py1,py2 = 75.6,80 
local heightOff = 67.4

local teamView=class(UIBase,function(self, item_obj)
	UIBase._ctor(self, res[1], item_obj)
end)


function teamView:dataInit()
	self:referInit()

end

-- 资源加载完成
function teamView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self:set_always_receive(true)
	self:dataInit()
	-- self:init_camera()
	self:init_ui()
	self:hide()
end

function teamView:referInit()
	self.onPanel  = LuaHelper.FindChild(self.root,"on")
	self.offPanel = LuaHelper.FindChild(self.root,"off")
	self.action = self.refer:Get(5)
	self:init_tween()
    self.max_hp_list = {}
end

function teamView:init_tween()
	if not self.action then
		return
	end
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.action.gameObject.transform.localPosition.y
	self.action.from = Vector3(-half_w+dx, y, 0)
	self.action.to = Vector3(-half_w-230+dx, y, 0)
	self.refer:Get("duiwu_rt").anchoredPosition = Vector2(dx, self.refer:Get("duiwu_rt").anchoredPosition.y)
end

function teamView:init_ui()
	self.member_item = {}
	self:showTeamOn()
	self:showTeamOff()	
	self:showTeamOnTvt()
	self:update_follow_state()
end

--isShow  是否显示出来
function teamView:showAction(isShow)
	if not self.action or not self:is_visible() then
		return
	end
	if not isShow then
		self.action:PlayForward()
	else
		self.action:PlayReverse()
	end
end

function teamView:showTeamOnTvt()
	--如果是3v3 不显示正常组队
	if not gf_getItemObject("copy"):is_pvptvt() then
		return
	end
	local data = LuaItemManager:get_item_obejct("pvp3v3"):get_team_members()

	if not next(data or {}) then
		return
	end
	self:showTeamView(true)
	

	gf_print_table(data, "组队shuju")

	local buttonPanel = self.refer:Get(3)

	buttonPanel.gameObject:SetActive(false)

	local itemPanel = self.refer:Get(2)

	local panel = self.refer:Get(4)

	for i=1,panel.transform.childCount do
  		local go = panel.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	--
	for i,v in ipairs(data or {}) do
		local cItemPanel = UnityEngine.Object.Instantiate(itemPanel,panel.transform).transform--实例化预制件 go.data
      	cItemPanel.gameObject:SetActive(true)
        cItemPanel.localPosition = Vector3(-640,py1 - (i - 1) * heightOff,0)--设置位置

        cItemPanel.transform:FindChild("value"):GetComponent("UnityEngine.UI.Text").text = v.roleId

        -- table.insert(self.itemList,cItemPanel)

        self:updatePanel(cItemPanel,false,v)

        self.member_item[v.roleId] = cItemPanel

	end

	if gf_getItemObject("team"):isLeader() then
		gf_setImageTexture(self.refer:Get(1), res[2])
	else
		gf_setImageTexture(self.refer:Get(1), res[3])
	end

end

function teamView:showTeamOn()
	--只有在tvt的时候才显示
	if gf_getItemObject("copy"):is_pvptvt() then
		return 
	end
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()

	if not next(data or {}) then
		return
	end
	self:showTeamView(true)
	--排序
	for i,v in ipairs(data.members) do
		v.sort = v.roleId == data.leader and 1 or 0
	end

	if #data.members > 1 then
		table.sort(data.members,function(a,b) return a.sort > b.sort end)
	end

	gf_print_table(data.members, "组队shuju")

	local buttonPanel = self.refer:Get(3)

	buttonPanel.gameObject:SetActive(true)

	local itemPanel = self.refer:Get(2)

	local panel = self.refer:Get(4)

	for i=1,panel.transform.childCount do
  		local go = panel.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	--
	for i,v in ipairs(data.members or {}) do
		local cItemPanel = UnityEngine.Object.Instantiate(itemPanel,panel.transform).transform--实例化预制件 go.data
      	cItemPanel.gameObject:SetActive(true)
        cItemPanel.localPosition = Vector3(-640,py1 - (i - 1) * heightOff,0)--设置位置

        cItemPanel.transform:FindChild("value"):GetComponent("UnityEngine.UI.Text").text = v.roleId

        -- table.insert(self.itemList,cItemPanel)

        self:updatePanel(cItemPanel,i == 1,v)

        --如果是最后一个
        if i == #data.members and #data.members < 3 then
        	local inviteButton = LuaHelper.FindChild(cItemPanel,"team_invite_button_mainui")
        	inviteButton.gameObject:SetActive(true)
        end

        self.member_item[v.roleId] = cItemPanel

	end

	buttonPanel.transform.localPosition =  Vector3(-640,py2 - (#data.members-1) * heightOff,0)


	if gf_getItemObject("team"):isLeader() then
		gf_setImageTexture(self.refer:Get(1), res[2])
	else
		gf_setImageTexture(self.refer:Get(1), res[3])
	end



end

function teamView:update_follow_state()
	local follow = gf_getItemObject("team"):is_follow()
	print("wtf follow:",follow)
	if follow then
		self.refer:Get(7).material = self.refer:Get(6) 
	else
		self.refer:Get(7).material = nil
	end
	-- self.refer:Get(7).material = follow and nil or self.refer:Get(6) 
end

function teamView:updatePanel(item,isLeader,data)
	gf_print_table(data, "member:")
	if not isLeader then
		item:FindChild("leadertag").gameObject:SetActive(false)
	end
	local pNode = item:FindChild("namenode")
	-- local name = pNode.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text")
	-- name.text = data.name
	if data.level then
		local lv = pNode.transform:FindChild("lv"):GetComponent("UnityEngine.UI.Text")
		lv.text = string.format("Lv.%d",data.level)
	end
	if data.name then
		local name = pNode.transform:FindChild("lv").transform:FindChild("name"):GetComponent("UnityEngine.UI.Text")
		name.text = data.name
	end

	if data.head then
		local head = item:FindChild("team_head"):GetComponent(UnityEngine_UI_Image)
		gf_set_head_ico(head,data.head)
	end
	
	--血量
	if data.hp then
		local max_hp = data.maxHp or self.max_hp_list[data.roleId] or 1
		local hp_img = item.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
		if max_hp then
			hp_img.fillAmount = data.hp / max_hp or data.maxHp
			self.max_hp_list[data.roleId] = max_hp
		end
	end
end

function teamView:showTeamOff()
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	if next(data or {}) then
		return
	end
	self:showTeamView(false)
end

function teamView:showTeamView(isShowOn)
	self.onPanel:SetActive(isShowOn)
	self.offPanel:SetActive(not isShowOn)
end

function teamView:clearItem()
	if self.itemList then
		for i,v in ipairs(self.itemList or {}) do
			print("Destroy wtf ",i)
			LuaHelper.Destroy(v)
		end
	end
end

function teamView:setParent(parent)
	parent:add_child(self.root)
end

--点击
function teamView:on_click(obj,arg)
	local eventName = obj.name

	if obj.name == "team_goto_button_mainui" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.team.teamEnter")()
	elseif obj.name == "team_create_button_mainui" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("team"):sendToCreateTeam()
		-- require("models.team.teamEnter")()
	elseif obj.name == "team_nearby_button_mainui" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.team.nearbyView")()
	elseif eventName == "team_location_button_mainui" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("发送坐标")
		-- gf_message_tips("发送坐标")
		gf_getItemObject("chat"):send_position_message(nil,nil,Enum.CHAT_CHANNEL.TEAM)

	elseif eventName == "team_follow_button_mainui" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("请求跟随")
		gf_team_follow()

	elseif eventName == "team_exit_button_mainui" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("退出队伍")
		local sure_fun = function()
			LuaItemManager:get_item_obejct("team"):sendToExitTeam()
		end
		local content = gf_localize_string("你是否要离开队伍？")
		--如果在组队副本里面
		if gf_getItemObject("copy"):is_team() then
			content = gf_localize_string("退出队伍的同时，也会退出组队副本，确定要退出吗？")
		end
		gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)


	elseif eventName == "team_invite_button_mainui" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("邀请队友")
		require("models.team.inviteView")()

	elseif eventName == "team_head" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local value = arg:GetComponent("UnityEngine.UI.Text").text
		value = tonumber(value)
		print("value:",value)
		local myRoleId = gf_getItemObject("game"):getId()
		if myRoleId ~= value then
			LuaItemManager:get_item_obejct("player"):show_player_tips(value)
		end
		
	end
end

function teamView:update_member_data(data)
	local cItemPanel = self.member_item[data.roleId] 
	if cItemPanel then
		self:updatePanel(cItemPanel,false,data)
	end
end

function teamView:on_receive(msg, id1, id2, sid)
	if id1 == Net:get_id1("team") then
		if id2 == Net:get_id2("team","CreateTeamR") or id2 == Net:get_id2("team","GetPlayerTeamR")
		   or id2 == Net:get_id2("team","LeaveTeamR") or id2 == Net:get_id2("team","JoinTeamResultR")  
		    or id2 == Net:get_id2("team","ChangeLeaderR") then
			self:init_ui() 
			
		elseif id2 == Net:get_id2("team","MemberAttrChangeNotifyR") then
			--刷新数据
			self:update_member_data(msg.member)

		elseif id2 == Net:get_id2("team","FollowLeaderR") then
			self:update_follow_state()
			
		end
	end
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy","MemberAttrChangeNotifyR") then
			gf_print_table(msg, "MemberAttrChangeNotifyR:")
			--刷新数据
			self:update_member_data(msg.member)

		elseif id2 == Net:get_id2("copy", "MemberListR") then
        	self:init_ui() 

		end
	end
	if id1 == ClientProto.FinishScene then
		self:init_ui()

	end
end

function teamView:on_showed()
	
end
-- 释放资源
function teamView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return teamView

