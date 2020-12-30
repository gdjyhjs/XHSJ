	
--[[
	create at 17.7.5
	by xin
]]
local Enum = require("enum.enum")
require("models.train.trainConfig")
local model_name = "alliance"
local dataUse = require("models.train.dataUse")
local res = 
{
	[1] = "legion_practice.u3d",
}

local center_x = 165

local color = 
{
	[1] = Color(101/255, 80/255, 60/255, 1),
	[2] = Color(132/255, 56/255, 19/255, 1),
}
local commom_string = 
{
	[1] = gf_localize_string("等级：%s"),
	[2] = gf_localize_string("贡献：%s"),
	[3] = gf_localize_string("铜币：%s"),
	[4] = gf_localize_string("修炼"),
	[5] = gf_localize_string("没有道具"),
	[6] = gf_localize_string("已经满级"),
	[7] = gf_localize_string("需要加入军团才能学习"),
	[8] = gf_localize_string("上限：%s"),
	
}

local train_type = 
{
	Enum.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE,Enum.ALLIANCE_TRAIN_TYPE.PLAYER_PROTECT,Enum.ALLIANCE_TRAIN_TYPE.PLAYER_HEALTH,
	Enum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE,Enum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT,Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH,
}

local legionTrain = class(UIBase,function(self,type)
	self.type = type
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)

end)

--资源加载完成
function legionTrain:on_asset_load(key,asset)
    self:init_ui()
end


function legionTrain:init_ui()
	self.total_exp = 0
	self.cal_exp = 0
	self.is_init = true
	self:scroll_view_init()
	
end


function legionTrain:update_name()

end 

function legionTrain:train_view_init(index)

	local type = train_type[index]
	self.type = type
		
	local train_data = gf_getItemObject("train"):get_train_data_by_type(type)
	local train_info1 = dataUse.get_train_data_by_level(type,train_data.level)
		
	if self.item then
		local text = self.item.transform:FindChild("Image (1)").transform:FindChild("levelTxt"):GetComponent("UnityEngine.UI.Text")
		text.text = train_data.level
	end

	local icon_name = dataUse.get_icon(type)
	gf_setImageTexture(self.refer:Get(28), icon_name)

	--level
	local level = train_data.level --% 5
	self.refer:Get(3).text = string.format(commom_string[1],level)

	--exp
	self:set_exp_view(train_data.level,train_data.exp)
		
	self:set_value(train_info1,self.refer:Get(26))

	--如果没有满级
	local not_max = dataUse.get_is_max_level(type) > train_data.level
	if not_max then
		local train_info2 = dataUse.get_train_data_by_level(type,train_data.level + 1)
		self:set_value(train_info2,self.refer:Get(27))
	end

	self.refer:Get(33):SetActive(not_max)
	self.refer:Get(32).transform.localPosition = Vector3(not_max and 0 or center_x,0,0)

	--限制等级	
	local allience_level = gf_getItemObject("legion"):get_info().level
	local cur_max_level = dataUse.get_train_max_level(allience_level,type)
	self.refer:Get(20).text = string.format(commom_string[8],cur_max_level)

 	--贡献
 	local n_donation = train_info1.cost_donate
 	self.refer:Get(14).text = gf_format_count(n_donation)
 	--铜币
 	local n_coin = train_info1.cost_coin
 	self.refer:Get(16).text = gf_format_count(n_coin)

 	gf_set_money_ico(self.refer:Get(22), ServerEnum.BASE_RES.ALLIANCE_DONATE)
	gf_set_money_ico(self.refer:Get(23), ServerEnum.BASE_RES.COIN)
 	gf_set_money_ico(self.refer:Get(21), ServerEnum.BASE_RES.ALLIANCE_DONATE)
	gf_set_money_ico(self.refer:Get(24), ServerEnum.BASE_RES.COIN)

 	--拥有量	 ()
 	local donation = gf_getItemObject("game"):get_donation()
	local coin = gf_getItemObject("game"):get_coin()

	local str = "<color=%s>%s</color>"
	local color1 = donation >= n_donation and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	local color2 = coin >= n_coin and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)

 	self.refer:Get(15).text = string.format(str,color1,gf_format_count(donation))
	self.refer:Get(17).text = string.format(str,color2,gf_format_count(coin))

 	self:item_need_view()
 	
end

function legionTrain:set_value(train_info,node)
	local attr = train_info.combat_attr
	local str = ""
	for i,v in ipairs(attr or {}) do
		local value = node.transform:FindChild("item"..i):GetComponent("UnityEngine.UI.Text")
		--如果是按百分比显示
		if ConfigMgr:get_config("propertyname")[v[1]].is_percent == 1 then
			str = ConfigMgr:get_config("propertyname")[v[1]].name.."+"..v[2] / 100 .. "%"
		else
			str = ConfigMgr:get_config("propertyname")[v[1]].name.."+"..v[2]
		end
		value.text = str
	end

	--隐藏
	local value_o1 = self.refer:Get(26).transform:FindChild("item3")
	value_o1.gameObject:SetActive(#attr >= 2)
	local value_o2 = self.refer:Get(27).transform:FindChild("item3")
	value_o2.gameObject:SetActive(#attr == 3)
end

--假升级
function legionTrain:train_view_init_test(index,level,exp)

	local type = train_type[index]
		

	local train_info1 = dataUse.get_train_data_by_level(type,level)
		
	if self.item then
		local text = self.item.transform:FindChild("Image (1)").transform:FindChild("levelTxt"):GetComponent("UnityEngine.UI.Text")
		text.text = level
	end

	local icon_name = dataUse.get_icon(type)
	gf_setImageTexture(self.refer:Get(28), icon_name)

	--level
	self.refer:Get(3).text = string.format(commom_string[1],level)

	--exp
	self:set_exp_view(level,exp)

	--隐藏
	-- local value_o1 = self.refer:Get(26).transform:FindChild("item3")
	-- value_o1.gameObject:SetActive(false)
	-- local value_o2 = self.refer:Get(27).transform:FindChild("item3")
	-- value_o2.gameObject:SetActive(false)
		
	self:set_value(train_info1,self.refer:Get(26))

	--如果没有满级
	if dataUse.get_is_max_level(type) > level then
		local train_info2 = dataUse.get_train_data_by_level(type,level + 1)
		self:set_value(train_info2,self.refer:Get(27))
	end
	
	--限制等级	
	local allience_level = gf_getItemObject("legion"):get_info().level
	local cur_max_level = dataUse.get_train_max_level(allience_level,type)
	self.refer:Get(20).text = string.format(commom_string[8],cur_max_level)

 	--贡献
 	local n_donation = train_info1.cost_donate
 	self.refer:Get(14).text = gf_format_count(n_donation)
 	--铜币
 	local n_coin = train_info1.cost_coin
 	self.refer:Get(16).text = gf_format_count(n_coin)

 	gf_set_money_ico(self.refer:Get(22), ServerEnum.BASE_RES.ALLIANCE_DONATE)
	gf_set_money_ico(self.refer:Get(23), ServerEnum.BASE_RES.COIN)
 	gf_set_money_ico(self.refer:Get(21), ServerEnum.BASE_RES.ALLIANCE_DONATE)
	gf_set_money_ico(self.refer:Get(24), ServerEnum.BASE_RES.COIN)

 	--拥有量	 ()
 	local donation = gf_getItemObject("game"):get_donation()
	local coin = gf_getItemObject("game"):get_coin()

	local str = "<color=%s>%s</color>"
	local color1 = donation >= n_donation and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	local color2 = coin >= n_coin and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)

 	self.refer:Get(15).text = string.format(str,color1,gf_format_count(donation))
	self.refer:Get(17).text = string.format(str,color2,gf_format_count(coin))

 	self:item_need_view()
 	
end

function legionTrain:set_exp_view(level,cur_exp)
	local width = 521
	local max_level = dataUse.get_is_max_level(self.type)
	if max_level == level then
		local str = "<color=%s>%s</color>"
		self.refer:Get(4).text = string.format(str,gf_get_color(Enum.COLOR.GREEN),commom_string[6])
		self.refer:Get(11).transform.sizeDelta = Vector2(width  , 19 )
	else
		local rank = math.floor(level / RANK_LEVEL)
		local total_exp = dataUse.get_train_data_by_level(self.type,level).need_exp--dataUse.get_max_exp(type,rank)
		self.refer:Get(4).text = string.format("%d / %d",cur_exp,total_exp)
		self.refer:Get(11).transform.sizeDelta = Vector2(width * cur_exp/total_exp , 19 )
	end
end

function legionTrain:type_click(index)

	self.choose_index = index

	local item = self.refer:Get(25).gameObject.transform:FindChild("train_type"..index)
	if not item then
		return
	end
	if self.item then
		self.item.transform:FindChild("hl").gameObject:SetActive(false)
	end
	item.transform:FindChild()
	self.item = item
	self.item.transform:FindChild("hl").gameObject:SetActive(true)

	self:train_view_init(index)

end



function legionTrain:scroll_view_init()
	local scroll_view = self.refer:Get(25)
	
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		print("index:wtf ",index,data_item)
		scroll_rect_item.gameObject.name = "train_type"..index
		local train_data = gf_getItemObject("train"):get_train_data_by_type(data_item)
		local refer = scroll_rect_item
		--icon
		local icon_name = dataUse.get_icon(data_item)
		gf_setImageTexture(refer:Get(1), icon_name)
		--等级
		refer:Get(3).text = train_data.level
		--name
		refer:Get(2).text = dataUse.get_name(data_item)

		refer:Get(7):SetActive(self.choose_index == index) -- 高亮图片

		if self.is_init and index == 6 then
			self:type_click(self.type or 1)
			self.is_init = false
		end
	end
	
	scroll_view.data = train_type
	scroll_view:Refresh(-1,-1)

	if self.type and self.type > 5 then
		scroll_view:ScrollTo(5)
	end
	
end


function legionTrain:item_need_view()
	local itemId = 40240301
 	local count = 0
	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.ALLIANCE_TRAIN_ITEM,ServerEnum.BAG_TYPE.NORMAL)
   	for i,v in ipairs(items or {}) do
   		itemId = v.item.protoId
   		count = v.item.num
   	end
   	self.itemId = itemId
	local str = "<color=%s>%d</color>"
	local color = count > 0 and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	self.refer:Get(8).text = string.format(str,color,count)

	gf_set_item(itemId, self.refer:Get(13), self.refer:Get(12))
end

function legionTrain:item_click()
   	gf_getItemObject("itemSys"):common_show_item_info(self.itemId)
end

function legionTrain:train_click(ptype)
	print("wtf time:",time,self.bType,self.sType)
	if not gf_getItemObject("legion"):is_in() then
		gf_message_tips(commom_string[7])
		return
	end
	if not self.schedule_id then
		self.train_data = gf_deep_copy(gf_getItemObject("train"):get_train_data_by_type(self.type))
	end
	gf_getItemObject("train"):send_to_train(self.type,ptype)
end

function legionTrain:item_use_click()
	if not self.schedule_id then
		self.train_data = gf_deep_copy(gf_getItemObject("train"):get_train_data_by_type(self.type))
	end
   	gf_getItemObject("train"):send_to_train_by_item(self.type)
   	
end



function legionTrain:add_exp(exp)
	--如果有经验在加 加入此经验 持续跳动1秒
	self.total_exp = self.total_exp - self.cal_exp
	-- if self.total_exp > 0 then
	self.total_exp = self.total_exp + exp
	-- else
		-- self.total_exp = exp
	-- end
	self:show_exp_anim(exp)

	self:start_scheduler()

end

function legionTrain:show_exp_anim(exp)
	if not self.item_list then
		self.item_list = {}
	end

	local node = LuaHelper.InstantiateLocal(self.refer:Get(30),self.refer:Get(31))
	node:GetComponent("UnityEngine.UI.Text").text = "+"..exp
	node:GetComponent("TweenPosition"):PlayForward()
	node:SetActive(true)
	local entry = {}
	entry.node = node
	entry.end_time = Net:get_server_time_s() + 2

	table.insert(self.item_list,entry)
end

function legionTrain:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	self.cal_exp = 0
	local tick_exp = self.total_exp / 50 * 4

	local train_data = self.train_data--gf_getItemObject("train"):get_train_data_by_type(self.type)
	
	local level = train_data.level
	local cur_exp = train_data.exp

	--返回加的经验等级和剩余经验
	local update = function()
		self.cal_exp = self.cal_exp + tick_exp

		if next(self.item_list or {} ) then
			for i,v in ipairs(self.item_list or {}) do
				if Net:get_server_time_s() - v.end_time >= 0 then
					LuaHelper.Destroy(v.node)
					table.remove(self.item_list,i)
					break
				end
				
			end
		end

		--如果超过了经验条
		if  self.cal_exp >= self.total_exp then
			self.total_exp = 0
			self.cal_exp = 0
			self:stop_schedule()

			for i,v in ipairs(self.item_list) do
				LuaHelper.Destroy(v.node)
			end
			self.item_list = {}
			--刷新界面
			self:type_click(self.type)
			return
		end

		--判断是否升级
		local train_info1 = dataUse.get_train_data_by_level(self.type,level)
		local need_exp = train_info1.need_exp
		if cur_exp + tick_exp >= need_exp then
			cur_exp =  cur_exp + tick_exp - need_exp
			level = level + 1
			self.train_data.level = level

			self:train_view_init_test(self.type,level,cur_exp)
		else
			cur_exp =  cur_exp + tick_exp
		end
		self.train_data.exp = cur_exp
		self:set_exp_view(level,cur_exp)

	end
	update()
	self.schedule_id = Schedule(update, 0)
end

function legionTrain:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end
--鼠标单击事件
function legionTrain:on_click( obj, arg)
    local eventName = obj.name
    print("train click ",eventName)
    
    if eventName == "train_closeBtn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()
    
    elseif string.find(eventName,"train_type") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local index = string.gsub(eventName,"train_type","")
    	index = tonumber(index)
    	self:type_click(index)	

    elseif eventName == "item" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click()

    elseif eventName == "btn_learn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:train_click(1)
    	-- local msg = {}
    	-- msg.err = 0
    	-- msg.addExp = 500
    	-- gf_send_and_receive(msg, "alliance", "TrainResultR", sid)

    elseif eventName == "btn_use" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_use_click()

    elseif eventName == "btn_learn_ten" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:train_click(2)

    elseif string.find(eventName,"train_tag") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:tag_click(eventName,arg)

    elseif eventName == "train_btn_help" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1132)

    end

end

function legionTrain:clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function legionTrain:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionTrain:on_showed()
	StateManager:register_view(self)
	self:init_ui()
end

function legionTrain:on_hided()
	self:clear()
end

function legionTrain:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "TrainResultR") then
			if msg.err == 0 then
				self.refer:Get(29):SetActive(false)
				self.refer:Get(29):SetActive(true)
				-- self:train_view_init(msg.type)	
				self:add_exp(msg.addExp)
			end
		end
	end
end

return legionTrain

-- local model_name = "legion"

-- local res = 
-- {
-- 	[1] = "legion_practice.u3d",
-- }

-- local commom_string = 
-- {
-- 	[1] = gf_localize_string(""),
-- }


-- local legionTrain = class(UIBase,function(self)
-- 	local item_obj = LuaItemManager:get_item_obejct("legion")
-- 	self.item_obj = item_obj
-- 	UIBase._ctor(self, res[1], item_obj)
-- end)


-- --资源加载完成
-- function legionTrain:on_asset_load(key,asset)
--     self:init_ui()
-- end

-- function legionTrain:init_ui()
-- end

-- --鼠标单击事件
-- function legionTrain:on_click( obj, arg)
-- 	local event_name = obj.name
-- 	print("legionTrain click",event_name)
--     if event_name == "gw_btn" then 
--     	gf_getItemObject("legion"):send_to_spirit()

--     elseif event_name == "upgrade_btn" then
--     	gf_getItemObject("legion"):send_to_upgrade_flag()

--     end
-- end

-- function legionTrain:on_showed()
-- 	StateManager:register_view(self)
-- end

-- function legionTrain:clear()
-- 	StateManager:remove_register_view(self)
-- end

-- function legionTrain:on_hided()
-- 	self:clear()
-- end
-- -- 释放资源
-- function legionTrain:dispose()
-- 	self:clear()
--     self._base.dispose(self)
-- end

-- function legionTrain:on_receive( msg, id1, id2, sid )
-- 	if id1 == Net:get_id1(model_name) then
-- 		if id2 == Net:get_id2(model_name, "WakeUpHeroR") then
-- 		end
-- 	end
-- end

-- return legionTrain