--[[
	附近队伍界面
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commomString = 
{
	[1] = gf_localize_string("无"),
	[2] = gf_localize_string("战力不足"),
	[3] = gf_localize_string("等级不足"),

}

local res = 
{
	[1] = "team_5.u3d", 
}

local dataUse = require("models.team.dataUse")
require("models.team.teamConfig")
--@bType 选中项 
local nearbyView=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("team")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


function nearbyView:dataInit()
end

-- 资源加载完成
function nearbyView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.item_obj:sendToGetNearTeam()
	-- self:init_ui({1})
end

function nearbyView:init_ui(viewData)
	self.viewData = viewData
	LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(false)
	if not next(viewData or {}) then
		LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(true)
	end
	local scroll_rect_table = LuaHelper.GetComponentInChildren(self.root,ScrollRectTable) --找到ScrollRectTable控件 
  	
  	local function getLeaderInfo(data)
  		local leaderId = data.leader
  		for i,v in ipairs(data.members or {}) do
  			if v.roleId == leaderId then
  				return v
  			end
  		end
  		print("error 没有找到队长")
  		return nil
  	end

 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
 		-- gf_print_table(data_item, "data item:")
		scroll_rect_item.gameObject:SetActive(true) --显示项
		scroll_rect_item:Get(1).text = data_item.teamId
		local parentNode = scroll_rect_item:Get(2)
		local data = getLeaderInfo(data_item)
		gf_print_table(data, "data:=====")
		parentNode.transform:FindChild("team_add_button_apply"):GetComponent("UnityEngine.UI.Button").interactable = true
		--名字
		local name = LuaHelper.FindChildComponent(parentNode,"name","UnityEngine.UI.Text")
		name.text = data.name 
		--战力限制
		local power = LuaHelper.FindChildComponent(parentNode,"power","UnityEngine.UI.Text")
		power.text = data_item.powerLimit
		--队长等级
		local level = LuaHelper.FindChildComponent(parentNode,"level","UnityEngine.UI.Text")
		level.text = data.level
		--目标
		local targetName = data_item.target > 0 and dataUse.getTargetNameById(data_item.target) or commomString[1]
		local node = LuaHelper.FindChildComponent(parentNode,"target","UnityEngine.UI.Text")
		node.text = targetName
		--人数
		local node = LuaHelper.FindChildComponent(parentNode,"count","UnityEngine.UI.Text")
		node.text = string.format("%d/%d",#data_item.members,teamNumberCount)
		--头像
		local icon = parentNode.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		gf_set_head_ico(icon,data.head)
	end

  	scroll_rect_table.data = viewData --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据

end

function nearbyView:getTeamData(teamId)
	for i,v in ipairs(self.viewData) do
		if v.teamId == teamId then
			return v 
		end
	end
	return nil
end
function nearbyView:getPowerByTeamId(teamId)
	local teamData = self:getTeamData(teamId)
	return teamData.powerLimit
end
function nearbyView:getLimitLevelByTeamId(teamId)
	local teamData = self:getTeamData(teamId)
	--如果没有目标
	if teamData.target <= 1 then
		return 0
	end
	return dataUse.getTargetLimitLevel(teamData.target)
end
function nearbyView:refreshButtonClick()
	self.item_obj:sendToGetNearTeam()
end
function nearbyView:closeButtonClick()
	-- self:dispose()
	self:hide()
end
function nearbyView:createButtonClick()
	-- self:dispose()
	self:hide()
	LuaItemManager:get_item_obejct("team"):sendToCreateTeam()
end

--点击
function nearbyView:on_click(obj,arg)
	local eventName = obj.name
	if  eventName == "team_refresh_button_nearby" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:refreshButtonClick()
    elseif eventName == "team_close_button_nearby" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:closeButtonClick()
    elseif eventName == "team_create_button_nearby" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:createButtonClick()
    elseif eventName == "team_add_button_apply" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--按钮置灰
    	LuaHelper.GetComponent(arg,"UnityEngine.UI.Button").interactable = false
    	local value = LuaHelper.FindChildComponent(arg,"value","UnityEngine.UI.Text").text
    	local teamId = tonumber(value)
    	print("teamId:",teamId)
    	local myPower = gf_getItemObject("game"):getPower()
    	if self:getPowerByTeamId(teamId) > myPower then
    		gf_message_tips(commomString[2])
    		return
    	end
    	local myLevel = gf_getItemObject("game"):getLevel()
    	if self:getLimitLevelByTeamId(teamId) > myLevel then
			gf_message_tips(commomString[3])
    		return
    	end
    	LuaItemManager:get_item_obejct("team"):sendToJoinTeam(teamId)
    end
end

function nearbyView:on_receive(msg, id1, id2, sid)	
	local modelName = "team"
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "GetNearTeamR") then
			gf_print_table(msg,"附近队伍列表:")
			self:init_ui(msg.teamList)
		elseif id2 == Net:get_id2(modelName,"CreateTeamR") then
			-- self:dispose()
			self:hide()
		elseif id2 == Net:get_id2(modelName,"JoinTeamResultR") then
			-- self:dispose()
		end
	end
end
-- 释放资源
function nearbyView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return nearbyView

