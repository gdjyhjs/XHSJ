--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-06 16:33:14
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Game = LuaItemManager:get_item_obejct("game")
local LegionDonateView=class(UIBase,function(self)
	self.item_obj =  LuaItemManager:get_item_obejct("legion")
    UIBase._ctor(self, "legion_donate.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LegionDonateView:on_asset_load(key,asset)
	StateManager:register_view(self)
	local bl = ConfigMgr:get_config("t_misc").alliance.donateRate
	self.all_times = ConfigMgr:get_config("t_misc").alliance.dayDevoteTimesMax
	local data = ConfigMgr:get_config("alliance_devote")
	for k,v in pairs(data) do
		self.refer:Get("cost_txt"..k).text =gf_format_count(Game:get_money(v.res_type))
		self.refer:Get("cost_need"..k).text = v.cost
		self.refer:Get("contribution"..k).text =gf_localize_string("军团贡献 +".. v.reward_donate)
		self.refer:Get("money"..k).text =gf_localize_string("军团资金 +"..v.reward_donate*bl)
		self.refer:Get("name"..k).text = v.name
	end
	self.times = self.refer:Get("donate_times")
	self.times.text= self.all_times-self.item_obj:get_devote_times().."/"..self.all_times
end

function LegionDonateView:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd , "donate_btn" )  then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.item_obj:get_devote_times()>=self.all_times then
			gf_message_tips("捐献次数已满")
			return
		end
		local d_id = string.sub(cmd, 11 ,11)
		self.item_obj:alliance_devote_c2s(d_id)
	elseif cmd == "legion_create_closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
		self:dispose()
	end
end

function LegionDonateView:on_receive(msg,id1,id2,sid)
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance","AllianceDevoteR") then
			if msg.err == 0 then
				self.times.text= self.all_times-self.item_obj:get_devote_times().."/"..self.all_times
				local data = ConfigMgr:get_config("alliance_devote")
				for k,v in pairs(data) do
					self.refer:Get("cost_txt"..k).text =gf_format_count(Game:get_money(v.res_type))
				end
			end
		end
	end
end

-- 释放资源
function LegionDonateView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return LegionDonateView

