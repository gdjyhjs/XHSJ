--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExRank=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("activeEx")
    UIBase._ctor(self, "service_open_activity_rank.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ActiveExRank:on_asset_load(key,asset)
end

function ActiveExRank:init_ui()
	--[[[40001] = require("enum.enum").RANKING_TYPE.POWER,
							[50001] = require("enum.enum").RANKING_TYPE.HERO,
							[60001] = require("enum.enum").RANKING_TYPE.LEVEL]]
	self.page = 1
	self.data_list = {}
	self.activity_id = LuaItemManager:get_item_obejct("activeEx").activity_id
	local config = LuaItemManager:get_item_obejct("activeEx"):get_config(self.activity_id)
	local item_config = ConfigMgr:get_config("item")
	local horse = ConfigMgr:get_config("horse")
	local function update(item,index,data)
		local top = item:Get(2)
		if index == 1 then
			top.gameObject:SetActive(true)
			gf_setImageTexture(top,"rank_1st")
		elseif index == 2 then
			top.gameObject:SetActive(true)
			gf_setImageTexture(top,"rank_2nd")
		elseif index == 3 then
			top.gameObject:SetActive(true)
			gf_setImageTexture(top,"rank_3rd")
		else
			top.gameObject:SetActive(false)
		end
		local rank = item:Get(3)
		rank.text = tostring(index)
		local name = item:Get(4)
		local job = item:Get(7)
		local combat = item:Get(8)
		local vip = item:Get(5)
		local lv = item:Get(6)
		if self.rank_type == require("enum.enum").RANKING_TYPE.POWER then
			name.text = data.name
			combat.text = tostring(data.power)
			lv.text = tostring(data.vipLevel)
			job.text = ClientEnum.JOB_NAME[data.career]
			if data.vipLevel == 0 then
				vip:SetActive(false)
			else
				vip:SetActive(true)
			end
		elseif self.rank_type == require("enum.enum").RANKING_TYPE.HERO then
			name.text = data.name
			combat.text = tostring(data.hero.heroPower)
			lv.text = tostring(data.vipLevel)
			job.text = data.hero.heroName
			if data.vipLevel == 0 then
				vip:SetActive(false)
			else
				vip:SetActive(true)
			end
		elseif self.rank_type == require("enum.enum").RANKING_TYPE.LEVEL then
			name.text = data.name
			combat.text = tostring(data.level)
			lv.text = tostring(data.vipLevel)
			job.text = ClientEnum.JOB_NAME[data.career]
			if data.vipLevel == 0 then
				vip:SetActive(false)
			else
				vip:SetActive(true)
			end
		elseif self.rank_type == require("enum.enum").RANKING_TYPE.ALLIANCE_LEVEL then
			name.text = data.name
			combat.text = tostring(data.level)
			--lv.text = tostring(data.vipLevel)
			vip:SetActive(false)
			job.text = tostring(data.leaderName)
		elseif self.rank_type == require("enum.enum").RANKING_TYPE.HORSE then
			name.text = data.name
			combat.text = require("models.horse.dataUse").get_horse_level_string(data.horse.horseLevel)--tostring(data.horse.horseLevel)
			lv.text = tostring(data.vipLevel)
			job.text = (horse[data.horse.horseCode] and horse[data.horse.horseCode].name) or ""
			if data.vipLevel == 0 then
				vip:SetActive(false)
			else
				vip:SetActive(true)
			end
		end

		local reward_id = tonumber(string.format("%d%02d%02d",self.activity_id,self.rank_type,index))
		local reward_list = config[reward_id] or {}
		reward_list = reward_list.reward or {}
		for i =1,2 do
			local award_item = item:Get(9 + i - 1)
			if reward_list[i] ~= nil then
				award_item.gameObject:SetActive(true)
				local item_back = item:Get(11 + i - 1)--award_item:Get(1)
				local item_icon_img = award_item:Get(1)
				local count = award_item:Get(2)
				gf_set_item( reward_list[i][1], item_icon_img, item_back,reward_list[i][4],reward_list[i][5])
				count.text = tostring(reward_list[i][2])
				--[[award_item.gameObject.name = "item_" .. reward_list[i][1]
				if reward_list[i][4] ~= nil then
					award_item.gameObject.name = award_item.gameObject.name .. "_" .. reward_list[i][4]
				end
				if reward_list[i][5] ~= nil then
					award_item.gameObject.name = award_item.gameObject.name .. "_" .. reward_list[i][5]
				end]]
				gf_set_click_prop_tips(award_item.gameObject,reward_list[i][1],reward_list[i][4],reward_list[i][5])

				local lock = award_item:Get(3)
				if item_config[reward_list[i][1]].bind == 1 then
					lock:SetActive(true)
				else
					lock:SetActive(false)
				end
			else
				award_item.gameObject:SetActive(false)
			end
		end
	end
	self.right_scroll = self.refer:Get(1)
	--self.right_scroll.data = self.data_list
	self.right_scroll.onItemRender = update

	self.right_scroll.onBottom = function(item, index, data)
		--if #self.data_list % 7 == 0 then
		if #self.data_list < 20 and #self.data_list % 7 == 0 and self.page ~= 999999 then
			if self.rank_type == require("enum.enum").RANKING_TYPE.ALLIANCE_LEVEL then
				Net:send({type = self.rank_type,page = self.page + 1},"base","GetAllianceRank")
			else
				Net:send({type = self.rank_type,page = self.page + 1},"base","GetRankInfo")
			end
		end
		--end
	end

	local start_time = self.refer:Get(2)
	start_time.text = os.date("%Y-%m-%d %H:%M:%S",LuaItemManager:get_item_obejct("activeEx"):get_time_info(self.activity_id).begin_time)

	local end_time = self.refer:Get(3)
	end_time.text = os.date("%Y-%m-%d %H:%M:%S",LuaItemManager:get_item_obejct("activeEx"):get_time_info(self.activity_id).end_time)

	local des = self.refer:Get(6)
	des.text = string.format(gf_localize_string("活动介绍:%s"),ConfigMgr:get_config("activity_server_start")[self.activity_id].description or "")
	self.rank_type = LuaItemManager:get_item_obejct("activeEx"):get_rank_type(self.activity_id)
	local combat = self.refer:Get(4)
	local text = self.refer:Get(7)
	--local str = ""
	if self.rank_type == require("enum.enum").RANKING_TYPE.POWER then
		text.text = gf_localize_string("我的战力:")
		combat.text = tostring(LuaItemManager:get_item_obejct("game"):getPower())
		--str = gf_localize_string("战力")
	elseif self.rank_type == require("enum.enum").RANKING_TYPE.HERO then
		text.text = gf_localize_string("我的武将:")
		combat.text = tostring(math.max(0,LuaItemManager:get_item_obejct("hero"):get_top_power()))
		--str = gf_localize_string("武将")
	elseif self.rank_type == require("enum.enum").RANKING_TYPE.LEVEL then
		text.text = string.format(gf_localize_string("我的等级:"))
		combat.text = tostring(LuaItemManager:get_item_obejct("game"):getLevel())
	elseif self.rank_type == require("enum.enum").RANKING_TYPE.HORSE then
		text.text = string.format(gf_localize_string("我的坐骑:"))
		local str = ""
		if self.my_info ~= nil and self.my_info.horse ~= nil then
			--value = self.my_info.horse.horseLevel or 0
			str = require("models.horse.dataUse").get_horse_level_string(self.my_info.horse.horseLevel)
		end
		combat.text = str--tostring(value)
	elseif self.rank_type == require("enum.enum").RANKING_TYPE.ALLIANCE_LEVEL then
		--str = gf_localize_string("等级")
		text.text = string.format(gf_localize_string("我的军团:"))
		local value = 0
		--[[if self.my_info ~= nil then
			value = self.my_info.level or 0
		end]]
		combat.text = string.format(gf_localize_string("%s级"),LuaItemManager:get_item_obejct("legion"):get_level() or 0)
	else
	end
	--t4.text = str
	local text_rank = self.refer:Get(5)
	text_rank.text = tostring(self.my_rank or "")

	local config = ConfigMgr:get_config("show_name")
	local label_list = {}
	for i,v in ipairs(config) do
		if v.rank_type == self.rank_type then
			table.insert(label_list,v.name)
		end
		if #label_list == 4 then
			break
		end
	end
	for i,v in ipairs(label_list) do
		local text = self.refer:Get(8 + i - 1)
		text.text = v
	end
	if self.rank_type == require("enum.enum").RANKING_TYPE.ALLIANCE_LEVEL then
		Net:send({type = self.rank_type,page = 1},"base","GetAllianceRank")
	else
		Net:send({type = self.rank_type,page = 1},"base","GetRankInfo")
	end
end

function ActiveExRank:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "GetRankInfoR") then
			if msg.type == self.rank_type then
				--self.data_list = gf_deep_copy(msg.list)
				if 0 < #msg.list then
					self.page = msg.page
					for i,v in ipairs(msg.list) do
						if #self.data_list < 20 then
							table.insert(self.data_list,gf_deep_copy(v))
							self.right_scroll:InsertData(gf_deep_copy(v), -1)
						end
					end
					self.my_rank = msg.myRank
					self.my_info = msg.myInfo
					--self.right_scroll.data = self.data_list
					self.right_scroll:Refresh(0,#self.data_list - 1)

					local text_rank = self.refer:Get(5)
					if self.my_rank ~= nil and self.my_rank ~= 0 then
						if self.my_rank <= 50 then
							text_rank.text = tostring(self.my_rank)
						else
							text_rank.text = "50+"
						end
					else
						text_rank.text = gf_localize_string("未上榜")
					end
					if self.rank_type == require("enum.enum").RANKING_TYPE.HORSE then
						local combat = self.refer:Get(4)
						local value = 0
						if self.my_info ~= nil and self.my_info.horse ~= nil then
							value = self.my_info.horse.horseLevel or 0
						end
						if value ~= 0 then
							combat.text = require("models.horse.dataUse").get_horse_level_string(value)--tostring(value)
						else
							combat.text = gf_localize_string("无坐骑")
						end
					elseif self.rank_type == require("enum.enum").RANKING_TYPE.HERO then
						local combat = self.refer:Get(4)
						local value = 0
						if self.my_info ~= nil and self.my_info.hero ~= nil then
							value = self.my_info.hero.heroPower or 0
						end
						combat.text = tostring(value)
					elseif self.rank_type == require("enum.enum").RANKING_TYPE.POWER then
						local combat = self.refer:Get(4)
						combat.text = tostring(self.my_info.power)
					elseif self.rank_type == require("enum.enum").RANKING_TYPE.LEVEL then
						local combat = self.refer:Get(4)
						combat.text = tostring(self.my_info.level)
					end
				else
					self.page = 999999
				end
			end
		elseif id2 == Net:get_id2("base", "GetAllianceRankR") then
			if msg.type == self.rank_type then
				--self.data_list = gf_deep_copy(msg.list)
				if 0 < #msg.list then
					self.page = msg.page
					for i,v in ipairs(msg.list) do
						if #self.data_list < 20 then
							table.insert(self.data_list,gf_deep_copy(v))
						end
					end
					self.my_rank = msg.myRank
					self.my_info = msg.myInfo
					self.right_scroll.data = self.data_list
					self.right_scroll:Refresh(0,#self.data_list - 1)

					local text_rank = self.refer:Get(5)
					if self.my_rank ~= nil and self.my_rank ~= 0 then
						if self.my_rank <= 50 then
							text_rank.text = tostring(self.my_rank)
						else
							text_rank.text = "50+"
						end
					else
						text_rank.text = gf_localize_string("未上榜")
					end
					local combat = self.refer:Get(4)
					combat.text = string.format(gf_localize_string("%s级"),LuaItemManager:get_item_obejct("legion"):get_level() or 0)
				else
					self.page = 999999
				end
			end
		end
	end
end

function ActiveExRank:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if string.find(cmd,"item") then
		--Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		--[[local index = string.f(cmd,"item","")
		index = tonumber(index)]]
		--gf_getItemObject("itemSys"):common_show_item_info(index)
		--[[local list = string.split(cmd,"_")
		local index = tonumber(list[2])
		local color = nil 
		if list[3] ~= nil then
			color = tonumber(list[3])
		end 
		local star = list[4]
		if list[4] ~= nil then
			star = tonumber(list[4])
		end
		print("ActiveExRank:on_click111",index,color,star)]]
		--gf_set_click_prop_tips(obj,index,color,star)
	end
end

function ActiveExRank:register()
	StateManager:register_view( self )
end

function ActiveExRank:cancel_register()
	StateManager:remove_register_view( self )
end

function ActiveExRank:on_showed()
	self:register()
	self:init_ui()
end

function ActiveExRank:on_hided()
end

-- 释放资源
function ActiveExRank:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return ActiveExRank

