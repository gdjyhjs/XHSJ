--[[
	军团主界面  属性
	create at 17.10.31
	by xin
]]
local dataUse = require("models.legion.dataUse")
local model_name = "legion"

require("models.legion.publicFunc")

local res = 
{
	[1] = "legion_info.u3d",
}

local commom_string = 
{	
	[1] = gf_localize_string("升级军团可<color=#B01FE5>提升军团成员数量、修炼等级、战旗等级上限、每次修炼经验</color>,确定要消耗<color=#B01FE5>%s</color>资金将军团升级到<color=#B01FE5>%d</color>级？"),
	[2] = gf_localize_string("尚未开放"),
	[3] = gf_localize_string("恭喜军团升到<color=#B01FE5>%d级</color>"),
	[4] = gf_localize_string("军团已满级"),
	[5] = gf_localize_string("暂无"),
	[6] = gf_localize_string("军团任务不能重复接取"),
	[7] = gf_localize_string("本周军团任务已经做完了"),
}


local legionMain = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionMain:on_asset_load(key,asset)
    self:init_ui()
end

function legionMain:init_ui()
	
	local data = gf_getItemObject("legion"):get_info()
	gf_print_table(data, "wtf data:")
	local legion_info = dataUse.getAllianceData(data.level)
	--主要信息--	
	self.refer:Get(1).text = data.name
	self.refer:Get(2).text = data.level
	self.refer:Get(3).text = data.leader
	self.refer:Get(4).text = data.memberSize.."/"..legion_info.max_member_size
	self.refer:Get(5).text = data.totalPower 
	self.refer:Get(6).text = gf_format_count(data.fund)
	self.refer:Get(7).text = string.format("%s/%s",data.fund,ConfigMgr:get_config("t_misc").alliance.upGradeCost / 100 * legion_info.max_fund_size)
	if self.item_obj:get_title() == ServerEnum.ALLIANCE_TITLE.LEADER then
		self.refer:Get("btn_reform_legion_name"):SetActive(true)
	end
	print("wtf :",string.format("%.0f", gf_getItemObject("game"):get_donation()))

	self.refer:Get(8).text = gf_format_count(gf_getItemObject("game"):get_donation())
	self.refer:Get(9).text = (not data.qqGroup or data.qqGroup == "") and commom_string[5] or data.qqGroup
	-- self.refer:Get(12).text = data.introduction
	self.refer:Get(13).text = data.word

	gf_setImageTexture(self.refer:Get(14), dataUse.getFlagByColor(data.flag))
	
	self:permission_view_init()
	self:update_introduction()
end

function legionMain:update_introduction()
	local data = gf_getItemObject("legion"):get_info()
	local introduction = data.introduction

	gf_update_introduction(introduction,self.refer:Get(19),self.refer:Get(20))

end

function legionMain:permission_view_init()
	local can_edit = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.MODIFY_INFO)
	local can_upgrade = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.ALLIANCE_LEVELUP)
	self.refer:Get(15):SetActive(can_edit)
	self.refer:Get(16):SetActive(can_edit)
	self.refer:Get(17):SetActive(can_upgrade)
	
end


function legionMain:upgrade_click()
	local sure_fun = function()
		gf_getItemObject("legion"):send_to_upgrade()
	end

	local data = gf_getItemObject("legion"):get_info()
	local legion_info = dataUse.getAllianceData(data.level)

	local need_cion = ConfigMgr:get_config("t_misc").alliance.upGradeCost / 100 * legion_info.max_fund_size
	local level = data.level

	if dataUse.getAllianceMaxLevel() == level then
		gf_message_tips(commom_string[4])
		return
	end

	local content = string.format(commom_string[1],need_cion,level + 1)
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
end


function legionMain:func_click(event)
	local index = string.gsub(event,"func","")
	index = tonumber(index)
end

function legionMain:do_repeat_task()
	
	local task_data = gf_getItemObject("task"):get_task_list()

	if gf_getItemObject("legion"):get_repeate_task_time() >= ConfigMgr:get_config("t_misc").alliance.repeatTaskTimesMax then
		gf_message_tips(commom_string[7])
		return
	end

	for i,v in ipairs(task_data or {}) do
		if v.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT then
			gf_message_tips(commom_string[6])
			return
		end
	end
	gf_receive_client_prot(msg,ClientProto.LegionViewClose)
	local data = gf_get_config_table("task")[gf_get_config_const("repeat_task_guild_id")]
	gf_getItemObject("task"):add_task(data)
	gf_getItemObject("task"):set_task_status(data.code, ServerEnum.TASK_STATUS.AVAILABLE)
	LuaItemManager:get_item_obejct("battle"):refresh_npc(data)
	gf_receive_client_prot({}, ClientProto.RefreshTask)
	gf_receive_client_prot({code = data.code},ClientProto.DoTask)
	
end

--鼠标单击事件
function legionMain:on_click( obj, arg)
	local event_name = obj.name
	print("legionMain click",event_name)
    if event_name == "legion_upgrade" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:upgrade_click()

    elseif event_name == "legion_q_edit" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.legion.legionQQEdit")()

    elseif event_name == "legion_notice_edit" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.legion.legionNoticeEdit")()

    -- elseif string.find(event_name,"func") then
    -- 	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	-- self:func_click(event_name)

    elseif event_name == "btn_help" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1131)

   	elseif event_name == "legion_list_btn" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		require("models.legion.ApplyView")()
   		gf_receive_client_prot(msg,ClientProto.LegionViewClose)
   	elseif event_name == "legion_chat_btn" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		gf_receive_client_prot(msg,ClientProto.LegionViewClose)
   		gf_open_model(ClientEnum.MODULE_TYPE.PUBLIC_CHAT,ServerEnum.CHAT_CHANNEL.ARMY_GROUP)
   		
   	elseif event_name == "legion_scene_btn" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		gf_receive_client_prot(msg,ClientProto.LegionViewClose)
		gf_getItemObject("legion"):enter_scene()

	elseif event_name == "func1" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local lv = ConfigMgr:get_config("t_misc").alliance.allianceTask
		if	LuaItemManager:get_item_obejct("game"):getLevel()>=lv then
			self:do_repeat_task()
		else
			gf_message_tips("150级开启军团任务")
		end
		

	elseif event_name == "func2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- gf_message_tips(commom_string[2])
		require("models.legion.legionDonateView")()
	elseif event_name == "func3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_open_model(ClientEnum.MODULE_TYPE.MALL,3,2,gf_get_config_const("shop_contribution_type"))
		gf_receive_client_prot(msg,ClientProto.LegionViewClose)

	elseif event_name == "func4" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_create_model_view("warehouse")
	elseif event_name == "btn_reform_legion_name" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local title =  self.item_obj:get_title() 
		if title ~= ServerEnum.ALLIANCE_TITLE.LEADER then
			gf_message_tips("非统帅不能改军团名字")
			return
		end
		local bag = LuaItemManager:get_item_obejct("bag")
		local tb = bag:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.NAME_CHANGE_CARD,ServerEnum.BAG_TYPE.NORMAL)
		gf_print_table(tb,"改名字")
		if #tb ~= 0 then
		 	for k,v in pairs(tb) do
		 		if v.data.color == 4 then
		 			self.item_obj:change_name_tip()
		 			return
		 		end
		 	end
		end
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message("您没有改名卡，是否前往商城购买?",
			function() 
			local Mall = LuaItemManager:get_item_obejct("mall")
			for k,v in pairs( ConfigMgr:get_config("goods")) do
			 	if v.shop_type == ClientEnum.SHOP_TYPE.NAME_CHANGE_CARD  then
			 		if  ConfigMgr:get_config("item")[v.item_code].color == 4 then 
			 			Net:receive({},ClientProto.LegionViewClose)
			 			Mall:set_model(1,2,v.goods_id)
						Mall:add_to_state()
					end
			 	end
			end
			end,function()  end,"是","否")
		-- LuaItemManager:get_item_obejct("mall"):add_to_state()
    end
end

function legionMain:on_showed()
	self.item_obj:get_member_list_c2s()
	self.item_obj:get_base_info_c2s()
	StateManager:register_view(self)
end

function legionMain:clear()
	StateManager:remove_register_view(self)
end

function legionMain:on_hided()
	self:clear()
end
-- 释放资源
function legionMain:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionMain:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetMemberListR") then
			
		elseif id2 == Net:get_id2("alliance", "GetBaseInfoR") then
			self:init_ui()

		elseif id2 == Net:get_id2("alliance", "ModifyInfoR")   then
			if msg.err ~= 0 then
				return
			end
			self:init_ui()

		elseif id2 == Net:get_id2("alliance", "UpGradeR") then
			if msg.err == 0 then
				local level = gf_getItemObject("legion"):get_info().level
				gf_message_tips(string.format(commom_string[3],level))
				self.item_obj:get_base_info_c2s()
			end
		elseif id2 == Net:get_id2("alliance","AllianceDevoteR") then
			if msg.err == 0 then
				self:init_ui()
			end
		end
	elseif id1 == Net:get_id1("bag") then
		if id2 == Net:get_id2("bag", "ChangeNameR") then
			if msg.err == 0 then
				-- self.item_obj:get_member_list_c2s()
				self.item_obj:get_base_info_c2s()
			end
		end
	end
end

return legionMain