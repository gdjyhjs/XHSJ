--[[--
-- 变强
-- @Author:Seven
-- @DateTime:2017-11-02 11:10:47
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local BagUserData = require("models.bag.bagUserData")

local Strengthen = LuaItemManager:get_item_obejct("strengthen")
--UI资源
Strengthen.assets=
{
    View("strengthenView", Strengthen) 
}
Strengthen.priority = ClientEnum.PRIORITY.MAIN_UI
Strengthen.event_name = "strengthen_view_on_click"

--点击事件
function Strengthen:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

--初始化函数只会调用一次
function Strengthen:initialize()
	print("变强初始化")
	self.urgent_time = 1
	self.lax_time = 10
	self.now_update_time = self.urgent_time
	local data = ConfigMgr:get_config("strengthen") --读配置表
	self.data = {}
	for k,v in pairs(data) do
		self.data[#self.data+1] = v
	end
	table.sort( self.data, function(a,b) return a.id<b.id end)

	self.btn_list = {}
	self.receive_change = 1
end

function Strengthen:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.FinishScene and not self.update_timer then -- 进入场景，刷新主ui
		self.update_timer = Schedule( handler(self, self.update),self.now_update_time)
	end
	if id1<1000000 then
		self.receive_change = 1
	end
end

-- 释放资源
function Strengthen:dispose()
    if self.update_timer then
    	self.update_timer:stop()
    	self.update_timer = nil
    end
end

function Strengthen:update()
	if self.receive_change == 1 then
		self.receive_change = 0
	else
		return
	end
	-- print("变强检测",UnityEngine.Time.time)
	local visible = self:get_btn_show()
	if visible and self.now_update_time==self.lax_time then
		self.now_update_time=self.urgent_time
		self.update_timer:reset_time(self.now_update_time)
	elseif not visible and self.now_update_time==self.urgent_time then
		self.now_update_time=self.lax_time
		self.update_timer:reset_time(self.now_update_time)
	end
	-- 通知按钮显影
	self.change = true
	self:judge_show()
	Net:receive({id=ClientEnum.MAIN_UI_BTN.STRENGTHEN, visible=visible}, ClientProto.ShowOrHideMainuiBtn)
end

-- 判断条件 检查是否选择按钮 并且刷新按钮列表
function Strengthen:judge_show()
	local show_list = {}
	local hide_list = {}
	for k,v in pairs(self.data) do
		if self:judge_item(k) then -- 查找如果无按钮则添加啊都合适的位置
			local i,data = self:get_btn_for_list(k)
			if not data then
				local d = self.data[k]
				local key = d.moduel..(d.parameter[1] or 0)..(d.parameter[2] or 0)..(d.parameter[3] or 0)..(d.parameter[4] or 0)
				data = {id = k,key = key}
				self:insert_btn(data)
				-- 通知出现红点
				Net:receive({show=true,module=v.moduel,a=v.parameter[1],b=v.parameter[2],c=v.parameter[3],d=v.parameter[4]}, ClientProto.UIRedPoint)
			end
			show_list[data.key] = k
		else -- 记录删除按钮
			local i,data = self:get_btn_for_list(k)
			if data then
				hide_list[data.key] = k
			end
		end
	end
	for k,id in pairs(hide_list) do
		if not show_list[k] then
			local i,data = self:get_btn_for_list(id)
			if i then
				table.remove(self.btn_list,i)
				-- 通知删除红点
				local v = self.data[data.id]
				Net:receive({show=false,module=v.moduel,a=v.parameter[1],b=v.parameter[2],c=v.parameter[3],d=v.parameter[4]}, ClientProto.UIRedPoint)
			end
		end
	end
end

-- 判断条件 检查某一条id是否符合条件
function Strengthen:judge_item(id)
	local game = LuaItemManager:get_item_obejct("game")
	local bag = LuaItemManager:get_item_obejct("bag")
	local d = self.data[id]
	-- -- 等级
	if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then -- 首战
		return false
	end
	-- 属性
	for i,v in ipairs(d.need_attr or {}) do
		local attr = v[1]
		local num = v[2]
		local compare = v[3]
		local have = gf_get_module_attr(attr,v[4],v[5],v[6]) or 0
		-- local debg_show = false
		-- debg_show = d.id>104061 and d.id<104090
		-- if debg_show then
			-- print(d.id.."变强判断"..d.name.."属性",attr,"拥有",have,"要求",compare==0 and "等于" or (compare==-1 and "小于") or ((not compare or compare==1) and "大于"),num,
				-- (((not compare or compare==1) and num>=have) or (compare==0 and num~=have) or (compare==-1 and num<=have)) and "驳回" or "通过")
		-- end
		if ((not compare or compare==1) and num>=have) or (compare==0 and num~=have) or (compare==-1 and num<=have) then
			-- if debg_show then
				-- print("判断按钮",d.id,d.name,"属性不符\n属性",attr,"拥有",have,"要求",compare==0 and "等于" or (compare==-1 and "小于") or (compare==1 and "大于"),num)
			-- end
			return false
		end
		-- if debg_show then
			-- print(d.id,d.name,"判断通过\n属性",attr,"拥有",have,"要求",compare==0 and "等于" or (compare==-1 and "小于") or (compare==1 and "大于"),num)
		-- end
	end
	-- 物品
	for i,v in ipairs(d.need_item or {}) do
		local itemId = v[1]
		local num = v[2]
		local compare = v[3]
		local have = 0
		if itemId<ServerEnum.BASE_RES.END then
			have = game:get_money(itemId) or 0
		else
			have = bag:get_item_count(itemId,ServerEnum.BAG_TYPE.NORMAL) or 0
		end
		if ((not compare or compare==1) and num>=have) or (compare==0 and num~=have) or (compare==-1 and num<=have) then
			-- print("判断按钮",id,d.name,"资源或物品不符\n物品id",itemId,"数量",num,"拥有",have,"要求",compare==0 and "等于" or (compare==-1 and "小于") or (compare==1 and "大于"))
			return false
		end
		-- print(id,d.name,"判断通过\n物品id",itemId,"数量",num,"拥有",have,"要求",compare==0 and "等于" or (compare==-1 and "小于") or (compare==1 and "大于"))
	end

	if not d.need_attr or not d.need_item and not self:need_other(d.moduel,d.parameter[1],d.parameter[2],d.parameter[3],d.parameter[4]) then
		return false
	end

	-- print("判断按钮",id,d.name,true)
	return true
end

-- 从按钮列表尝试取出一个按钮
function Strengthen:get_btn_for_list(id)
	local d = self.data[id]
	local key = d.moduel..(d.parameter[1] or 0)..(d.parameter[2] or 0)..(d.parameter[3] or 0)..(d.parameter[4] or 0)
	for i,v in ipairs(self.btn_list) do -- 查找如果有按钮则删除
		if key == v.key then
			return i,v
		end
	end
end

-- 将某一个按钮插入按钮列表合适的位置
function Strengthen:insert_btn(data)
	local d = self.data[data.id]
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.STRENGTHEN, visible=true}, ClientProto.ShowAwardEffect)
	for i,v in ipairs(self.btn_list) do
		if d.order >= self.data[v.id].order then
			-- print(data,"将按钮插入",i)
			table.insert(self.btn_list,data)
			return
		end
	end
	self.btn_list[#self.btn_list+1] = data
end

-- 特殊条件判断
function Strengthen:need_other(module_type,...) -- 特殊条件判断
	local a,b,c,d = ...
	-- print("特殊条件判断",module_type,a or 0,b or 0,c or 0,d or 0)
	if module_type == ClientEnum.MODULE_TYPE.EQUIP and a==2 then
		-- print(" 装备打造")
		--[[ 装备打造
		身上装备低于当前可打造的最高等级装备
		拥有材料足够打造当前等级的装备

		或者

		身上装备等级等于当前可打造的最高等级
		身上装备品质低于该等级保底材料品质
		拥有该等级的保底材料
		]]
		local sub_type = c
		local EquipUserData = require("models.equip.equipUserData")
		local bag = LuaItemManager:get_item_obejct("bag")
		local my_equip = bag:get_bag_item()[ServerEnum.BAG_TYPE.EQUIP*10000+sub_type]
		local need_formula = not my_equip
		-- print("是否有装备",not need_formula)
		if my_equip then
			local my_equip_level = ConfigMgr:get_config("item")[my_equip.protoId].level
			local formula_max_level = EquipUserData:get_formula_equip_dropdown_value(EquipUserData:get_def_value())
			-- print("身上装备等级和可打造最大等级",my_equip_level,formula_max_level)
			if my_equip_level < formula_max_level then
				need_formula = true
			elseif my_equip_level == formula_max_level then
				local list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.FORMULA_EQUIP_BASE_COLOR)
				table.sort(list,function(a,b) return a.item_level>b.item_level end)
				local color_prop = (function(list) 
						for i,v in ipairs(list) do
							if v.item_level <= my_equip_level then
								for i,sub_type in ipairs(v.effect_ex) do
									if sub_type==sub_type then
										return v
									end
								end
							end
						end

					end)(list)
				-- print(b,"装备品质和保底品质",my_equip.color , color_prop.effect[1])
				if my_equip.color < color_prop.effect[1] then
					local count = bag:get_item_count(color_prop.code,ServerEnum.BAG_TYPE.NORMAL)
					need_formula = count>0
				end
			end
		end
		if need_formula then
			local formula_max_level = EquipUserData:get_formula_equip_dropdown_value(EquipUserData:get_def_value())
			-- print("打造的等级和类型",formula_max_level,sub_type)
			if formula_max_level<0 then
				return false
			end
			local formula_data = EquipUserData:get_formula_equip_list(formula_max_level)[sub_type]
			for i,v in ipairs(formula_data.need_item) do -- 判断材料够不够
				local need_count = v[2]
				local have_count = bag:get_item_count(v[1],ServerEnum.BAG_TYPE.NORMAL)
				if have_count < need_count then
					return false
				end
			end
			if LuaItemManager:get_item_obejct("game"):get_money(formula_data.need_money[1])<formula_data.need_money[2] then  -- 判断金钱够不够
				return false
			end
			return true
		end

	elseif module_type == ClientEnum.MODULE_TYPE.EQUIP and a==3 then
		local sub_type = b
		local Bag = LuaItemManager:get_item_obejct("bag")
		local equip = Bag:get_bag_item()[10000*ServerEnum.BAG_TYPE.EQUIP+sub_type]
		-- print("判断宝石相关 有没有装备",10000*ServerEnum.BAG_TYPE.EQUIP+sub_type,equip)
		if equip then
			local Equip = LuaItemManager:get_item_obejct("equip")
			local gem_info = Equip:get_gem_info()[sub_type] or {}
			if c == 1 then
				-- print("宝石镶嵌")
				-- 符合一下条件
				-- 有未镶嵌宝石的可用的孔，玩家背包里面有可以镶嵌的宝石 
				for i,v in ipairs(gem_info) do
					if v==0 and not Equip:get_gem_lock_str(equip,i) then -- 有未镶嵌宝石的可用的孔
						local type_list = ConfigMgr:get_config("equip_gem_suit")[sub_type].gem_type -- 可镶嵌的类型列表
						for i,gem_type in ipairs(type_list) do
							for i,v in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.GEM,gem_type)) do
								local gemId = v.code
								local count = Bag:get_item_count(gemId,ServerEnum.BAG_TYPE.NORMAL) -- 玩家背包里面有可以镶嵌的宝石 
								-- print("判断拥有多少宝石",v.code,count)
								if count>0 then
									-- print("有可镶嵌宝石",gemId)
									return true
								end
							end
						end
					end
				end
				-- print("没有可以镶嵌的宝石")
			elseif c == 2 then
				-- print("宝石升级")
				-- 符合以下条件之一
				-- · 有已镶嵌宝石，宝石可升级
				-- · 有已镶嵌宝石,玩家背包宝石等级大于玩家已穿戴装备宝石等级
				for i,gemId in ipairs(gem_info) do
					if gemId~=0 then -- 有已镶嵌宝石
						local gem_data = ConfigMgr:get_config("item")[gemId]
						if gem_data.item_level<10 then  -- 宝石可升级
							local useId,needCount = Equip:get_level_up_gem(gemId)
							if needCount>1 then
								-- print("有可升级宝石",useId)
								return true
							end
						end


						local type_list = ConfigMgr:get_config("equip_gem_suit")[sub_type].gem_type -- 可镶嵌的类型列表
						for i,gem_type in ipairs(type_list) do
							for i,v in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.GEM,gem_type)) do
								if v.item_level > gem_data.item_level then
									local count = Bag:get_item_count(v.code,ServerEnum.BAG_TYPE.NORMAL)
									if count>0 then
										-- print("有更高级宝石",v.code)
										return true
									end
								end
							end
						end


					end
				end
				-- print("没有可以升级的宝石")
			end
		end

	elseif module_type == ClientEnum.MODULE_TYPE.HERO and a==1 and b==3 and d then
		-- print(" 武将觉醒")
		--[[ 武将觉醒
		有武将可以觉醒
		]]
		local hero = LuaItemManager:get_item_obejct("hero")

	-- print("武将觉醒判断",module_type,a or 0,b or 0,c or 0,d or 0,hero:get_hero_is_awaken(d))
		return hero:get_hero_is_awaken(d)

	elseif module_type == ClientEnum.MODULE_TYPE.HERO and a==1 and b==6 then
		-- print(" 武将升级")
		--[[ 武将升级
		背包武将经验道具足够当前出战武将升级
		]]
		local hero = LuaItemManager:get_item_obejct("hero")
		local hero_info = hero:get_fight_hero_info()
		return hero:get_hero_can_level_up(hero_info)

	elseif module_type == ClientEnum.MODULE_TYPE.HORSE and a==1 then
		-- print(" 坐骑进阶")
		--[[ 坐骑进阶
		当前坐骑进阶道具足够升级到下一级
		]]
		return LuaItemManager:get_item_obejct("horse"):get_prop_enough_level_up()

	elseif module_type == ClientEnum.MODULE_TYPE.LEGION and a==2 then
		-- print(" 军团修炼")
		--[[ 军团修炼
		在军团 且 当前基础资源能够升到下一级，就给提示
		]]
		if not LuaItemManager:get_item_obejct("legion"):is_in() then
			-- print("没有军团")
			return false
		end
        local train = LuaItemManager:get_item_obejct("train")
        return train:get_can_level_up(c)
	elseif module_type == ClientEnum.MODULE_TYPE.PLAYER_INFO and a==3 then
		-- print("-- 天命特殊处理",c)
		-- 1	当玩家解锁新的天命镶嵌孔,并且还没镶嵌时
		-- 2	当玩家的精粹大于当前升级需要的精粹数量时
		local Destiny = LuaItemManager:get_item_obejct("destiny")
		local d = Destiny:get_destiny_on_body(c)
		if not d then
			-- print("没有镶嵌天命")
			return true
		else
			-- gf_print_table(d,"天命信息")
			local data = ConfigMgr:get_config("destiny_level")[d.destinyId]
			local res = LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.SPIRIT)
			if res>=data.exp then
				local next_data = ConfigMgr:get_config("destiny_level")[d.destinyId+1]
				if next_data and (data.level+1) == next_data.level then
					return true
				end
			end
		end
	end
end

-- 设置按钮显示.
function Strengthen:get_btn_show()
	return #self.btn_list>0
end