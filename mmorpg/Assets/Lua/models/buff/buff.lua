--[[--
--buff数据类
-- @Author:Seven
-- @DateTime:2017-09-05 14:49:44
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Buff = LuaItemManager:get_item_obejct("buff")


--点击事件
function Buff:on_click(obj,arg)
end

--每次显示时候调用
function Buff:on_showed( ... )

end

--初始化函数只会调用一次
function Buff:initialize()
	print("初始化更新buff1")
	self.buff_data = {}
end

function Buff:get_buff_tb(r_id)
	return self.buff_data[r_id]
end

function Buff:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "BuffUpdateR") then
			gf_print_table(msg,"buff1")
			self:buff_update_s2c(msg.buff)
		end
	end
end
function Buff:get_buff_data()
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	return self.buff_data[r_id] or {}
end
--更新buff
function Buff:buff_update_s2c(msg)
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	if msg.ownerId == r_id then
		if not self.buff_data[r_id] then
			self.buff_data[r_id] = {}
			print("buff1r_id",r_id)
		end
		if msg.updateType == ServerEnum.BUFF_UPDATE_TYPE.CREATE then
			print("buff1创建",msg.buffId)
			self:buff_add(r_id,msg)
		elseif msg.updateType == ServerEnum.BUFF_UPDATE_TYPE.UPDATE then
			print("buff1更新",msg.buffId,msg.cumulateEffect)
			self:buff_update(r_id,msg)
		elseif msg.updateType == ServerEnum.BUFF_UPDATE_TYPE.REMOVE then
			print("buff1移除",msg.buffId)
			self:buff_remove(r_id,msg)
		end
		self:update_main_buff(self.buff_data[r_id])
	end
end
--添加buff
function Buff:buff_add(r_id,msg)
	local b_id = msg.buffId
	local data = copy(ConfigMgr:get_config("buff"))
	local tb = self.buff_data[r_id]
	if #tb ~= 0 then
		local index = 0
		for k,v in pairs(tb) do
			if v.type == data[b_id].type then
				index = k
				break
			end
		end
		if index > 0 then
			table.remove(tb,index)
		end
		local t = #tb+1
		tb[t] = copy(data[b_id])
		if msg.expireTime then
			tb[t].expireTime = tonumber(msg.expireTime)
		end
		if msg.duration then
			tb[t].cur_duration = msg.duration
		end
		if msg.cumulateEffect then
			tb[t].cumulateEffect = msg.cumulateEffect
		end
			self:check_buff_show(tb[t])
	else
		tb[1] = copy(data[b_id])
		if msg.expireTime then
			tb[1].expireTime = tonumber(msg.expireTime)
		end
		if msg.duration then
			tb[1].cur_duration = msg.duration
		end
		if msg.cumulateEffect then
			tb[1].cumulateEffect = msg.cumulateEffect
		end
			self:check_buff_show(tb[1])
	end
	self.buff_data[r_id] = tb
end

function Buff:buff_update(r_id,msg)
	local b_id = msg.buffId
	local data = ConfigMgr:get_config("buff") 
	local tb = self.buff_data[r_id]
	for k,v in pairs(tb) do
		if v.buff_id == b_id then --加时间
			if msg.expireTime then
				v.expireTime = tonumber(msg.expireTime)
			end
			print("啊啊啊buff",msg.cumulateEffect)
			if msg.cumulateEffect then
				v.cumulateEffect = msg.cumulateEffect
			end
			self:check_buff_show(v)
			return
		end
		if v.set ~=0 and v.set == data[b_id].set then	--替换buff
			v = copy(data[b_id])
			v.expireTime = tonumber(msg.expireTime)
			self:check_buff_show(v)
			return
		end
	end
end

function Buff:buff_remove(r_id,msg)
	local b_id = msg.buffId
	local data = ConfigMgr:get_config("buff") 
	local tb = self.buff_data[r_id]
	local index = 0
	for k,v in pairs(tb) do
		if v.buff_id == data[b_id].buff_id then
			index = k
			break
		end
	end
	if index > 0 then
		table.remove(tb,index)
	end
end

--判断buff是否需要弹框
function Buff:check_buff(i_id,guid,usefun)
	print("buff检查",i_id,guid)
	local b_id = ConfigMgr:get_config("item")[i_id].effect[1]
	local data = ConfigMgr:get_config("buff")[b_id]
	-- if not data then return false end 
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	for k,v in pairs(self.buff_data[r_id] or {}) do
		 if v.type == data.type then
		 	if v.buff_id == data.buff_id then
		 		if usefun then
					usefun()
				end
		 		LuaItemManager:get_item_obejct("bag"):use_item_c2s(guid,1,i_id)
		 		return
		 	end
		 	self:reminder_player(guid,v,usefun)
		 	return
		 end
	end
	if usefun then
		usefun()
	end
	LuaItemManager:get_item_obejct("bag"):use_item_c2s(guid,1,i_id)
end

function Buff:reminder_player(guid,data,usefun)
	local fun_sure = function()
		print("buff使用",guid)
		if usefun then
			usefun()
		end
		LuaItemManager:get_item_obejct("bag"):use_item_c2s(guid,1,i_id)
	end
	local nowtime =  math.floor(Net:get_server_time_s())*10
	local s = (data.expireTime-nowtime)*0.1
	local txt = gf_localize_string("当前已存在<color=#B01FE5>" ..data.name.."</color>效果，剩余生效时间<color=#B01FE5>" ..gf_convert_time_ms_ch(s).."</color>，使用后将会直接覆盖原有的效果，是否继续使用？")
	LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(txt,fun_sure,nil,"使用")
end

function Buff:update_main_buff(data)
	Net:receive(data, ClientProto.BuffInfo)
end

function Buff:check_buff_show(data)
	if not data.show_type and data.show_type == 0 then
		return
	end
	local tb = ConfigMgr:get_config("buff_show")[data.show_type]
	if not tb then return end
	if self.buff_show then
		self.buff_show:update_buff(tb.icon,data.cur_duration+math.floor(Net:get_server_time_s())*10,data.duration/1000)
	else
		self.buff_show_data = data
		self.buff_show = require("models.buff.buffshow")()
	end
end

function Buff:get_buff_time(tp)
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	for k,v in pairs(self.buff_data[r_id] or {}) do
		if v.type == tp then
			return v.expireTime
		end
	end
end


function Buff:get_buff_id(tp)
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	for k,v in pairs(self.buff_data[r_id] or {}) do
		if v.type == tp then
			return v.buff_id
		end
	end
end

function Buff:get_buff_value(b_id)
	local data = ConfigMgr:get_config("buff")
	for k,v in pairs(data) do
		if v.buff_id == b_id then
			return v.state_effect[1][#v.state_effect[1]]
		end
	end
end
--经验药加成
function Buff:get_exp_add()
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	for k,v in pairs(self.buff_data[r_id] or {}) do
		if v.type == 15 then
			return v.state_effect[1][4]*0.0001
		end
	end 
	return 0
end