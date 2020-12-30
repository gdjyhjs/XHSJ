--[[
	兵来将挡界面
	create at 17.12.21
	by xin
]]

local uiBase = require("common.viewBase")

local dataUse = require("models.copy.dataUse")

local common_string = 
{
	[1] = gf_localize_string("可购买次数不足"),
	[2] = gf_localize_string("3星通关可扫荡"),
	[3] = gf_localize_string("进入次数不足"),
	[4] = gf_localize_string("进入等级:%s"),
	[5] = gf_localize_string("副本说明:%s"),
	[6] = gf_localize_string("%d级开启"),

}

local defenceCopy = class(uiBase,function(self,type)
	self.material_type = type--ServerEnum.COPY_TYPE.MATERIAL
	local item_obj = gf_getItemObject("copy")
	uiBase._ctor(self, "copy_materials.u3d", item_obj)
end)

function defenceCopy:on_showed()
	defenceCopy._base.on_showed(self)

	self:refer_init()

	self:init_ui()
end

function defenceCopy:refer_init()
	if not self.is_refer_init then
	end
end

function defenceCopy:init_ui()
	local pass_data = gf_getItemObject("copy"):get_material_copy_data(self.material_type).starList or {}
	local copy_data = self:get_copy_type_data()
	local data = self:get_show_data() 
	local select_id = self:get_select_id(data,pass_data,copy_data)
	self:select_copy(select_id)

	local scroll_view = self.refer:Get(1)
	
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		if not self:is_unlock(data_item,index,data)  then
			self:set_lock(scroll_rect_item,index,data_item,data)
		elseif select_id == data_item then
			self:set_select(scroll_rect_item,index,data_item)
		else
			self:set_normal(scroll_rect_item,index,data_item)
		end
	end
	gf_print_table(data,"wtf data:")
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
	scroll_view:ScrollTo(#data - 1)

end

function defenceCopy:get_select_id(data,pass_data,copy_data)
	local select_id --= #pass_data == 0 and data[1] or (#pass_data >= (#copy_data - 1) and data[#data] or data[#data - 1])
	if #pass_data == 0 then
		select_id = data[1]
	end
	if #pass_data >= (#copy_data - 1) then
		select_id = data[#data]
		--如果最后一个没有解锁
		if not self:is_unlock(select_id,#data,data) then
			select_id = data[#data - 1]
		end
	end
	select_id = data[#data - 1]
	if not self:is_unlock(select_id,#data - 1,data) then
		select_id = data[#data - 2]
	end
	return select_id
end

function defenceCopy:get_copy_type_data()
	return self.material_type == ServerEnum.COPY_TYPE.MATERIAL and dataUse.get_defence_copy() or dataUse.get_treasury_copy()
end

function defenceCopy:is_unlock(copy_id,index,data)
	print("is unlock:",copy_id,index)
	--等级不足 
	local level = gf_getItemObject("game"):getLevel()
	local copy_data_ = gf_get_config_table("copy")[copy_id]
	if copy_data_.min_level > level then
		return false
	end

	local copy_data = self:get_copy_type_data()
	local pass_data = gf_getItemObject("copy"):get_material_copy_data(self.material_type).starList or {}

	--如果是没有通关过 开启第一个为解锁状态 一个以上 倒数第二个为开启状态 如果是倒数第一个 直接为开启状态
	if (#data == 3 and #pass_data == 0 and index == 1) or (#data >= 3 and #pass_data >= 1 and index == (#data - 1)) or (#pass_data == (#copy_data - 1) and index == #copy_data )  then
		return true
	end

	for i,v in ipairs(pass_data) do
		if v.copyCode == copy_id then
			return true
		end
	end
	return false
end

function defenceCopy:set_normal(item,index,data_item)
	print("set wtf  ffff normal",data_item)
	for i=1,item.gameObject.transform.childCount do
		local child = item.gameObject.transform:GetChild(i - 1)
		LuaHelper.Destroy(child.gameObject)
	end
	local pass_data = gf_getItemObject("copy"):get_material_copy_data_id(self.material_type,data_item) or {}
	local item = LuaHelper.InstantiateLocal(self.refer:Get(8).gameObject,item.gameObject)
	item.gameObject:SetActive(true)
	item.transform.localPosition = Vector3(0,0,0)

	local refer = item.gameObject:GetComponent("ReferGameObjects")
	local data_copy = gf_get_config_table("copy")[data_item]
	gf_setImageTexture(refer:Get(1),data_copy.bg_code)

	refer:Get(3).text = gf_get_config_table("material")[data_item].diff_name

	for i=1,3 do
		refer:Get(4 + i).material = nil
	end

	local count = pass_data.star or 0

	for i=count + 1,3 do 
		refer:Get(4 + i).material = self.refer:Get(11).material
	end
end

function defenceCopy:set_select(item,index,data_item)
	print("set wtf  ffff set_select")
	self.copy_id = data_item
	if self.pre_item then
		self:set_normal(self.pre_item,self.pre_item.index,self.pre_item.data)
	end

	self.pre_item = item

	for i=1,item.gameObject.transform.childCount do
		local child = item.gameObject.transform:GetChild(i - 1)
		LuaHelper.Destroy(child.gameObject)
	end

	local item = LuaHelper.InstantiateLocal(self.refer:Get(9).gameObject,item.gameObject)
	item.gameObject:SetActive(true)
	item.transform.localPosition = Vector3(0,0,0)
	
	local refer = item.gameObject:GetComponent("ReferGameObjects")
	local data_copy = gf_get_config_table("copy")[data_item]
	gf_setImageTexture(refer:Get(1),data_copy.bg_code)

	refer:Get(3).text = gf_get_config_table("material")[data_item].diff_name

	local pass_data = gf_getItemObject("copy"):get_material_copy_data_id(self.material_type,data_item) or {}

	for i=1,3 do
		refer:Get(4 + i).material = nil
	end

	local count = pass_data.star or 0

	for i=count + 1,3 do
		refer:Get(4 + i).material = self.refer:Get(11).material
	end

	self:select_copy(data_item)
end
function defenceCopy:set_lock(item,index,data_item)
	print("set wtf  ffff set_lock")
	for i=1,item.gameObject.transform.childCount do
		local child = item.gameObject.transform:GetChild(i - 1)
		LuaHelper.Destroy(child.gameObject)
	end

	local item = LuaHelper.InstantiateLocal(self.refer:Get(10).gameObject,item.gameObject)
	item.gameObject:SetActive(true)
	item.transform.localPosition = Vector3(0,0,0)

	local data_copy = gf_get_config_table("copy")[data_item]
	
	local refer = item.gameObject:GetComponent("ReferGameObjects")

	gf_setImageTexture(refer:Get(1),data_copy.bg_code)

	refer:Get(3).text = gf_get_config_table("material")[data_item].diff_name

	--如果等级不足 
	local level = gf_getItemObject("game"):getLevel()
	local copy_data = gf_get_config_table("copy")[data_item]
	
	refer:Get(9):SetActive(level >= copy_data.min_level)
	refer:Get(10):SetActive(level < copy_data.min_level)
	
	if level < copy_data.min_level then
		refer:Get(8).text = string.format(common_string[6],copy_data.min_level)
	end

	--星星
	refer:Get(5).material = self.refer:Get(11).material
	refer:Get(6).material = self.refer:Get(11).material
	refer:Get(7).material = self.refer:Get(11).material
end

function defenceCopy:get_copy_type_data_by_index(i)
	return self.material_type == ServerEnum.COPY_TYPE.MATERIAL and dataUse.get_defence_copy_by_index(i) or dataUse.get_treasury_copy_by_index(i)
end

function defenceCopy:get_show_data()
	local pass_data = gf_getItemObject("copy"):get_material_copy_data(self.material_type).starList or {}

	local copy_data = self:get_copy_type_data()--dataUse.get_defence_copy()

	local temp = {}

	for i,v in ipairs(pass_data or {}) do
		table.insert(temp,v.copyCode)
	end

	if #temp <= 1 then
		--补齐三个
		for i=#temp + 1 ,3  do
			local data = self:get_copy_type_data_by_index(i)
			table.insert(temp,data.copy_code)
		end
	end
	gf_print_table(temp,"wtf show data1:")

	--再后面补两个
	if #pass_data >= 2 and #temp <= (#copy_data - 1) then
		for i=#temp, #temp + 1 do
			local data = self:get_copy_type_data_by_index(#temp + 1)--dataUse.get_defence_copy_by_index(#temp + 1)
			if data then
				table.insert(temp,data.copy_code)
			end
		end
	end

	gf_print_table(temp,"wtf show data2:")

	return temp
end

function defenceCopy:reward_show()
	local data = gf_get_config_table("material")[self.copy_id].loot_show

	if next(data or {}) then
		for i,v in ipairs(data or {}) do
			if i > 3 then
				return
			end
			local item_id = v
			local item = self.refer:Get(4 + i)
			local bg = item:GetComponent(UnityEngine_UI_Image)
			local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
			local count = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")

			count.text = ""

			gf_set_item(item_id,icon,bg)

			item.transform:FindChild("binding").gameObject:SetActive(gf_get_config_table("item")[item_id].bind == 1)
		end
	end
end

function defenceCopy:select_copy(copy_id)
	self.copy_id = copy_id

	local s_data = gf_getItemObject("copy"):get_material_copy_data(self.material_type)
	gf_print_table(s_data,"获取兵来将挡服务器数据")
	--奖励展示
	self:reward_show()
	
	self:update_count()

	local copy_data = gf_get_config_table("copy")[copy_id]
	--限制等级
	self.refer:Get(2).text = string.format(common_string[4],copy_data.min_level)
	--副本描述
	self.refer:Get(3).text = string.format(common_string[5],copy_data.desc)
end

function defenceCopy:update_count()
	--进入次数
	local s_data = gf_getItemObject("copy"):get_material_copy_data(self.material_type)
	local count = s_data.validTimes
	local top_count = gf_get_config_table("t_misc").copy.materialCopyResetMax 
	self.refer:Get(4).text = string.format("副本次数:%d/%d",count,top_count)
end

function defenceCopy:clear()
	print("clear wtf")
end
function defenceCopy:on_hided()
	defenceCopy._base.on_hided(self)
end

-- 释放资源
function defenceCopy:dispose()
	defenceCopy._base.dispose(self)
end

function defenceCopy:add_click()
	print("add_click:")
	local count = gf_getItemObject("copy"):get_material_copy_data(self.material_type).buyTimes

	local vip_level = gf_getItemObject("vipPrivileged"):get_vip_lv()
	local data = ConfigMgr:get_config("vip")
	local cur_vip_data = data[vip_level] -- 获取当前vip等级的配置文件
	local vip_count = self.type == ServerEnum.COPY_TYPE.MATERIAL and cur_vip_data.buy_times_10 or cur_vip_data.buy_times_15

	-- if count >= vip_count then
	-- 	gf_message_tips(common_string[1])
	-- 	return
	-- end
	require("models.copy.materialBuyCount")(self.material_type)
end

function defenceCopy:enter_click()
	local count =  gf_getItemObject("copy"):get_material_copy_data(self.material_type).validTimes
	if count <= 0 then
		gf_message_tips(common_string[3])
		return
	end
	gf_getItemObject("copy"):enter_copy_c2s(self.copy_id)
end

function defenceCopy:clear_click()
	gf_getItemObject("copy"):sweep_copy_c2s(self.copy_id,1)
end

function defenceCopy:item_click(arg)
	local data = self:get_show_data() 
	if not self:is_unlock(arg.data,arg.index + 1,data) then
		return
	end
	self:set_select(arg,arg.index + 1,arg.data)
end

function defenceCopy:reward_click(event_name)
	local index = string.gsub(event_name,"material_reward","")
	index = tonumber(index)

	local data = gf_get_config_table("material")[self.copy_id].loot_show
	local item_id = data[index]
	gf_getItemObject("itemSys"):common_show_item_info(item_id)
end

function defenceCopy:on_click(obj,arg)
	local event_name = obj.name
	print("defenceCopy event_name ",event_name)

	if event_name == "material_add_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:add_click()

	elseif event_name == "material_enter_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:enter_click()

	elseif event_name == "material_saodan_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:clear_click()

	elseif string.find(event_name,"copy_item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:item_click(arg)

	elseif string.find(event_name,"material_reward") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:reward_click(event_name)

	end
	
end

function defenceCopy:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "BuyMaterialTimesR") then
			self:update_count()

		elseif id2 == Net:get_id2("copy", "SweepCopyR") then
			self:update_count()
			
		end
	end
end

return defenceCopy