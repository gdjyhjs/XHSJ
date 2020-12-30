
--[[
	组队主界面  没有组队界面
	create at 17.5.22
	by xin
]]
local LuaHelper = LuaHelper

local modelName = "team"

local dataUse = require("models.team.dataUse")

local res = 
{
	[1] = "team_4.u3d",
	[2] = "team_scrollview.u3d",
}

local job_res = 
{
	[ServerEnum.CAREER.MAGIC] = "team_job_02",
	[ServerEnum.CAREER.BOWMAN] = "team_job_03",
	[ServerEnum.CAREER.SOLDER] = "team_job_01",
}

local commomString = 
{
	[1] = gf_localize_string("一键申请"),
	[2] = gf_localize_string("附近队伍"),
	[3] = gf_localize_string("%s的队伍"),
	[4] = gf_localize_string("战力限制：%d"),
	[5] = gf_localize_string("无"),
	[6] = gf_localize_string("请输入大于零的数字"),
	[7] = gf_localize_string("<color=#F34248>只可匹配组队副本</color>"),
	[8] = gf_localize_string("开始匹配"),
	[9] = gf_localize_string("取消匹配"),
	[10] = gf_localize_string("正在匹配中"),
	
}


local teamView=class(Asset,function(self,item_obj)
	self.item_obj=item_obj
    self:uiLoad()
end)

function teamView:uiLoad()
	local resName = res[1]
	self:set_bg_visible(true)
	Asset._ctor(self, resName) -- 资源名字全部是小写
	
end

--资源加载完成
function teamView:on_asset_load(key,asset)
	self:hide_mainui(true)
	
	self.item_obj:register_event("team_view_on_click", handler(self, self.on_click))
    print("组队初始化完毕")

end

function teamView:init_ui()

	local param = gf_getItemObject("team"):get_param()
	gf_print_table(param, "wtf param:")
	if next(param or {})  then
	 	self.targetId = param[1]
	 	if param[2] then
	 		self:auto_click()
	 	end
		gf_getItemObject("team"):set_param()
	end

	self:initScrollView()
	self:initTeamScrollView({})
	self:initMatchingTeamScrollView()
	self:init_top()
	self:init_button()

end

function teamView:pre_target_init()
	if self.pre_target_id then
		
	end
end

function teamView:init_button()
	local is_mathing = gf_getItemObject("team"):get_matching_state()
	self.refer:Get(7).text = is_mathing and commomString[9] or commomString[8]
end

function teamView:init_top()
	self.refer:Get(2).text = commomString[5]
	print("wtf self.targetId:",self.targetId)
	if self.targetId then
		local targetName = dataUse.getTargetNameById(self.targetId) 
		self.refer:Get(2).text = targetName
	end
	

	self.refer:Get(3).text = commomString[5]
end

--右边条件选择
function teamView:initScrollView()
	local callback = function(targetId)
		print("arg:",targetId)
		self.targetId = targetId
		self:updateApplyButton()

		local targetName = targetId > 0 and dataUse.getTargetNameById(targetId) or commomString[5]
		self.refer:Get(2).text = targetName

		if targetId == 0 or targetId == 1 then
			self:initTeamScrollView({})
			return 
		end
		
		LuaItemManager:get_item_obejct("team"):sendToGetTeamByTargetId(targetId)
	end
	self.opinion = require("models.team.opinion")(self.targetId,callback)
	if self.targetId then
		callback(self.targetId)
	end
	-- self:add_child(self.opinion)
end

--刷新一键申请按钮
function teamView:updateApplyButton()
	local text = self.refer:Get("txt_team_nearby")
	if self.targetId > 1 then
		text.text = commomString[1]
		return
	end
	text.text = commomString[2]
end


function teamView:initTeamScrollView(viewData)

	local is_mathing = gf_getItemObject("team"):get_matching_state()
	print("is_mathing1:",is_mathing)
	self.refer:Get(5):SetActive(not is_mathing)

	local viewData = viewData or {}
	if not next(viewData or {}) then
		LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(true)
	else
		LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(false)
	end
	-- --创建panel 
 	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
 	local scroll_rect_table = refer:Get(1)
 	
	local function getLeaderData(data)
		for i,v in ipairs(data.members or {}) do
			if v.roleId == data.leader then
				return v
			end
		end
	end

	

 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true) --显示项
		--修改value值为teamId
		local button = scroll_rect_item.transform:FindChild("Image").transform:FindChild("team_apply")
		local valueText = button:FindChild("value"):GetComponent("UnityEngine.UI.Text")
		valueText.text = data_item.teamId

		local leader_data = getLeaderData(data_item)

		--队伍名字
		scroll_rect_item:Get(3).text = string.format(commomString[3],leader_data.name)
		--战力限制
		scroll_rect_item:Get(4).text = string.format(commomString[4],data_item.powerLimit)
		--头像 
		gf_set_head_ico(scroll_rect_item:Get(5), leader_data.head)
		--等级
		scroll_rect_item:Get(6).text = leader_data.level

		--队伍成员数据
		for i=1,3 do
			local mebmer_data = data_item.members[i]
			local item = scroll_rect_item:Get(12 + i)
			if mebmer_data then
				item:SetActive(true)
				gf_setImageTexture(scroll_rect_item:Get(6 + i),job_res[mebmer_data.career])
				scroll_rect_item:Get(9 + i).text = mebmer_data.level
			else
				item:SetActive(false)
			end
			
		end

	end
  	scroll_rect_table.data = viewData --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据
end

function teamView:initMatchingTeamScrollView()
	local is_mathing = gf_getItemObject("team"):get_matching_state()
	print("is_mathing2:",is_mathing)

	self.refer:Get(4):SetActive(is_mathing)
	-- --创建panel 
 	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
 	local scroll_rect_table = refer:Get(6)

 	scroll_rect_table.onItemRender = function(item,index,data_item) --设置渲染函数
 		item.name = "team_item"..index

 		if index > 1 then
 			item:Get(3):SetActive(false)
 			item:Get(4):SetActive(true)
 			return
 		end
 		item:Get(3):SetActive(true)
 		item:Get(4):SetActive(false)
 		local game_data = gf_getItemObject("game")
 		local pNode = item.transform:FindChild("team_member_bg").transform:FindChild("team_panel")
		local pTransform = pNode.transform
		--name
		local node = pNode:FindChild("name"):GetComponent("UnityEngine.UI.Text")
		node.text = game_data:getName().."  lv."..game_data:getLevel()
		--power
		local node = pNode:FindChild("power"):GetComponent("UnityEngine.UI.Text")
		node.text = "战力  "..game_data:getPower()
		
		--位置
		local map_name = ConfigMgr:get_config("mapinfo")[game_data:get_map_id()].name
		local node = pNode:FindChild("location"):GetComponent("UnityEngine.UI.Text")
		node.text = map_name
		local character_head_ = character_head[game_data:get_career()]
		gf_setImageTexture(item.transform:FindChild("team_member_bg"):GetComponent(UnityEngine_UI_Image), character_head_)

		if index == 1 then
			self:start_scheduler()
		end
	end
  	scroll_rect_table.data = {1,2,3} --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据
end


function teamView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local is_mathing = gf_getItemObject("team"):get_matching_state()
	if not is_mathing then
		return
	end
	
	self.tick = 0
	local update = function()
		self.tick = self.tick + 1
		for i=2,teamNumberCount do
			local node = self.refer:Get(8).transform:FindChild("team_item"..i)
			if not node then
				return
			end
			local refer = node:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
			refer:Get(2):SetActive(true)

			local str = ""

			for i=1,self.tick % 4 do
				str = str .. "."
			end

			refer:Get(1).text = commomString[10]..str
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end


function teamView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function teamView:nearByButtonClick()
	require("models.team.nearbyView")()
end

function teamView:createButtonClick()
	self.item_obj:sendToCreateTeam()
end

function teamView:inviteListButtonClick()
	require("models.team.beInviteView")()
end
     
--鼠标单击事件
function teamView:on_click(item_obj, obj, arg)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if  cmd == "team_nearby_button" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if self.targetId and self.targetId > 1 then
    		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    		print("一键申请",self.targetId)
    		gf_getItemObject("team"):sendToApplyAll(self.targetId)
    		return
    	end
    	self:nearByButtonClick()
    elseif cmd == "team_invitelist_button" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:inviteListButtonClick()
    elseif cmd == "team_create_button" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:createButtonClick()
    elseif cmd == "team_btn_cancle" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	-- self.item_obj:remove_view()
    	self.opinion:dispose()
    	self:hide()
    	
    elseif cmd == "team_apply" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local teamId = tonumber(arg:GetComponent("UnityEngine.UI.Text").text or {}) or -1
    	print("teamId:",teamId)
    	LuaItemManager:get_item_obejct("team"):sendToJoinTeam(teamId)

    elseif cmd == "edit_Image" then
    	self:edit_click()

    elseif cmd == "team_auto_button" then
    	self:auto_click()

    elseif cmd == "add_panel" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.team.inviteView")()
    	
    end
end

function teamView:auto_click()
	local is_mathing = gf_getItemObject("team"):get_matching_state()

	local target_data = dataUse.getTargetDataById(self.targetId)
	--组队类型
	if self.targetId and self.targetId > 1 and target_data.open_type == 1 then
		local is_mathing = not gf_getItemObject("team"):get_matching_state()
		gf_getItemObject("team"):sendToMatch(is_mathing,self.targetId)
		return
	end
	gf_message_tips(commomString[7])

end


function teamView:edit_click()
	local callback = function()
		local power = tonumber(self.refer:Get(3).text)
    	if not power or power < 0 then
    		self.refer:Get(3).text = 0
    		gf_message_tips(commomString[6])
    		return
    	end
    	gf_getItemObject("team"):sendToChangePowerLimit(math.floor(power))
	end
	gf_getItemObject("keyboard"):use_number_keyboard(self.refer:Get(3),99999999,0,pos,pivot,anchor,initValue,callback,ep)
end

-- 释放资源
function teamView:dispose()
	self:clear()
    self._base.dispose(self)
end

function teamView:clear()
	self.targetId = nil
	self.opinion = nil
	self:stop_schedule()
end

function teamView:on_showed()
	self:init_ui()
end

--每次隐藏时调用
function teamView:on_hided()
	self:clear()
end

function teamView:on_update()
end


function teamView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		--创建队伍成功时 关闭主界面 打开有队伍界面
		if id2 == Net:get_id2(modelName, "CreateTeamR") or id2 == Net:get_id2(modelName, "InviteNoticeR") or id2 == Net:get_id2(modelName, "JoinTeamResultR") then
			-- self.item_obj:remove_view()
			self.opinion:dispose()
			self:hide()
			
			--通知关闭界面
			require("models.team.teamEnter")()
		--请求进入队伍 接受进入队伍成功 关闭主界面 进入有队伍界面
    	-- elseif id2 == Net:get_id2(modelName, "InviteNoticeR") or id2 == Net:get_id2(modelName, "JoinTeamResultR") then
    	-- 	print("接收到加入队伍 销毁次界面")
    	-- 	-- self.item_obj:remove_view()
    	-- 	self:hide()
    	-- 	self.opinion:hide()
			-- require("models.team.teamEnter")()
		elseif id2 == Net:get_id2(modelName, "TargetTeamListR") then
			--刷新tableview
			local viewData = msg.team
			gf_print_table(viewData, "目标队伍:")
			self:initTeamScrollView(viewData)

		elseif id2 == Net:get_id2(modelName, "GetNearTeamR")  then
			-- self:initTeamScrollView(msg.teamList)

		elseif id2 == Net:get_id2(modelName, "TeamAutoMatchR") then
			self:initTeamScrollView({})
			self:initMatchingTeamScrollView()
			self:init_top()
			self:init_button()

		end
	end
	-- if id1 == ClientProto.JointTeam then
	-- 	self:hide()
 --    	self.opinion:hide()
	-- end
end

return teamView