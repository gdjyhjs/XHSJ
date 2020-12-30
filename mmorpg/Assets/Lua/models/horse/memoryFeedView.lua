--[[
	记忆喂养界面  属性
	create at 17.6.23
	by xin
]]
local dataUse = require("models.horse.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "horse"

local res = 
{
	[1] = "horse_feed_choose.u3d",
}

local exp_width = 605.87

local select_star = 1

local commom_string = 
{
	[1] = gf_localize_string("没有记忆"),
	[2] = gf_localize_string("请选择喂养道具"),
	[3] = gf_localize_string("筛选等级"),
	[4] = gf_localize_string("筛选品质"),
	[5] = gf_localize_string("%d级"),
	[6] = gf_localize_string("请选择喂养装备"),
	[7] = gf_localize_string("没有可喂养的道具"),
	[8] = gf_localize_string("没有可喂养的装备"),
	[9] = gf_localize_string("已经满级"),
	[10] = gf_localize_string("装备喂养"),
	[11] = gf_localize_string("道具喂养"),
	[12] = gf_localize_string("%d级"),
}
 
local show_type = 
{
	equip  	= 1,
	item 	= 2,
}

local memoryFeedView = class(UIBase,function(self,type)
	self.type = type
	local item_obj = LuaItemManager:get_item_obejct("horse")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function memoryFeedView:on_asset_load(key,asset)
    --发送协议获取记忆
    if self.type == show_type.item then
    	gf_getItemObject("horse"):send_to_get_memory()
    	gf_mask_show(true)
    end

    local scroll_view = self.refer:Get(1)
	scroll_view.onItemRender = self.type == show_type.item and handler(self, self.update_item) or handler(self, self.update_equip_item)

	self:view_init()

	if self.type == show_type.equip then
		self:init_color_selecter()
		self:init_level_selecter()

		self:init_ui()
		
	end

end

function memoryFeedView:init_color_selecter()
	self.s_color = 0
	self.star_select = false
	local options = self.refer:Get(4).options
	options:Clear()

	for i=ServerEnum.COLOR.BEGIN,ServerEnum.COLOR.END do
		local option = UnityEngine.UI.Dropdown.OptionData(self:get_color_name(i))
		options:Add(option)
	end
	local select_ = 0
	self.refer:Get(4).value = select_
	self.refer:Get(4).captionText.text = self:get_color_name(select_)

end

function memoryFeedView:init_level_selecter()
	self.s_level = 0
	local options = self.refer:Get(3).options
	options:Clear()

	local selector = gf_get_config_table("equip_lv")[1].level_filter--gf_get_config_table("selector")

	local select_ = 0

	local option = UnityEngine.UI.Dropdown.OptionData(self:get_level_name(select_))
	options:Add(option)

	for i,v in ipairs(selector or {}) do
		local option = UnityEngine.UI.Dropdown.OptionData(string.format(commom_string[12],v))
		options:Add(option)
	end
	
	self.refer:Get(3).value = select_
	self.refer:Get(3).captionText.text = self:get_level_name(select_)

end

function memoryFeedView:get_color_name(index)
	if index == 0 then
		return commom_string[4]
	end
	return gf_getItemObject("itemSys"):get_color_name(index)
end
function memoryFeedView:get_level_name(index)
	if index == 0 then
		return commom_string[3]
	end
	return string.format(commom_string[5],index * 10)
end

function memoryFeedView:view_init()
	self.refer:Get(6):SetActive(self.type == show_type.equip)
	self.refer:Get(7):SetActive(self.type == show_type.item)
end

function memoryFeedView:init_ui()

	self.refer:Get(11).text = self.type == show_type.equip and commom_string[10] or commom_string[11]

	local data,exp = self:get_item_from_bag()

	self.total_exp = exp

	self.data = data

	--如果是装备喂养 进行筛选
	if self.type == show_type.equip then
		self:get_equip_on_selector()
	end

	self:scroll_view_init(self.data)
	
	self:update_exp(exp)
end

function memoryFeedView:update_exp(exp)
	local level = gf_getItemObject("horse"):get_feed_level()
	local total_exp = dataUse.get_feed_exp(level)
	local cur_exp = gf_getItemObject("horse"):get_feed_exp()
	local add_total_exp = exp + cur_exp


	local level = gf_getItemObject("horse"):get_feed_level()
	local max_level = dataUse.get_feed_max_level()

	if level >= max_level then
		self.refer:Get(14).transform.sizeDelta = Vector2(exp_width , 15 )
		self.refer:Get(9).text = string.format("%s/%d","max",total_exp)
		self.refer:Get(10).text = string.format(commom_string[5],max_level)
		self.refer:Get(15).transform.sizeDelta = Vector2(exp_width  , 15 )
		return
	end

	--总经验
	local scale = add_total_exp / total_exp
	scale = scale > 1 and 1 or scale
	self.refer:Get(14).transform.sizeDelta = Vector2(exp_width * scale , 15 )

	--当前经验条
	local scale = cur_exp / total_exp
	self.refer:Get(15).transform.sizeDelta = Vector2(exp_width * scale , 15 )

	self.refer:Get(9).text = string.format("%d/%d",add_total_exp,total_exp)

	--等级
	local n_level = dataUse.get_level_and_left_exp(add_total_exp,level)
	self.refer:Get(10).text = string.format(commom_string[5],n_level)
end

function memoryFeedView:get_availble_count(data)
	local count = 0
	for i,v in ipairs(data or {}) do
		if v.type == 1 then
			count = count + 1
		end
	end
	return count
end

function memoryFeedView:scroll_view_init(data)
	self.refer:Get(17):SetActive(false)
	local count = self:get_availble_count(data)
	if not next(data or {}) or count <= 0 then
		self.refer:Get(17):SetActive(true)

		if self.type == show_type.item then
			self.refer:Get(18).text = commom_string[7]
		else
			self.refer:Get(18).text = commom_string[8]
		end

	end
	
	local scroll_view = self.refer:Get(1)
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
end

function memoryFeedView:get_item_from_bag()

	local item_data = self.type == show_type.equip and  gf_getItemObject("bag"):get_equip_from_bag(ServerEnum.BAG_TYPE.NORMAL) or gf_getItemObject("bag"):get_item_for_bag_type(ServerEnum.BAG_TYPE.NORMAL)
	gf_print_table(item_data,"wtf item_data:")
	local pre_exp = 0

	for i,v in ipairs(item_data or {}) do
		local b_type,s_type = gf_getItemObject("bag"):get_type_for_protoId(v.protoId)
		v.sort = (b_type == ServerEnum.ITEM_TYPE.PROP and s_type == ServerEnum.PROP_TYPE.HORSE_FOOD) and 0 or 1
		
	end

	table.sort(item_data,function(a,b)return a.sort < b.sort end)

	local temp_list = {}
	local index = 0
	for k,v in ipairs(item_data or {}) do
		if self:get_feed_exp(v) > 0 and v.num > 0 then
			local b_type,s_type = gf_getItemObject("bag"):get_type_for_protoId(v.protoId)
			if b_type == ServerEnum.ITEM_TYPE.PROP and s_type == ServerEnum.PROP_TYPE.HORSE_FOOD then
				local exp = ConfigMgr:get_config("item")[v.protoId].mount_exp
				pre_exp = pre_exp + exp * v.num
			end
			if self.type == show_type.equip and ((self.star_select and #v.exAttr == select_star) or #v.exAttr == 0) and v.color <= ServerEnum.COLOR.GOLD  then
				local exp = self:get_feed_exp(v)
				pre_exp = pre_exp + exp * v.num
			end

			local temp = {}
			temp.item = v
			temp.type = 1
			local b_type,s_type = gf_getItemObject("bag"):get_type_for_protoId(v.protoId)
			
			temp.is_select = false
			--如果是装备展示方式
			if self.type == show_type.equip then
				temp.is_select = ((self.star_select and #v.exAttr == select_star) or #v.exAttr == 0) and v.color <= ServerEnum.COLOR.GOLD
			else
				temp.is_select = b_type == ServerEnum.ITEM_TYPE.PROP and s_type == ServerEnum.PROP_TYPE.HORSE_FOOD
			end

			index = index + 1

			table.insert(temp_list,temp)

		end
	end

	--如果是空表 返回
	if not next(temp_list or {}) then
		return temp_list,pre_exp
	end

	--如果不足一页 补齐
	for i = 1 ,32 - #temp_list do
		local entry = {type = 2}
		table.insert(temp_list,entry)
	end

	--如果大于32 补齐最下一列
	if #temp_list > 32 then
		local count = 8 - #temp_list % 8
		for i=1,count do
			local entry = {type = 2}
			table.insert(temp_list,entry)
		end
	end

	return temp_list,pre_exp
end

--计算喂养经验
function memoryFeedView:get_feed_exp(item)
	if self.type == show_type.item then
		return gf_getItemObject("itemSys"):get_item_for_id(item.protoId).mount_exp
	end
	--计算装备喂养经验
	local equip_exp = gf_getItemObject("warehouse"):get_score(item) * gf_get_config_table("t_misc").horse_equip_feed_coeff
	return math.ceil(equip_exp)
	-- return 50
end
  
function memoryFeedView:update_item(item,index,data)
	if data.type ~= 1 then
		self:reset_item(item)
		return
	end
	item.gameObject.name = "b_item"..index

	item:Get(5).text = data.item.num > 1 and data.item.num or ""
	
	gf_set_item(data.item.protoId, item:Get(2), item:Get(1)) 

	local item_info = ConfigMgr:get_config("item")[data.item.protoId]
	item:Get(4):SetActive(item_info.bind == 1)
	
	item:Get(3):SetActive(data.is_select)

end
	
function memoryFeedView:reset_item(item)
	item:Get(5).text = ""--data.item.num
	gf_setImageTexture(item:Get(1),"item_color_0")
	gf_setImageTexture(item:Get(2),"transparent")
	item:Get(3):SetActive(false)
	item:Get(4):SetActive(false)
	item:Get(6):SetActive(false)
	item:Get(7):SetActive(false)
	item:Get(8):SetActive(false)
	--如果有星星
	local star = item:Get(2).gameObject.transform:FindChild("star")
	if star then
		LuaHelper.Destroy(star.gameObject)
	end
end

function memoryFeedView:update_equip_item(item,index,data)
	if data.type ~= 1 then
		self:reset_item(item)
		return
	end
	item.gameObject.name = "b_item"..index

	item:Get(5).text = ""--data.item.num

	gf_set_equip_icon(data.item, item:Get(2), item:Get(1),data.item.color)

	local item_info = ConfigMgr:get_config("item")[data.item.protoId]
	item:Get(4):SetActive(item_info.bind == 1)
	
	item:Get(3):SetActive(data.is_select)

	local is_up,is_level,is_career = gf_getItemObject("equip"):compare_body_equip(data.item)
	
	item:Get(8):SetActive(not is_career)

	if is_career then
		item:Get(6):SetActive(is_up ~= -1)
		item:Get(7):SetActive(is_up == -1)
	end
	
end
function memoryFeedView:item_click(arg)
	local index = arg.index 
	local data = self.data[index + 1]
	if not next(data or {}) or data.type ~= 1 then
		return
	end
	data.is_select = not data.is_select

	local feed_exp = self:get_feed_exp(data.item)

	self.total_exp = self.total_exp + (data.is_select and 1 or -1) * feed_exp * data.item.num

	self:update_exp(self.total_exp)

	if self.type == show_type.equip then
		self:update_equip_item(arg,index + 1,data)
		return
	end
	self:update_item(arg,index + 1,data)
end

function memoryFeedView:read_click()
	local memory = gf_getItemObject("horse"):get_feed_memory()
	if not next(memory or {}) then
		gf_message_tips(commom_string[1])
		return
	end
	for i,v in ipairs(memory) do
		for ii,vv in ipairs(self.data or {}) do
			if vv and vv.item and v == vv.item.protoId then
				if not self.data[ii].is_select then
					self.data[ii].is_select = true
					local item_info = gf_getItemObject("itemSys"):get_item_for_id(vv.item.protoId)
					self.total_exp = self.total_exp + item_info.mount_exp * vv.item.num

					local item = self.refer:Get(1).gameObject.transform:FindChild("b_item"..ii):GetComponent("Hugula.UGUIExtend.ScrollRectItem")

					self:update_item(item,ii,self.data[ii])
				end
			end
		end
	end
	
	self:update_exp(self.total_exp)
end

function memoryFeedView:get_equip_on_selector()
	--等级
	local exp1 = self:get_data_on_level(self.s_level)
	--品质
	local exp2 = self:get_data_on_quality(self.s_color)
	print("exp1 exp2:",exp1,exp2)
	self:scroll_view_init(self.data)

	if exp1 < 0 and exp2 < 0 then
		
	elseif exp1 < 0 then
		self.total_exp = exp2
	elseif exp2 < 0 then
		self.total_exp = exp1
	else
		self.total_exp = 0
	end
	self:update_exp(self.total_exp)
end

function memoryFeedView:get_data_on_level(level)
	if level == 0 then
		return -1
	end
	local pre_exp = 0
	local real_level = gf_get_config_table("equip_lv")[1].level_filter[level]
	local temp = {}
	for i,v in ipairs(self.data or {}) do
		if v.type == 1 then
			local item = gf_get_config_table("item")[v.item.protoId]
			if item.level == real_level then
				--如果是一星的
				if ((self.star_select and #v.item.exAttr == select_star ) or #v.item.exAttr == 0) and v.item.color <= ServerEnum.COLOR.GOLD then
					local exp = self:get_feed_exp(v.item)
					pre_exp = pre_exp + exp * v.item.num
				end
				table.insert(temp,v)
			end
		end
	end
	self.data = temp
	return pre_exp
end
function memoryFeedView:get_data_on_quality(color)
	if color == 0 then
		return -1
	end
	local temp = {}
	local pre_exp = 0

	for i,v in ipairs(self.data or {}) do
		if v.type == 1 and v.item.color == color then
			if ((self.star_select and #v.item.exAttr == select_star) or #v.item.exAttr == 0) and v.item.color <= ServerEnum.COLOR.GOLD then
				local exp = self:get_feed_exp(v.item)
				pre_exp = pre_exp + exp * v.item.num
			end
			table.insert(temp,v)
		end
	end
	self.data = temp
	return pre_exp
end

function memoryFeedView:feed_click()
	local temp = {}
	for i,v in ipairs(self.data or {}) do
		if v.is_select then
			table.insert(temp,v.item.guid)
		end
		
	end
	if not next(temp or {}) then
		if self.type == show_type.equip then
			gf_message_tips(commom_string[6])
		else
			gf_message_tips(commom_string[2])
		end
		
		return
	end

	local level = gf_getItemObject("horse"):get_feed_level()
	local max_level = dataUse.get_feed_max_level()

	if level >= max_level then
		gf_message_tips(commom_string[9])
		return
	end
	gf_getItemObject("horse"):send_to_feed(temp)
end

function memoryFeedView:item_select(arg)
	if not arg or Seven.PublicFun.IsNull(arg) then
		return
	end
	self.arg = arg
	local index = arg.value

	self.data,self.total_exp = self:get_item_from_bag()

	if arg.gameObject.name == "selectEquip" then
		self.s_level = index

	elseif arg.gameObject.name == "selectQuality" then
		self.s_color = index

	end
	self:get_equip_on_selector()
end

function memoryFeedView:check_equip_click(arg)
	for i,v in ipairs(self.data or {}) do
		if v.type == 1 and #v.item.exAttr == select_star and v.is_select ~= arg.isOn and v.item.color <= ServerEnum.COLOR.GOLD then
			v.is_select = arg.isOn
			local item_node = self.refer:Get(1).gameObject.transform:FindChild("b_item"..i)
			if not item_node then
				return
			end
			local item = item_node:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
			self.total_exp = self.total_exp + (v.is_select and 1 or -1) * self:get_feed_exp(v.item) * v.item.num
			self:update_equip_item(item,i,v)
		end

	end
	self:update_exp(self.total_exp)
	self.star_select = arg.isOn
end

--鼠标单击事件
function memoryFeedView:on_click( obj, arg)
    local event_name = obj.name
    print("wtf event name :",event_name)
    if string.find(event_name , "b_item") then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(arg)

    elseif event_name == "read_memory" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:read_click()

    elseif event_name == "set_memory" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.horse.memorySet")() 

    elseif event_name == "memory_feed" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:feed_click()

    elseif event_name == "feed_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    elseif string.find(event_name,"Item") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		self:item_select(arg)

	elseif event_name == "check_equip" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:check_equip_click(arg)

	elseif event_name == "btnEquipFeed" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:feed_click()

    end
end


-- 释放资源
function memoryFeedView:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function memoryFeedView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "GetItemToFeedMemoryR") then
			gf_mask_show(false)
			self:init_ui()

		elseif id2 == Net:get_id2(model_name,"FeedHorseR") then
			self:dispose()

		end
	end
end

return memoryFeedView