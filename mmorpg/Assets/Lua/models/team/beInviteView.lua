--[[
	邀请界面
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
require("models.team.teamConfig")

local commomString = 
{
	[1] = gf_localize_string("无"),
}

local res = 
{
	[1] = "team_6.u3d", 
}

local dataUse = require("models.team.dataUse")
--@bType 选中项 
local beInviteView=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("team")
	UIBase._ctor(self, res[1], item_obj)
end)


function beInviteView:dataInit()
end

-- 资源加载完成
function beInviteView:on_asset_load(key,asset)
	gf_getItemObject("team"):clear_team_red_point()
	StateManager:register_view(self)

	self:init_ui()
end

function beInviteView:init_ui()
	local viewData = LuaItemManager:get_item_obejct("team"):getInviteList()
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
		scroll_rect_item.gameObject:SetActive(true) --显示项
		scroll_rect_item:Get(1).text = data_item.teamId
		
		local data = getLeaderInfo(data_item)

		local parentNode = scroll_rect_item:Get(2)
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
		local icon = scroll_rect_item:Get(3).transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		gf_set_head_ico(icon,data.head)
	end

  	scroll_rect_table.data = viewData --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据

end

function beInviteView:rejectButtonClick()
	--发送全部拒绝协议并关闭界面
	gf_getItemObject("team"):sendToRejectAllInvite()
	-- self:dispose()
	self:hide()
end
function beInviteView:closeButtonClick()
	-- self:dispose()
	self:hide()
end
function beInviteView:createButtonClick()
	-- self:dispose()
	self:hide()
	LuaItemManager:get_item_obejct("team"):sendToCreateTeam()
end

--点击
function beInviteView:on_click(obj,arg)
	local eventName = obj.name
	
	if  eventName == "team_reject_button_beinvite" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:rejectButtonClick()

    elseif eventName == "team_close_button_beinvite" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:closeButtonClick()

    elseif eventName == "team_create_button_beinvite" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:createButtonClick()

    elseif eventName == "team_accept_button_invite" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local value = LuaHelper.FindChildComponent(arg,"value","UnityEngine.UI.Text").text
    	local teamId = tonumber(value)
    	self:hide()
    	gf_getItemObject("team"):setInviteList()
    	LuaItemManager:get_item_obejct("team"):sendToAgreeInvite(teamId,true)

    end
end

function beInviteView:on_receive(msg, id1, id2, sid)	
	local modelName = "team"
	if id1 == Net:get_id1(modelName) then
		-- if id2 == Net:get_id2(modelName, "GetInviteListR") then
		-- end
	end
end

-- 释放资源
function beInviteView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return beInviteView

