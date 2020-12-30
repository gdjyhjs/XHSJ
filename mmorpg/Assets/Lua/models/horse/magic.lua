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
	[1] = "horse_magic.u3d",
}

local pos = {0,192}

local commom_string =  
{
	[1] = gf_localize_string("1.通过使用<color=#73d675>坐骑道具</color>，即可<color=#73d675>激活</color>对应的坐骑<color=#73d675>形象</color>。"),
	[2] = gf_localize_string("2.<color=#73d675>已激活</color>的坐骑可是<color=#73d675>随时进行幻化</color>，<color=#73d675>地图上的坐骑形象</color>将会显示为幻化后的形象。"),
	[3] = gf_localize_string("3.幻化<color=#73d675>只改变</color>坐骑<color=#73d675>形象</color>，不会改变坐骑属性。"),
	[4] = gf_localize_string("激活"),
	[5] = gf_localize_string("幻化"),
	[6] = gf_localize_string("坐骑进阶到%d阶激活"),
	[7] = gf_localize_string("灵气已经环绕全身，达到极限了"),
	[8] = gf_localize_string("可通过活动获得"),
	[9] = gf_localize_string("已激活"),
	[10] = gf_localize_string("进阶到%d阶可激活"),
	[11] = gf_localize_string("%s灵件"),
	[12] = gf_localize_string("封灵等级：%d"),
	[13] = gf_localize_string("<color=#E28225>封灵等级达到%d级</color>"),
	[14] = gf_localize_string("缺乏对应的坐骑精魂"),
	[15] = gf_localize_string("<color=#E28225>封灵等级达到%d级(未达到)</color>"),
	[16] = gf_localize_string("<color=#E28225>下级目标：</color>"),

}

local magic = class(UIBase,function(self,tag_index,horse_id)
	self.tag_index = tag_index 
	self.t_horse_id = horse_id 


	local item_obj = LuaItemManager:get_item_obejct("horse")
	self.item_obj = item_obj
	
	UIBase._ctor(self, res[1], item_obj)
end)


magic.level = UIMgr.STACTIC

--资源加载完成
function magic:on_asset_load(key,asset)
	print("magic wtf load")
 	
end

function magic:init_ui()
	local tag_name = "tag"..(self.tag_index or 1)
	local tag_item = self.refer:Get(17).transform:FindChild(tag_name)
	self:tag_clcik(tag_name,tag_item)
	self:add_end_effect_handel()
	
	self:init_lock_component()
end

function magic:init_lock_component()
	--是否开发驻灵
	local level = gf_getItemObject("game"):getLevel()
	self.refer:Get(17).transform:FindChild("tag3").gameObject:SetActive(gf_get_config_const("hero_wash_open_level") <= level  )
end

function magic:data_init()
	self.is_receive = true
	self.item_list = {}
	self.soul_item_list = {}
end

function magic:view_init(index)
	print("init index:",index)
	self.index = index
	self:hide_view()

	if index == "1" then
		self.refer:Get(3):SetActive(true)
		self:normal_magic_init(HORSE_TYPE.normal)

	elseif index == "2" then
		self.refer:Get(3):SetActive(true)
		self:normal_magic_init(HORSE_TYPE.ex)

	elseif index == "3" then
		self.refer:Get(4):SetActive(true)
		self:reg_magic_init()

	end


end

--驻灵
function magic:reg_magic_init()
	local data = gf_getItemObject("horse"):get_horse_list()
	gf_print_table(data, "data:")
	local pItem = self.refer:Get(2)
	local copyItem = self.refer:Get(1)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end


  	local dataModel = gf_getItemObject("horse")

  	local function sort1(a,b)
  		if a.horseId ~= b.horseId then
  			return a.horseId < b.horseId
  		end
  		return a.soulLevel < b.soulLevel  
  	end
  	-- local function sort2(a,b)
  	-- 	return a.soulLevel < b.soulLevel  
  	-- end
  	table.sort( data,sort1 )
  	-- table.sort( data,sort2 )

	for i,v in ipairs(data or {}) do
		local horse_info = dataUse.get_horse_data(v.horseId)
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		cItem.name = "horse_reg_index"..i

		--name
		cItem.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text").text = horse_info.name

		--品质框
		local head_icon = cItem.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(head_icon,"item_color_"..horse_info.color)
		--icon
		local head_icon = cItem.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(head_icon, horse_info.head_icon)
		
		--等级
		-- if v.soulLevel > 0 then
		-- 	cItem.transform:FindChild("Image").gameObject:SetActive(true)
		-- end
		-- local level_text = cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		-- level_text.text =  string.format(commom_string[12],v.soulLevel)

		self:set_item_level(cItem,v.horseId)

		cItem.transform:FindChild("lock").gameObject:SetActive(false)
		--选中
		if i == 1 then 
			self:horse_reg_click("horse_reg_index"..i, cItem)
		end

		self.soul_item_list[v.horseId] = {}
		self.soul_item_list[v.horseId].item = cItem
		self.soul_item_list[v.horseId].index = i

	end


end

function magic:set_item_level(item,horse_id)
	local level = gf_getItemObject("horse"):get_horse_data(horse_id).soulLevel
	local level_text = item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	level_text.text =  string.format(commom_string[12],level)
end

--幻化
function magic:normal_magic_init(horse_type)
	self.horse_type = horse_type
	local data = dataUse.get_horse_by_type(horse_type)

	local pItem = self.refer:Get(2)
	local copyItem = self.refer:Get(1)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

  	local dataModel = gf_getItemObject("horse")

  	local cur_magic_id = dataModel:get_magic_id()

  	local function get_is_magic()
  		for i,v in ipairs(data or {}) do
  			if cur_magic_id == v.horse_id then
  				return true
  			end
  		end
  		return false
  	end

  	local is_magic = get_is_magic()

	for i,v in ipairs(data or {}) do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		cItem.name = "horse_index"..i

		--name
		cItem.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text").text = v.name

		local head_icon = cItem.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(head_icon,"item_color_"..v.color)
		--icon
		local head_icon = cItem.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(head_icon, v.head_icon)
		--是否解锁
		if not dataModel:get_is_unlock(v.horse_id) then
			cItem.transform:FindChild("reactive").gameObject:SetActive(true)
			--如果可以激活
			if self:is_can_active(v.horse_id) and horse_type == HORSE_TYPE.ex then
				cItem.transform:FindChild("reactive").gameObject:SetActive(true)
			else
				cItem.transform:FindChild("reactive").gameObject:SetActive(false)
				cItem.transform:FindChild("lock").gameObject:SetActive(true)
			end
		else
			--头像状态 
			cItem.transform:FindChild("lock").gameObject:SetActive(false)
		end

		--激活 未激活 
		local state_text = cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		state_text.text = commom_string[9]
		if horse_type == HORSE_TYPE.ex then
			if not dataModel:get_is_unlock(v.horse_id) then
				local item_id = dataUse.get_horse_item_id(v.horse_id)
				local item_info = ConfigMgr:get_config("item")[item_id]
				state_text.text = item_info.gain
			end
		else
			if not dataModel:get_is_unlock(v.horse_id) then
				local horse_info = dataUse.get_horse_level_info(v.horse_id)
				state_text.text = string.format(commom_string[10],horse_info.stage_level)
			end
		end

		cItem.transform:FindChild("magicing").gameObject:SetActive(cur_magic_id == v.horse_id)
		--如果是特殊坐骑 判断是否可以激活
		-- if horse_type == HORSE_TYPE.ex then
		-- 	if not dataModel:get_is_unlock(v.horse_id) then
		-- 		if self:is_can_active(v.horse_id) then
					
		-- 		end
		-- 	end
		-- end



		self.item_list[v.horse_id] = {}
		self.item_list[v.horse_id].item = cItem
		self.item_list[v.horse_id].index = i

	end
	
	local find_index = function(id)
		for i,v in ipairs(data or {}) do
			if v.horse_id == id then
				return i
			end
		end
	end

	if self.t_horse_id  then
		local index = find_index(self.t_horse_id)
		self:horse_click("horse_index"..index, self.item_list[self.t_horse_id].item)
		self.t_horse_id = nil

		--如果大于5 移动
		if index > 5 then 
			print("wtf  (index - #data) / #data :", 1 / (#data - 5) * (#data - index) )
			self.refer:Get(12).verticalNormalizedPosition = 1 / (#data - 5) * (#data - index)
		end

		return
	end

	if is_magic  then
		local index = find_index(cur_magic_id)
		self:horse_click("horse_index"..index, self.item_list[cur_magic_id].item)
		return
	end

	self:horse_click("horse_index"..1, self.item_list[data[1].horse_id].item)




end

function magic:add_end_effect_handel()
	
	local function gOnFinishFn()
		self.refer:Get(25).gameObject:SetActive(false)
	end
	self.refer:Get(25):GetComponent("Delay").onFinishFn = gOnFinishFn
end
function magic:show_effect()
	self.refer:Get(25):GetComponent("Delay"):ShowEffect()
	self.refer:Get(25).gameObject:SetActive(false)
	self.refer:Get(25).gameObject:SetActive(true)
	-- self.refer:Get(18):GetComponent("Delay"):ShowEffect()
end

function magic:is_can_active(horse_id)
	local item_data = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_FROM_ITEM,ServerEnum.BAG_TYPE.NORMAL)
	local use_temp = {}
	for i,v in ipairs(item_data or {}) do
		for ii,vv in ipairs(v.data.effect or {}) do
			if vv == horse_id then
				table.insert(use_temp,v)
			end
		end
	end

	if next(use_temp or {}) then
		return true
	end
	return false
end

function magic:hide_view()
	self.refer:Get(3):SetActive(false)
	self.refer:Get(4):SetActive(false)
end

function magic:horse_view_init(horse_id)
	print("horse_id:",horse_id)

	self.id = horse_id

	--如果是特殊幻化
	if self.horse_type == HORSE_TYPE.normal then
		self.refer:Get(8):SetActive(false)
		self.refer:Get(9).transform.localPosition = Vector3(116,0,0)
	elseif self.horse_type == HORSE_TYPE.ex then
		self.refer:Get(8):SetActive(true)
		self.refer:Get(9).transform.localPosition = Vector3(0,0,0)
	end
	--模型
	self:model_change(horse_id)

	--描述
	self.refer:Get(27).text = gf_get_config_table("horse")[horse_id].desc

	
end

function magic:horse_reg_view_init(horse_id)

	self.choose_id = horse_id

	local data = gf_getItemObject("horse"):get_horse_data(horse_id)
	
	--名字
	local n_level = data.soulLevel > 0 and "+"..data.soulLevel or ""
	self.refer:Get(20).text = dataUse.getHorseName(horse_id)..n_level

	--总属性（总属性 + 每个孔位的加成）
	local soul_type = dataUse.get_horse_soul_type(horse_id)
	local property_data = get_soul_property_add2(soul_type,data.soulLevel)
	local soul_data = dataUse.get_soul_data_by_level(soul_type,data.soulLevel)

	local hole_data = self:get_soul_hole_property_add(soul_type,data.soulLevel,data.slotLevel)
	
	local h_node = self.refer:Get(15)

	local is_handel = false

	for i,v in ipairs(HORSE_PROPERTY_NAME2) do
		local p_node = self.refer:Get(14).transform:FindChild(v)
		local c_value = p_node.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		c_value.text = property_data[v] + hole_data[v]
		
		--孔位属性 
		local hole_node = h_node.transform:FindChild(v)
		
		--孔位等级
		for kk=1,HORSE_HOLE_LEVEL do
			local stone = hole_node.transform:FindChild("Image ("..kk..")")
			stone.gameObject:SetActive(false)
		end
		for kk=1,data.slotLevel[i] do
			local stone = hole_node.transform:FindChild("Image ("..kk..")")
			stone.gameObject:SetActive(true)
		end
		--如果满级了
		local soul_type = dataUse.get_horse_soul_type(horse_id)
		if data.soulLevel == dataUse.get_soul_max_level(soul_type) then
			for kk=1,HORSE_HOLE_LEVEL do
				local stone = hole_node.transform:FindChild("Image ("..kk..")")
				stone.gameObject:SetActive(true)
			end
		end

		--默认选中未满的
		print("self.hole_index and not is_handel:",self.hole_index , not is_handel)
		if self.hole_index and not is_handel then
			self:hole_click(HORSE_PROPERTY_NAME2[self.hole_index])
			is_handel = true
		elseif data.slotLevel[i] < HORSE_HOLE_LEVEL and not is_handel then
			self:hole_click(v)
			is_handel = true
		end
	end
	
	--注灵道具
	local item_data = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_SOUL_ITEM,ServerEnum.BAG_TYPE.NORMAL)
	
	local item_id = next(item_data or {}) and item_data[1].item.protoId or 40201301
	local item = self.refer:Get(16)
	-- horse_set_item_icon(item,item_id,item_data)

	local count = 0
	for i,v in ipairs(item_data) do
		count = count + v.item.num
	end

	gf_set_item(item_id,self.refer:Get(29),self.refer:Get(28))
	self.refer:Get(30).text = string.format("%d/%d",count,soul_data.slot_need_item[1] and soul_data.slot_need_item[1][2] or 0)

	--模型
	set_model_view(horse_id,self.refer:Get(18),0,-1.482)

end

--获取每个孔位属性加成
--封灵等级。每个孔位等级
function magic:get_soul_hole_property_add(soul_type,level,hole_levels)
	local temp = 
	{
		attack 				= 0,
		physical_defense 	= 0,
		magic_defense 		= 0,
		hp 					= 0,
		hit 			= 0,
	} 
	for i=1,level do
		local soul_data = dataUse.get_soul_data_by_level(soul_type,i-1)
		for k,v in pairs(temp) do
			temp[k] = temp[k] + soul_data["slot_"..k] * HORSE_HOLE_LEVEL
		end
	end
	--剩余等级
	local soul_data = dataUse.get_soul_data_by_level(soul_type,level)
	
	for i,v in ipairs(hole_levels) do
		temp[HORSE_PROPERTY_NAME2[i]] = temp[HORSE_PROPERTY_NAME2[i]] + soul_data["slot_"..HORSE_PROPERTY_NAME2[i]] * v
	end
	return temp
end

function magic:model_change(id)

	--模型
	set_model_view(id,self.refer:Get(6),0,-1.482)
	
	--名字
	self.refer:Get(7).text = dataUse.getHorseName(id)
	
	local dataModel = gf_getItemObject("horse")

	self.refer:Get(10):SetActive(true)
	self.refer:Get(10).transform.localPosition = Vector3(2.7,-182.5,0)

	--*幻化状态*--
	--图标
	--如果正在幻化中
	if id == dataModel:get_magic_id() then
		self.refer:Get(10):SetActive(false)
	end

	--属性加成
	local total_property = {}
	local cur_property = {}

	self.refer:Get(21):SetActive(false)
	self.refer:Get(24):SetActive(false)

	--如果未激活
	local button_text = self.refer:Get(10).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	if not dataModel:get_is_unlock(id) then
		self.refer:Get(10):SetActive(false)
		--如果是特殊坐骑
		if self.horse_type == HORSE_TYPE.ex then
			self.refer:Get(21):SetActive(true)
		else
			self.refer:Get(24):SetActive(true)
		end

		--显示属性 总能属性加上激活后的加成
		total_property = gf_getItemObject("horse"):get_horse_property_add()
		cur_property = dataUse.get_horse_data(id)
	else
		--显示属性 总能属性
		total_property = gf_getItemObject("horse"):get_horse_property_add()
		button_text.text = commom_string[5]
	end

	--特殊坐骑显示属性
	local p_node = self.refer:Get(8)
	gf_print_table(total_property, "total_property:")
	if self.horse_type == HORSE_TYPE.ex then
		for k,v in pairs(total_property or {}) do
			local cp = p_node.transform:FindChild(k).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
			cp.text = v

			local cp = p_node.transform:FindChild(k).transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
			cp.text = cur_property[k] and "+"..cur_property[k] or ""

			if k == "speed" then
				local add_value = (cur_property[k] or 0) - total_property[k]
				cp.text = add_value > 0 and "+"..add_value or ""
			end

		end
		--修改位置
		self.refer:Get(10).transform.localPosition = Vector3(202.7,-203.1,0)

	end
	
end


function magic:horse_click(event,button)
	print("magic horse_click")
	local index = string.gsub(event,"horse_index","")
	index = tonumber(index)

	local horse_id = dataUse.get_horse_by_type(self.horse_type)[index].horse_id

	local cur_magic_id = gf_getItemObject("horse"):get_magic_id()

	if self.last_button then
		self.last_button.transform:FindChild("select_box").gameObject:SetActive(false)
	end
	
	

	self.refer:Get(26):SetActive(cur_magic_id == horse_id)

	self.last_button = button
	self.last_button.transform:FindChild("select_box").gameObject:SetActive(true)

	self:horse_view_init(horse_id)
end

function magic:horse_reg_click(event,button)

	self.refer:Get(26):SetActive(false)

	local index = string.gsub(event,"horse_reg_index","")
	index = tonumber(index)
	if self.last_button then
		self.last_button.transform:FindChild("select_box").gameObject:SetActive(false)
	end
	self.last_button = button
	self.last_button.transform:FindChild("select_box").gameObject:SetActive(true)
	
	gf_print_table(gf_getItemObject("horse"):get_horse_list(), "wtf you") 

	local horse_id = gf_getItemObject("horse"):get_horse_list()[index].horseId
	self.horse_id = horse_id

	self:horse_reg_view_init(horse_id)
end

function magic:tag_clcik(event,arg)
	for i=1,4 do
		self.refer:Get(17).transform:FindChild("tag"..i).transform:FindChild("Image").gameObject:SetActive(false)
	end
	arg.transform:FindChild("Image").gameObject:SetActive(true)

	local tag_index = string.gsub(event,"tag","")
	self.tag_index = tag_index
	self:view_init(tag_index)
end

function magic:item_click()
	local item_data = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_SOUL_ITEM,ServerEnum.BAG_TYPE.NORMAL)
	local item_id = next(item_data) ~= nil and item_data[1].item.protoId or 40201301
   	gf_getItemObject("itemSys"):common_show_item_info(item_id)
end

function magic:faq_click()
	local NormalTipsView = require("common.normalTipsView")
	NormalTipsView(self.item_obj, {commom_string[1],commom_string[2],commom_string[3]})
end

function magic:magic_click()
	gf_getItemObject("horse"):send_to_magic(self.id)
end

function magic:hole_click(event)
	print("hole_click wtf:",event)
	local p_node = self.refer:Get(15)
	local function get_index()
		local iindex = 1
		for i,v in ipairs(HORSE_PROPERTY_NAME2) do
			p_node.transform:FindChild(v).transform:FindChild("Image").gameObject:SetActive(false)
			if event == v then
				iindex = i
			end
		end
		return iindex 
	end
	local index = get_index()
	print("index:",index)
	p_node.transform:FindChild(HORSE_PROPERTY_NAME2[index]).transform:FindChild("Image").gameObject:SetActive(true)

	self.hole_index = index

	local property = HORSE_PROPERTY_NAME2[index]

	print("property:",property,self.horse_id)

	local soul_type = dataUse.get_horse_soul_type(self.horse_id)
	local data = gf_getItemObject("horse"):get_horse_data(self.horse_id)
	local soul_data = dataUse.get_soul_data_by_level(soul_type,data.soulLevel)
	gf_print_table(soul_data,"wtf soul_data:")
	-- local hole_data = self:get_soul_hole_property_add(soul_type,data.soulLevel,data.slotLevel)
	local value = data.slotLevel[index] * soul_data["slot_"..property]

	local r_property = SLOT_TO_PROPERTY[index] 

	local str = data.slotLevel[index] == 4 and "" or string.format("<color=#20C123>+%d</color>",soul_data["slot_"..property])

	self.refer:Get(23).text = string.format("%s %d %s",ConfigMgr:get_config("propertyname")[r_property].name,value,str)
	self.refer:Get(22).text = string.format(commom_string[11],ConfigMgr:get_config("propertyname")[r_property].name)

end

function magic:acitve_click()
	local item_data = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HORSE_FROM_ITEM,ServerEnum.BAG_TYPE.NORMAL)
	local use_temp = {}
	for i,v in ipairs(item_data or {}) do
		for ii,vv in ipairs(v.data.effect or {}) do
			if vv == self.id then
				table.insert(use_temp,v)
			end
		end
	end

	if next(use_temp or {}) then
		--绑定优先
		for i,v in ipairs(use_temp or {}) do
			if v.data.bind == 1 and v.item.num > 0 then
				gf_getItemObject("bag"):use_item_c2s(v.item.guid,1,v.item.protoId)
				return
			end
		end
		--非绑定 进行解锁
		-- if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		gf_getItemObject("bag"):use_item_c2s(use_temp[1].item.guid,1,use_temp[1].item.protoId)
		-- end
		return
	end
	gf_message_tips(commom_string[14])
end

function magic:propertyShow()
	local horse_id = self.choose_id
	local temp ={}
	local soul_type = dataUse.get_horse_soul_type(horse_id)
	local data = gf_getItemObject("horse"):get_horse_data(horse_id)

	local c_hole_data = get_soul_property_add2(soul_type,data.soulLevel)

	local str = "<color=#E9DDC7>%s</color> : <color=#20C123>%s</color>"

	if data.soulLevel > 0 then
		table.insert(temp,string.format(commom_string[13] ,data.soulLevel))
		for i,v in ipairs(HORSE_PROPERTY_NAME2) do
			table.insert(temp,string.format(str,HORSE_PROPERTY_NAME_CH2[i],c_hole_data[v]))
		end
	end
	-- if data.soulLevel == 0 then
	-- 	table.insert(temp,string.format(commom_string[15] ,data.soulLevel + 1))
	-- 	local n_hole_data = get_soul_property_add2(soul_type,data.soulLevel + 1)
	-- 	for i,v in ipairs(HORSE_PROPERTY_NAME2) do
	-- 		table.insert(temp,string.format(str,HORSE_PROPERTY_NAME_CH2[i],n_hole_data[v]))
	-- 	end
	-- end
	--判断是否满级 
	local soul_type = dataUse.get_horse_soul_type(horse_id)
	if  data.soulLevel ~= dataUse.get_soul_max_level(soul_type) then
		local n_hole_data = get_soul_property_add2(soul_type,data.soulLevel + 1)
		if data.soulLevel ~= 0 then
			table.insert(temp,commom_string[16] ) 
		end
		table.insert(temp,string.format(data.soulLevel == 0 and commom_string[15] or commom_string[13],data.soulLevel + 1) ) 
		for i,v in ipairs(HORSE_PROPERTY_NAME2) do
			table.insert(temp,string.format(str,HORSE_PROPERTY_NAME_CH2[i],n_hole_data[v]))
		end
	end
	--E28225FF 20C123FF E9DDC7FF
	gf_show_tips(temp,250)
end

--鼠标单击事件
function magic:on_click( obj, arg)
	print("magic click")
    local event_name = obj.name
    if string.find(event_name,"tag") then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:tag_clcik(event_name, arg)
    
    elseif string.find(event_name,"horse_index") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:horse_click(event_name,arg)

    elseif event_name == "btn_help" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1006)

    elseif event_name == "horse_magic" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:magic_click()

    elseif string.find(event_name,"horse_reg_index") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self.hole_index = nil
    	self:horse_reg_click(event_name,arg)

    elseif event_name == "magic_reg" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local horse_id = self.choose_id
    	local data = gf_getItemObject("horse"):get_horse_data(horse_id)
		local soul_type = dataUse.get_horse_soul_type(horse_id)
		if data.soulLevel == dataUse.get_soul_max_level(soul_type) then
    		gf_message_tips(commom_string[7])
    		return
    	end
    	if not self.is_receive then
    		return
    	end
    	
    	gf_getItemObject("horse"):send_to_slot(self.choose_id,self.hole_index)
    	self.is_receive = false
    	
    elseif event_name == "attack" or event_name == "physical_defense" or event_name == "magic_defense" or event_name == "hp" or event_name == "hit" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:hole_click(event_name)

    elseif event_name == "b_item (1)" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click()

    elseif event_name == "magic_show" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:propertyShow()

    elseif event_name == "horse_active" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:acitve_click()

    elseif event_name == "btn_help_normal" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if self.index == "1" then
    		gf_show_doubt(1004)

    	elseif self.index == "2" then
    		gf_show_doubt(1005)	

    	end

    elseif event_name == "horse_goto_group" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_receive_client_prot(msg, ClientProto.HorseGoToGroup )

    end
end

function magic:clear()
	self.last_button = nil
	StateManager:remove_register_view(self)
end

function magic:on_hided()
	self:clear()
end

function magic:on_showed()
	StateManager:register_view(self)
	self:data_init()
    self:init_ui()
end

-- 释放资源
function magic:dispose()
	self:clear()
    self._base.dispose(self)
end

function magic:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ChangeHorseViewR") then
			if self.index == "3" then
				return
			end
			-- self:horse_click("horse_index"..self.item_list[msg.horseId].index, self.item_list[msg.horseId].item,true)
			self:view_init(self.index)
		elseif id2 == Net:get_id2(model_name, "HorseSlotLevelUpR") then
			self.is_receive = true
			if msg.err ~= 0 or self.index ~= "3" then
				return
			end
			self:show_effect() 
			
			if msg.level > 0 then
				if msg.level == 4 then
					self.hole_index = nil
				end
				self:horse_reg_click("horse_reg_index"..self.soul_item_list[msg.horseId].index, self.soul_item_list[msg.horseId].item)
			else
				self.hole_index = nil
				-- self:view_init("3")
				self:horse_reg_click("horse_reg_index"..self.soul_item_list[msg.horseId].index, self.soul_item_list[msg.horseId].item)
				self:set_item_level(self.soul_item_list[msg.horseId].item,msg.horseId)
			end
			
		elseif id2 == Net:get_id2(model_name,"HorseR") then
			if self.index ~= "2" then
				return
			end
			self:view_init("2")

			

		end
	end

end

return magic