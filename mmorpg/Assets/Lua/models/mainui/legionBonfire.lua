--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-17 18:13:26
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LegionBonfire=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "mainui_legion_bonfire.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LegionBonfire:on_asset_load(key,asset)
	-- tween滑动
	self.tween = self.refer:Get("tween")
	self.tween.from = self.tween.transform.localPosition
	self.tween.to = self.tween.transform.localPosition + Vector3(-265, 0, 0)
	-- 获取组件
	self.name1 = self.refer:Get("name1")
	self.value1 = self.refer:Get("value1")
	self.name2 = self.refer:Get("name2")
	self.value2 = self.refer:Get("value2")
	self.name3 = self.refer:Get("name3")
	self.value3 = self.refer:Get("value3")
	self.name4 = self.refer:Get("name4")
	self.value4 = self.refer:Get("value4")
	self.name5 = self.refer:Get("name5")
	self.value5 = self.refer:Get("value5")

	self.drinkBtn = self.refer:Get("drinkBtn") -- 喝酒
	self.answerBtn = self.refer:Get("answerBtn") -- 答题
	self.FireworksBtn = self.refer:Get("FireworksBtn") -- 放烟火
	self.diceBtn = self.refer:Get("diceBtn") -- 骰子

	self.bonfire = LuaItemManager:get_item_obejct("bonfire")

	self:hide()
	self.is_init = true
end

function LegionBonfire:show_view( show )
	if not self.tween then
		return
	end

	if show then
		self.tween:PlayReverse()
	else
		self.tween:PlayForward()
	end
end

function LegionBonfire:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "drinkBtn" then -- 喝酒
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local Bonfire = LuaItemManager:get_item_obejct("bonfire")
		local data = ConfigMgr:get_config("alliance_legion_act")[Bonfire.actType]
		print(Bonfire.expCoef,data.add_exp_per_max)
		if Bonfire.expCoef<data.add_exp_per_max then
			-- local str = string.format("你确定要花费%d元宝请大家喝酒吗？喝酒后可以获得%d军团贡献。1分钟内群英会经验加成%d%%",data.add_cost,data.add_donation,data.add_exp_per)
			local str = string.format("您确定要<color=#B01FE5>花费%d元宝(优先使用绑元)</color>请大家喝酒吗？<color=#B01FE5>每日前5次</color>喝酒后可以<color=#B01FE5>获得%d贡献</color>。3分钟内军团篝火挂机经验加成<color=#B01FE5>提升%d%%</color>。",data.add_cost,data.add_donation,data.add_exp_per)
			local function sure_func()
				Bonfire:AllianceNeedfireDrink_c2s()
			end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func)
		else
			gf_message_tips("现在的酒已经够大家喝了")
		end

	elseif cmd == "answerBtn" then -- 答题
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local Bonfire = LuaItemManager:get_item_obejct("bonfire")
		Bonfire:AllianceNeedfireGetQuestion_c2s() -- 请求问题

	elseif cmd == "diceBtn" then -- 骰子
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local Bonfire = LuaItemManager:get_item_obejct("bonfire")
		if Bonfire.questionNo == 5 and Bonfire.rightTimes>1 then -- 打开骰子
			View("dice",Bonfire)
		else
			gf_message_tips("需答对2题才可投骰子")
		end

	elseif cmd == "FireworksBtn" then -- 放烟花

		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local Bonfire = LuaItemManager:get_item_obejct("bonfire")
		local data = ConfigMgr:get_config("alliance_legion_act")[Bonfire.actType]
		print(Bonfire.expCoef,data.add_exp_per_max)
		if Bonfire.expCoef<data.add_exp_per_max then
			-- local str = string.format("你确定要花费%d元宝燃放烟火吗？燃放烟火后可以使1分钟内全体成员经验加成%d%%",data.add_cost,data.add_exp_per)
			local str = string.format("您确定要<color=#B01FE5>花费%d元宝(优先使用绑元)</color>来放烟火吗？<color=#B01FE5>每日前5次</color>放烟火后可以<color=#B01FE5>获得%d贡献</color>。3分钟内军团宴会挂机经验加成<color=#B01FE5>提升%d%%</color>。",data.add_cost,data.add_donation,data.add_exp_per)
			local function sure_func()
				Bonfire:AlliancePartyFirework_c2s()
			end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func)
		else
			gf_message_tips("大家烟花放的太多了，请等等再放。")
		end

	end
end

function LegionBonfire:on_update( dt )
	if self.bonfire.actType == ServerEnum.ALLIANCE_LEGION_ACT_TYPE.NEEDFIRE then -- 篝火
		self.drinkBtn:SetActive(true)
		self.answerBtn:SetActive(self.bonfire.questionNo~=5)
		self.diceBtn:SetActive(self.bonfire.questionNo==5)
		self.FireworksBtn:SetActive(false)
		self.name1.text = gf_localize_string("剩余时间:")
		self.value1.text = self.bonfire:activity_time()
		self.name2.text = gf_localize_string("参与人数:")
		self.value2.text = self.bonfire.legionPlrCount
		self.name3.text = gf_localize_string("经验倍率:")
		self.value3.text = self.bonfire.expCoef.."%"
		self.name4.text = gf_localize_string("答题进度:")
		self.value4.text = (self.bonfire.questionNo>4 and 4 or self.bonfire.questionNo).."/4"
		self.name5.text = gf_localize_string("骰子点数:")
		self.value5.text = self.bonfire.rightTimes<2 and gf_localize_string("需答对2题") or 
			(self.bonfire.showDice and self.bonfire.diceNum>0 and (self.bonfire.diceNum..gf_localize_string("点"))) or "可以投骰子"
	else -- 宴会
		self.FireworksBtn:SetActive(true)
		self.drinkBtn:SetActive(false)
		self.answerBtn:SetActive(false)
		self.diceBtn:SetActive(false)
		self.name1.text = gf_localize_string("剩余时间:")
		self.value1.text = self.bonfire:activity_time()
		self.name2.text = gf_localize_string("参与人数:")
		self.value2.text = self.bonfire.legionPlrCount
		self.name3.text = gf_localize_string("已吃佳肴:")
		self.value3.text = self.bonfire.eatTimes.."/5"
		self.name4.text = gf_localize_string("送菜任务:")
		self.value4.text = self.bonfire.diliverTimes.."/5"
		self.name5.text = gf_localize_string("经验倍率:")
		self.value5.text = self.bonfire.expCoef.."%"
	end
	if self.parent and not self.bonfire:in_activity() then
		self.parent:update_ui()
	end
end

function LegionBonfire:register()
	StateManager:register_view( self )
	self.schedule = Schedule(handler(self, self.on_update), 0.5)
end

function LegionBonfire:cancel_register()
	StateManager:remove_register_view( self )
	if self.schedule then
		self.schedule:stop()
	end
	self.schedule = nil
end

function LegionBonfire:on_showed()
	if self.is_init then
		self:on_update()
	end
	self:register()
end

function LegionBonfire:on_hided()
	self:cancel_register()
end

-- 释放资源
function LegionBonfire:dispose()
	self.is_init = nil
	self.hide()
    self._base.dispose(self)
 end

return LegionBonfire