--[[
	修炼系统数据模块
	create at 17.7.5
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local train = LuaItemManager:get_item_obejct("train")
train.priority = ClientEnum.PRIORITY.TRAIN 
local Enum = require("enum.enum")
local model_name = "alliance"
--UI资源
train.assets=
{
    View("trainView", train) ,
}

--点击事件
function train:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("train_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function train:initialize()
	self.train_list = {}
end



--get ***********************************************************************************
function train:get_train_list()
	return self.train_list
end
function train:get_train_data_by_type(type)
	if self.train_list[type] then
		return self.train_list[type]
	end
end

--获取当前基础资源是否能够升到下一级
function train:get_can_level_up(type)
	local dataUse = require("models.train.dataUse")
	
    if self.train_list[type] and gf_getItemObject("legion"):get_info() then
	    local train_info = dataUse.get_train_data_by_level(type,self.train_list[type].level)
	    local game = LuaItemManager:get_item_obejct("game") --:get_money()
	    -- print(type,"修炼等级",self.train_list[type].level,"最大",dataUse.get_train_max_level(gf_getItemObject("legion"):get_info().level,type))
	    if game:get_money(ServerEnum.BASE_RES.COIN)>=train_info.cost_coin 
	    	and	game:get_money(ServerEnum.BASE_RES.ALLIANCE_DONATE)>=train_info.cost_donate
			and self.train_list[type].level < dataUse.get_train_max_level(gf_getItemObject("legion"):get_info().level,type)
	    	then
	    	return true
	    end
	else
		-- print("，没有这个修炼呀？",type)
	end
end

--set ***********************************************************************************


--send ***********************************************************************************
function train:send_to_get_train_data()
	local msg = {}
	Net:send(msg,model_name,"GetTrainInfo")
end
--train_type  修炼类型 
function train:send_to_train(train_type,add_type)
	local msg = {}
	msg.type = train_type
	msg.addType = add_type
	Net:send(msg,model_name,"Train")
end
--@uid
--@type 修炼类型
function train:send_to_train_by_item(type)
	local msg = {}
	msg.type = type
	Net:send(msg,model_name,"TrainInItem")
	-- gf_print_table(msg, "send_to_train_by_item:")
end

--rec ***********************************************************************************
function train:rec_train_info(msg)
	gf_print_table(msg,"wtf receive TrainR")
	self.train_list = {}
	for i,v in ipairs(msg.trainLevel or {}) do
		self.train_list[i] = {level = v,exp = msg.trainExp[i]}
	end
end

function train:rec_train_back(msg)
	gf_print_table(msg, "TrainResultR:")
	if msg.err ~= 0 then
		return
	end
	self.train_list[msg.type] = {level = msg.currLevel,exp = msg.currExp}
end

--服务器返回
function train:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name, "TrainR") then
        	self:rec_train_info(msg)

       	elseif id2 == Net:get_id2(model_name, "TrainResultR") then
       		self:rec_train_back(msg)

        end
    end
end


