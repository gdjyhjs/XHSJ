--[[--
-- 任务栏管理ui zork
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local TaskBaseView=class(UIBase,function(self,item_obj)
	self.is_fromto = true

    UIBase._ctor(self, "mainui_task_base.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function TaskBaseView:on_asset_load(key,asset)
	self:set_always_receive(true)

	self:init_ui()

	self.task_view 			= self:add_child_view("taskView")
	self.team_view 			= self:add_child_view("teamView")
	self.copy_view 			= self:add_child_view("copyView")
	self.sit_view 			= self:add_child_view("sitView")
	self.legionBonfire 	 	= self:add_child_view("legionBonfire") -- 军团篝火
	self.zork_view 	 	= self:add_child_view("zork") -- 魔域修炼
	-- self.challenge_view 	= self:add_child_view("challengeView")
	self.boss_view 			= self:add_child_view("bossStateView")
	-- self.story_view 		= self:add_child_view("storyView")
	self.husong_view        = self:add_child_view("husongView")
	self.rvr_view           = self:add_child_view("rvrView")

	self.magic_boss_view    = self:add_child_view("magicBossView")

	self.team_copy_view  	= self:add_child_view("teamCopyState")

	self.legion_copy_game_view    = self:add_child_view("legionCopyGameView")

	self.is_left = true -- 是否选中左边按钮


	self:update_ui()
end

function TaskBaseView:init_ui()
	--任务面板显示隐藏
	self.task_base_show = true
	-- 左边按钮文字
	self.left_txt = self.refer:Get("left_txt")
	-- 右边按钮文字
	self.right_txt = self.refer:Get("right_txt")
	-- 按钮高亮图片
	self.hl = self.refer:Get("hl")
	-- 按钮选择颜色
	self.select_color = self.left_txt.color 
	self.unselect_color = self.right_txt.color 
	-- 隐藏显示的高亮图片
	self.form_to_hl = self.refer:Get("from_to_hl")

	self.tweem = self.refer:Get("tween")
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tweem.gameObject.transform.localPosition.y
	self.tweem.from = Vector3(-half_w+dx, y, 0)
	self.tweem.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("task_mgr_rt").anchoredPosition = Vector2(dx, self.refer:Get("task_mgr_rt").anchoredPosition.y)
end

function TaskBaseView:add_child_view( name )
	local view = View(name, self.item_obj)
	self:add_child(view)
	return view
end

function TaskBaseView:show_view( show )
	print("wtf TaskBaseView:",show)
	if not self.tweem then
		return
	end

	self.is_fromto = show

	if show then
		self.tweem:PlayReverse()
	else
		self.tweem:PlayForward()
	end
	self.form_to_hl:SetActive(not show)

	self.husong_view:show_view(show)
	self.sit_view:show_view(show)
	self.zork_view:show_view(show)
	self.task_view:show_view(show)
	self.copy_view:show_view(show)
	self.team_view:showAction(show)
	self.team_copy_view:showAction(show)
	-- self.material_view:showAction(show)
	self.legionBonfire:show_view(show)

	self.legion_copy_game_view:showAction(show)

	self.boss_view:showAction(show)
	self.rvr_view:show_view(show)
	self.magic_boss_view:show_view(show)
end

function TaskBaseView:select_team()

	self.left_txt.color = self.unselect_color
	self.right_txt.color = self.select_color

	if not self.is_left then -- 打开组队ui
		local is_rvr = LuaItemManager:get_item_obejct("rvr"):is_rvr()
		local is_tvt = gf_getItemObject("copy"):is_pvptvt()
		if not LuaItemManager:get_item_obejct("copy"):is_show_task() and not is_rvr and not is_tvt then
			require("models.team.teamEnter")()
		end
		return
	end
	
	self.is_left = false
	self.hl.transform.localScale= Vector3(1,1,1)

	self:show_left_view()
end

function TaskBaseView:select_task()

	self.left_txt.color = self.select_color
	self.right_txt.color = self.unselect_color

	local is_rvr = LuaItemManager:get_item_obejct("rvr"):is_rvr()
	if self.is_left and not self.is_sitting and not is_rvr and not LuaItemManager:get_item_obejct("zorkPractice"):is_on_zork_scene() then -- 打开任务ui
		gf_create_model_view("task")
	end

	self.is_left = true
	self.hl.transform.localScale= Vector3(-1,1,1)

	-- 隐藏
	self:show_right_view()
end

function TaskBaseView:show_left_view() -- 这个是显示右边
	-- 隐藏任务ui
	self.task_view:set_visible(false)
	self.sit_view:set_visible(false)
	self.husong_view:set_visible(false)
	self.zork_view:set_visible(false)

	-- self.challenge_view:set_visible(false)
	self.boss_view:set_visible(false)
	self.magic_boss_view:set_visible(false)

	local is_copy = LuaItemManager:get_item_obejct("copy"):is_show_task() -- 是否在副本中
	local is_tower = LuaItemManager:get_item_obejct("copy"):is_tower()
	local is_rvr = LuaItemManager:get_item_obejct("rvr"):is_rvr()
	local in_activity = LuaItemManager:get_item_obejct("bonfire"):in_activity() 
	local is_legion_copy_game = LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME)
	local is_team_copy = gf_getItemObject("copy"):is_team() or gf_getItemObject("copy"):is_copy_type(ServerEnum.COPY_TYPE.MATERIAL) or gf_getItemObject("copy"):is_copy_type(ServerEnum.COPY_TYPE.MATERIAL2)

	self.rvr_view:set_visible(is_rvr)
	self.copy_view:set_visible(is_copy )
	-- self.material_view:set_visible(is_material)
	self.legionBonfire:set_visible(in_activity)

	self.legion_copy_game_view:set_visible(is_legion_copy_game)

	self.team_copy_view:set_visible(is_team_copy)

	self.team_view:set_visible(not is_team_copy and not in_activity and not is_tower and not is_rvr and not is_legion_copy_game)

	
end

function TaskBaseView:show_right_view() -- 这个是显示左边
	self.legionBonfire:set_visible(false)
	self.copy_view:set_visible(false)
	self.team_copy_view:set_visible(false)
	self.team_view:set_visible(false)
	-- self.material_view:set_visible(false)
	self.rvr_view:set_visible(false)
	self.legion_copy_game_view:set_visible(false)

	-- local is_challenge = LuaItemManager:get_item_obejct("copy"):is_challenge()
	local is_sit = LuaItemManager:get_item_obejct("sit"):is_sit() -- 显示打坐
	local is_boss = LuaItemManager:get_item_obejct("boss"):is_boss_scene()
	local is_husong = LuaItemManager:get_item_obejct("husong"):is_husong()
	local is_magic = LuaItemManager:get_item_obejct("boss"):is_magic()
	local is_mozu = LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY)
	local on_zork_scene = LuaItemManager:get_item_obejct("zorkPractice"):is_on_zork_scene() -- 是否在魔域场景

	if is_mozu == true then
		self:set_visible(false)
	else
		self:set_visible(true)
	end

	self.sit_view:set_visible(is_sit and not on_zork_scene)
	self.boss_view:set_visible(is_boss)
	self.magic_boss_view:set_visible(is_magic and not is_sit and not is_husong)
	self.husong_view:set_visible(is_husong)
	self.zork_view:set_visible(on_zork_scene)
	self.task_view:set_visible(not is_sit and not is_boss and not is_husong and not is_magic and not is_mozu and not on_zork_scene)
	-- self.challenge_view:set_visible(is_challenge)
end

function TaskBaseView:update_ui()
	local copy_data = gf_getItemObject("copy")
	local show_team = copy_data:is_team() or copy_data:is_story() or copy_data:is_tower() or copy_data:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL) or copy_data:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL2) or copy_data:is_copy_type(ServerEnum.COPY_TYPE.TEAM_VS)
		or LuaItemManager:get_item_obejct("bonfire"):in_activity() or copy_data:is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME)

	if show_team then
		self.is_left = true
		self:select_team()
		self.copy_view:update_view()
	else
		self.is_left = false
		self:select_task()
	end

	self:set_title()

	print("TaskBaseView update_ui")

	-- --如果是剧情副本 隐藏
	-- if LuaItemManager:get_item_obejct("copy"):is_story() then
	-- 	print("task show_view:")
	-- 	self:show_view(not self.is_fromto)
	-- end

	self:show_view(gf_get_mainui_show_state(ServerEnum.MAINUI_UI_MODLE.TASK) or false)

	-- 通知显示或者隐藏主ui右上角ui
	-- Net:receive({visible = not LuaItemManager:get_item_obejct("copy"):is_hide_right_top_mainui()}, ClientProto.HideOrShowMainUIRightTop)
end

function TaskBaseView:set_title()
	if LuaItemManager:get_item_obejct("copy"):is_tower() or gf_getItemObject("copy"):is_copy_type(ServerEnum.COPY_TYPE.MATERIAL) then
		self.right_txt.text = gf_localize_string("副本")
		self.left_txt.text = gf_localize_string("任务")
		
	elseif self.is_sitting then
		self.left_txt.text = gf_localize_string("打坐")
		
	elseif LuaItemManager:get_item_obejct("zorkPractice"):is_on_zork_scene() then
		self.left_txt.text = gf_localize_string("修炼")
		
	elseif LuaItemManager:get_item_obejct("boss"):is_boss_scene() then
		self.left_txt.text = "领主"

	elseif LuaItemManager:get_item_obejct("boss"):is_magic() then
		self.left_txt.text = gf_localize_string("BOSS列表")

	elseif self.is_husong then
		self.left_txt.text = gf_localize_string("任务")

	elseif gf_getItemObject("copy"):is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
		local copy_id = gf_getItemObject("copy"):get_copy_id()
		local copy_name = ConfigMgr:get_config("copy")[copy_id].name
		self.right_txt.text = copy_name

	elseif LuaItemManager:get_item_obejct("bonfire"):in_activity() then
		self.right_txt.text = LuaItemManager:get_item_obejct("bonfire"):get_actname()

	elseif LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		self.right_txt.text = gf_localize_string("战场")
		self.left_txt.text = gf_localize_string("任务")

	elseif gf_getItemObject("copy"):is_team() then
		local count = #gf_getItemObject("team"):getTeamData().members
		self.right_txt.text = gf_localize_string("队伍*"..count)
		self.left_txt.text = gf_localize_string("任务")

	else 
		self.left_txt.text = gf_localize_string("任务")
		self.right_txt.text = gf_localize_string("队伍")
	end
end

function TaskBaseView:hide_view()
end

function TaskBaseView:on_receive( msg, id1, id2, sid )
	
	if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) then
			return
		end 
		self:update_ui()

	elseif id1 == ClientProto.HidOrShowMainUI then -- 隐藏或显示主界面
		self:set_visible(msg.visible)
		self.task_base_show = msg.visible
		if msg.visible then
			self:update_ui()
		end
	elseif id1 == ClientProto.HideOrShowTaskPanel then -- 显示或者隐藏任务面板
		if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then -- 新手第一场战斗不显示
			return
		end

		self:set_visible(msg)
		self:show_view(msg)

	elseif id1 == ClientProto.FristBattleMainui then -- 首场战斗ui
		self:set_visible(msg)

	elseif id1 == ClientProto.HusongLeftUI then --开始护送
		if msg and self.task_base_show then
			self:update_ui()
		end
	elseif id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "StartRestR") then -- 开始打坐
			if msg.err == 0 then
				self.is_sitting = true
				if self.task_base_show then
				 	self:update_ui()
				end
			end

		elseif id2 == Net:get_id2("scene", "EndRestR") then -- 取消打坐
			if msg.err == 0 then
				self.is_sitting = false
				if self.task_base_show then
				 	self:update_ui()
				end
			end
		end
	elseif id1 == ClientProto.HeroFightOrRest  then
		
	elseif id1 == Net:get_id1("team") then
		if id2 == Net:get_id2("team","CreateTeamR") or id2 == Net:get_id2("team","JoinTeamResultR") then
			self:update_ui()
		end
	elseif id1 == Net:get_id1("alliance") then
		if id2== Net:get_id2("alliance", "AllianceLegionActInfoR") then
			print("军团篝火开启")
			self:update_ui()
		end
	end
end

function TaskBaseView:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	
	if cmd == "btn_task" then -- 任务
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_MAINUI_TASK_BASE_BTN) -- 音效

		--如果是3v3不给切换
		if gf_getItemObject("copy"):is_pvptvt() then
			return
		end

		self:select_task()
		
	elseif cmd == "btn_team" then -- 组队
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_MAINUI_TASK_BASE_BTN) -- 音效
		self:select_team()
		
	elseif cmd == "btn_fromto" then -- 隐藏或显示任务栏
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_MAINUI_TASK_BASE_BTN) -- 音效
		self:show_view(not self.is_fromto)

	end
end

function TaskBaseView:register()
	StateManager:register_view( self )
end

function TaskBaseView:cancel_register()
	StateManager:remove_register_view( self )
end

function TaskBaseView:on_showed()
	self:register()
end

function TaskBaseView:on_hided()
end

-- 释放资源
function TaskBaseView:dispose()
	self.task_view 					= nil
	self.team_view 					= nil
	self.team_copy_view 			= nil
	-- self.material_view 				= nil
	self.copy_view 					= nil
	self.sit_view 					= nil
	self.legionBonfire				= nil
	self.zork_view				= nil
	-- self.challenge_view 			= nil
	self.boss_view 					= nil
	self.husong_view				= nil
	self.rvr_view           		= nil
	self.magic_boss_view    		= nil
	self.legion_copy_game_view    	= nil
	print("TaskBaseView:dispose")
	self:cancel_register()
    self._base.dispose(self)
end

return TaskBaseView

