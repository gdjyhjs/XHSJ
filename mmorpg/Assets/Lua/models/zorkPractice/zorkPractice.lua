--[[--
-- 魔域修炼
-- @Author:HuangJunShan
-- @DateTime:2017-09-04 09:50:30
--]]



local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local BagUserData = require("models.bag.bagUserData")
local exp_prop_hide_min_level = 3 -- 这个品质以上的经验药，如果背包没有，不会显示在列表

local ZorkPractice = LuaItemManager:get_item_obejct("zorkPractice")
--UI资源
ZorkPractice.assets=
{
    View("zorkPracticeView", ZorkPractice) 
}

ZorkPractice.event_name = "ZorkPracticeView_on_click"
--点击事件
function ZorkPractice:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
end

--初始化函数只会调用一次
function ZorkPractice:initialize()
	self.valid_time = 0 -- 剩余的修炼时间
	self.info_scene_info = {0,0} -- 进入魔域时的等级和经验 {lv,exp}
	self.use_prop_count = 0 -- 已使用修炼道具次数
	self.on_zork_scene = false
end

function ZorkPractice:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("scene"))then
		if(id2== Net:get_id2("scene", "GetDeathtrapInfoR"))then -- 获取剩余修炼时间 -- 使用增加修炼时间的道具，会推送此协议
			gf_print_table(msg,"返回协议：获取剩余修炼时间")
			gf_print_table(msg,"wtf receive GetDeathtrapInfoR")
			self:practice_time_s2c(msg)
		elseif(id2== Net:get_id2("scene", "DeathtrapInspireR"))then -- 返回协议：鼓舞
			gf_print_table(msg,"返回协议：鼓舞")
			self:deathtrap_inspire_s2c(msg)
		end
	elseif id1 == ClientProto.FinishScene then
		local game = LuaItemManager:get_item_obejct("game")
		local mapId = game:get_map_id()
		local mapInfo = ConfigMgr:get_config("mapinfo")[mapId]
		if mapInfo.type == 1 and mapInfo.sub_type == 3 then
			self.info_scene_info = {game:getLevel(),game:get_exp()}
			self.on_zork_scene = true
		else
			self.on_zork_scene = false
		end
		print("加载场景完毕",mapId,mapInfo.type,mapInfo.sub_type)
	end
end

-- 发送协议：获取剩余修炼时间 已获得经验 十倍经验状态
function ZorkPractice:practice_time_c2s()
	print("发送协议：获取剩余修炼时间")
	Net:send({},"scene","GetDeathtrapInfo")
end

-- 鼓舞
function ZorkPractice:deathtrap_inspire_c2s() -- 1表示开启 0表示关闭
	print("发送协议：鼓舞")
	Net:send({},"scene","DeathtrapInspire")
end

-- 返回协议：获取剩余修炼时间 -- 使用增加修炼时间的道具，会推送此协议
function ZorkPractice:practice_time_s2c(msg)
	self.valid_time = msg.validTime or 0
	self.use_prop_count = msg.itemUsedCount or 0
end

-- 鼓舞
function ZorkPractice:deathtrap_inspire_s2c(msg)
	if msg.err == 0 then
		gf_message_tips(gf_localize_string("鼓舞成功"))
	end
end

-- 使用增加修炼时间药
function ZorkPractice:use_practice_prop(propId,guid,useing_fn)
	local data = ConfigMgr:get_config("item")[propId]
	local fn_use = function()
		LuaItemManager:get_item_obejct("bag"):use_item_c2s(guid,1,propId)
		if useing_fn then
			useing_fn()
		end
	end
	if self:get_practice_time() + data.effect[1] > ConfigMgr:get_config("t_misc").deathtrap.max_time then
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(gf_localize_string("使用后剩余修炼时间将超过上限，确定要继续使用吗？"),fn_use)
	else
		fn_use()
	end
end

-- 是否在魔域场景
function ZorkPractice:is_on_zork_scene()
	return self.on_zork_scene
end

-- 进入魔域场景
function ZorkPractice:info_zork_scene()
	local deathtrap = self:get_recommend_zork_scene()
	if deathtrap then
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(deathtrap.map_id,nil,nil,nil,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	else
		gf_message_tips(gf_localize_string("等级不足"))
	end
end

-- get ---- get ---- get ---- get ---- get ---- get ---- get ---- get ---- get --

-- 获取已使用修炼道具次数
function ZorkPractice:get_use_prop_count()
	return self.use_prop_count
end

-- 获取推荐进入的地图
function ZorkPractice:get_recommend_zork_scene()
	local deathtrap = nil
	local player_lv = LuaItemManager:get_item_obejct("game"):getLevel()
	for k,v in pairs(ConfigMgr:get_config("deathtrap")) do
		if player_lv>=v.min_level and (not deathtrap or deathtrap.recom_level<v.recom_level) then
			deathtrap = v
		end
	end
	return deathtrap
end

-- 获取当前剩余的修炼时长
function ZorkPractice:get_practice_time()
	if self:is_on_zork_scene() then
		local end_time = LuaItemManager:get_item_obejct("buff"):get_buff_time(36) -- 据说要除以10 才是秒
		-- print("剩余时间",end_time - Net:get_server_time_s())
		return end_time and (end_time/10) - Net:get_server_time_s() or 0
	else
		return self.valid_time or 0
	end
end

-- 获取已获得的经验值
function ZorkPractice:get_obtained_exp()
	local game = LuaItemManager:get_item_obejct("game")
	local lv = game:getLevel()
	local exp = game:get_exp()
	local up_lv = lv - self.info_scene_info[1] -- 进入场景之后提升的等级
	local obtained_exp = exp - self.info_scene_info[2] -- 进入场景之后获得的经验
	if up_lv>0 then
		for i=up_lv,1,-1 do
			obtained_exp = obtained_exp + ConfigMgr:get_config("player")[lv-i].exp
		end
	end
	return obtained_exp
end


-- 打开使用修炼石 self
function ZorkPractice:use_zork_practice_item() -- 34 ZORK_PRACTICE_TIME
	local max_prop_count = ConfigMgr:get_config("t_misc").deathtrap.item_count_max
	if self:get_use_prop_count() >= max_prop_count then
		gf_message_tips(gf_localize_string("今天使用已达上限"))
		return
	end
	local item_list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.ZORK_PRACTICE_TIME)
	local list = {}
	local bag = LuaItemManager:get_item_obejct("bag")
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local view = nil
	for i,v in ipairs(item_list) do
		if v.bind == 0 then
			local des = string.format(gf_localize_string("修炼时间<color=#009E08FF>+%d分钟</color>"),v.effect[1]/60)
			local count = bag:get_item_count(v.code,ClientEnum.BAG_TYPE.BAG)
			local name = itemSys:give_color_for_string(v.name,v.color)
			print(v.code,des,v.name,count)
			list[#list+1] = {
				propId = v.code,
				des = des,
				name = name,
				count = count,
				color = v.color,
			}
		end
	end
	table.sort( list, function(a,b) return a.color>b.color end )
	local title = gf_localize_string("修炼石")
	local tips = string.format(gf_localize_string("今天剩余使用次数%d/%d"),self:get_use_prop_count(),max_prop_count)
	local fn = function(v,itemObj)
		gf_print_table(itemObj,"使用修炼石")
		if v.count>0 then
			local item = bag:get_item_for_protoId(v.propId)
			if item then
				local useing_fn = function()
					v.count = v.count - 1
					itemObj.count.text = v.count
					if self.use_prop_count+1 >= max_prop_count then
						view:dispose()
					else
						local tips = string.format(gf_localize_string("今天剩余使用次数%d/%d"),self:get_use_prop_count()+1,max_prop_count)
						view:set_tips(tips)
					end
				end
				self:use_practice_prop(v.propId,item.guid,useing_fn)
			end
		else
			local content = string.format(gf_localize_string("当前缺少%s，是否前往商城购买？"),v.name)
			local fn = function()
				LuaItemManager:get_item_obejct("mall"):open_select_goods(v.propId,true)
				view:dispose()
			end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,fn,nil,gf_localize_string("前往"))
		end
	end
	view = View("itemList",self)
	view:set_data(list,fn,title,tips)
end

-- 打开使用经验药
function ZorkPractice:use_add_exp_gain_item() -- 29 ADD_EXP_GAIN_ITEM
	local item_list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.ADD_EXP_GAIN_ITEM)
	local list = {}
	local bag = LuaItemManager:get_item_obejct("bag")
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local view = nil
	for i,v in ipairs(item_list) do
		if v.bind == 0 then
			local count = bag:get_item_count(v.code,ClientEnum.BAG_TYPE.BAG)
			if count>0 or v.item_level<exp_prop_hide_min_level then
				local buffId = v.effect[1]
				print(buffId)
				local effect = LuaItemManager:get_item_obejct("buff"):get_buff_value(buffId) or 0
				local des = string.format(gf_localize_string("经验加成<color=#009E08FF>%d%%</color>"),(effect)/100)
				local name = itemSys:give_color_for_string(v.name,v.color)
				list[#list+1] = {
					propId = v.code,
					des = des,
					name = name,
					count = count,
					item_level = v.item_level,
				}
			end
		end
	end
	table.sort( list, function(a,b) return a.item_level>b.item_level end )
	local title = gf_localize_string("经验药")
	local tips = gf_localize_string("使用多倍经验药，助你快速升级")
	local fn = function(v,itemObj)
		print("使用经验药")
		if v.count>0 then
			local item = bag:get_item_for_protoId(v.propId)
			if item then
				local useing_fn = function()
					v.count = v.count - 1
					itemObj.count.text = v.count
					if v.count<1 and v.item_level>=exp_prop_hide_min_level then
						itemObj.none:SetActive(true)
					end
					view:dispose()
				end
				LuaItemManager:get_item_obejct("buff"):check_buff(v.propId,item.guid,useing_fn)
			end
		else
			local content = string.format(gf_localize_string("当前缺少%s，是否前往商城购买？"),v.name)
			local fn = function()
				LuaItemManager:get_item_obejct("mall"):open_select_goods(v.propId,true)
				view:dispose()
			end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,fn,nil,gf_localize_string("前往"))
		end
	end
	view = View("itemList",self)
	view:set_data(list,fn,title,tips)
end
