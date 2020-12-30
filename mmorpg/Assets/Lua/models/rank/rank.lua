--[[
	排行版数据模块
	create at 17.7.3
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
require("models.team.testReceive")
local rank = LuaItemManager:get_item_obejct("rank")

rank.priority = ClientEnum.PRIORITY.RANK
local Enum = require("enum.enum")
local model_name = "base"
--UI资源
rank.assets=
{
    View("rankView", rank) ,
}

--点击事件
function rank:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event("rank_view_on_click", false, obj, arg)
	return true
end


--初始化函数只会调用一次
function rank:initialize()
	self.list = {}
end

-- function rank:create_rank_view(rank_id)
-- 	local dataUse = require("models.rank.dataUse")
-- 	local stype = dataUse.get_index_by_id(rank_id)
-- 	self.sindex = stype
-- 	self.rank_id = rank_id
-- 	gf_create_model_view("rank")
-- end

--get ***********************************************************************************

-- function rank:get_param()
-- 	print("self.sindex,self.rank_id:",self.sindex,self.rank_id)
-- 	return self.sindex,self.rank_id
-- end

-- function rank:set_param(...)
	
-- end

function rank:get_rank_list(type,page)
	if page then
		return self.list[type][page]
	end
	return self.list[type]
end
function rank:get_rank_data(type)
	local temp = {}
	for i,v in ipairs(self:get_rank_list(type) or {}) do
		for ii,vv in ipairs(v or {}) do
			table.insert(temp,vv)
		end
	end
	return temp
end
function rank:get_my_rank()
	return self.rank
end

--set ***********************************************************************************
function rank:set_rank_list(type,list)
	if not self.list[type] then
		self.list[type] = {}
	end
	self.list[type] = list
end

function rank:set_page_rank_list(type,page,list)
	if not self.list[type] then
		self.list[type] = {}
	end
	self.list[type][page] = list
end
function rank:set_my_rank(rank)
	self.rank = rank
end
--send ***********************************************************************************
--@type 排行榜类型
--@page 分页页数
function rank:send_to_get_rank(type)
	local msg = {}
	msg.type = type
	msg.page = self:get_max_page(type)
	Net:send(msg,model_name,"GetRankInfo")
	gf_print_table(msg, "GetRankInfo:")
	-- testReceive(msg, model_name, "GetRankInfoR", type)
end
function rank:get_max_page(type_)
	local data = self:get_rank_list(type_)
	if next(data or {}) then
		return #data + 1
	end
	return 1
end
function rank:send_to_get_rank_alliance(type)
	local msg = {}
	msg.type = type
	msg.page = self:get_max_page(type)
	Net:send(msg,model_name,"GetAllianceRank")
	gf_print_table(msg, "GetAllianceRank:")
	-- testReceive(msg, model_name, "GetAllianceRankR", type)
end

--rec ***********************************************************************************
function rank:rec_rank_list(msg)
	if not next(msg.list or {}) then
		return
	end
	self:set_page_rank_list(msg.type,msg.page,msg.list)
	self:set_my_rank(msg.myRank)
end
function rank:rec_rank_list_alliance(msg)
	if not next(msg.list or {}) then
		return
	end
	self:set_page_rank_list(msg.type,msg.page,msg.list)
	self:set_my_rank(msg.myRank)
end
--服务器返回
function rank:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name, "GetRankInfoR") then
        	gf_print_table(msg, "GetRankInfoR")
        	self:rec_rank_list(msg)
        elseif id2 == Net:get_id2(model_name,"GetAllianceRankR") then
        	gf_print_table(msg, "GetAllianceRankR")
        	self:rec_rank_list_alliance(msg)
        end
    end
end


