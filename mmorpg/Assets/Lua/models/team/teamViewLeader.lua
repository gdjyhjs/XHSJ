--[[
	组队界面 有组队状态 队长
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local commomString = 
{
	[1] = gf_localize_string("无"),
	[2] = gf_localize_string("请输入大于零的数字"),
	[3] = gf_localize_string("<color=#F34248>只可匹配组队副本</color>"),
	[4] = gf_localize_string("正在匹配中"),
	[5] = gf_localize_string("开始匹配"),
	[6] = gf_localize_string("取消匹配"),
	[7] = gf_localize_string("队伍已满，无需匹配"),
}

local res = 
{
	[1] = "team_1.u3d", 
}

local dataUse = require("models.team.dataUse")
require("models.team.teamConfig")
--@bType 选中项 
local teamViewLeader=class(UIBase,function(self,pre_target_id)
	self.pre_target_id = pre_target_id
	self:set_bg_visible(true)
	local item_obj = LuaItemManager:get_item_obejct("team")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)
local models = {
    [Enum.CAREER.MAGIC] = {model_name="111101.u3d",default_angles= Vector3(0,158,0)},
    [Enum.CAREER.SOLDER] = {model_name="114101.u3d",default_angles= Vector3(0,159,0)},
    [Enum.CAREER.BOWMAN] = {model_name="112101.u3d",default_angles= Vector3(0,159,0)},
}

function teamViewLeader:dataInit()
end

-- 资源加载完成
function teamViewLeader:on_asset_load(key,asset)
	self:hide_mainui(true)
	
end

function teamViewLeader:init_data()
	self.itemList = {}
end
function teamViewLeader:init_ui()

	if self.pre_target_id then
		self.targetId = self.pre_target_id
		self:auto_click()
		self.pre_target_id = nil
	end

	self:initScrollView()
	self:initTeamScrollView()
	self:initTarget(true)
	self:initGotoName()
	self:initAutoAgree()
	self:initPowerLimitChange()
	self:postButtonUpdate()
	self:start_scheduler()
	self:init_button()

end


function teamViewLeader:init_button()
	local is_mathing = gf_getItemObject("team"):get_matching_state()
	self.refer:Get(5).text = is_mathing and commomString[6] or commomString[5]
end

function teamViewLeader:initTarget(isFirst)
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	local targetId = self.targetId and self.targetId or data.target
	self.targetId = targetId
	if not isFirst then
		self.opinion:setTarget(targetId)
	end
	local targetName = targetId > 0 and dataUse.getTargetNameById(targetId) or commomString[1]
	local targetText = LuaHelper.FindChildComponent(self.root,"target","UnityEngine.UI.Text")
	targetText.text = targetName
end
function teamViewLeader:initGotoName()
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	local targetId = self.targetId and self.targetId or data.target
	local button = LuaHelper.FindChildComponent(self.root,"team_enter_button_myteam","UnityEngine.UI.Button")
	print("wtf targetId:",targetId)
	button.gameObject:SetActive(true)
	if targetId <= 0 or targetId == 1 then
		button.gameObject:SetActive(false)
		return
	end
	local gotoName = targetId > 0 and dataUse.getGotoNameById(targetId)
	local gotoNameNode = LuaHelper.FindChildComponent(self.root,"gotoname","UnityEngine.UI.Text")
	if not gotoName or gotoName == "" then
		button.gameObject:SetActive(false)
		return
	end
	gotoNameNode.text = gotoName
end
function teamViewLeader:initAutoAgree()
	local autoAgreeButton = LuaHelper.FindChild(self.root,"team_agreeflag_button_myteam")
	local autoAgreeTag = LuaHelper.FindChildComponent(autoAgreeButton,"Image",UnityEngine_UI_Image)
	self.autoAgreeTag = autoAgreeTag

	local data = LuaItemManager:get_item_obejct("team"):getTeamData()

	if data.autoAgree then
		autoAgreeTag.gameObject:SetActive(true)
	else
		autoAgreeTag.gameObject:SetActive(false)
	end
end
--右边条件选择
function teamViewLeader:initScrollView()
	local callback = function(targetId)
		self.targetId = targetId
		--切换tag
		LuaItemManager:get_item_obejct("team"):sendToChangeTarget(targetId)
		self:postButtonUpdate()
	end 
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	local targetId = self.targetId or data.target
	self.opinion = require("models.team.opinion")(targetId,callback)
	-- self:add_child(self.opinion)
end

function teamViewLeader:initTeamScrollView()
	local data = LuaItemManager:get_item_obejct("team"):getTeamData()
	--排序 队长在前
	for i,v in ipairs(data.members) do
		v.sort = v.roleId == data.leader and 1 or 0
	end

	if #data.members > 1 then
		table.sort(data.members,function(a,b) return a.sort > b.sort end)
	end
	gf_print_table(data, "队伍信息:")
	--如果队友未满 补全
	local memberTable = {}
	for i,v in ipairs(data.members or {}) do
		table.insert(memberTable,v)
	end
	local empty = {roleId = -1,}
	for i=1,teamNumberCount - #data.members do
		table.insert(memberTable,empty)
	end
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
 	local scroll_rect_table = refer:Get(1)
	-- local scroll_rect_table = LuaHelper.GetComponentInChildren(self.root,ScrollRectTable) --找到ScrollRectTable控件 
  		
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		gf_print_table(data_item, "data_item:")

		scroll_rect_item.name = "team_item"..index

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

		if index == 3 then
			self:update_item_state()
		end
	end

  	scroll_rect_table.data = memberTable--data.members --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据
end


function teamViewLeader:teamEmptyItemUpdate(item,showAdd)
	local pNode = item.transform:FindChild("team_member_bg")
	local tNode = pNode.transform:FindChild("team_panel")
	tNode.gameObject:SetActive(not showAdd)
	local aNode = pNode.transform:FindChild("add_panel")
	aNode.gameObject:SetActive(showAdd)

	local aNode = pNode.transform:FindChild("auto")
	aNode.gameObject:SetActive(not showAdd)

	if showAdd then
		gf_setImageTexture(item.transform:FindChild("team_member_bg"):GetComponent(UnityEngine_UI_Image), "team_bg_01")
	end
	
	-- local camera = pNode.transform:FindChild("model").transform:FindChild("camera")
	-- for i=1,camera.transform.childCount do
 --  		local go = camera.transform:GetChild(i - 1).gameObject
	-- 	LuaHelper.Destroy(go)
 --  	end
end
function teamViewLeader:teamLeaderItemUpdate(item,data)
	local pNode = item.transform:FindChild("team_member_bg").transform:FindChild("team_panel")
	local pTransform = pNode.transform
	--name
	local node = pNode:FindChild("name"):GetComponent("UnityEngine.UI.Text")
	node.text = data.name.."  lv."..data.level
	--power
	local node = pNode:FindChild("power"):GetComponent("UnityEngine.UI.Text")
	node.text = "战力  "..data.power or 111111
	--lv 
	-- local node = pNode:FindChild("lv"):GetComponent("UnityEngine.UI.Text")
	-- node.text = string.format("Lv.%d",data.level)
	--位置
	local map_name = ConfigMgr:get_config("mapinfo")[data.mapId].name
	local node = pNode:FindChild("location"):GetComponent("UnityEngine.UI.Text")
	node.text = map_name
 
	-- local model =item.transform:FindChild("team_member_bg").transform:FindChild("model")

	-- local eachFn =function(i,obj)
	-- 	print("destroy:",i)
	-- 	LuaHelper.Destroy(obj)
	-- end
	-- LuaHelper.ForeachChild(model.transform:FindChild("camera").gameObject,eachFn)

	-- local model_data = models[data.career]
	-- model_data.scale_rate = Vector3(0.8,0.8,0.8)

	local character_head_ = character_head[data.career]
	gf_setImageTexture(item.transform:FindChild("team_member_bg"):GetComponent(UnityEngine_UI_Image), character_head_)

	-- local modelView = require("common.uiModel")(model.gameObject,Vector3(0,-1.4,4),true,nil,model_data)
	-- self.itemList[item] = model
	
end
function teamViewLeader:teamItemUpdate(item,data)
	self:teamEmptyItemUpdate(item,false)
	--隐藏队长标记
	local pNode = item.transform:FindChild("team_member_bg").transform:FindChild("team_panel")
	local pTransform = pNode.transform
	local leaderTag = pTransform:FindChild("leadertag").gameObject
	leaderTag:SetActive(false)
	self:teamLeaderItemUpdate(item,data)
end

function teamViewLeader:postButtonUpdate()
	if self.targetId > 1 then
		self.refer:Get(3).gameObject:SetActive(true)
		return	
	end
	self.refer:Get(3).gameObject:SetActive(false)	
end

function teamViewLeader:postButtonClick()
	-- LuaItemManager:get_item_obejct("team"):sendToChangeLeader(leaderId)
	local teamId = gf_getItemObject("team"):getTeamData().teamId
	local targetId = self.targetId
	if targetId <= 1 then
		return
	end
	local targetName,bTargetName = dataUse.getTargetNameById(targetId) 

	print("targetName,bTargetName:",targetName,bTargetName,self.targetId)

	local bigTarget = bTargetName
	local smlTarget = targetName

	local target_info = dataUse.getTargetDataById(self.targetId)
	local copy_id = target_info.open_param[1]

	local level = gf_get_config_table("copy")[copy_id].min_level
	 --dataUse.getTargetLimitLevel(targetId)
	level = level > 0 and string.format("（%d级）",level) or ""
	local str = "%s【%s】%s"
	
	str = string.format(str,bigTarget,smlTarget,level).."%s"

	local channel = Enum.CHAT_CHANNEL.WORLD

	if gf_getItemObject("legion"):is_in() then
		channel = Enum.CHAT_CHANNEL.ARMY_GROUP
	end

	gf_getItemObject("chat"):send_apply_into_team(teamId,channel,str)
	
end
function teamViewLeader:closeButtonClick()
	self.opinion:dispose()
	self:hide()
	
end
function teamViewLeader:exitButtonClick()
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
function teamViewLeader:applyButtonClick()
	require("models.team.applyView")()
end
--进入副本
function teamViewLeader:enterButtonClick()
	local target_info = dataUse.getTargetDataById(self.targetId)
	gf_print_table(target_info, "wtf target_info:"..self.targetId)
	
	if target_info.open_type == 1 then
		ENTER_TEAM_COPY(target_info.open_param[1])

	elseif target_info.open_type == 5 then
		if #team_data.members == 1 then
			self:view_clear()
		end
		gf_getItemObject("pvp3v3"):send_to_enter_fight_c2s()

	end
	
end
function teamViewLeader:agreeFlagButtonClick(flag)
	print("agreeFlagButtonClick",flag.activeSelf)
	--切换是否允许自动加入限制
	local isAgree = flag.activeSelf
	flag:SetActive(not isAgree)
	LuaItemManager:get_item_obejct("team"):sendToAutoAgree(not isAgree)
end
function teamViewLeader:initPowerLimitChange(power)
	if not power then
		local data = LuaItemManager:get_item_obejct("team"):getTeamData()
		gf_print_table(data,"data:")
		power = data.powerLimit
	end 
	if not self.powerNode then
		self.powerNode=LuaHelper.FindChildComponent(self.root,"team_input_inputfiled_text","UnityEngine.UI.Text")
	end
	self.powerNode.text = power > 0 and power or commomString[1]
end

function teamViewLeader:powerChangeClick()
	local callback = function()
		local power = tonumber(self.powerNode.text)
    	if not power or power < 0 then
    		self:initPowerLimitChange(0)
    		gf_message_tips(commomString[2])
    		return
    	end
    	gf_getItemObject("team"):sendToChangePowerLimit(math.floor(power))
	end
	gf_getItemObject("keyboard"):use_number_keyboard(self.powerNode,99999999,0,pos,pivot,anchor,initValue,callback,ep)
end

function teamViewLeader:member_click(arg)
	local item = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
	local index = item.index + 1 		 --索引从零开始
	local data = gf_getItemObject("team"):getTeamData()
	gf_print_table(data, "data wtf:")
	if next(data.members[index] or {}) then
		local roleId = data.members[index].roleId
		print("show player1",roleId)
		local myRoleId = gf_getItemObject("game"):getId()
		if myRoleId ~= roleId then
			print("show player2",roleId)
			LuaItemManager:get_item_obejct("player"):show_player_tips(roleId)
		end
	end

end

--点击
function teamViewLeader:on_click(obj,arg)

	local eventName = obj.name
	print("teamViewLeader on_click",eventName)
	if  eventName == "team_post_button_myteam" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:postButtonClick()
    
    elseif eventName == "team_close_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:closeButtonClick()
    
    elseif eventName == "team_exit_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:exitButtonClick()
    
    elseif eventName == "team_apply_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:applyButtonClick()
    
    elseif eventName == "team_enter_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:enterButtonClick()
    
    elseif eventName == "team_agreeflag_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:agreeFlagButtonClick(arg)

    elseif eventName == "edit_Image" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:powerChangeClick()

    elseif eventName == "add_panel" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.team.inviteView")()

    elseif eventName == "team_member_bg" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:member_click(arg)

    elseif eventName == "team_begin_button_myteam" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:auto_click(arg)

    end
end

function teamViewLeader:auto_click()
	local is_mathing = gf_getItemObject("team"):get_matching_state()

	local data = LuaItemManager:get_item_obejct("team"):getTeamData()


	if #data.members == teamNumberCount then
		gf_message_tips(commomString[7])
		return
	end
	local target_data = dataUse.getTargetDataById(self.targetId)
	--组队类型  
	if self.targetId > 0 and target_data.open_type == 1 then
		local is_mathing = not gf_getItemObject("team"):get_matching_state()
		gf_getItemObject("team"):sendToMatch(is_mathing,self.targetId)
		return
	end
	gf_message_tips(commomString[3])

end

function teamViewLeader:view_clear()
	self.opinion:dispose()
	self:hide()
end
function teamViewLeader:on_receive(msg, id1, id2, sid)	
	local modelName = "team"
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "LeaveTeamR") then
			--退出队伍
			local myRoldId = LuaItemManager:get_item_obejct("game").role_info.roleId
			if myRoldId == msg.roleId then
				self:view_clear()
				require("models.team.teamEnter")()
			else
				self:initTeamScrollView()
			end

		--目标切换
		elseif id2 == Net:get_id2(modelName,"ChangeTargetR") then
			self:initTarget()
			self:initGotoName()

		--有人加入队伍 刷新界面
		elseif id2 == Net:get_id2(modelName,"JoinTeamResultR") then
			self:initTeamScrollView()
			
		elseif id2 == Net:get_id2(modelName,"ChangeLeaderR") then
			self:view_clear()
			require("models.team.teamEnter")()

		elseif id2 == Net:get_id2(modelName,"ChangePowerLimitR") then
			self:initPowerLimitChange(msg.newLimit)

		elseif id2 == Net:get_id2(modelName,"MemberAttrChangeNotifyR") then
			self:initTeamScrollView()

		elseif id2 == Net:get_id2(modelName, "TeamAutoMatchR") then
			self:rec_matching(msg)

		end
	end

	--单人进入副本
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			self:view_clear()
		end
	end

	-- if id1 == ClientProto.JointTeam then
	-- 	self:hide()
	-- 	self.opinion:hide()
	-- 	require("models.team.teamEnter")()
	-- end

end

function teamViewLeader:rec_matching(msg)
	--进入匹配模式
	self:start_scheduler()
	self:init_button()
end

function teamViewLeader:update_item_state()
	local is_mathing = gf_getItemObject("team"):get_matching_state()
	local data = LuaItemManager:get_item_obejct("team"):getTeamData().members
	for i=1,teamNumberCount do 
		local node = self.refer:Get(4).transform:FindChild("team_item"..i)
		if node then
			local refer = node:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
			refer:Get(1):SetActive(is_mathing)
			if i <= #data then
				refer:Get(1):SetActive(false)
			end
		end
	end
end

function teamViewLeader:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local is_mathing = gf_getItemObject("team"):get_matching_state()
	self.tick = 0
	local update = function()
		self.tick = self.tick + 1
		local data = LuaItemManager:get_item_obejct("team"):getTeamData()
		for i=#data.members + 1,teamNumberCount do 
			local node = self.refer:Get(4).transform:FindChild("team_item"..i)
			if node then
				local refer = node:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
				refer:Get(1):SetActive(is_mathing)
				local str = ""
				for i=1,self.tick % 4 do
					str = str .. "."
				end
				refer:Get(2).text = commomString[4]..str
			end
		end
	end
	update()
	
	if not is_mathing then
		return
	end
	
	self.schedule_id = Schedule(update, 0.5)
end


function teamViewLeader:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function teamViewLeader:on_showed()
	StateManager:register_view(self)
	self:init_data()
	self:init_ui()
end

function teamViewLeader:clear()
	self:stop_schedule()
end

function teamViewLeader:on_hided()
	self:clear()
	StateManager:remove_register_view(self)
end

-- 释放资源
function teamViewLeader:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return teamViewLeader