--[[--
--天命
-- @Author:HuangJunShan
-- @DateTime:2017-08-02 12:10:28
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")

local Destiny = LuaItemManager:get_item_obejct("destiny")
Destiny.priority = ClientEnum.PRIORITY.LOADING_MASK
--UI资源
Destiny.assets=
{
    View("destinyView", Destiny) 
}
Destiny.event_name = "destiny_view_on_click"

--点击事件
function Destiny:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

--初始化函数只会调用一次
function Destiny:initialize()
	self.destinyCanDraw = 1
	self.items = {}
end

--获取某个抽奖按钮是否激活
function Destiny:get_btn_active(index)
	local pos = bit._rshift(0x80000000,32-index)
	return bit._and(self.destinyCanDraw,pos)==pos
end

--获取天命列表 -- 获取天命列表（背包类型，是否倒序）
function Destiny:get_items(type,isInverted)
	local t = {}
	for k,v in pairs(self.items[type] or {}) do
		t[#t+1] = v
	end
	local data = ConfigMgr:get_config( "destiny_level" )
	table.sort( t, function(a_d,b_d)
			local a = data[a_d.destinyId]
			local b = data[b_d.destinyId]
			if a.type == 0 and b.type~=0 then
				return false
			elseif a.type ~= 0 and b.type==0 then
				return true
			elseif a.color~=b.color then
				if isInverted then
					return a.color<b.color
				else
					return a.color>b.color
				end
			elseif a.type~=b.type then
				if isInverted then
					return a.type<b.type
				else
					return a.type>b.type
				end
			else
				return false
			end
	 	end)
	return t
end

--清空天命列表
function Destiny:clear_items(type)
	self.items[type] = {}
end

--获取天命（天命唯一id，背包类型）
function Destiny:get_destiny(duid,btype)
	if btype then
		for i,v in pairs(self.items[btype] or {}) do
			if v.duid == duid then
				return v
			end
		end
	else
		for k,list in pairs(self.items or {}) do
			for i,v in pairs(list) do
				if v.duid == duid then
					return v
				end
			end
		end
	end
end

--获取身上的天命（位置）
function Destiny:get_destiny_on_body(slot)
	for k,v in pairs(self.items[Enum.DESTINY_CONTIANER_TYPE.BODY] or {}) do
		if v.slot == slot then
			return v
		end
	end
end

--删除天命（天命唯一id，背包类型）
function Destiny:del_destiny(duid,btype)
	if btype then
		for i,v in pairs(self.items[btype] or {}) do
			if v.duid == duid then
				table.remove(self.items[btype],i)
				return
			end
		end
	else
		for k,list in pairs(self.items or {}) do
			for i,v in pairs(list) do
				if v.duid == duid then
					table.remove(self.items[k],i)
					return
				end
			end
		end
	end
end

--添加天命（背包类型，天命）
function Destiny:add_destiny(type,destiny)
	if not self.items[type] then
		self.items[type] = {}
	end
	self.items[type][#self.items[type]+1] = destiny
end

--初始获取所有天命列表
function Destiny:get_all_destiny_for_sever()
	self:get_destiny_can_draw_c2s()
	for k,v in pairs(Enum.DESTINY_CONTIANER_TYPE) do
		self.items[v] = {}
		self:get_destiny_voarr_c2s(v)
	end
end

function Destiny:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("bag"))then
		if id2== Net:get_id2("bag", "GetDestinyVOArrR") then
			print(msg)
			gf_print_table(msg,"接收协议：获取天命背包列表")
			gf_print_table(msg,"wtf receive GetDestinyVOArrR")
			self:get_destiny_s2c(msg)
		elseif id2== Net:get_id2("bag", "GetDestinyCanDrawR") then
			print(msg)
			gf_print_table(msg,"接收协议：获取当前可抽的天命目录")
			self:get_destiny_can_draw_s2c(msg)
		elseif id2== Net:get_id2("bag", "GainDestinyR") then
			print(msg)
			gf_print_table(msg,"接收协议：获得天命推送")
			self:gain_destiny_s2c(msg)
		elseif id2== Net:get_id2("bag", "SetDestinyToSlotR") then
			print(msg)
			gf_print_table(msg,"接收协议：将某个天命装到身上的某个槽上")
			self:set_destiny_to_slot_s2c(msg)
		elseif id2== Net:get_id2("bag", "DrawDestinyR") then
			print(msg)
			gf_print_table(msg,"接收协议：元宝抽取天命")
			self:draw_destiny_s2c(msg)
		elseif id2== Net:get_id2("bag", "DrawDestinyCoinR") then
			print(msg)
			gf_print_table(msg,"接收协议：铜钱抽取天命")
			self:draw_destiny_coin_s2c(msg)
		elseif id2== Net:get_id2("bag", "ResolveDestinyR") then
			print(msg)
			gf_print_table(msg,"接收协议：分解天命")
			self:resolve_destiny_s2c(msg)
		elseif id2== Net:get_id2("bag", "UplevelDestinyR") then
			print(msg)
			gf_print_table(msg,"接收协议：升级天命")
			self:upgrade_destiny_s2c(msg)
		end
	end
end
--获取当前可抽的天命目录
function Destiny:get_destiny_can_draw_s2c(msg)
	self.destinyCanDraw = msg.destinyCanDraw or self.destinyCanDraw
end
--获得天命
function Destiny:gain_destiny_s2c(msg)
	for i,v in pairs(msg.destinyDrawInfoArr) do
		self:add_destiny(Enum.DESTINY_CONTIANER_TYPE.BAG,v)
	end
end
--将某个天命装到身上的某个槽上 type
function Destiny:set_destiny_to_slot_s2c(msg)
	if msg.err == 0 then
		--如果身上有，脱下
		local on_body_destiny = self:get_destiny_on_body(msg.slot)
		if on_body_destiny then
			on_body_destiny.slot = nil
			self:del_destiny(on_body_destiny.duid)
			self:add_destiny(Enum.DESTINY_CONTIANER_TYPE.BAG,on_body_destiny)
		end
		--如果guid不等于0，穿戴
		if msg.duid ~= 0 then
			local d = self:get_destiny(msg.duid)
			d.slot = msg.slot
			self:del_destiny(d.duid)
			self:add_destiny(Enum.DESTINY_CONTIANER_TYPE.BODY,d)
		end
	end
end
--元宝抽取天命
function Destiny:draw_destiny_s2c(msg)
	if msg.err == 0 then
		for i,v in pairs(msg.destinyDrawInfoArr) do
			self:add_destiny(Enum.DESTINY_CONTIANER_TYPE.BAG,v)
		end
	end
end
--铜钱抽取天命
function Destiny:draw_destiny_coin_s2c(msg)
	for i,v in pairs(msg.destinyDrawResultArr) do
		if v.err == 0 then
			self:add_destiny(Enum.DESTINY_CONTIANER_TYPE.BAG,v.destinyDrawInfo)
			self.destinyCanDraw = v.newDrawIndex
		end
	end
end
--获取天命背包列表
function Destiny:get_destiny_s2c(msg)
	self.items[msg.type] = msg.destinyVOArr
end
--分解
function Destiny:resolve_destiny_s2c(msg)
	for i,v in ipairs(msg.successDuid) do
		self:del_destiny(v)
	end
end
--升级
function Destiny:upgrade_destiny_s2c(msg)
	if msg.err == 0 then
		local d = self:get_destiny(msg.duid,ServerEnum.DESTINY_CONTIANER_TYPE.BODY)
		if d then
			d.destinyId = msg.destinyId
		end
	end
end

------------------------------------------------------------------------------------------

--将某个天命装到身上的某个槽上 duid=0 为脱下
function Destiny:set_destiny_to_slot_c2s(duid,slot)
	local msg = {duid=duid,slot=slot}
	gf_print_table(msg,"发送协议：将某个天命装到身上的某个槽上")
	Net:send(msg,"bag","SetDestinyToSlot")
end
--元宝抽取天命
function Destiny:draw_destiny_c2s(countType)
	local msg = {countType=countType}
	gf_print_table(msg,"发送协议：元宝抽取天命")
	Net:send(msg,"bag","DrawDestiny")
end
--铜钱抽取天命
function Destiny:draw_destiny_coin_c2s(countType,drawIndex)
	local msg = {countType=countType,drawIndex=drawIndex}
	gf_print_table(msg,"发送协议：抽取天命")
	Net:send(msg,"bag","DrawDestinyCoin")
end
--获取天命背包列表
function Destiny:get_destiny_voarr_c2s(type)
	local msg = {type=type}
	gf_print_table(msg,"发送协议：获取天命背包列表")
	Net:send(msg,"bag","GetDestinyVOArr")
end
--拾取
function Destiny:destiny_draw_to_bag_c2s(duid)
	local msg = {duid=duid}
	gf_print_table(msg,"发送协议：拾取")
	Net:send(msg,"bag","DestinyDrawToBag")
end
--获取当前可抽的天命目录
function Destiny:get_destiny_can_draw_c2s(duid)
	local msg = {}
	gf_print_table(msg,"发送协议：获取当前可抽的天命目录")
	Net:send(msg,"bag","GetDestinyCanDraw")
end
--分解
function Destiny:resolve_destiny_c2s(resolveDuidArr)
	local msg = {resolveDuidArr=resolveDuidArr}
	gf_print_table(msg,"发送协议：分解")
	Net:send(msg,"bag","ResolveDestiny")
end
--升级
function Destiny:upgrade_destiny_c2s(slot)
	local msg = {slot=slot}
	gf_print_table(msg,"发送协议：升级")
	Net:send(msg,"bag","UplevelDestiny")
end

--------------------View
-- 记录当前选择的用来显示tips或者用来吞噬等功能的天命的duid
Destiny.tips_duid = nil

-- data
function Destiny:get_need_money(money_type,pool_param)
	if not self.destiny_need_money then
		self.destiny_need_money = {}
		for k,v in pairs(ConfigMgr:get_config( "destiny_need_money" )) do
			if not self.destiny_need_money[v.money_type] then
				self.destiny_need_money[v.money_type] = {}
			end
			if not self.destiny_need_money[v.money_type][v.pool_param] then
				self.destiny_need_money[v.money_type][v.pool_param] = v
			end
		end
	end
	return self.destiny_need_money[money_type] and self.destiny_need_money[money_type][pool_param] or {}
end