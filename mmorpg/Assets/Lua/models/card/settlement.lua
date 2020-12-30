--[[--
-- 结算界面
-- @Author:Seven
-- @DateTime:2017-10-27 12:00:15
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Settlement=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "poker_settlement.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Settlement:on_asset_load(key,asset)
	local root = self.refer:Get("gameRecord")
	local sample = root:GetChild(0).gameObject
	local tf = nil
	local RoundInfoRecord = self.item_obj.scoreList or {}
	local idx = 0
	local count = root.childCount
	if self.item_obj.state == ServerEnum.CARDS_GAME_STATE.ENEMY_RUN then
		RoundInfoRecord[#RoundInfoRecord+1] = false
	end
	local win = 0
	for i,v in ipairs(RoundInfoRecord) do
		idx = idx + 1
		if count >= idx then
			tf = root:GetChild(idx-1)
		else
			tf = LuaHelper.Instantiate(sample).transform
			tf:SetParent(root,false)
		end
		tf.gameObject:SetActive(true)
		tf:FindChild("num"):GetComponent("UnityEngine.UI.Text").text =
			string.format(gf_localize_string("第%d局"),i)
		tf:FindChild("score"):GetComponent("UnityEngine.UI.Text").text = v and
			string.format("%d Vs %d",v.myScore,v.hisScore)
			or gf_localize_string("对手离线")
		local w = v and 
				((v.myScore>v.hisScore and 1) or (v.myScore<v.hisScore 
				and -1)
				or 0)
				or 10
		tf:FindChild("result"):GetComponent("UnityEngine.UI.Text").text = 
			(w>0 and gf_localize_string("胜")) or (w<0
				and "<color=#FD4D4DFF>"..gf_localize_string("负").."</color>") 
				or "<color=#EAEAEAFF>"..gf_localize_string("平").."</color>"
		win = win + w
	end
	print("赢了吗",win)
	self.refer:Get("success"):SetActive(win>0)
	self.refer:Get("defeated"):SetActive(win<0)
	self.refer:Get("deuce"):SetActive(win==0)
end

function Settlement:on_click(obj,arg)
	if obj.name == "startMatchBtn" then
		self:dispose()
	elseif obj.name == "cancleSettlement" then
		self.item_obj.state = 1
		self.item_obj.assets[1]:set_state()
		self:dispose()
	end
end

function Settlement:on_showed()
	StateManager:register_view( self )
end

-- 释放资源
function Settlement:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return Settlement

