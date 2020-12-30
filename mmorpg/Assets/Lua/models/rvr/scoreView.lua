--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-11 11:34:40
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ScoreView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "score_view.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ScoreView:on_asset_load(key,asset)
	self:set_always_receive(true)
	self:set_level(UIMgr.LEVEL_STATIC)

	self:register()
	self:init_ui()
	self:update_ui()
end

function ScoreView:init_ui()
	self.our_score   = self.refer:Get("our_score")
	self.enemy_score = self.refer:Get("enemy_score")

	self.assist = self.refer:Get("assist_img")
	self.kill = self.refer:Get("kill_img")
	self.assist_tween = self.refer:Get("assist_tween")
	self.kill_tween = self.refer:Get("kill_tween")
	self.assist_txt = self.refer:Get("assist_txt")
	self.kill_txt = self.refer:Get("kill_txt")

	self.left_hp = self.refer:Get("left_hp")
	self.right_hp = self.refer:Get("right_hp")

	local refer = self.refer:Get("left")
	self.l_arrow_hp_1 = refer:Get("arrow_hp_1")
	self.l_arrow_hp_2 = refer:Get("arrow_hp_2")
	self.l_arrow_hp_3 = refer:Get("arrow_hp_3")
	self.l_arrow_hp_4 = refer:Get("arrow_hp_4")

	refer = self.refer:Get("right")
	self.r_arrow_hp_1 = refer:Get("arrow_hp_1")
	self.r_arrow_hp_2 = refer:Get("arrow_hp_2")
	self.r_arrow_hp_3 = refer:Get("arrow_hp_3")
	self.r_arrow_hp_4 = refer:Get("arrow_hp_4")
end

function ScoreView:update_ui()
	self.our_score.text   = tostring(self.item_obj:get_our_score())
	self.enemy_score.text = tostring(self.item_obj:get_enemy_score())

	self.left_hp.fillAmount = self.item_obj:get_left_flags(1)
	self.right_hp.fillAmount = self.item_obj:get_right_flags(1)

	for i=1,4 do
		self["l_arrow_hp_"..i].fillAmount = self.item_obj:get_left_flags(i+1)
	end

	for i=1,4 do
		self["r_arrow_hp_"..i].fillAmount = self.item_obj:get_right_flags(i+1)
	end
end

-- 显示助攻
function ScoreView:show_assist()
	local assist = tostring(self.item_obj:get_assist())
	if self.assist_txt.text ~= assist then
		self.assist_txt.text = assist
		self.assist:SetActive(true)
		self.assist_tween.enabled = true
		local cb = function()
			self.assist_tween.enabled = false
			self.assist_tween.transform.localScale = Vector3(1,1,1)
			self.assist:SetActive(false)
		end
		delay(cb, 0.3)
	end
end

-- 显示击杀
function ScoreView:show_kill()
	local kill_num = tostring(self.item_obj:get_kill_num())
	print("显示击杀",kill_num)
	if self.kill_txt.text~=kill_num then
		self.kill_txt.text = kill_num
		self.kill:SetActive(true)
		self.kill_tween.enabled = true
		local cb = function()
			self.kill_tween.enabled = false
			self.kill_tween.transform.localScale = Vector3(1,1,1)
			self.kill:SetActive(false)
		end
		delay(cb, 0.3)
	end
end

function ScoreView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
end

function ScoreView:on_receive( msg, id1, id2, sid )

	if id1==Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "FactionStatisticsR") then -- 战场实时数据
			self:update_ui()

			if msg.assist then
				--self:show_kill()
				self:show_assist()
			end
			gf_print_table(msg,"FactionStatisticsR")
			if msg.kill then
				--self:show_assist()
				self:show_kill()
			end
			
		end

	elseif id1 == ClientProto.HidOrShowMainUI then

		self:show(msg.visible)

	end
end

function ScoreView:register()
	StateManager:register_view( self )
end

function ScoreView:cancel_register()
	StateManager:remove_register_view( self )
end

function ScoreView:on_showed()
	
end

function ScoreView:on_hided()
	
end

-- 释放资源
function ScoreView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return ScoreView

