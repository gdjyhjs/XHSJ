--[[
	组队界面 有组队状态 队长
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Enum = require("enum.enum")

local commomString = 
{
	[1] = gf_localize_string("协助战斗"),
	[2] = gf_localize_string("跟随"),
	[3] = gf_localize_string("取消跟随"),
	[4] = gf_localize_string("无"),
	[5] = gf_localize_string("只有队长才能选择目标。"),
	
}

local res = 
{
	[1] = "team_10.u3d", 
}
require("models.team.teamConfig")

local dataUse = require("models.team.dataUse")

local models = {
    [Enum.CAREER.MAGIC] = {model_name="111101.u3d",default_angles= Vector3(0,158,0)},
    [Enum.CAREER.SOLDER] = {model_name="114101.u3d",default_angles= Vector3(0,159,0)},
    [Enum.CAREER.BOWMAN] = {model_name="112101.u3d",default_angles= Vector3(0,159,0)},
}
--@bType 选中项 
local teamViewMember=class(UIBase,function(self)
	self:set_bg_visible(true)
	local item_obj = LuaItemManager:get_item_obejct("team")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)


function teamViewMember:dataInit()
end

-- 资源加载完成
function teamViewMember:on_asset_load(key,asset)
	self:hide_mainui(true)
	
	StateManager:register_view(self)
	self:init_ui()
end

function teamViewMember:init_ui()
	self:initView()
	self:initScrollView()
	self:initTeamScrollView()
	self:initPowerLimitChange()
	self:initTarget()
end

function teamViewMember:initView()
	local parentNode = LuaHelper.FindChild(self.root,"2")

	
	local text = LuaHelper.FindChildComponent(parentNode,"actiontext","UnityEngine.UI.Text")
	text.text = commomString[1]

	local button = LuaHelper.FindChild(parentNode,"team_enter_button_myteam")
	local btText = LuaHelper.FindChildComponent(button,"gotoname","UnityEngine.UI.Text")

	local follow = gf_getItemObject("team"):is_follow()
	btText.text = follow and commomString[3] or commomString[2]

	local button = LuaHelper.FindChild(parentNode,"team_input_inputfiled_myteam")
	LuaHelper.FindChildComponent(parentNode,"team_input_inputfiled_myteam","UnityEngine.UI.Button").interactable = false
	-- button:SetActive(false)
	
end

--右边条件选择
function teamViewMember:initScrollView()
	local callback = function(arg)
		print("arg:",arg)
		gf_message_tips(commomString[5])
	end 
	self.opinion = require("models.team.opinion")(nil,callback)
	-- self:add_child(self.opinion)
end

function teamViewMember:initTeamScrollView()
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	--排序 队长在前
	for i,v in ipairs(data.members) do
		v.sort = v.roleId == data.leader and 1 or 0
	end

	if #data.members > 1 then
		table.sort(data.members,function(a,b) return a.sort > b.sort end)
	end

	gf_print_table(data, "队伍信息:")
	-- local scroll_rect_table = LuaHelper.GetComponentInChildren(self.root,ScrollRectTable) --找到ScrollRectTable控件 
  	local memberTable = {}
	for i,v in ipairs(data.members or {}) do
		table.insert(memberTable,v)
	end
	local empty = {roleId = -1,}
	for i=1,teamNumberCount - #data.members do
		table.insert(memberTable,empty)
	end

	
	gf_print_table(memberTable, "wtf memberTable:")
  	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
 	local scroll_rect_table = refer:Get(1)
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
 		print("data init :",index)
		scroll_rect_item.gameObject:SetActive(true) --显示项
		--空队员
		if data_item.roleId == -1 then
			self:teamEmptyItemUpdate(scroll_rect_item,true)
		else
			--队长
			if data_item.roleId == data.leader then
				self:teamLeaderItemUpdate(scroll_rect_item,data_item)
			else
				self:teamItemUpdate(scroll_rect_item,data_item)
			end
		end
	end

  	scroll_rect_table.data = memberTable --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据
end

function teamViewMember:teamEmptyItemUpdate(item,showAdd)
	local pNode = item.transform:FindChild("team_member_bg")
	local tNode = pNode.transform:FindChild("team_panel")
	tNode.gameObject:SetActive(not showAdd)
	local aNode = pNode.transform:FindChild("add_panel")
	aNode.gameObject:SetActive(showAdd)

	if showAdd then
		print("set texture2")
		gf_setImageTexture(item.transform:FindChild("team_member_bg"):GetComponent(UnityEngine_UI_Image), "team_bg_01")
	end
	

end
function teamViewMember:teamLeaderItemUpdate(item,data)
	local pNode = item.transform:FindChild("team_member_bg").transform:FindChild("team_panel")
	local pTransform = pNode.transform
	local leaderTag = pTransform:FindChild("leadertag").gameObject
	leaderTag:SetActive(true)
	--name
	local node = pNode:FindChild("name"):GetComponent("UnityEngine.UI.Text")
	node.text = data.name.."  lv."..data.level
	--power
	local node = pNode:FindChild("power"):GetComponent("UnityEngine.UI.Text")
	node.text = "战力  "..data.power or 111111
	--lv 
	-- local node = pNode:FindChild("lv"):GetComponent("UnityEngine.UI.Text")
	-- node.text = string.format("Lv.%d",data.level)
	--位置 local teamTable = ConfigMgr:get_config("team")
	local map_name = ConfigMgr:get_config("mapinfo")[data.mapId].name
	local node = pNode:FindChild("location"):GetComponent("UnityEngine.UI.Text")
	node.text = map_name

	-- local model = item.transform:FindChild("team_member_bg").transform:FindChild("model")

	-- local eachFn =function(i,obj)
	-- 	print("destroy:",i)
	-- 	LuaHelper.Destroy(obj)
	-- end
	-- LuaHelper.ForeachChild(model.transform:FindChild("camera").gameObject,eachFn)

	-- local model_data = models[data.career]
	-- model_data.scale_rate = Vector3(0.8,0.8,0.8)
	-- local modelView = require("common.uiModel")(model.gameObject,Vector3(0,-1.4,4),true,nil,model_data)

	local character_head_ = character_head[data.career]
	print("set texture"..character_head_)
	gf_setImageTexture(item.transform:FindChild("team_member_bg"):GetComponent(UnityEngine_UI_Image), character_head_)

end
function teamViewMember:teamItemUpdate(item,data)
	self:teamEmptyItemUpdate(item,false)
	self:teamLeaderItemUpdate(item,data)
	
	--隐藏队长标记
	local pNode = item.transform:FindChild("team_member_bg").transform:FindChild("team_panel")
	local pTransform = pNode.transform
	local leaderTag = pTransform:FindChild("leadertag").gameObject
	leaderTag:SetActive(false)
	-- local character_head_ = character_head[data.career]
	-- gf_setImageTexture(item.transform:FindChild("team_member_bg"):GetComponent(UnityEngine_UI_Image), character_head_)
end

function teamViewMember:initPowerLimitChange(power)
	if not power then
		local data = LuaItemManager:get_item_obejct("team"):getTeamData()
		power = data.powerLimit
	end
	if not self.powerNode then
		self.powerNode=LuaHelper.FindChildComponent(self.root,"team_input_inputfiled_text","UnityEngine.UI.Text")
	end
	self.powerNode.text = power > 0 and power or commomString[4]
end

function teamViewMember:closeButtonClick()
	-- self:dispose()
	self:view_clear()
end
function teamViewMember:exitButtonClick()
	local sure_fun = function()
		LuaItemManager:get_item_obejct("team"):sendToExitTeam()
	end
	local content = gf_localize_string("你是否要离开队伍？")
	--如果在组队副本里面
	if gf_getItemObject("copy"):is_team() then
		content = gf_localize_string("退出队伍的同时，也会退出组队副本，确定要退出吗？")
	end
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
end
function teamViewMember:applyButtonClick()
	require("models.team.applyView")()
end

--跟随 取消跟随
function teamViewMember:followButtonClick(flag)
	--切换是否允许自动加入限制
	flag:SetActive(not flag.activeSelf)
	-- LuaItemManager:get_item_obejct("team"):sendToAutoAgree(not flag.activeSelf)
	-- LuaItemManager:get_item_obejct("team"):sendToChangeLeader(leaderId)
end
--点击
function teamViewMember:on_click(obj,arg)
	local eventName = obj.name
	if eventName == "team_close_button_myteam" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:closeButtonClick()
    elseif eventName == "team_exit_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:exitButtonClick()
    elseif eventName == "team_agreeflag_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:followButtonClick(arg)
    elseif eventName == "add_panel"  then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.team.inviteView")()

    elseif eventName == "team_member_bg" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:member_click(arg)

    elseif eventName == "team_enter_button_myteam" then
    	gf_team_follow()
    	
    end
end

function teamViewMember:initTarget()
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	local targetId = data.target
	
	local targetName = targetId > 0 and dataUse.getTargetNameById(targetId) or commomString[4]
	local targetText = LuaHelper.FindChildComponent(self.root,"target","UnityEngine.UI.Text")
	targetText.text = targetName
end

function teamViewMember:member_click(arg)
	local item = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
	local index = item.index + 1 		 --索引从零开始
	local data = gf_getItemObject("team"):getTeamData()

	local roleId = data.members[index].roleId
	local myRoleId = gf_getItemObject("game"):getId()
	if myRoleId ~= roleId then
		LuaItemManager:get_item_obejct("player"):show_player_tips(roleId)
	end

end

function teamViewMember:on_receive(msg, id1, id2, sid)	
	local modelName = "team"
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "LeaveTeamR") then
			--退出队伍
			local myRoldId = LuaItemManager:get_item_obejct("game").role_info.roleId
			if myRoldId == msg.roleId then
				-- self:dispose()
				self:view_clear()
			else
				--刷新界面  or 成为队长
				self:initTeamScrollView()
			end
		elseif  id2 == Net:get_id2(modelName, "ChangeLeaderR") then
			--如果队长是自己
			local myRoldId = LuaItemManager:get_item_obejct("game").role_info.roleId
			if myRoldId == msg.newLeader then
				-- self:dispose()
				self:view_clear()
				require("models.team.teamEnter")()
			else
				self:initTeamScrollView()
			end
		elseif id2 == Net:get_id2(modelName, "ChangePowerLimitR") then
			self:initPowerLimitChange(msg.newLimit)

		--目标切换
		elseif id2 == Net:get_id2(modelName,"ChangeTargetR") then
			self:initTarget()

		elseif id2 == Net:get_id2(modelName,"MemberAttrChangeNotifyR") then
			self:initTeamScrollView()

		elseif id2 == Net:get_id2(modelName,"FollowLeaderR") then
			self:initView()

		elseif id2 == Net:get_id2(modelName,"JoinTeamResultR") then
			self:initTeamScrollView()

		end
	end


	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			self:view_clear()
		end
	end

	
end

function teamViewMember:view_clear()
	self:hide()
	self.opinion:hide()
end
-- 释放资源
function teamViewMember:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return teamViewMember

