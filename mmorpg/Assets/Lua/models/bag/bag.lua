--[[-- gf_message_tips
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-24 14:42:41
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local Enum_ser = require("enum.enum_ser")
local BagUserData = require("models.bag.bagUserData")
local Bag = LuaItemManager:get_item_obejct("bag")
Bag.priority = ClientEnum.PRIORITY.BAG

Bag.items={} --背包所有物品
Bag.unlock={
} -- 解锁数据
Bag.last_sort_ware_time = 0	--上一次整理仓库时间
Bag.last_merge_ware_time = 0	--上一次合并仓库时间
Bag.last_merge_bag_time = 0	--上一次合并背包时间
Bag.last_sort_bag_time = 0		--上一次整理背包时间
Bag.sort_bag_time_cool = 10	--整理背包冷却时长

--UI资源
Bag.assets=
{
    View("bagView", Bag),
}

--获取炼化配置表
function Bag:get_funsion_config()
	if not self.funsion_config then
		local list = {}
		local data = ConfigMgr:get_config("smelt")
		for i,v in ipairs(data) do
			if not list[v.type] then list[v.type] = {} end
			if not list[v.type][v.category] then list[v.type][v.category] = {name = v.category_name,order = v.category} end
			list[v.type][v.category][#list[v.type][v.category]+1]=v
		end
		for t,c in ipairs(list) do
			table.sort(c,function(a,b) return a.order<b.order end)
		end
		self.funsion_config = list
	end
	return self.funsion_config
end
Bag.event_name = "bag_view_on_click"
--点击事件
function Bag:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

--初始化函数
function Bag:initialize()
	self.useing_treasure_map = nil --正在使用的藏宝图
	self.bag_open_page = 1
	self.main_item = LuaItemManager:get_item_obejct("mainui")
	self.item_sys = LuaItemManager:get_item_obejct("itemSys")
end

-- 获取是否有红点
function Bag:is_have_red_point()
	return self.have_red_point or false --TODO 这里要去返回是否有红点
end
-- 设置是否有红点
function Bag:set_have_red_point()
	-- gf_print_table(self.unlock[Enum.BAG_TYPE.NORMAL],"背包解锁时间")
	-- print("背包红点判断等级",LuaItemManager:get_item_obejct("game"):getLevel() , ConfigMgr:get_config("t_misc").guide_protect_level)
	self.have_red_point = LuaItemManager:get_item_obejct("game"):getLevel() > ConfigMgr:get_config("t_misc").guide_protect_level and
								self.unlock[Enum.BAG_TYPE.NORMAL] and self.unlock[Enum.BAG_TYPE.NORMAL].size and 
								self.unlock[Enum.BAG_TYPE.NORMAL].size<BagUserData:get_max_item_count(Enum.BAG_TYPE.NORMAL) and 
								self.unlock[Enum.BAG_TYPE.NORMAL].unlockTimeLeft <= Net:get_server_time_s() or false
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.BAG, visible=self.have_red_point}, ClientProto.ShowHotPoint)
	if self.have_red_point then
		self.bag_open_page = math.ceil((self:get_bagsize(Enum.BAG_TYPE.NORMAL)+1)/BagUserData:get_knapsack_page_item_count(Enum.BAG_TYPE.NORMAL))
	end
end

--获取某件装备的套装mask
function Bag:get_set_mask(item)
	-- print("获取某件装备的套装mask")
	local on_bag = math.floor(item.slot/10000)
	local sub_type = ConfigMgr:get_config("item")[item.protoId].sub_type
	if on_bag == Enum.BAG_TYPE.EQUIP then -- 是穿着的
		local set_info = LuaItemManager:get_item_obejct("itemSys"):get_equip_set(item.protoId)
		if set_info then
			local set_mask = 0
			for i,v in ipairs(set_info.element or {}) do
				local sub_type = ConfigMgr:get_config("item")[v].sub_type
				local slot = sub_type + Enum.BAG_TYPE.EQUIP*10000
				if self.items[slot] and self.items[slot].protoId == v then
					set_mask = set_mask + bit._rshift(0x80000000,31-sub_type)
				end
			end
			-- print("是穿着的装备",set_mask)
			return set_mask
		end
		-- print("是穿着的装备,但是没套装效果",item.protoId)
	else -- 不是穿着的
		-- print("不是穿着的装备",bit._rshift(0x80000000,31-sub_type))
		return bit._rshift(0x80000000,31-sub_type)
	end
end
--[[
item_id 	物品id 		必填
bag_type 	背包类型 	在哪个背包查找，为空则装备栏，背包，仓库都会查找 枚举表 BAG_TYPE)
locak_bind 	锁定绑定 	默认false 则查找绑定+不绑定的物品数量		true:则根据物品id对应的数量(id对应的物品是绑定的则只查绑定的数量，是不绑定的则只查不绑定的数量)
]]
--获取物品数量 （物品id，背包类型，是否分局id只获取绑定或不绑定）
function Bag:get_item_count(item_id,bag_type,locak_bind)
	local count = 0
	for k,v in pairs(self.items) do
		-- print("物品id",v.protoId)
		local data = self.item_sys:get_item_for_id(v.protoId)
		if (item_id==v.protoId or (not locak_bind and item_id==data.rel_code)) and (not bag_type or bag_type==math.floor(k/10000)) then
			count=count+v.num
		end
	end
	return count
end

--根据guid获取物品	背包右这个物品才能返回
function Bag:get_item_for_guid(guid)
	for k,v in pairs(self.items) do
		if v.guid == guid then
			return v
		end
	end
end

--根据原型id获取物品
function Bag:get_item_for_protoId(protoId,bag_type,locak_bind)
	for k,v in pairs(self.items) do
		-- print("物品id",v.protoId)
		local data = self.item_sys:get_item_for_id(v.protoId)
		if (v.protoId == protoId or (not locak_bind and data.rel_code == protoId)) and (not bag_type or bag_type==math.floor(k/10000)) then
			return v
		end
	end
end
--根据原型id和背包类型获取物品列表
function Bag:get_item_for_protoId_type(protoId,bag_type)
	local comparison_type_fun=function(item,info)
		if bag_type==math.floor(item.slot/10000) and item.protoId == protoId then
			return true
		else
			return false
		end
	end
	return self:get_item_for_condition_fun(comparison_type_fun)
end
--[[
big_type 	查找哪个大类的物品 		必填
small_type	查找小类的物品			为空则大类下的物品都会找到 枚举表BAG_TYPE)
bag_type 	背包类型				在哪个背包查找，为空则装备栏，背包，仓库都会查找
]]
--根据类型获取道具
function Bag:get_item_for_type(big_type,small_type,bag_type)
	local comparison_type_fun=function(item,info)
		local bt,st=self:get_type_for_protoId(item.protoId)
		if bt==big_type and (small_type==nil and true or st==small_type) and (bag_type==nil and true or bag_type==math.floor(item.slot/10000)) then
			return true
		else
			return false
		end
	end
	return self:get_item_for_condition_fun(comparison_type_fun)
end

-- 获取背包的所有物品表 键=在背包的格子位置 值=物品属性
function Bag:get_bag_item()
	return self.items
end

function Bag:get_item_list(bagType)
	local list = {}
	if not bagType or bagType==ServerEnum.BAG_TYPE.NORMAL then
		for i=ServerEnum.BAG_TYPE.NORMAL*10000+1,ServerEnum.BAG_TYPE.NORMAL*10000+self:get_bagsize(ServerEnum.BAG_TYPE.NORMAL) do
			list[#list+1] = self.items[i]
		end
	end
	if not bagType or bagType==ServerEnum.BAG_TYPE.EQUIP then
		for i=ServerEnum.BAG_TYPE.EQUIP*10000+1,ServerEnum.BAG_TYPE.EQUIP*10000+self:get_bagsize(ServerEnum.BAG_TYPE.EQUIP) do
			list[#list+1] = self.items[i]
		end
	end
	if not bagType or bagType==ServerEnum.BAG_TYPE.DEPOT then
		for i=ServerEnum.BAG_TYPE.DEPOT*10000+1,ServerEnum.BAG_TYPE.DEPOT*10000+self:get_bagsize(ServerEnum.BAG_TYPE.DEPOT) do
			list[#list+1] = self.items[i]
		end
	end
	return list
end

--[[
condition_fun 	条件方法	一个方法返回true或者false 符合条件的道具会加入表返回
bag_type 	 	背包类型	在哪个背包查找，为空则装备栏，背包，仓库都会查找
]]
--根据条件方法获取道具 (item(物品信息),data(物品配置))
function Bag:get_item_for_condition_fun(condition_fun,bag_type)
	local result={}
	for k,v in pairs(self.items) do
		local data = self.item_sys:get_item_for_id(v.protoId)
		if condition_fun(v,data) and (bag_type==nil and true or bag_type==math.floor(v.slot/10000)) then
			result[#result+1]={item=v,data=data}
		end
	end
	return result
end

function Bag:get_equip_from_bag(bag_type)
	local result={}
	for k,v in pairs(self.items) do
		local bt,st=self:get_type_for_protoId(v.protoId)
		if bag_type==math.floor(v.slot/10000) and bt == ServerEnum.ITEM_TYPE.EQUIP then
			table.insert(result,v)
		end
	end
	return result
end

function Bag:get_item_for_bag_type(bag_type)
	local result={}
	for k,v in pairs(self.items) do
		if bag_type==math.floor(v.slot/10000) then
			table.insert(result,v)
		end
	end
	return result
end

--根据原型id获取类型
function Bag:get_type_for_protoId(protoId)
	-- local big_type = math.floor(protoId*0.0000001)
	-- local small_type = math.floor(protoId%1000000*0.0001)

	local data = gf_get_config_table("item")[protoId]
	if data then
		return data.type,data.sub_type
	end

	return big_type,small_type
end
--获取 道具数量 包括绑定和非绑定的道具
--@道具id prot_id
function Bag:get_count_in_bag(prot_id)
	local big_type,small_type = self:get_type_for_protoId(prot_id)
	local item = self:get_item_for_type(big_type,small_type,ServerEnum.BAG_TYPE.NORMAL)
	local count = 0
	for i,v in ipairs(item or {}) do
		count = count + v.item.num
	end
	return count
end
--获取物品小类
function Bag:get_item_small_type(protoId)
	return math.floor(protoId%1000000*0.0001)
end
--获取物品大类
function Bag:get_big_small_type(protoId)
	return math.floor(protoId*0.0000001)
end
--获取背包大小
function Bag:get_bagsize(bagType)
	return self.unlock[bagType] and self.unlock[bagType].size or 10
end
--更新背包大小
function Bag:update_bagsize_s2c(msg)
	self:set_bag_size(msg.type,msg.size)--更新大小
end
--获取背包第一个空位
function Bag:get_bag_first_space(bagtype)
	for i=1,self:get_bagsize(bagtype) do
		local slot = bagtype*10000+i
		if not self:get_bag_item()[slot] then
			-- print("找到空位",slot)
			return slot
		end
	end
end

--删除物品 数量一般不用填 或者填1
function Bag:delete_item(id,count)
	local msg={itemList={}}
	local del=function(item)
		msg.itemList[1]={}
		msg.itemList[1].slot=item.slot
		msg.itemList[1].num=count and item.num-count or 0
		local t = self:get_type_for_protoId(item.protoId)
		if t==Enum.ITEM_TYPE.EQUIP then
			self:update_equip_s2c(msg)
		else
			self:update_item_s2c(msg)
		end
	end
	if type(id)=="number" or tonumber(id) then
		local item = self:get_item_for_protoId(tonumber(id))
		if item then
			del(item)
		end
	elseif type(id)=="string" then
		local item = self:get_item_for_guid(id)
		if item then
			del(item)
		end
	else
		return 
	end
end

--服务器返回
function Bag:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("bag"))then
		-- gf_print_table(msg,"*********************背包**********************服务器返回消息啦<<<<<<<<<<<<<<<")
		if(id2== Net:get_id2("bag", "UpdateItemR"))then
			gf_print_table(msg,"--更新物品信息")
			self:update_item_s2c(msg)
		elseif(id2== Net:get_id2("bag", "UpdateEquipR"))then
			gf_print_table(msg,"--更新装备信息")
			self:update_equip_s2c(msg)
		elseif(id2== Net:get_id2("bag", "UpdateHeroEquipR"))then
			gf_print_table(msg,"--更新武将装备信息")
			self:update_hero_equip_s2c(msg)
		elseif(id2== Net:get_id2("bag", "UpdateBagR"))then
			gf_print_table(msg,"--更新整个背包")
			self:update_bag_s2c(msg)
		elseif(id2== Net:get_id2("bag", "GetBagInfoR"))then 
			gf_print_table(msg,"--获取背包道具列表 解锁情况",sid)
			-- gf_print_table(msg,"wtf receive GetBagInfoR")
			self:get_bag_s2c(msg,sid)
		elseif(id2== Net:get_id2("bag", "SwapItemR"))then
			-- gf_print_table(msg,"--交换位置")
			self:swap_item_s2c(msg,sid)
		elseif(id2== Net:get_id2("bag", "UseItemR"))then
			gf_print_table(msg,"--使用物品")
			self:use_item_s2c(msg)
		elseif(id2== Net:get_id2("bag", "MultiUseItemR"))then
			gf_print_table(msg,"--批量使用物品")
			self:multi_use_item_s2c(msg)
		elseif(id2== Net:get_id2("bag", "UnlockSlotR"))then
			gf_print_table(msg,"--开启格子")
			self:unlock_slot_s2s(msg)
		elseif(id2== Net:get_id2("bag", "UpdateBagSizeR"))then
			gf_print_table(msg,"--更新背包大小")
			self:update_bagsize_s2c(msg)
		elseif(id2== Net:get_id2("bag", "SplitItemR"))then
			gf_print_table(msg,"--拆分物品")
			self:split_item_s2c(msg)
		elseif(id2== Net:get_id2("bag", "SellItemR"))then
			gf_print_table(msg,"--出售物品")
			self:sell_item_s2c(msg)
		elseif(id2== Net:get_id2("bag", "UseTreasureMapR"))then
			--使用藏宝图返回
			-- gf_print_table(msg,"挖宝:使用藏宝图返回")
			self:use_treasure_map_s2c(msg)
		elseif(id2== Net:get_id2("bag", "DigTreasureMapR"))then
			--开始挖宝返回
			-- gf_print_table(msg,"挖宝:开始挖宝返回")
			self:dig_treasure_map_s2c(msg)
		elseif(id2== Net:get_id2("bag", "TreasureMapRewardR"))then
			--领取挖宝奖励返回
			-- gf_print_table(msg,"挖宝:领取挖宝奖励返回")
			self:treasure_map_reward_s2c(msg)
        elseif(id2== Net:get_id2("bag", "TreasureMapMonsterRewardR"))then
        	-- 宝图怪物死后奖励推送
        	self:treasure_map_monster_reward_s2c(msg)
        elseif(id2== Net:get_id2("bag", "TreasureMapMonsterDied"))then
        	-- 宝图怪物死后推送给挖出此怪物的人
        	self:treasure_map_monster_died_s2c(msg)
        elseif(id2== Net:get_id2("bag", "GetOnlyShowCanR"))then
        elseif(id2== Net:get_id2("bag", "SmeltItemR"))then
		end
	elseif id1 == Net:get_id1("horse") then
		if id2 == Net:get_id2("horse","SetHorseRidingR") then
			print("收到下坐骑协议，判断是不是在挖宝horse")
			if msg.err == 0  and msg.bHorse == 0 and self.useTreasureMap then
				PLua.Delay(function()
						if self.useTreasureMap then
							self:can_dig_treasure_tips(self.useTreasureMap.guid)
						end
					end,1)
			end
		end
	elseif id1 == ClientProto.FinishScene then
		self:check_equip()
	elseif id1 == ClientProto.JoystickStartMove or 
		   id1 == ClientProto.MouseClick        or
		   id1 == ClientProto.PlayerSelAttack	then
		if self.useTreasureMap then
			print("set useTreasureMap nil    -- treasure 新操作 停止自动移动",self.useTreasureMap)
			self.useTreasureMap = nil
			Net:receive({id=ClientEnum.MAIN_UI_BTN.USE_TREASURE, visible=false}, ClientProto.ShowOrHideMainuiBtn)
		end
	elseif id1 == ClientProto.PlayerAutoMove  then
		local move_target = LuaItemManager:get_item_obejct("battle").move_target
		if self.useTreasureMap and self.treasure_map_target_pos and (not move_target or self.treasure_map_target_pos.map_id ~= move_target.map_id or self.treasure_map_target_pos.pos_x ~= move_target.x or self.treasure_map_target_pos.pos_y ~= move_target.y) then
			print("set useTreasureMap nil    -- treasure 新自动寻路 停止自动移动")
			self.useTreasureMap = nil
			Net:receive({id=ClientEnum.MAIN_UI_BTN.USE_TREASURE, visible=false}, ClientProto.ShowOrHideMainuiBtn)
		end
	end
end

function Bag:check_equip()
	-- if sid == ServerEnum.BAG_TYPE.EQUIP then -- 先获取了背包，然后是装备，然后是仓库，获取了装备就可以判断要不要弹出tips了
	for i=1,9 do
		local slot = ServerEnum.BAG_TYPE.EQUIP*10000+i
		if not self.items[slot] then
			local list = self:get_item_for_type(ServerEnum.BAG_TYPE.NORMAL,i,ServerEnum.ITEM_TYPE.EQUIP)

			if list[1] then
				local equip_data = list[1].data
				local game = LuaItemManager:get_item_obejct("game")
				print(equip_data.name,equip_data.level,equip_data.career)
				if equip_data.level<=game:getLevel() and (equip_data.career==0 or equip_data.career==game:get_career()) then
					-- gf_print_table(list[1],"ItemSysUseGuideView发现有部位"..slot.."没有穿装备".."自动穿")
					LuaItemManager:get_item_obejct("itemSys"):show_quick_use(list[1].item.guid)
					break
				end
			end
		end
	end
-- end
end

--使用藏宝图返回
function Bag:use_treasure_map_s2c(msg)
	gf_print_table(msg,"挖宝:使用藏宝图返回")
	local _ = msg.treasureMapInfo
	local map_id = _[1]
	local pos_x = _[2]
	local pos_y = _[3]
	self.treasure_map_target_pos = {map_id = map_id,pos_x = pos_x,pos_y = pos_y}
	LuaItemManager:get_item_obejct("battle"):move_to( map_id,pos_x,pos_y,function() self:on_treasure_map_move_end(map_id,pos_x,pos_y,msg.guid) end,0.45)
	self.assets[1]:hide()

	Net:receive({id=ClientEnum.MAIN_UI_BTN.USE_TREASURE, visible=true}, ClientProto.ShowOrHideMainuiBtn)
end

--挖宝寻路结束 判断是否到达挖宝地点
function Bag:on_treasure_map_move_end(map_id,pos_x,pos_y,map_guid)
	print("挖宝寻路结束 判断是否到达挖宝地点",map_id,pos_x,pos_y,map_guid)
	local my_pos = LuaItemManager:get_item_obejct("map"):get_player_pos()
	local dis = Vector2.Distance(Vector2(pos_x,pos_y)/10,Vector2(my_pos.x,my_pos.z))
	print("寻路结束",dis,Vector2(pos_x,pos_y)/10,Vector2(my_pos.x,my_pos.z))
	if dis > 0.45 then
		print("寻路结束如果在距离外，再次寻路")
		self.treasure_map_target_pos = {map_id = map_id,pos_x = pos_x,pos_y = pos_y}
		LuaItemManager:get_item_obejct("battle"):move_to( map_id,pos_x,pos_y,function()
			PLua.Delay(function() -- 延迟0.1秒再次寻路 避免死循环
				self:on_treasure_map_move_end(map_id,pos_x,pos_y,map_guid)
			end,1)
		end,0.1)
	else
		print("寻路结束如果在距离内，挖宝")
		self:can_dig_treasure_tips(map_guid)
	end
end

--挖宝结果返回
function Bag:dig_treasure_map_s2c(msg)
	gf_print_table(msg,"挖宝:挖宝结果返回")
	self:treasure_map_reward_handle(msg.err==0 and msg.eventCode or nil,msg.equipList,true)
end

-- 宝图怪物死后奖励推送
function Bag:treasure_map_monster_reward_s2c(msg)
	gf_print_table(msg,"挖宝:宝图怪物死后奖励推送")
	self:treasure_map_reward_handle(msg.eventCode,msg.equipList,not msg.eventCode)
end

-- 处理挖宝奖励
function Bag:treasure_map_reward_handle(eventCode,equipList,next_use)
	local next_use = next_use and true or false

    if eventCode then
    	local d = ConfigMgr:get_config( "treasure_map_event" )[eventCode]
		if d.event==ServerEnum.TREASURE_EVENT_TYPE.MONSTER then
			print("挖宝结果 -- 怪物出现")
			if next_use then
				next_use = false
				-- 开始自动挂机
				Net:receive(true, ClientProto.AutoAtk)
			else
				Net:receive(false, ClientProto.AutoAtk)
				if d.show == 1 then
					next_use = false
					print("挖宝结果 -- 弹出界面")
					local view = View("getTreasureMapReward",self)
    				view:set_data(equipList or d.code)
				else
					print("挖宝结果 -- 物品飘飞")
					for i,v in ipairs(d.param) do
						LuaItemManager:get_item_obejct("floatTextSys"):add_get_item(v[1],nil,equipList and equipList[i].color)
					end
				end
			end
		else
			if d.show == 1 then
				next_use = false
				print("挖宝结果 -- 弹出界面")
				local view = View("getTreasureMapReward",self)
    			view:set_data(equipList or d.code)
			else
				print("挖宝结果 -- 物品飘飞")
				for i,v in ipairs(d.param) do
					LuaItemManager:get_item_obejct("floatTextSys"):add_get_item(v[1],nil,equipList and equipList[i].color)
				end
			end
		end
    end

    if next_use then
	    print("-- 挖下一张宝图")
		self:next_treasure_map()
	end

	Net:receive({id=ClientEnum.MAIN_UI_BTN.USE_TREASURE, visible=false}, ClientProto.ShowOrHideMainuiBtn)
end

-- 挖下一张宝图
function Bag:next_treasure_map()
	if self.useTreasureMap then
		Net:receive(false, ClientProto.AutoAtk)
		local data = ConfigMgr:get_config("item")[self.useTreasureMap.protoId]
		print("上一次使用的宝图品质",data.color)
		local list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.TREASURE_MAP)
		for i,v in ipairs(list) do
			print(v.code,v.color)
			if v.color == data.color then
				local role_level = LuaItemManager:get_item_obejct("game"):getLevel()
				if role_level>=v.level then
					local item = self:get_item_for_protoId(v.code,ServerEnum.BAG_TYPE.NORMAL)
					print("是否有这个宝图 数量",item and item.num or 0)
					if item then
						self:use_item_c2s(item.guid,1,item.protoId)
						return
					end
				end
			end
		end
	end
end

--到达可挖宝地方 弹出挖宝中的图标
function Bag:can_dig_treasure_tips(guid)
	local battle = LuaItemManager:get_item_obejct("battle")
	local function cb()
		print("完成挖宝")
		self.on_dig_treasure_view = nil
		self:dig_treasure_map_c2s(guid,1)
		battle.character.animator:SetBool("collect", false)
		battle:remove_model_effect(battle.character.guid, ClientEnum.EFFECT_INDEX.COLLECT)
	end
	local function cb2()
		print("中断挖宝")
		self.on_dig_treasure_view = nil
		battle.character.animator:SetBool("collect", false)
		battle:remove_model_effect(battle.character.guid, ClientEnum.EFFECT_INDEX.COLLECT)
		if self.useTreasureMap then
			-- 停止寻宝
			print("set useTreasureMap nil    -- 中断挖宝")
			self.useTreasureMap = nil
		end
	end
	print("挖宝:到达挖宝地点，挖宝")
	local horse = LuaItemManager:get_item_obejct("horse")
	if horse:is_ride() then
		horse:send_to_ride_ex()
		return
	end
	Net:receive({id=ClientEnum.MAIN_UI_BTN.USE_TREASURE, visible=false}, ClientProto.ShowOrHideMainuiBtn)
	battle.character.animator:SetBool("collect", true)
	battle:add_model_effect(battle.character.guid, "41000140.u3d", ClientEnum.EFFECT_INDEX.COLLECT,function(ef) ef.transform.localEulerAngles = Vector3(0,0,0) end)

	local view = LuaItemManager:get_item_obejct("mainui"):collect_view()
	if view then
		self.on_dig_treasure_view = view
		self.on_dig_treasure_view:set_is_transmit()
		self.on_dig_treasure_view:set_time(5)
		self.on_dig_treasure_view:set_cancel(true)
		self.on_dig_treasure_view:set_name(gf_localize_string("挖宝中"))
		self.on_dig_treasure_view:set_finish_cb(cb)
		self.on_dig_treasure_view:set_cancel_cb(cb2)
	else
		self.on_dig_treasure_view = nil
		print("set useTreasureMap nil    -- 无法挖宝")
		self.useTreasureMap = nil
	end
end
--发送开始挖宝协议
function Bag:dig_treasure_map_c2s(guid)
	-- print("挖宝:发送开始挖宝协议")
	local msg={guid=guid}
	Net:send(msg,"bag","DigTreasureMap")
end

--解锁格子
function Bag:unlock_slot_s2s(msg)
	if(msg.err~=0)then
		-- gf_message_tips(Net:error_code(msg.err))
	else
		-- gf_message_tips("解锁成功")
		Sound:play(ClientEnum.SOUND_KEY.USE_PROP)
		 -- 技能、武将伙伴库、背包仓库等解锁时播放的音效
	end
end
--交换位置
function Bag:swap_item_s2c(msg)
	if(msg.err==0)then
		-- gf_message_tips("交换位置成功")
		gf_print_table(msg,"交换位置成功")

		--交换物品
		self.items[msg.srcSlot],self.items[msg.destSlot] = self.items[msg.destSlot],self.items[msg.srcSlot]
		if self.items[msg.srcSlot] then self.items[msg.srcSlot].slot = msg.srcSlot end
		if self.items[msg.destSlot] then self.items[msg.destSlot].slot = msg.destSlot end

		gf_print_table(self.items[msg.destSlot] or {},"目标物品"..msg.destSlot)
		gf_print_table(self.items[msg.srcSlot] or {},"源物品"..msg.srcSlot)


		local weapon_slot = ServerEnum.BAG_TYPE.EQUIP*10000+ServerEnum.EQUIP_TYPE.WEAPON
		local helmet_slot = ServerEnum.BAG_TYPE.EQUIP*10000+ServerEnum.EQUIP_TYPE.HELMET
		--判断是否装备变化
		if math.floor(msg.srcSlot/10000) == ServerEnum.BAG_TYPE.EQUIP or math.floor(msg.destSlot/10000) == ServerEnum.BAG_TYPE.EQUIP then
			--print("-- 更换装备时播放的音效")
			Sound:play(ClientEnum.SOUND_KEY.CHANGE_EQUIP)
		end
		if msg.srcSlot == weapon_slot or  msg.destSlot == weapon_slot then
			local msg = BagUserData:get_role_equip_mode()[1]
			print("--武器穿戴变化",msg)
			Net:receive(msg, ClientProto.ChangePlayerWeaponModle)-- 更换玩家武器模型
			self.need_change_mode = true
		end
		if msg.srcSlot == helmet_slot or  msg.destSlot == helmet_slot then
			local msg = BagUserData:get_role_equip_mode()[3]
			print("--衣服穿戴变化",msg)
			Net:receive(msg, ClientProto.ChangePlayerModle)-- 更换玩家模型
			self.need_change_mode = true
		end

		--飘字提示
		local item = self.items[msg.destSlot]
		if math.floor(msg.destSlot/10000) == Enum.BAG_TYPE.DEPOT then
			--存入仓库
			local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(item.protoId,true)
			local num = item.num
			gf_message_tips(string.format("存入%s*%d",name,num))

		elseif math.floor(msg.destSlot/10000) == Enum.BAG_TYPE.NORMAL and math.floor(msg.srcSlot/10000) == Enum.BAG_TYPE.DEPOT then
			--取出物品
			local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(item.protoId,true)
			local num = item.num
			gf_message_tips(string.format("取出%s*%d",name,num))

		end

	else
		-- gf_message_tips(Net:error_code(msg.err))
	end
	
	LuaItemManager:get_item_obejct("bag"):check_equip()
end
--使用物品
function Bag:use_item_s2c(msg)
	if(msg.err==0)then
		-- gf_message_tips("使用成功")
		local data = ConfigMgr:get_config("item")[msg.protoId]
		if data.type == Enum.ITEM_TYPE.PROP and data.sub_type == Enum.PROP_TYPE.IMMED_ADD_HP_ITEM then
			 -- 使用血瓶时播放的音效
			Sound:play(ClientEnum.SOUND_KEY.USE_PROP)
		end
	else
		-- gf_message_tips(Net:error_code(msg.err))
	end
end
--批量使用物品
function Bag:multi_use_item_s2c(msg)
	for i,v in ipairs(msg.errs) do
		if v~=0 then
			gf_message_tips(Net:error_code(v))
		end
	end
end
--拆分物品
function Bag:split_item_s2c(msg)
	if(msg.err==0)then
		gf_message_tips("拆分成功")
	else
		-- gf_message_tips(Net:error_code(msg.err))
	end
end
--出售物品
function Bag:sell_item_s2c(msg)
	if(msg.err==0)then
		-- gf_message_tips("出售成功")
	else
		-- gf_message_tips(Net:error_code(msg.err))
	end
end
--获取背包解锁下一格进度
function Bag:get_bag_unlock_fill()
	if not self.unlock[Enum.BAG_TYPE.NORMAL] or not self.unlock[Enum.BAG_TYPE.NORMAL].unlockTimeLeft then
		return 1
	end
	-- print("下一格解锁时间",self.unlock[Enum.BAG_TYPE.NORMAL].unlockTimeLeft)
	local t = self.unlock[Enum.BAG_TYPE.NORMAL].unlockTimeLeft - Net:get_server_time_s()
	-- print("距离下一格解锁还有",t)
	local slot = Enum.BAG_TYPE.NORMAL*10000+self:get_bagsize(Enum.BAG_TYPE.NORMAL)+1
	local data = ConfigMgr:get_config("bagUnlock")[slot]
	local all_need_t = data and data.time or 1
	-- print("总解锁时长",all_need_t)
	t = t>0 and t or 0
	-- print("解锁进度",t/all_need_t)
	return t/all_need_t
end

--设置背包大小 (背包类型，大小，下一格解锁剩余时间)
function Bag:set_bag_size(bagtype,size,unlockTimeLeft)
	self.unlock[bagtype]={size=size,unlockTimeLeft=unlockTimeLeft}
	local next_unlock_slot = bagtype*10000+size+1
	local item_data = ConfigMgr:get_config("bagUnlock")[next_unlock_slot]
	self.unlock[bagtype].unlockAllTime=item_data and item_data.time or 3153600000
	if not self.unlock[bagtype].unlockTimeLeft then --没有下一格解锁需要的时间，则读配置
		self.unlock[bagtype].unlockTimeLeft=self.unlock[bagtype].unlockAllTime
	end
	if bagtype == ClientEnum.BAG_TYPE.BAG then
		if self.unlock_next_timer then
			self.unlock_next_timer:stop()
			self.unlock_next_timer = nil
		end
		local func = function()
			if self.unlock_next_timer then
				self.unlock_next_timer:stop()
				self.unlock_next_timer = nil
			end
			self:set_have_red_point()
		end
		self.next_can_unlock_slot = next_unlock_slot
		self.unlock_next_timer = Schedule(func,self.unlock[bagtype].unlockTimeLeft)
		PLua.Delay(func, self.unlock[bagtype].unlockTimeLeft)
	end
	self.unlock[bagtype].unlockTimeLeft = self.unlock[bagtype].unlockTimeLeft + Net:get_server_time_s()
	self:set_have_red_point()
end	
--获取整个背包物品 --初始化的时候设置背包物品
function Bag:get_bag_s2c(msg)
	local bag_type = msg.type
	--更新背包大小
	if bag_type~=Enum.BAG_TYPE.EQUIP then
		self:set_bag_size(bag_type,msg.size,msg.unlockTimeLeft)
	end

	for i=1,self:get_bagsize(bag_type) do
		self.items[bag_type*10000+i] = nil
	end
	--更新物品列表
	if(msg.itemList)then --物品列表
		for k,v in pairs(msg.itemList or {}) do
			self:update_data(k,v)
		end
	end
	if(msg.equips) then --装备列表
		for k,v in pairs(msg.equips or {}) do
			self:update_data(k,v)
		end
	end
	if(msg.heroEquips) then --武将装备列表
		for k,v in pairs(msg.heroEquips or {}) do
			self:update_data(k,v)
		end
	end

end
--更新物品 color
function Bag:update_item_s2c(msg)
	-- gf_print_table(msg,"更新物品")
	local quick_use = nil
	if msg.itemList then
		for k,v in pairs(msg.itemList) do

			--获得物品通知
			if v.logT ~= Enum_ser.RES_LOG.SPLIT_ITEM then
				local old_num = self.items[v.slot] and self.items[v.slot].num or 0
				local new_num = v.num and v.num or 0
				local add_num = new_num - old_num
				if add_num~=0 then
					if add_num>0 then
						local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(v.protoId,true)
						gf_message_tips(string.format("获得%s*%d",name,add_num))
						 -- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
						Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS)
						if v.logT ~= Enum_ser.RES_LOG.CREATURE_DROP then
							 -- 怪物死亡掉落奖励时的音效
							Sound:play(ClientEnum.SOUND_KEY.DROP_ITEMS)
						end
						if BagUserData:get_item_use_guide(v.protoId) then
							quick_use = v.guid
						end
					else
						local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(self.items[v.slot].protoId,true)
						gf_message_tips(string.format("消耗%s*%d",name,-add_num))
					end
				end
			end

			self:update_data(k,v)

		end
	end
	if quick_use then
		LuaItemManager:get_item_obejct("itemSys"):show_quick_use(quick_use)
	end
end
--更新装备
function Bag:update_equip_s2c(msg,no_use)
	-- gf_print_table(msg,"更新人物装备")
	if msg.equipList then
		for k,v in pairs(msg.equipList) do

			local quick_use = false
			--获得物品通知
			local old_num = self.items[v.slot] and self.items[v.slot].num or 0
			local new_num = v.num and v.num or 0
			if old_num<new_num then
				local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_equip_name(v,true)
				gf_message_tips(string.format("获得%s",name))
				 -- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
				Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS)
				if v.logT ~= Enum_ser.RES_LOG.CREATURE_DROP then
					 -- 怪物死亡掉落奖励时的音效
					Sound:play(ClientEnum.SOUND_KEY.DROP_ITEMS)
				end

				if not no_use then
					-- 装备等级需要<=自身人物等级 职业必须符合
					local equip_data = ConfigMgr:get_config("item")[v.protoId]
					local game = LuaItemManager:get_item_obejct("game")
					if equip_data.level<=game:getLevel() and (equip_data.career==0 or equip_data.career==game:get_career()) then
						--判断获得的装备是否比身上的装备战力高好 如果是，弹出快速使用指引
						local bodySlot = Enum.BAG_TYPE.EQUIP*10000+equip_data.sub_type
						-- print("判断是否有穿此类装备",bodySlot,self.items[bodySlot])
						if not self.items[bodySlot] then 
							--弹出快速使用指引
							-- print("没穿，直接弹出快速使用")
							quick_use = true
						else
							local equip = LuaItemManager:get_item_obejct("equip")
							if equip:calculate_equip_fighting_capacity(self.items[bodySlot]) < equip:calculate_equip_fighting_capacity(v) then
								quick_use = true
							end
						end
					end
				end

			elseif old_num>new_num then
				local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_equip_name(self.items[v.slot],true)
				gf_message_tips(string.format("消耗%s",name))
			end

			self:update_data(k,v)

			if quick_use then
				LuaItemManager:get_item_obejct("itemSys"):show_quick_use(v.guid)
			end
		end
	end
end
--更新武将装备
function Bag:update_hero_equip_s2c(msg)
	-- gf_print_table(msg,"更新武将装备")
	if msg.heroEquipList then
		for k,v in pairs(msg.heroEquipList) do

			--获得武将装备通知
			gf_message_tips("更新武将装备")
			local old_num = self.items[v.slot] and self.items[v.slot].num or 0
			local new_num = v.num and v.num or 0
			if old_num<new_num then
				local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(v.protoId,true)
				gf_message_tips(string.format("获得%s",name))
				 -- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
				Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS)
				if v.logT ~= Enum_ser.RES_LOG.CREATURE_DROP then
					 -- 怪物死亡掉落奖励时的音效
					Sound:play(ClientEnum.SOUND_KEY.DROP_ITEMS)
				end
			elseif old_num>new_num then
				local name = LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(self.items[v.slot].protoId,true)
				gf_message_tips(string.format("消耗%s",name))
			end

			self:update_data(k,v)
		end
	end
end
--更新背包	整理或者合并时 会更新整个背包
function Bag:update_bag_s2c(msg)
	for i=1,self:get_bagsize(msg.type) do
		self.items[msg.type*10000+i] = nil
	end

	--更新物品列表
	if(msg.itemList)then --物品列表
		for k,v in pairs(msg.itemList or {}) do
			self:update_data(k,v)
		end
	end
	if(msg.equips) then --装备列表
		for k,v in pairs(msg.equips or {}) do
			self:update_data(k,v)
		end
	end
	if(msg.heroEquips) then --武将装备列表
		for k,v in pairs(msg.heroEquips or {}) do
			self:update_data(k,v)
		end
	end
end
--更新数据
function Bag:update_data(key,value)
	if value.num==0 and self.items[value.slot] then
		self.items[value.slot]=nil
	else

		self.items[value.slot]=value
	end
end

--申请获取背包物品列表 枚举表BAG_TYPE
function Bag:get_bag_item_list_c2s(type, sid)
	local msg={type = type}
	Net:send(msg,"bag","GetBagInfo",sid)
end
--整理
function Bag:sort_item_c2s(type)
	local msg={type=type}
	-- print("整理背包",type)
	Net:send(msg,"bag","SortItem")
end
--合并
function Bag:merge_item_c2s(type)
	local msg={type=type}
	-- print("合并背包",type)
	Net:send(msg,"bag","MergeItem")
end
--交换位置
function Bag:swap_item_c2s(src_slot,dest_slot)
	if self.items[src_slot] then
		local msg={srcSlot=src_slot,destSlot=dest_slot}
		Net:send(msg,"bag","SwapItem")
		gf_print_table(msg,"发送交换位置协议")
	end
end
--使用物品
function Bag:use_item_c2s(guid,num,code)
	print("使用物品",guid,num,code)
	if num ~= 0 then
		local msg={guid=guid,num=num}
		if not BagUserData:get_item_lock(code) or not LuaItemManager:get_item_obejct("setting"):is_lock() then
			Net:send(msg,"bag","UseItem")

			if code then
				local data = ConfigMgr:get_config("item")[code]
				print("使用物品类型,",data.type,data.sub_type)
				if data.type == ServerEnum.ITEM_TYPE.PROP and data.sub_type == ServerEnum.PROP_TYPE.TREASURE_MAP then
					print("set useTreasureMap -- 记录使用的藏宝图")
					self.useTreasureMap = {guid = guid,protoId = code}
				end
			end
		end
	end
end
--批量使用物品
function Bag:multi_use_item_c2s(guid_list,num_list)
	if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		local msg={guid=guid_list,num=num_list}
		Net:send(msg,"bag","MultiUseItem")
	end
end
--解锁格子
function Bag:unlock_slot_c2s(msg)
	-- gf_print_table(msg,"开启格子")
	Net:send(msg,"bag","UnlockSlot")
end
--拆分物品
function Bag:split_item_c2s(guid,num)
	if num ~= 0 then
		Net:send({guid=guid,num=num},"bag","SplitItem")
	else
		gf_message_tips("无法拆分0个物品")
	end
end
--出售物品
function Bag:sell_item_c2s(guid,num)
	if num ~= 0 then
		Net:send({guid=guid,num=num},"bag","SellItem")
	else
		gf_message_tips("无法拆分0个物品")
	end
end

--熔炼物品
function Bag:smelt_item_c2s(smeltId,num,protoId)
	-- print("向服务器发出熔炼协议") 熔炼合成
	num = num or 1
	protoId = protoId or 0
	local msg = {smeltId=smeltId,num=num,protoId=protoId}
	-- gf_print_table(msg,"向服务器发出熔炼协议")
	if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		Net:send(msg,"bag","SmeltItem")
	end
	-- print("向服务器发出熔炼协议完成")
end

--获取是否只显示能打造的
function Bag:get_only_show_can_c2s()
	-- print("发送协议，请求获取是否只显示能打造的")
	Net:send({},"bag","GetOnlyShowCan")
end

--设置是否只显示能打造的
function Bag:set_only_show_can(bOnlyShowCan)
	Net:send({bOnlyShowCan=bOnlyShowCan},"bag","SetOnlyShowCan")
end

--快捷
function Bag:set_immed_add_hp_item_c2s(protoId)
	-- print("发送协议，设置快键补血药物品")
	Net:send({protoId=protoId},"base","SetImmedAddHPItem")
end

-- 打开一键使用
function Bag:open_one_key_use(hide_obj,open)
	-- print("打开一键使用")
	open = open==nil and true or open
	if open then
		self.OneKeyUseHideObj = hide_obj
		self.OneKeyUseObj = View("oneKeyUse",self)
	elseif self.OneKeyUseObj then
		self.OneKeyUseObj:dispose()
	end
end

function Bag:recycle_equip_c2s(guidArr)
	Net:send({guidArr=guidArr},"bag","RecycleEquip")
end

function Bag:set_open_mode(value)
	self.open_mode = value
end