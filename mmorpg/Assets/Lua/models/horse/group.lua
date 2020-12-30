--[[
	坐骑进阶界面  属性
	create at 17.6.19
	by xin
]]
local dataUse = require("models.horse.dataUse")
require("models.horse.horsePublic")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "horse"

local res = 
{
	[1] = "horse_group.u3d",
}

local commom_string = 
{	
	[1] = gf_localize_string("1.进阶需要消耗一定数量的<color=#73d675>坐骑进阶石</color>，同时获得一定的经验。"),
	[2] = gf_localize_string("2.经验满了之后即会进行升星，<color=#73d675>升星</color>可获得大量<color=#73d675>属性加成</color>。"),
	[3] = gf_localize_string("3.达到9星时升星即为进阶，<color=#73d675>进阶</color>可获得大量<color=#73d675>属性加成</color>，同时<color=#73d675>激活</color>新的坐骑<color=#73d675>形象</color>,<color=#73d675>提升</color>坐骑<color=#73d675>形象</color>。"),
	[4] = gf_localize_string("骑乘"),
	[5] = gf_localize_string("休息"),
	[6] = gf_localize_string("%d阶%d星"),
	[7] = gf_localize_string("已经突破天际，无法再进阶了"),
	[8] = gf_localize_string("此星级可解锁酷炫特效"),
	[9] = gf_localize_string("经验+%d"),
	[10] = gf_localize_string("道具不足"),
	[11] = gf_localize_string("双人打坐不能骑乘"),
	[12] = gf_localize_string("幻化"),
	[13] = gf_localize_string("（满级）"),
}



local group = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("horse")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function group:on_asset_load(key,asset)
	self:refer_init()
	self:data_init()
    self:init_ui()
    self:add_end_effect_handel()
end

function group:refer_init()
	self.model_node = self.refer:Get(1)
	self.model_camera = self.refer:Get(2)
	self.name_text = self.refer:Get(3):GetComponent("UnityEngine.UI.Text")

end

function group:init_ui()
	local level = gf_getItemObject("horse"):get_level()
	local top_horse = dataUse.get_top_unlock_horse(level)
	-- gf_print_table(top_horse, "top_horse:")
	local id = top_horse.horse_id
	self:horse_init(id)
end


--@id 坐骑id
function group:horse_init(id)
	self.id = id
	local cur_level = gf_getItemObject("horse"):get_level()
	--模型
	self:model_change(id)

	self:set_item_view()
	
	
	self:update_star_view(cur_level)

	--进阶经验
	self.cur_total_exp = gf_getItemObject("horse"):get_total_exp()
	self:update_exp_view(true)
	
	--自动购买勾选框
	self.refer:Get(13).gameObject:SetActive(gf_getItemObject("horse"):get_auto_buy_state() == 1)

	--骑乘状态
	self:ride_state_init(id)

end

function group:set_item_view()
	local cur_level = gf_getItemObject("horse"):get_level()
	--升阶道具
	local need_item = dataUse.get_group_item(cur_level)

	local bType,sType = gf_getItemObject("bag"):get_type_for_protoId(need_item[1][1])--(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_STAGE_UP)
	local item_data = gf_getItemObject("bag"):get_item_for_type(bType,sType,ServerEnum.BAG_TYPE.NORMAL)
	-- gf_print_table(item_data, "wtf item_data:")

	local need_count = need_item[1][2]
	local count = 0
	for i,v in ipairs(item_data or {}) do
		count = count + v.item.num
	end

	local item_id = need_item[1][1]
	local item = self.refer:Get(8)
	local item_bg = item:GetComponent(UnityEngine_UI_Image)
	local item_icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
	gf_set_item(item_id,item_icon,item_bg)
	--数量
	local count_text = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
	local str = "<color=%s>%d/%d</color>"
	local color = count > 0 and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	count_text.text = string.format(str,color,count,need_count)
end

function group:update_property_view(id,cur_level)
	print("wtf update_property_view:",cur_level)
	--属性
	local property = 
	{
		[1] = "attack",
		[2] = "physical_defense",
		[3] = "magic_defense",
		[4] = "hp",
		[5] = "dodge", 
	}
	local p_node = self.refer:Get(6)
	if cur_level == dataUse.get_max_level() then
		p_node.transform.localPosition = Vector3(80,0,0) 
		p_node.transform:FindChild("Image").gameObject:SetActive(false)
	end
	local cur_level_data = self.total_property[cur_level] and self.total_property[cur_level] or dataUse.get_total_property_info_bylevel(cur_level)
	self.total_property[cur_level] = cur_level_data
	local next_level_data = cur_level == dataUse.get_max_level() and nil or dataUse.get_level_data(cur_level + 1)
	for i,v in ipairs(property) do
		local pp_node = p_node.transform:FindChild("property"..i)
		local p_name = pp_node:GetComponent("UnityEngine.UI.Text")
		
		local cur_value = pp_node.transform:FindChild("cur_value"):GetComponent("UnityEngine.UI.Text")
		cur_value.text = cur_level_data[v]

		local nxt_value = pp_node.transform:FindChild("nxt_value"):GetComponent("UnityEngine.UI.Text")
		pp_node.transform:FindChild("nxt_value").transform:FindChild("Image").gameObject:SetActive(true)
		if cur_level == dataUse.get_max_level() then
			pp_node.transform:FindChild("nxt_value").gameObject:SetActive(false)
		else
			nxt_value.text = next_level_data[v]
		end
	end
	
	--移动速度
	local value = self:get_speed_value(id).."%"
	self.refer:Get(7).text = string.format("移动速度提升:%s",value)
end

--星阶
function group:update_star_view(cur_level,is_level_up)
	print("wtf cur_level:",cur_level)
	local p_node = self.refer:Get(9)
	--阶级 星级
	local star_count,stage_level = dataUse.get_horse_star_by_level(cur_level)
	for i=1,10 do
		p_node.transform:FindChild("star"..i).transform:FindChild("Image (10)").gameObject:SetActive(false)
	end
	self.refer:Get(15).text = string.format(commom_string[6],stage_level,star_count) ..(cur_level == dataUse.get_max_level() and commom_string[13] or "")

	self.refer:Get(17).text = string.format(commom_string[6],stage_level,star_count + 1)

	if cur_level == dataUse.get_max_level() then
		star_count = star_count + 1
		self.refer:Get(17).text = ""
	end
	for i=1,star_count do
		p_node.transform:FindChild("star"..i).transform:FindChild("Image (10)").gameObject:SetActive(true)
	end
	
	if is_level_up and star_count > 0 then
		local effect = self.refer:Get(19)
		effect.transform.parent = p_node.transform:FindChild("star"..star_count).transform
		effect.transform.localPosition = Vector3(0,0,0)
		effect:GetComponent("Delay"):ShowEffect()
		effect.gameObject:SetActive(false)
		effect.gameObject:SetActive(true)
	end

	--刷新属性
	self:update_property_view(self.id,cur_level)
	--是否解锁新形象
	-- if self.unlock_horse_id then
	-- 	self:model_change(self.unlock_horse_id)
	-- 	self.unlock_horse_id = nil

	-- end
end

--刷新经验
--@isReal   使用真实数据。读取数据模块的数据
function group:update_exp_view(isReal)
	print("update exp loadingbar",isReal)
	local cur_total_exp =  isReal and gf_getItemObject("horse"):get_total_exp() or self.cur_total_exp --
	local level,cur_exp,max_exp = dataUse.get_transform_exp(cur_total_exp)
	local cur_level = gf_getItemObject("horse"):get_level()

	if isReal and cur_level == dataUse.get_max_level() then
		max_exp = dataUse.get_exp_by_level(cur_level)
		self:set_exp_loadingbar("max",max_exp,true)
		return
	end
	self:set_exp_loadingbar(cur_exp,max_exp)
end

function group:set_exp_loadingbar(cur_exp,max_exp,is_max)
	print("cur_exp,max_exp,is_max:",cur_exp,max_exp,is_max)
	local width,height = 541.8,15
	local exp_node = self.refer:Get(10)
	if is_max then
		exp_node.transform.sizeDelta = Vector2(width ,height)
		self.refer:Get(16).text = string.format("%s/%d",cur_exp,max_exp)
		return
	end
	exp_node.transform.sizeDelta = Vector2(width * cur_exp / max_exp,height)
	self.refer:Get(16).text = string.format("%d/%d",cur_exp,max_exp)
end

function group:model_change(id)
	print("idid:",id)
	self.move_id = id
	local cur_level = gf_getItemObject("horse"):get_level()
	

	set_model_view(id,self.refer:Get(1),0,-1.037)

	--名字
	self.name_text.text = dataUse.getHorseName(id)
	local level_info = dataUse.get_horse_level_info(id)
	--如果未解锁
	if level_info.level > cur_level then
		local rand = level_info.stage_level				--阶数
		self.refer:Get(5).gameObject:SetActive(false)
		self.refer:Get(4).gameObject:SetActive(true)
		-- self.refer:Get(4).text = string.format("进阶到%d阶即可激活该形象",rand)
		local num1,num2 = self:get_rand_num(rand)
		local img1 = self.refer:Get(20):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(img1, "horse_num_"..num1)
		if num2 then
			self.refer:Get(21).gameObject:SetActive(true)
			local img2 = self.refer:Get(21):GetComponent(UnityEngine_UI_Image)
			gf_setImageTexture(img2, "horse_num_"..num2)
		else
			self.refer:Get(21).gameObject:SetActive(false)
		end
	else
		self.refer:Get(5).gameObject:SetActive(true)
		self.refer:Get(4).gameObject:SetActive(false)
	end

	--判断是否有前一个坐骑 或者后一个坐骑
	local data = dataUse.get_horse_next_and_front(HORSE_TYPE.normal,id)
	self.refer:Get(11):SetActive(true)
	self.refer:Get(12):SetActive(true)
	if not data[1] then
		self.refer:Get(11):SetActive(false)
	end
	if not data[2] then
		self.refer:Get(12):SetActive(false)
	end
end

function group:get_rand_num(rank)
	if rank < 10 then
		return rank
	end
	return math.floor(rank / 10),rank % 10
end
--计算速度
function group:get_speed_value(id)
	local horse_data = gf_getItemObject("horse"):get_horse_list()
	--当前阶级速度 要减100
	local speed = dataUse.get_horse_speed(id) - 100
	--特殊坐骑速度 取最大值
	local max = 0
	for i,v in ipairs(horse_data or {}) do
		local type = dataUse.get_horse_type(v.horseId)
		print("type == horse_type.ex:",type == HORSE_TYPE.ex,type , HORSE_TYPE.ex)
		if type == HORSE_TYPE.ex then
			local speed = dataUse.get_horse_speed(v.horseId)
			if speed > max then
				max = speed
			end
		end
	end
	max = max >0 and  max - 100 or 0
	return (speed + max) 
end

function group:ride_state_init(horse_id)
	--骑乘状态
	local magic_id = gf_getItemObject("horse"):get_magic_id()

	local ride_text = self.refer:Get(14).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	print("state:",gf_getItemObject("horse"):get_ride_state())
	if not horse_id or magic_id == horse_id then
		if gf_getItemObject("horse"):get_ride_state() == RIDE_STATE.riding then
			ride_text.text = commom_string[5]
		else
			ride_text.text = commom_string[4]
		end
	else
		ride_text.text = commom_string[12]
	end
	
end

function group:data_init()
	self.total_property = {}
	self.anim_exp = 0
end


function group:faq_click()
	gf_show_doubt(1001)
	-- local NormalTipsView = require("common.normalTipsView")
	-- NormalTipsView(self.item_obj, {commom_string[1],commom_string[2],commom_string[3]})
end
function group:goto_click(type)
	local data = dataUse.get_horse_next_and_front(HORSE_TYPE.normal,self.move_id)
	if data[type] then
		self:model_change(data[type].horse_id)
		self:ride_state_init(data[type].horse_id)
	end
end

function group:check_buy(checkbox)
	if not checkbox.gameObject.activeSelf then
		gf_getItemObject("horse"):set_auto_buy_state(1)
		checkbox.gameObject:SetActive(true)
		return
	end
	gf_getItemObject("horse"):set_auto_buy_state(0)
	checkbox.gameObject:SetActive(false)
	
end

function group:show_effect()
	self.refer:Get(18):GetComponent("Delay"):ShowEffect()
	self.refer:Get(19).gameObject:SetActive(false)
	self.refer:Get(18).gameObject:SetActive(false)
	self.refer:Get(18).gameObject:SetActive(true)
	-- self.refer:Get(18):GetComponent("Delay"):ShowEffect()
end

function group:ride_click()
	--如果是双休 不予上坐骑
	if gf_getItemObject("sit"):is_pair() then
		gf_message_tips(commom_string[11])
		return
	end

	--如果不是当前的坐骑 幻化成这个
	local magic_id = gf_getItemObject("horse"):get_magic_id()
	if self.move_id ~= magic_id then
		gf_getItemObject("horse"):send_to_magic(self.move_id)
		return
	end

	gf_getItemObject("horse"):send_to_ride_ex()
end
 
function group:group_click(type)
	local cur_level = gf_getItemObject("horse"):get_level()

	--如果道具不足 而且没有勾选自动购买
	local item_data = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_STAGE_UP,ServerEnum.BAG_TYPE.NORMAL)
	-- gf_print_table(item_data, "item_data:")

	if not next(item_data or {}) and gf_getItemObject("horse"):get_auto_buy_state() == 0 then
		gf_message_tips(commom_string[10])

		local cur_level = gf_getItemObject("horse"):get_level()
		--升阶道具
		local need_item = dataUse.get_group_item(cur_level)

		local item_id = need_item[1][1]
		local item = gf_get_config_table("item")[item_id]

		if item.bind == 1 then
			item_id = item.rel_code
		end

		--使用未绑定道具 
		gf_create_quick_buy(item_id,1)
		return
	end

	--满级
	if cur_level >= dataUse.get_max_level() then
		gf_message_tips(commom_string[7])
		return
	end
	if not self.schedule_id then
		self.cur_exp = gf_getItemObject("horse"):get_exp()
		self.cur_level = gf_getItemObject("horse"):get_level()
	end
	gf_getItemObject("horse"):send_to_group(type)
end


function group:star_click()
	gf_message_tips(commom_string[8])
end
function group:item_click()
	print("itemitem")
	local item_data = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_STAGE_UP,ServerEnum.BAG_TYPE.NORMAL)
	local item_id = next(item_data) ~= nil and item_data[1].item.protoId or 40180301
   	gf_getItemObject("itemSys"):common_show_item_info(item_id)
end

--鼠标单击事件
function group:on_click( obj, arg)
	print("group click")
    local event_name = obj.name
    if event_name == "hero_property" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    
    elseif event_name == "horse_group_help" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:faq_click()
    	print("group.level = UIMgr.LEVEL_STATIC:",self.level)
    elseif event_name == "horse_group_left" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:goto_click(1)
    
    elseif event_name == "horse_group_right" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:goto_click(2)

    elseif event_name == "choose_buy" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:check_buy(arg)

    elseif event_name == "horse_group_ride" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:ride_click()

    elseif event_name == "horse_group_group" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

    	-- require("models.team.testReceive")
     --    testReceive(msg, "horse", "HorseR", sid)

    	self:group_click(GROUP_TYPE.normal)

    elseif event_name == "horse_group_onkey_group" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:group_click(GROUP_TYPE.onekey)

    elseif event_name == "star4" or event_name == "star7" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:star_click()

    elseif event_name == "b_item" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click()

    end
end


function group:rec_exp(msg)
	if msg.err == 0 then
		local total_exp = 0

		for i,v in ipairs(msg.expArr) do
			total_exp = total_exp + v.exp * v.times
		end
		local r_total_exp = total_exp
		--如果动画还在播 经验值累加
		if self.schedule_id and self.left_exp > 0 then
			total_exp = total_exp + self.left_exp
		end

		--经验条特效
		self:play_exp_anim(total_exp)
		
		self:play_anim(math.floor(r_total_exp))

	end
end

function group:play_anim(exp)
	local node = LuaHelper.InstantiateLocal(self.refer:Get(22),self.refer:Get(23))
	node:GetComponent("UnityEngine.UI.Text").text = "+"..exp
	node:GetComponent("TweenPosition"):PlayForward()
	node:SetActive(true)
end

function group:play_exp_tips(expArr)
	local temp = {}
	for i,v in ipairs(expArr or {}) do
		for k=1,v.times do
			temp[math.random(1,100000000)] = v.exp
		end
	end
	for i,v in pairs(temp) do
		gf_message_tips(string.format(commom_string[9],v))
	end
end

function group:play_exp_anim(exp)
	self:stop_schedule()

	local total_time 	= 0.1
	local tick_time = 0.01
	local tick_count = total_time / tick_time
	local tick_exp = exp / tick_count

	local add_total_exp = 0

	local max_exp = dataUse.get_exp_by_level(self.cur_level)

	local cur_exp = self.cur_exp

	local cur_tick_count = 0

	local function update()
		cur_tick_count = cur_tick_count + 1
		add_total_exp = add_total_exp + tick_exp

		print("add_total_exp:",add_total_exp,tick_exp)

		self.left_exp = exp - add_total_exp

		cur_exp = cur_exp + tick_exp

		self.cur_exp = cur_exp

		--如果经验值溢出
		if cur_exp >= max_exp then
			--如果满级 停止定时器 如果未满级 获取下一等级最大经验
			self.cur_level = self.cur_level + 1
			--播放升星特效
			self:update_star_view(self.cur_level,true)

			if dataUse.get_max_level() == self.cur_level then
				self:stop_schedule()
				self:update_exp_view(true)
				return
			end
			
			cur_exp = cur_exp - max_exp
			self.cur_exp = cur_exp
			max_exp = dataUse.get_exp_by_level(self.cur_level)
			return
		end

		if add_total_exp >= exp or cur_tick_count >= tick_count then
			self:stop_schedule()
			self:update_exp_view(true)
			return
		end

		self:set_exp_loadingbar(cur_exp,max_exp)
	end
	self.schedule_id = Schedule(update, tick_time)
end

function group:add_end_effect_handel()
	local function sOnFinishFn()
		print("sOnFinishFn wtf")
		self.refer:Get(19).gameObject:SetActive(false)
	end
	self.refer:Get(19):GetComponent("Delay").onFinishFn = sOnFinishFn
	local function gOnFinishFn()
		print("gOnFinishFn wtf")
		self.refer:Get(18).gameObject:SetActive(false)
	end
	self.refer:Get(18):GetComponent("Delay").onFinishFn = gOnFinishFn
end

function group:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function group:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "SetHorseRidingR") then
			self:ride_state_init()

		elseif id2 == Net:get_id2(model_name,"AddExpByItemR") then
			gf_print_table(msg, "AddExpByItemR:")
			if msg.err == 0 then
				self:show_effect()
				self:set_item_view()
				self:rec_exp(msg)
			end

		elseif id2 == Net:get_id2(model_name,"HorseR") then
			print("msg.horse.horseId:",msg.horse.horseId)
			-- self.unlock_horse_id = msg.horse.horseId
        	-- self:model_change(msg.horse.horseId)

        elseif id2 == Net:get_id2(model_name,"ChangeHorseViewR") then
        	self:ride_state_init(msg.horseId)

		end 
	end
	if id1==Net:get_id1("shop") then
		if id2== Net:get_id2("shop", "BuyR") then
			self:set_item_view()
		end
	end

	if id1 == ClientProto.HorseShowState then
		self:init_ui()
	end
end

function group:on_hided()
	self.unlock_horse_id = nil
	self:stop_schedule()
end

-- 释放资源
function group:dispose()
	self.unlock_horse_id = nil
	self:stop_schedule()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

return group