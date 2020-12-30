--[[
	过关斩将系统主界面
	create at 17.7.17
	by xin
]]
local LuaHelper = LuaHelper

local model_name = "scene"

local res = 
{
	[1] = "boss.u3d",
	[2] = "bag_icon_01_select",
	[3] = "bag_icon_01_normal",
	[4] = "scroll_table_cell_bg_02_select",
	[5] = "scroll_table_cell_bg_02_normal",
}

local legion_data_use = require("models.legion.dataUse")

local page_res = 
{
	[1] = {"boss_page_01_normal","boss_page_01_select"},
	[2] = {"boss_page_02_normal","boss_page_02_select"},
	[3] = {"boss_page_03_normal","boss_page_03_select"},
	[4] = {"boss_page_03_normal","boss_page_03_select"},
}

local dataUse = require("models.boss.dataUse")

local commom_string = 
{
	[1] = gf_localize_string("等级 <color=#8F4C34FF>%d</color>"),
	[2] = gf_localize_string("刷新倒计时：%s"),
	[3] = gf_localize_string("讨伐中"),
	[4] = gf_localize_string("<color=#8F4C34FF>%s</color>在魔狱三层与<color=#8F4C34FF>%s</color>大战五百回合，获得极品【<color=#8F4C34FF>%s</color>】"),
	[5] = gf_localize_string("<color=#36C548FF>已刷新</color>"),
}

local layer = 
{
	gf_localize_string("流放一层"),
	gf_localize_string("流放二层"),
	gf_localize_string("流放三层"),
}



local bossView=class(Asset,function(self,item_obj)
	self.item_obj=item_obj
	self:set_bg_visible(true)

	self.magic_refresh_time_l = {} -- 魔域boss时间刷新列表

  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
  	
  	self.tag_list = {}
  	self.item_list = {}
  	self.magic_time_list = {}
end)


--资源加载完成
function bossView:on_asset_load(key,asset)
	self:hide_mainui(true)
	self.item_obj:register_event("boss_view_on_click", handler(self, self.on_click))
end

function bossView:init_ui()
	self:page_click("page_3",self.refer:Get(10))
end

--boss列表
function bossView:scroll_view_init(data,show_time)
	local scroll_view = self.refer:Get(1)
	
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		self:item_render(scroll_rect_item,index,data_item,show_time)
	end
	
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
	self.left_scroll = scroll_view
end

function bossView:item_render(scroll_rect_item,index,data_item,show_time,page)
	print("wtf show time :",show_time)
	local refer = scroll_rect_item

		local boss_id = data_item.boss_code
		local map_id = data_item.map_id

		local boss_info = ConfigMgr:get_config("creature")[boss_id]
		local map_info = ConfigMgr:get_config("mapinfo")[map_id]
		--boss name 
		refer:Get(1).text = boss_info.name
		--等级
		refer:Get(4).text = string.format(commom_string[1],boss_info.level)
		--地图名字
		if not show_time then
			refer:Get(5).text = map_info.name
		else
			-- 显示刷新时间
			if not self.magic_time_list then
				self.magic_time_list = {}
			end
			local time = self.magic_time_list[boss_id]

			if not time or time == 0 or time <= Net:get_server_time_s() then
				refer:Get(5).text = commom_string[5]
			else
				refer:Get(5).text = gf_set_text_color(gf_convert_time(time - Net:get_server_time_s()), ClientEnum.SET_GM_COLOR.INTERFACE_RED)
				self.magic_refresh_time_l[boss_id] = {txt = refer:Get(5), time = time}

				if not self.magic_schedule then
					self.magic_schedule = Schedule(handler(self, self.update_magic_time), 1)
				end

			end
		end

		--boss icon
		local icon = refer:Get(3)
		gf_setImageTexture(icon,boss_info.icon_id or "")
		if not self.last_select_item then -- 设置第一个高亮
			if self.pre_boss_id and self.pre_page == page then  
				if self.pre_boss_id == data_item.boss_code then
					self.last_select_item = refer
					refer:Get(6):SetActive(true)
					-- self.pre_boss_id = nil
				end
			elseif  index == 1 then
				self.last_select_item = refer
				refer:Get(6):SetActive(true)
			end
			
		end
		-- 设置品质
		if boss_info.color then
			gf_setImageTexture(refer:Get(7),boss_info.color)
		end
end

function bossView:clear_item()
	local p_item = self.refer:Get(19)

	for i=1,p_item.transform.childCount do
  		local go = p_item.transform:GetChild(i - 1).gameObject
		go.gameObject:SetActive(false)
  	end

end

function bossView:clear_boss_item()
	for i,v in ipairs(self.item_list or {}) do
		v.gameObject:SetActive(false)
	end
end

function bossView:tag_init(index,is_click)
	print("wtf tage init :",index,self.tag_index)
	if self.magic_schedule then
		self.magic_schedule:stop()
		self.magic_schedule = nil
	end

	self:reset_last_blide()
	local boss = dataUse.getWorldBoss()
	local item = self.refer:Get(21)
	local p_item = self.refer:Get(19)

	for i=#boss,1,-1 do
		local item = self:get_copy_item(item,p_item,1,i)
		item.transform:SetAsFirstSibling()
		item.gameObject:SetActive(true)
		item.name = "tag_item"..i
		local refer = item:GetComponent("ReferGameObjects")
		refer:Get(1).text = layer[i]

		local state = index ~= self.tag_index and i == index 

		refer:Get(2).gameObject:SetActive(not state)
		refer:Get(3).gameObject:SetActive(state)

		self.tag_list[i] = item
	end

	self.tag_index = self.tag_index == index and -1 or index
	print("wtf self.tag_index:",self.tag_index)
	if self.tag_index == -1 then
		self:clear_boss_item()
		return
	end

	local data = boss[index]
	if index then
		self:item_init(data,index)
		for i = index,1,-1 do
			self.tag_list[i].transform:SetAsFirstSibling()
		end
	end
	if is_click then
		if self.pre_boss_id and self.pre_page == index then
			self:boss_view_init(self.pre_boss_id, self.refer:Get("zork_refer"))
			return
		end
		self:boss_view_init(data[1].boss_code, self.refer:Get("zork_refer"))
	end

	
end

function bossView:get_copy_item(item,p_item,type,index)
	if type == 1 and self.tag_list[index] then
		return self.tag_list[index]
	end
	if type == 2 and self.item_list[index] then
		return self.item_list[index]
	end
	return LuaHelper.InstantiateLocal(item.gameObject,p_item.gameObject)
end

function bossView:item_init(data,page)
	local item = self.refer:Get(20)
	local p_item = self.refer:Get(19)
	for i=#data,1,-1 do
		local item = self:get_copy_item(item,p_item,2,i)
		item.gameObject:SetActive(true)
		item.transform:SetAsFirstSibling()
		item.name = "boss_item"..data[i].boss_code
		local refer = item:GetComponent("ReferGameObjects")
			
		local show_time = self.boss_type == ServerEnum.BOSS_TYPE.MAGIC_BOSS and self.magic_time_list[data[i].boss_code] or nil

		self:item_render(refer,i,data[i],show_time,page)

		self.item_list[i] = item
	end
	
end

--掉落展示
function bossView:scroll_view_all_reward(data, refer)
	local scroll_view = refer:Get("drop_scroll")
	local career = gf_getItemObject("game"):get_career()
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		local refer = scroll_rect_item
		--数量  
		refer:Get(2).text = data_item[2]
		--icon 
		local icon = refer:Get(1)
		local bg = refer:Get(3)

		gf_set_equip_icon_ex(data_item,icon,bg)
		
		local food_item_id = legion_data_use.getCareerItem(data_item[1],career)

		gf_set_click_prop_tips(scroll_rect_item.gameObject,food_item_id,data_item[4],data_item[5])

	end
	
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
end

function bossView:get_top_level_boss()
	local index = 1
	local boss_id = 1
	return index,boss_id
end

--参与奖励
function bossView:scroll_view_reward(data, refer)
	local scroll_view = refer:Get("reward_scroll")
	
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		local refer = scroll_rect_item
		refer:Get(2).text = data_item[2]
		--icon 
		local icon = refer:Get(1)
		local bg = refer:Get(3)
		-- gf_set_item(data_item[1], icon, bg)

		gf_set_equip_icon_ex(data_item,icon,bg)
		
		gf_set_click_prop_tips(scroll_rect_item.gameObject,data_item[1],data_item[4],data_item[5])

	end
	
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
end

--boss
function bossView:boss_view_init(boss_id, refer)
	print("wtf boss_id init:",boss_id)
	self.boss_id = boss_id

	self:reward_show(boss_id)

	local model = refer:Get("model")

	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end
		
	local callback = function(c_model)
		if model.transform:FindChild("my_model") then
	 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
	 	end
		c_model.name = "my_model"

	end
  	local boss_info = ConfigMgr:get_config("creature")[boss_id]
	local heroModel = boss_info.model_id
	local scale = dataUse.getBossInfo(boss_id).model_scare
	local modelView = require("common.uiModel")(model.gameObject,Vector3(-0.2,-1.6,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,158,0),scale_rate=Vector3(scale,scale,scale)},callback)

	refer:Get("boss_name").text = boss_info.name
end

function bossView:update_time(time_stamp)
	local time = time_stamp - Net:get_server_time_s()
	print("wtf time time:",time)
	if time <= 0 then
		self.refer:Get(9).text = commom_string[3]
	else
		local time_str = gf_convert_timeEx(time)
		self.refer:Get(9).text = string.format(commom_string[2],time_str)
	end
end

--倒计时
function bossView:cd_init(time)
	local btn_goto_attack = self.refer:Get(12)
	self.time = time
	local left_time = time - Net:get_server_time_s()
	if left_time > 0 then
		self:start_scheduler()
		btn_goto_attack.interactable = false
		return
	end
	btn_goto_attack.interactable = true
	self.refer:Get(9).text = commom_string[3]
end

-- 魔域boss时间刷新
function bossView:update_magic_time( dt )
	local have = false
	for k,v in pairs(self.magic_refresh_time_l or {}) do
		local t = Net:get_server_time_s()
		if v.time <= t then
			v.txt.text = gf_set_text_color(commom_string[5], ClientEnum.SET_GM_COLOR.INTERFACE_GREEN)
			self.magic_refresh_time_l[k] = nil
		else
			v.txt.text = gf_set_text_color(gf_convert_time(v.time - t), ClientEnum.SET_GM_COLOR.INTERFACE_RED)
		end
		have = true
	end
	if not have then
		self.magic_schedule:stop()
		self.magic_schedule = nil
	end
end

--击杀记录
function bossView:record_init(top_hurt,last_hurt)
	if self.boss_type == 2 then
		self.refer:Get(11):SetActive(false)
		return
	else
		self.refer:Get(11):SetActive(true)
	end
	self.refer:Get(5).text = top_hurt
	self.refer:Get(6).text = last_hurt	

end

-- 初始化掉落列表
function bossView:update_drop_view(data)
	if not self.drop_scroll then
		self.drop_scroll = self.refer:Get("drop_scroll")
		self.drop_scroll.onItemRender = handler(self, self.update_drop_item)
	end
	self.drop_scroll.data = data
	self.drop_scroll:Refresh(-1,-1)
end

function bossView:update_drop_item( item, index, data )
	item:Get(1).text = gf_get_time_stamp(data.date) -- 日期

	local boss_name = ConfigMgr:get_config("creature")[data.bossCode].name
	local item_name = ConfigMgr:get_config("item")[data.itemCode].name
	item:Get(2).text = string.format(commom_string[3],data.playerName, boss_name, item_name) -- 内容
end

function bossView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local end_time = self.time
	local update = function()
		local left_time = end_time - Net:get_server_time_s()
		self:update_time(end_time)
		if left_time <= 0 then
			gf_getItemObject("boss"):send_to_get_boss_data(self.boss_id)
			self:stop_schedule()
			return
		end
		
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end

function bossView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end

	if self.magic_schedule then
		self.magic_schedule:stop()
		self.magic_schedule = nil
	end
end

function bossView:page_click(event_name,arg)
	self.tag_index = -1
	self:clear_item()
	self:reset_last_blide()
	local index = string.gsub(event_name,"page_","")
	index = tonumber(index)
	print("页签",index)

	if self.button then
		self.button:GetComponent("UnityEngine.UI.Button").interactable = true
		local image = self.button.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(image, page_res[self.boss_type][1])
	end
	self.button = arg
	self.button:GetComponent("UnityEngine.UI.Button").interactable = false
	local image = self.button.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(image, page_res[index][2])

	if index == 4 then -- 掉落记录
		self.item_obj:drop_record_c2s()
		self.refer:Get("boss_obj"):SetActive(false)
		self.refer:Get("drop"):SetActive(true)
		return
	end
	self.refer:Get("boss_obj"):SetActive(true)
	self.refer:Get("drop"):SetActive(false)

	local refer = self.refer:Get("normal_refer")
	if index == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		refer = self.refer:Get("zork_refer")
		self.refer:Get("normal"):SetActive(false)
		self.refer:Get("zork"):SetActive(true)
	else
		self.refer:Get("normal"):SetActive(true)
		self.refer:Get("zork"):SetActive(false)
	end

	self.boss_type = index

	--boss列表
	local page,boss_id 
	local boss_info = dataUse.getBossListByType(index)
	if index == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		local level = gf_getItemObject("game"):getLevel()
		 page,boss_id = dataUse.getWorldBossTop(level)
		 print("wtf page,boss_id:",page,boss_id)
		 self.pre_page = page
		 self.pre_boss_id = boss_id
		-- self:tag_init(page)
	else
		-- self:scroll_view_init(boss_info, index == ServerEnum.BOSS_TYPE.MAGIC_BOSS)
		self:item_init(boss_info)
	end

	local first_boss_id = boss_id or boss_info[1].boss_code

	--掉落奖励
	local drop_rewards = dataUse.getDropRewardItem(first_boss_id)
	self:scroll_view_all_reward(drop_rewards, refer)

	--参与奖励
	if index ~= ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		local join_rewards = dataUse.getJoinRewardItem(first_boss_id)
		self:scroll_view_reward(join_rewards, refer)
	end
	
	--默认选中的bossid
	self.boss_id = first_boss_id

	if index == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		self.item_obj:magic_boss_refresh_list_c2s()
		self.item_obj:magic_boss_info_c2s(first_boss_id)
	else
		if self.magic_schedule then
			self.magic_schedule:stop()
			self.magic_schedule = nil
		end
		gf_getItemObject("boss"):send_to_get_boss_data(first_boss_id)
	end
end

function  bossView:reset_last_blide()
	if self.last_select_item and not Seven.PublicFun.IsNull(self.last_select_item) then
		self.last_select_item:Get(6):SetActive(false) -- 取消上一个高亮
		self.last_select_item = nil
	end
end
function bossView:boss_click(item,event)
	if self.last_select_item == item then
		return
	end
		
	local boss_code = string.gsub(event,"boss_item","")
	boss_code = tonumber(boss_code)
	
	self:reset_last_blide()
	
	item:Get(6):SetActive(true) -- 设置高亮


	local boss_info = dataUse.getBossListByType(self.boss_type)

	local boss_id = boss_code
	-- if self.boss_type == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
	-- 	local boss_data = dataUse.getWorldBoss()
	-- 	boss_id = boss_data[index].boss_code
	-- end
	self.boss_id = boss_id

	

	self.last_select_item = item

	--掉落奖励
	-- local refer
	-- if self.boss_type == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
	-- 	refer = self.refer:Get("zork_refer")
	-- 	self.item_obj:magic_boss_info_c2s(boss_id)
	-- else
	-- 	refer = self.refer:Get("normal_refer")
	-- 	gf_getItemObject("boss"):send_to_get_boss_data(boss_id)
	-- end

	-- local drop_rewards = dataUse.getDropRewardItem(boss_id)
	-- self:scroll_view_all_reward(drop_rewards, refer)

	if self.boss_type == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		self.item_obj:magic_boss_info_c2s(boss_id)
	else
		gf_getItemObject("boss"):send_to_get_boss_data(boss_id)
	end

	-- self:reward_show(boss_id)
end

function bossView:reward_show(boss_id)
	local refer
	if self.boss_type == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		refer = self.refer:Get("zork_refer")
	else
		refer = self.refer:Get("normal_refer")
	end
	--掉落奖励
	local drop_rewards = dataUse.getDropRewardItem(boss_id)
	self:scroll_view_all_reward(drop_rewards, refer)
end

function bossView:item_click(arg,event)
	local itype = string.sub(event,1,1)

	local rewards 
	if itype == "1" then
		rewards = dataUse.getDropRewardItem(self.boss_id)
	else
		rewards = dataUse.getJoinRewardItem(self.boss_id)
	end

	local index = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem").index + 1

	local item_id = rewards[index][1]
	print("点击boss掉落物品：",item_id)
	gf_getItemObject("itemSys"):prop_tips(item_id)
end

function bossView:tag_click(event)
	local index = string.gsub(event,"tag_item","")
	index = tonumber(index)
	self:tag_init(index,true)
end

--鼠标单击事件
function bossView:on_click(item_obj, obj, arg)
    local event_name = obj.name
    print("event_name:wtf",event_name)
    if event_name == "boss_close" then 
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    elseif string.find(event_name,"page") then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
    	self:page_click(event_name,arg)

    elseif string.find(event_name,"btn_goto_attack") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--如果已经在此地图
    	if gf_getItemObject("boss"):find_boss(self.boss_id) then
    		self:hide()
    	end

    elseif string.find(event_name,"boss_item") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	    self:boss_click(arg,event_name)

    elseif string.find(event_name,"item_reward") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(arg,event_name)

    elseif string.find(event_name,"tag_item") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:tag_click(event_name)

    elseif event_name == "help_btn" then -- 帮助
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if self.boss_type == ServerEnum.BOSS_TYPE.WILD_BOSS then
    		gf_show_doubt(1122)
    		return
    	end
    	gf_show_doubt(1121)

    elseif event_name == "togglleSoldier" then -- 关注/取消关注
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	arg:SetActive(not arg.activeSelf)
    	self.item_obj:magic_boss_focus_c2s(self.boss_id, arg.activeSelf)

    -- elseif string.find(event_name , "itemSysPropClick_" ) then
    --     Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    --     local sp = string.split(event_name,"_")
    --     local flexibleId = tonumber(sp[2])
    --     local itemSys = LuaItemManager:get_item_obejct("itemSys")
    --     local id = itemSys:get_formulaId_for_id(flexibleId) -- 先判断是不是装备虚拟id 获取到真实的物品id或者打造id
    --     local data = ConfigMgr:get_config("item")[id]
    --     if data then -- 物品 是物品
    --         itemSys:prop_tips(id,nil,obj.transform.position)
    --     else -- 装备预览 -- 物品表没有，就是打造id
    --         LuaItemManager:get_item_obejct("equip"):formula_tips(id,sp[3]~="" and sp[3] or nil,sp[4]~="" and sp[4] or nil,obj.transform.position)
    --     end

    end
end

function bossView:clear()
	self.button = nil
	self.last_select_item = nil
	self.item_list = {}
	self.tag_list = {}
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function bossView:dispose()
	self:stop_schedule()
	self:clear()
    self._base.dispose(self)
end

function bossView:on_hided()
	self:stop_schedule()
end
  
function bossView:on_showed()
	self:init_ui()
end


function bossView:rec_boss_data(msg)
	gf_print_table(msg, "WorldBossInfoR wtf:")
	-- self:update_time(msg.refreshTime)
	self.msg = msg
	self:cd_init(msg.refreshTime)
	self:record_init(msg.highestHurtName,msg.killerName)
	self:boss_view_init(self.boss_id, self.refer:Get("normal_refer"))
end

function bossView:update_magic_boss_view(msg)
	local refer = self.refer:Get("zork_refer")
	self:boss_view_init(self.boss_id, refer)
	refer:Get("tired_txt").text = string.format(gf_localize_string("疲劳值：%d/%d"),self.item_obj:get_magic_tired(), ConfigMgr:get_config("t_misc").boss.magic_boss_max_tired)
	refer:Get("kill_name").text = self.item_obj:get_magic_kill_name()

	local level = ConfigMgr:get_config("creature")[self.boss_id].level + ConfigMgr:get_const("magic_boss_d_lv")
	refer:Get("kill_warning"):SetActive(gf_getItemObject("game"):getLevel() > level)

	self.refer:Get(22):SetActive(msg.focus or false)

	-- refer:Get("togglle").isOn = 
end

function bossView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "WorldBossInfoR") then
			self:rec_boss_data(msg)

		elseif id2 == Net:get_id2(model_name, "MagicBossInfoR") then
        	self:update_magic_boss_view(msg)

        elseif id2 == Net:get_id2(model_name, "MagicBossRefreshListR") then
        	if self.boss_type ~= ServerEnum.BOSS_TYPE.MAGIC_BOSS then
        		return
        	end
        	gf_print_table(msg, "boss列表")
        	if not self.magic_time_list then
        		self.magic_time_list = {}
        	end
        	for i,v in ipairs(msg.list or {}) do
        		self.magic_time_list[v.bossCode] = v.refreshTime
        	end
        	self:tag_init(self.pre_page or 1)
       
        	-- self.left_scroll:Refresh(-1,-1)

        elseif id2 == Net:get_id2(model_name, "DropRecordLR") then
        	self:update_drop_view(msg.list or {})
		end
	end
end

return bossView