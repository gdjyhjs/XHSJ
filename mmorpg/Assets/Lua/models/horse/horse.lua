--[[
	坐骑系统数据模块
	create at 17.6.19
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local dataUse = require("models.horse.dataUse")
local horse = LuaItemManager:get_item_obejct("horse")

horse.priority = ClientEnum.PRIORITY.HORSE

require("models.horse.horsePublic")
local Enum = require("enum.enum")
local model_name = "horse"
--UI资源
horse.assets=
{
    View("horseView", horse) ,
}

--点击事件
function horse:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("horse_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function horse:initialize()
	self.ride_state 	= -1
	self.horse_list 	= {}
	self.level 			= -1
	self.feed_level 	= -1
	self.feed_exp 		= -1
	self.exp 			= -1
	self.magic_id 		= -1
	self.auto_buy 		= 0 			--主动购买标记
	self.memory_list 	= {}

	self.page_index = nil
	self.tag_index = nil
	self.t_horse_id = nil
end



--get ***********************************************************************************
function horse:get_arg()
	return self.page_index ,self.tag_index,self.t_horse_id
end
function horse:get_magic_id()
	return self.magic_id
end
function horse:get_level()
	return self.level
end
function horse:get_feed_level()
	return self.feed_level
end
function horse:get_feed_exp()
	return self.feed_exp
end
function horse:get_ride_state()
	return self.ride_state
end
function horse:get_horse_list()
	return self.horse_list
end
function horse:get_exp()
	return self.exp
end
function horse:get_total_exp()
	local exp = dataUse.get_total_exp(self.level - 1)
	print("exp:",exp)
	return exp + self.exp
end
function horse:get_auto_buy_state()
	return self.auto_buy
end
function horse:get_feed_memory()
	return self.memory_list
end

-- 当前拥有的坐骑进阶道具是否足够升级到下一级 
function horse:get_prop_enough_level_up()
    local cur_level = horse:get_level()
    -- print("cur_level:",cur_level)
    if cur_level <= 0 then
    	return
    end
    local dataUse = require("models.horse.dataUse")
    local max_exp = dataUse.get_exp_by_level(cur_level)
    local cur_exp = horse:get_exp()
    local need_exp = max_exp - cur_exp
    local bag = LuaItemManager:get_item_obejct("bag")
	local data_list = require("models.bag.bagUserData"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.HORSE_STAGE_UP)
	local prop_exp = 0
	for i,v in ipairs(data_list) do
		local count = bag:get_item_count(v.code,ServerEnum.BAG_TYPE.NORMAL,true)
		prop_exp = prop_exp + count*v.effect[1]
	end
	-- print("道具经验",prop_exp,"需要经验",need_exp,"当前经验",cur_exp,"最大经验",max_exp)
	return prop_exp>=need_exp
end

function horse:get_is_unlock(horse_id)
	for i,v in ipairs(self.horse_list or {}) do
		if v.horseId == horse_id then
			return true
		end
	end
	return false 
end

function horse:get_horse_data(id)
	for i,v in ipairs(self.horse_list or {}) do
		if v.horseId == id then
			return v
		end
	end
	print("error get_horse_data id :",id)
end
 

function horse:get_horse_effect(id)
	local horse_info = dataUse.get_horse_data(id)
	gf_print_table(horse_info, "wtf horse_info:")
	if horse_info.type == Enum.HORSE_TYPE.NORMAL then
		local level = dataUse.get_horse_level_info(id).level
		local level_horse_info = dataUse.get_level_data(level)
		
		local list = {}
		if level_horse_info.spec_effect and level_horse_info.spec_effect ~= "" then
			list = {{level_horse_info.spec_effect}}
		end
		for i,v in ipairs(level_horse_info.skeleto_effect or {}) do
			list[#list+1] = v
		end
		return list
	end
 
	local list = {}
	
	if horse_info.spec_effect and horse_info.spec_effect ~= "" then
		list = {{horse_info.spec_effect}}
	end
	for i,v in ipairs(horse_info.skeleto_effect or {}) do
		list[#list+1] = v
	end
	
	return list
end

--获取特殊坐骑的属性加成 
function horse:get_horse_property_add()
	local temp = 
	{
		attack 				= 0,
		physical_defense 	= 0,
		magic_defense 		= 0,
		hp 					= 0,
		dodge 				= 0,
		speed 				= 0,
	}

	for i,v in ipairs(self.horse_list or {}) do
		local horse_info = dataUse.get_horse_data(v.horseId)
		if horse_info.type == HORSE_TYPE.ex then
			for kk,vv in pairs(temp) do
				temp[kk] = temp[kk] + horse_info[kk]
			end
		end
	end
	return temp
end

-- 是否骑着坐骑
function horse:is_ride()
	return self.ride_state == 1
end

--set ***********************************************************************************
function horse:set_arg(page_index,tag_index,horse_id)
	self.page_index = page_index
	self.tag_index = tag_index
	self.t_horse_id = horse_id
end

function horse:set_param(...)
	self.param = {...}
end
function horse:get_param()
	return self.param
end
function horse:set_magic_id(magic_id)
 	self.magic_id = magic_id
end
function horse:set_level(level)
 	self.level = level
end
function horse:set_feed_level(feed_level)
 	self.feed_level = feed_level
end
function horse:set_feed_exp(feed_exp)
 	self.feed_exp = feed_exp
end
function horse:set_ride_state(ride_state)
 	self.ride_state = ride_state
end
function horse:set_horse_list(horse_list)
 	self.horse_list = horse_list
end 
function horse:set_horse_info(horse)
	for i,v in ipairs(self.horse_list or {}) do
		if v.horseId == horse.horseId then
			self.horse_list[i] = horse
			return
		end
	end
 	-- 获得坐骑、武将时的专用音效
	Sound:play(ClientEnum.SOUND_KEY.GET_PARTNER)
	require("models.horse.showTips")(2,horse.horseId)
	self.magic_id = horse.horseId
	table.insert(self.horse_list,horse)
	gf_print_table(self.horse_list,"horse_list wtf:")
end
function horse:set_slot(slot)
	self.horse_list.horse = slot
end
function horse:set_exp(exp)
 	self.exp = exp
end
function horse:set_get_type(type)
	self.get_type = type
end
function horse:get_get_type()
	return self.get_type
end
function horse:set_auto_buy_state(state)
	print("设置自动自动购买状态",state)
	self.auto_buy = state
end
function horse:set_feed_memory(memory)
	self.memory_list = memory
end
function horse:set_slot(info)
	for i,v in ipairs(self.horse_list or {}) do
		if v.horseId == info.horseId then
			v.slotLevel[info.slot] = info.level
		end
	end
end

--send ***********************************************************************************
function horse:send_to_get_horse_info()
	local msg = {}
	Net:send(msg,model_name,"GetHorseInfo")
	gf_print_table(msg, "GetHorseInfo:")
	testReceive(msg, model_name, "GetHorseInfoR", sid)
end

function horse:send_to_ride_ex()
	if self:get_ride_state() == 1 then
		self:send_to_ride(0)
	else
		self:send_to_ride(1)
	end
end
function horse:send_to_ride(ride)
	local msg = {bIntRide = ride}
	Net:send(msg,model_name,"SetHorseRiding")
	testReceive(msg, model_name, "SetHorseRidingR", self:get_ride_state())
end
function horse:send_to_group(type)
	local msg 				= {}
	msg.addType				= type
	msg.bAutoBuyItem		= self.auto_buy
	Net:send(msg,model_name,"AddExpByItem") 
	testReceive(msg, model_name, "AddExpByItemR", {exp = self.exp,level =  self.level})
end
function horse:send_to_magic(id)
	if not id then
		return
	end
	local msg = {}
	msg.horseId = id
	Net:send(msg,model_name,"ChangeHorseView")
	testReceive(msg, model_name, "ChangeHorseViewR", id)
end
function horse:send_to_slot(id,slot_id)
	if not id or not slot_id then
		return
	end
	local msg = {}
	msg.horseId = id
	msg.slot = slot_id
	Net:send(msg,model_name,"HorseSlotLevelUp")
	gf_print_table(msg, "HorseSlotLevelUp:")
	testReceive(msg, model_name, "HorseSlotLevelUpR", {id,slot_id})
end
function horse:send_to_feed_memory()
	local msg = {}
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	Net:send(msg,model_name,"FeedHorseByMemory")
	testReceive(msg, model_name, "FeedHorseByMemoryR", self.feed_exp)
end
function horse:send_to_feed(uids)
	local msg = {}
	msg.guid = uids
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	Net:send(msg,model_name,"FeedHorse")
	gf_print_table(msg, "FeedHorse:")
	testReceive(msg, model_name, "FeedHorseR", sid)
end
function horse:send_to_save_memory(item_ids)
	local msg = {}
	msg.protoIdArr = item_ids
	Net:send(msg,model_name,"RmItemToFeedMemory")
	testReceive(msg, model_name, "SaveItemToFeedMemoryR", item_ids)
end
function horse:send_to_get_memory()
	local msg = {}
	Net:send(msg,model_name,"GetItemToFeedMemory")
	testReceive(msg, model_name, "GetItemToFeedMemoryR", sid)
end


--rec ***********************************************************************************
function horse:rec_horse_info(msg)
	self:set_ride_state(msg.bHorse)
	self:set_horse_list(msg.horse)
	self:set_level(msg.level)
	self:set_feed_level(msg.feedLevel)
	self:set_feed_exp(msg.feedExp)
	self:set_exp(msg.exp)
	self:set_magic_id(msg.viewHorseId)
end
function horse:rec_ride_state(msg)
	if msg.err == 0 then
		self:set_ride_state(msg.bHorse)
		 -- 上滑上坐骑或在坐骑界面点击骑乘上坐骑的时候播放的音效，取消坐骑同理
		Sound:play(ClientEnum.SOUND_KEY.MOUNTS)
	end
end
function horse:rec_exp(msg)
	if msg.err == 0 then
		self:set_exp(msg.exp)
		self:set_level(msg.level)
	end
end
function horse:rec_magic(msg)
	if msg.err == 0 then
		self:set_magic_id(msg.horseId)
	end
end
function horse:rec_slot(msg)
	if msg.err == 0 then
		--如果是槽位升级
		if msg.level > 0 and not next(msg.horse or {}) then
			self:set_slot(msg)
			return
		end
		--如果是封灵升级
		self:set_horse_info(msg.horse)
	end
end

function horse:rec_feed(msg)
	if msg.err == 0 then
		if msg.feedlevel>self.feed_level then
			 -- 角色、坐骑、武将升级时播放的音效
			Sound:play(ClientEnum.SOUND_KEY.LEVEL_UP)
		end
		self:set_feed_exp(msg.feedexp)
		self:set_feed_level(msg.feedlevel)
	end
end


--服务器返回
function horse:on_receive( msg, id1, id2, sid )
    if(id1 == Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name, "GetHorseInfoR") then
        	gf_print_table(msg,"wtf receive GetHorseInfoR")
       		self:rec_horse_info(msg)
       	
       	elseif id2 == Net:get_id2(model_name,"SetHorseRidingR") then
       		gf_print_table(msg,"SetHorseRidingR")
       		self:rec_ride_state(msg)
        	gf_receive_client_prot(nil, ClientProto.CharacterRide)
        elseif id2 == Net:get_id2(model_name,"AddExpByItemR") then
        	gf_print_table(msg,"AddExpByItemR")
        	self:rec_exp(msg)

        elseif id2 == Net:get_id2(model_name,"ChangeHorseViewR") then
        	gf_print_table(msg,"ChangeHorseViewR")
        	self:rec_magic(msg)

        elseif id2 == Net:get_id2(model_name,"HorseSlotLevelUpR") then
        	gf_print_table(msg,"HorseSlotLevelUpR")
        	self:rec_slot(msg)

        elseif id2 == Net:get_id2(model_name,"FeedHorseByMemoryR") then
        	gf_print_table(msg,"FeedHorseByMemoryR")
        	self:rec_feed(msg) 

        elseif id2 == Net:get_id2(model_name,"FeedHorseR") then
			gf_print_table(msg,"FeedHorseR")
        	self:rec_feed(msg)        	

        elseif id2 == Net:get_id2(model_name,"RmItemToFeedMemoryR") then
        	gf_print_table(msg,"RmItemToFeedMemoryR")
        	self:set_feed_memory(msg.protoIdArr)
        elseif id2 == Net:get_id2(model_name,"GetItemToFeedMemoryR") then
        	gf_print_table(msg,"GetItemToFeedMemoryR")
        	self:set_feed_memory(msg.protoIdArr)

        elseif id2 == Net:get_id2(model_name,"HorseR") then
        	gf_print_table(msg,"HorseR wtf =====")
        	self:set_horse_info(msg.horse)

        end
    end
end


