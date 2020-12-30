--[[--
-- 任务栏管理ui 
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local baseUi = require("models.mainuiLeftPanel.leftPanelBase")

local TaskBaseView=class(baseUi,function(self,item_obj)
	self.is_fromto = true

    baseUi._ctor(self, "mainui_task_base.u3d", item_obj) -- 资源名字全部是小写
end)

local direct = 
{
	left  = -1,
	right = 1,
}

local res = 
{ 
	[ClientEnum.LeftPanelType.Task]  					= {"taskView",				direct.left}	,--任务
	[ClientEnum.LeftPanelType.Copy] 					= {"copyView",				direct.right}	,--副本
	[ClientEnum.LeftPanelType.Sit] 						= {"sitView",				direct.left}	,--打坐
	[ClientEnum.LeftPanelType.LegionBonFire] 			= {"legionBonfire",			direct.right}	,--篝火
	[ClientEnum.LeftPanelType.Zork] 					= {"zork",					direct.left}	,--魔域
	[ClientEnum.LeftPanelType.Boss] 					= {"bossStateView",			direct.left}	,--boss
	[ClientEnum.LeftPanelType.Husong] 					= {"husongView",			direct.left}	,--护送
	[ClientEnum.LeftPanelType.Rvr] 						= {"rvrView",				direct.right}	,--战场
	[ClientEnum.LeftPanelType.MeterialCopy] 			= {"teamCopyState",			direct.left}	,--材料副本
	[ClientEnum.LeftPanelType.MagicBoss] 				= {"magicBossView",			direct.left}	,--魔域boss
	[ClientEnum.LeftPanelType.TeamCopy] 				= {"teamCopyState",			direct.right}	,--组队副本
	[ClientEnum.LeftPanelType.SmallGame] 				= {"legionCopyGameView",	direct.right}	,--小游戏副本
	[ClientEnum.LeftPanelType.Team] 					= {"teamView",				direct.right}	,--组队
}

local title = 
{
	[ClientEnum.LeftPanelType.Task]  					= {"任务",					"队伍"	}	,--任务
	[ClientEnum.LeftPanelType.Copy] 					= {"任务",					"副本"	}	,--副本
	[ClientEnum.LeftPanelType.Sit] 						= {"打坐",					""	}	,--打坐
	[ClientEnum.LeftPanelType.LegionBonFire] 			= {"任务",					""		}	,--篝火
	[ClientEnum.LeftPanelType.Zork] 					= {"修炼",					"队伍"	}	,--魔域
	[ClientEnum.LeftPanelType.Boss] 					= {"BOSS",					"队伍"	}	,--boss
	[ClientEnum.LeftPanelType.Husong] 					= {"任务",					"队伍"	}	,--护送
	[ClientEnum.LeftPanelType.Rvr] 						= {"任务",					"战场"	}	,--战场
	[ClientEnum.LeftPanelType.MeterialCopy] 			= {"副本",					"队伍"	}	,--材料副本
	[ClientEnum.LeftPanelType.MagicBoss] 				= {"BOSS列表",				"队伍"	}	,--魔域boss
	[ClientEnum.LeftPanelType.TeamCopy] 				= {"任务",					""		}	,--组队副本
	[ClientEnum.LeftPanelType.SmallGame] 				= {"任务",					""		}	,	--小游戏副本
	[ClientEnum.LeftPanelType.Team] 					= {"任务",					"队伍"	}	,--组队
}

-- 资源加载完成
function TaskBaseView:on_asset_load(key,asset)
	self.is_init = true
	self:set_always_receive(true)

	self:init_ui()

	if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then -- 新手第一场战斗不显示
		self:set_visible(false)
		return
	end
	
	self:pre_init_ui()
end

function TaskBaseView:get_state()

	local state 

	local copy_data = gf_getItemObject("copy")
	local is_copy = copy_data:is_show_task() -- 是否在副本中
	local is_tower = copy_data:is_tower()
	local is_material = copy_data:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL) or copy_data:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL2)
	local is_rvr = LuaItemManager:get_item_obejct("rvr"):is_rvr()
	local in_activity = LuaItemManager:get_item_obejct("bonfire"):in_activity() 
	local is_legion_copy_game = copy_data:is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME)
	local is_team_copy = copy_data:is_team()
	local is_sit = LuaItemManager:get_item_obejct("sit"):is_sit() -- 显示打坐
	local is_boss = LuaItemManager:get_item_obejct("boss"):is_boss_scene()
	local is_husong = LuaItemManager:get_item_obejct("husong"):is_husong()
	local is_magic = LuaItemManager:get_item_obejct("boss"):is_magic()
	local is_mozu = copy_data:is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY)
	local is_zork_scene = LuaItemManager:get_item_obejct("zorkPractice"):is_on_zork_scene() -- 是否在魔域场景
	local is_team = gf_getItemObject("team"):is_in_team()

	--如果是副本
	if is_tower then
		state = ClientEnum.LeftPanelType.Copy
	elseif is_material then
		state = ClientEnum.LeftPanelType.MeterialCopy
	elseif is_sit then
		state = ClientEnum.LeftPanelType.Sit
	elseif is_husong then
		state = ClientEnum.LeftPanelType.Husong
	elseif is_boss then
		state = ClientEnum.LeftPanelType.Boss
	elseif is_magic then
		state = ClientEnum.LeftPanelType.MagicBoss
	elseif is_team_copy then
		state = ClientEnum.LeftPanelType.TeamCopy
	elseif is_legion_copy_game then
		state = ClientEnum.LeftPanelType.SmallGame
	elseif in_activity then
		state = ClientEnum.LeftPanelType.LegionBonFire
	elseif is_rvr then
		state = ClientEnum.LeftPanelType.Rvr
	elseif is_zork_scene then
		state = ClientEnum.LeftPanelType.Zork
	-- elseif is_team then
	-- 	state = ClientEnum.LeftPanelType.Team
	end

	return state
end

function TaskBaseView:init_ui()
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

	self.tween = self.refer:Get("tween")
	-- self.tween.from = self.tween.transform.localPosition
	-- self.tween.to = self.tween.transform.localPosition + Vector3(-265, 0, 0)

	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)

	--常驻任务
	local callback = function()
		if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then -- 新手第一场战斗不显示
			self.task_view:set_visible(false)
		end
	end
	self.task_view = require("models.mainuiLeftPanel.taskView")(self.item_obj,callback)
end

function TaskBaseView:add_child_view( name ,callback)
	--如果是任务界面
	if name == "taskView" and self.task_view then
		self.task_view:show()
		if callback then
			callback()
		end
		return self.task_view
	end
	self.task_view:hide()
	if self.view_list[self.main_dir] then
		if callback then
			-- callback()
		end
		self.view_list[self.main_dir]:show()
		return self.view_list[self.main_dir]
	end
	local view = require("models.mainuiLeftPanel."..name)(self.item_obj,callback) --View(name, self.item_obj)
	self:add_child(view)
	self.view_list[self.main_dir] = view
	return view
end 

function TaskBaseView:show_view( show )
	print("wtf task show_view:",show)
	self.form_to_hl:SetActive(not show)

	self._base.show_view(self,self.is_fromto,show)

	if not self:get_state() and self.main_dir == direct.left then
		self.task_view:show_view(self.is_fromto,show)
	else
		self.panel_view:show_view(self.is_fromto,show)
	end

	self.is_fromto = show
end
function TaskBaseView:select_team(is_click)
	print("wtf ffff select_team")
	self.left_txt.color = self.unselect_color
	self.right_txt.color = self.select_color

	if is_click then -- 打开组队ui
		if self.main_state == ClientEnum.LeftPanelType.Team then
			require("models.team.teamEnter")()
			return true
		end
		self.main_dir = direct.right

		local r_state = self:get_state() or ClientEnum.LeftPanelType.Team

		if self.main_dir ~= res[r_state][2] then
			--如果是篝火
			local in_activity = LuaItemManager:get_item_obejct("bonfire"):in_activity()
			self.main_state = in_activity and ClientEnum.LeftPanelType.LegionBonFire or ClientEnum.LeftPanelType.Team
		else
			self.main_state = r_state
		end

	end

	self.hl.transform.localScale = Vector3(1,1,1)

	if self.view_list[direct.left] then
		self.view_list[direct.left]:hide()
	end
end

function TaskBaseView:select_task(is_click)
	print("wtf ffff select_task")
	self.left_txt.color = self.select_color
	self.right_txt.color = self.unselect_color

	if is_click then -- 打开任务ui
		if self.main_state == ClientEnum.LeftPanelType.Task then
			gf_create_model_view("task")
			return true
		end
		self.main_dir = direct.left 
		
		local r_state = self:get_state() or ClientEnum.LeftPanelType.Task

		--如果方向相反 而且不是真状态 使用默认状态
		if self.main_dir ~= res[r_state][2] then
			self.main_state = ClientEnum.LeftPanelType.Task
		else
			self.main_state = r_state
		end
	end

	self.hl.transform.localScale = Vector3(-1,1,1)

	if self.view_list[direct.right] then
		self.view_list[direct.right]:hide()
	end
end

--重新初始化ui 方向重制
function TaskBaseView:pre_init_ui(state,show)
	if self.view_is_init then
		self:update_ui()
		return
	end
	self.view_is_init = true
	self:remove_children()
	self.view_list = {}
	self.main_state = state or self:get_state() or ClientEnum.LeftPanelType.Task
	self.main_dir = res[self.main_state][2]
	
	if self.main_dir == direct.left then
		self:select_task()
 
	elseif self.main_dir == direct.right then
		self:select_team()

	end 

	local callback = function()
		self.view_is_init = false
		local state_show = show == nil and true or show
		self:show_view(state_show)
	end
	
	self:update_ui(callback)
	  
end

function TaskBaseView:reverse_tween()
end

function TaskBaseView:update_ui(callback)
	print("wtf res[self.main_state]:",self.main_state,res[self.main_state])
	self.panel_view = self:add_child_view(res[self.main_state][1],callback)

	self:set_title()

end

function TaskBaseView:set_title()
	local r_state = self:get_state() or self.main_state
	local left_text = title[r_state][1]
	local right_text = title[r_state][2]
	self.right_txt.text = right_text == "" and self:get_special_title(r_state) or right_text
	self.left_txt.text = left_text == "" and self:get_special_title(r_state) or left_text
end

function TaskBaseView:get_special_title(type)

	local function get_copy_name()
		local copy_id = gf_getItemObject("copy"):get_copy_id()
		local copy_name = ConfigMgr:get_config("copy")[copy_id].name
		return copy_name
	end
	local function get_team_copy_name()
		local count = #gf_getItemObject("team"):getTeamData().members
		return gf_localize_string("队伍*"..count)
	end
	local function get_bonfire_name()
		return LuaItemManager:get_item_obejct("bonfire"):get_actname()
	end
	local function get_small_game_name()
		local copy_id = gf_getItemObject("copy"):get_copy_id()
		local copy_name = ConfigMgr:get_config("copy")[copy_id].name
		return copy_name
	end
	local function get_sit_right_name()
		local in_activity = LuaItemManager:get_item_obejct("bonfire"):in_activity() 
		if in_activity then
			return LuaItemManager:get_item_obejct("bonfire"):get_actname()
		else
			return gf_localize_string("队伍")
		end
	end

	local func = 
	{
		[ClientEnum.LeftPanelType.Copy] 			= get_copy_name,
		[ClientEnum.LeftPanelType.TeamCopy] 		= get_team_copy_name,
		[ClientEnum.LeftPanelType.LegionBonFire] 	= get_bonfire_name,
		[ClientEnum.LeftPanelType.SmallGame] 		= get_small_game_name,
		[ClientEnum.LeftPanelType.Sit] 				= get_sit_right_name,
	}

	return func[type]()
		
end

function TaskBaseView:hide_view(show)
	self:set_visible(show)
	--如果是显示状态 
	if self.main_state == ClientEnum.LeftPanelType.Task then
		self.task_view:set_visible(show)
	end
end

function TaskBaseView:on_receive( msg, id1, id2, sid )
	
	if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) then
			self:hide_view(false)
			return 
		end 
		self:hide_view(true)
		self:pre_init_ui(nil,gf_get_mainui_show_state(ServerEnum.MAINUI_UI_MODLE.TASK))

	elseif id1 == ClientProto.HidOrShowMainUI then -- 隐藏或显示主界面
		self:pre_init_ui()
		self:hide_view(msg.visible)
		
	elseif id1 == ClientProto.HideOrShowTaskPanel then -- 显示或者隐藏任务面板
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) then
			return 
		end 
		if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then -- 新手第一场战斗不显示
			return
		end
		self:pre_init_ui()
		self:hide_view(msg)

	elseif id1 == ClientProto.FristBattleMainui then -- 首场战斗ui
		if not self._is_loaded then
			return
		end
		if self.main_state == self:get_state() and not LuaItemManager:get_item_obejct("bonfire"):in_activity()  then
			return
		end
		-- self:pre_init_ui()
		self:hide_view(msg)  

	elseif id1 == ClientProto.HusongLeftUI then --开始护送
		if msg then
			self:pre_init_ui()
		end
	elseif id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "StartRestR") then -- 开始打坐
			if msg.err == 0 then
				self:pre_init_ui()
			end

		elseif id2 == Net:get_id2("scene", "EndRestR") then -- 取消打坐
			--只有状态变化的时候才需要重置 
			if self.main_state == self:get_state() and not LuaItemManager:get_item_obejct("bonfire"):in_activity()  then
				return
			end
			--副本 特殊场景 不需要刷新
			-- if gf_getItemObject("copy"):is_copy() or gf_getItemObject("pvp"):is_pvp() then
			-- 	return
			-- end
			if msg.err == 0 then
				if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) then
					return 
				end 
				self:pre_init_ui()
			end
		end
	elseif id1 == ClientProto.HeroFightOrRest  then
		
	elseif id1 == Net:get_id1("team") then
		if id2 == Net:get_id2("team","CreateTeamR") or id2 == Net:get_id2("team","JoinTeamResultR") then
			if self.main_dir ~= direct.right  then
				self:pre_init_ui(ClientEnum.LeftPanelType.Team)
			end
		end
	elseif id1 == Net:get_id1("alliance") then
		if id2== Net:get_id2("alliance", "AllianceLegionActInfoR") then
			self:pre_init_ui()
		end
	end

	if id1 == ClientProto.RefreshLeftPanel then
		self:pre_init_ui()
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

		if self:select_task(true) then
			return
		end
		self:update_ui()

	elseif cmd == "btn_team" then -- 组队
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_MAINUI_TASK_BASE_BTN) -- 音效
		if self:select_team(true) then
			return
		end
		self:update_ui()

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
	print("wtf task base view hide")
end

-- 释放资源
function TaskBaseView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return TaskBaseView

