--[[--
-- 打坐ui
-- @Author:Seven
-- @DateTime:2017-06-23 17:49:25
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local TMisc = ConfigMgr:get_config("t_misc")

local leftPanelBase = require("models.mainuiLeftPanel.leftPanelBase")

local SitView=class(leftPanelBase,function(self,item_obj,...)
	self.sit_item = LuaItemManager:get_item_obejct("sit")
	self.game_item = LuaItemManager:get_item_obejct("game")

    leftPanelBase._ctor(self, "mainui_sit.u3d", item_obj,...) -- 资源名字全部是小写
end)

-- 资源加载完成
function SitView:on_asset_load(key,asset)
	self.is_init = true

	-- 邀请玩家的item
	self.invite_item = self.refer:Get("sitItem_2")
	-- 玩家的item
	self.player_item = self.refer:Get("sitItem_3")
	-- 经验
	self.exp = self.refer:Get("sitExpValueTxt")
	-- 打坐时间
	self.sit_time = self.refer:Get("sitTimeValueTxt")
	-- 邀请玩家名字
	self.player_name = self.refer:Get("sitNameTxt")
	-- 好友度
	self.friendly = self.refer:Get("sitFriendlyValueTxt")
	-- 玩家头像
	self.player_icon = self.refer:Get("sitHeadImg")
	self.tween = self.refer:Get("tween")
	self:init_tween()
	-- self:hide()
	SitView._base.on_asset_load(self,key,asset)
end

function SitView:init_tween()
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("sit_rt").anchoredPosition = Vector2(dx, self.refer:Get("sit_rt").anchoredPosition.y)
end

function SitView:update_ui( have_player, data, auto_move )
	
	have_player = have_player or false

	 -- self:show_player_view(have_player)

	if have_player then -- 有玩家接受邀请
		self.player_name.text = data.name
		gf_set_head_ico(self.player_icon, data.head)

		if auto_move then
			self.friendly.text = gf_localize_string("寻路中")
		else
			self.friendly.text = gf_localize_string("经验增加20%")
		end
	else

	end
end

function SitView:show_player_view(show)
    self.player_item:SetActive(show)
	self.invite_item:SetActive(not show)
end

-- function SitView:show_view( show )
-- 	if not self.tween or not self:is_visible() then
-- 		return
-- 	end

-- 	if show then
-- 		self.tween:PlayReverse()
-- 	else
-- 		self.tween:PlayForward()
-- 	end
-- end

function SitView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "AcceptInviteRestAMsgR") then -- 有人接受邀请的推送
			self:update_ui(true, self.sit_item.accept_player_data, true)

		elseif id2 == Net:get_id2("scene", "NoticeStartOrEndRest") then -- 通知开始或者结束双人打坐（对方通知)
			if msg.type == 1 then -- 开始双人打坐
				self:update_ui(true, self.sit_item.accept_player_data)
			elseif msg.type == 2 then -- 结束双人打坐
				self:update_ui(false)

			elseif msg.type == 0 then -- 对方应邀过来过程中取消
				self:update_ui(false)
			end


		end
	end
end

function SitView:on_click( sender, arg )
    local cmd= not Seven.PublicFun.IsNull(sender) and sender.name or "nil"
    
	if cmd == "sitInviteBtn" then -- 邀请附近玩家
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_create_model_view("sit")

	elseif cmd == "sitHeadBtn" then -- 查看玩家
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

	end
end

function SitView:on_update( dt )
	local time = self.sit_item:get_sit_time()
	if  self.sit_time then
	 	self.sit_time.text = gf_convert_time(time)
	end
	local exp = ConfigMgr:get_config("rest")[self.game_item:getLevel()].exp
	if self.sit_item:is_pair() then
		exp = ConfigMgr:get_config("rest")[self.game_item:getLevel()].pair_exp
	end
	exp = exp + exp * LuaItemManager:get_item_obejct("vipPrivileged"):get_sit_exp() / 10000

	if self.exp then
		self.exp.text = math.floor(math.floor(time/TMisc.rest.exp_cycle)*exp)
	end
end

function SitView:register()
	StateManager:register_view( self )
	self:stop_schedule()
	self.schedule = Schedule(handler(self, self.on_update), 0.5)
end

function SitView:cancel_register()
	StateManager:remove_register_view( self )
	self:stop_schedule()
end
function SitView:stop_schedule()
	if self.schedule then
		self.schedule:stop()
		self.schedule = nil
	end
end
function SitView:on_showed()
	if self.is_init then
		self:update_ui(self.sit_item.is_accept, self.sit_item.inviter_data)
		self.sit_item:clear_temp_data()
		self.exp.text = "0"
	end
	self:register()
end

function SitView:on_hided()
	self:cancel_register()
end

-- 释放资源
function SitView:dispose()
	self:cancel_register()
    self._base.dispose(self)
 end

return SitView

