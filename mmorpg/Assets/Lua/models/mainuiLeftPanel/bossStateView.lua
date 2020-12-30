--[[
	module:世界boss状态面板
	at 2017.7.28
	by xin
]]


local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commom_string = 
{

}

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "mainui_copy_boss.u3d", 
}

local py1,py2 = 75.6,80 
local heightOff = 67.4

local leftPanelBase = require("models.mainuiLeftPanel.leftPanelBase")

local bossStateView = class(leftPanelBase,function(self, item_obj,...)
	leftPanelBase._ctor(self, res[1], item_obj,...)
end)


function bossStateView:dataInit()
	self.msg = {}
	self:referInit()

end

-- 资源加载完成
function bossStateView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self:set_always_receive(true)
	self:dataInit()
	local is_boss = LuaItemManager:get_item_obejct("boss"):is_boss_scene()
	self:set_visible(is_boss)
	bossStateView._base.on_asset_load(self,key,asset)
end

function bossStateView:referInit()
	self.tween = self.refer:Get(6)
	self.tween.from = self.tween.transform.localPosition
	self.twenn.to = self.tween.transform.localPosition + Vector3(-265, 0, 0)
end

function bossStateView:init_ui(msg)
	self.msg = msg or {}
	--boss名字 
	self.refer:Get(1).text = msg.bossName
	--血量比例
	local width = 213.1
	self.refer:Get(2).sizeDelta = Vector2(width * msg.bossHp / 100,10.6)

	self:update_hurt_view(msg.teamRank)

end

function bossStateView:update_hurt_view(data)
	--排名排序
	table.sort(data,function(a,b)return a.hurt>b.hurt end)
	--伤害排名
	local pItem = self.refer:Get(5)
	local copyItem = self.refer:Get(4)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for i,v in ipairs(data or {}) do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)

		--排名
		local rank_text = cItem.transform:FindChild("timeTxt (3)"):GetComponent("UnityEngine.UI.Text")
		rank_text.text = i

		--名字
		local name_text = cItem.transform:FindChild("timeTxt (4)"):GetComponent("UnityEngine.UI.Text")
		name_text.text = v.name

		--伤害
		local hurt_text = cItem.transform:FindChild("timeTxt (5)"):GetComponent("UnityEngine.UI.Text")
		hurt_text.text = v.hurt .. "%"

		--是否是队长
		if v.isLeader then
			cItem.transform:FindChild("Image").gameObject:SetActive(true)
		end
	end
end

-- --isShow  是否显示出来
-- function bossStateView:showAction(isShow)
-- 	if not self.action then
-- 		return
-- 	end
-- 	if not isShow then
-- 		self.action:PlayForward()
-- 	else
-- 		self.action:PlayReverse()
-- 	end
-- end


function bossStateView:setParent(parent)
	parent:add_child(self.root)
end

--点击
function bossStateView:on_click(obj,arg)
	local event_name = obj.name
	if event_name == "team_hurt" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:update_hurt_view(self.msg.teamRank)

	elseif event_name == "alliance_hurt" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:update_hurt_view(self.msg.allianceRank)

	end
end

function bossStateView:on_receive(msg, id1, id2, sid)
	if(id1==Net:get_id1("scene"))then
        if id2 == Net:get_id2("scene", "WorldBossHurtListR") then
        	gf_print_table(msg, "WorldBossHurtListR wtf:")
        	self:init_ui(msg)
        end
    end
    
end
function bossStateView:on_hided()
end
-- 释放资源
function bossStateView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return bossStateView

