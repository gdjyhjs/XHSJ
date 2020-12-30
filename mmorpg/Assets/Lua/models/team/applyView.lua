--[[
	组队申请界面
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commomString = 
{
	[1] = gf_localize_string("你没有收到任何入队申请哦！"),
}

local res = 
{
	[1] = "team_7.u3d", 
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
	gf_getItemObject("team"):clear_team_red_point()
	StateManager:register_view(self)
	LuaItemManager:get_item_obejct("team"):sendToGetApplyList()

	self:init_origin_ui()
end

function applyView:init_origin_ui()
end

function applyView:init_ui(viewData)
	self.viewData =  viewData
	LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(false)
	if not next(viewData or {}) then
		LuaHelper.FindChild(self.root.transform,"bg").gameObject:SetActive(true)
		local tips = LuaHelper.FindChild(self.root.transform,"bg").transform:FindChild("bgtext").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		tips.text = commomString[1]
	end
	local scroll_rect_table = LuaHelper.GetComponentInChildren(self.root,ScrollRectTable) --找到ScrollRectTable控件 
  		
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
 		gf_print_table(data_item, "data item:")
		scroll_rect_item.gameObject:SetActive(true) --显示项
		scroll_rect_item:Get(1).text = data_item.roleId

		self:updateItem(scroll_rect_item,data_item)
	end

  	scroll_rect_table.data = viewData --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据

end

function applyView:updateItem(item,data)
	--name
	local node = LuaHelper.FindChildComponent(item.gameObject,"name","UnityEngine.UI.Text")
	node.text = data.name
	--power
	local node = LuaHelper.FindChildComponent(item.gameObject,"power","UnityEngine.UI.Text")
	node.text = data.power
	local node = LuaHelper.FindChildComponent(item.gameObject,"lv","UnityEngine.UI.Text")
	node.text = data.level
	--头像
	local icon = LuaHelper.FindChildComponent(item.gameObject,"icon",UnityEngine_UI_Image)
	gf_set_head_ico(icon,data.head)
end

function applyView:rejectButtonClick()
	-- self.opinion = require("models.team.opinion")()
	gf_getItemObject("team"):sendToRejectAll()
	-- self:dispose()
	self:hide()
end
function applyView:closeButtonClick()
	-- self:dispose()
	self:hide()
end
function applyView:createButtonClick()
	LuaItemManager:get_item_obejct("team"):sendToCreateTeam()
end

--点击
function applyView:on_click(obj,arg)
	local eventName = obj.name
	if  eventName == "team_reject_button_apply" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:rejectButtonClick()
    elseif eventName == "team_close_button_apply" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:closeButtonClick()
    elseif eventName == "team_agree_button_apply" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local value = LuaHelper.FindChildComponent(arg,"value","UnityEngine.UI.Text").text
    	local roleId = tonumber(value) 

    	local data = self.data
    	for i,v in ipairs(data or {}) do
    		if v.roleId == roleId then
    			table.remove(data,i)
    		end
    	end
    	self:init_ui(data)

   		LuaItemManager:get_item_obejct("team"):sendToAgreeToTeam(roleId,true)
    end
end

function applyView:on_receive(msg, id1, id2, sid)	
	local modelName = "team"
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "GetApplyListR") then
			gf_print_table(msg,"申请列表:")
			self:init_ui(msg.roleList)
		elseif id2 == Net:get_id2(modelName,"CreateTeamR") then
			-- self:dispose()
			self:hide()
		end
	end
end
-- 释放资源
function applyView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return applyView

