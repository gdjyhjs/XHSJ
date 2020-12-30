--[[
	修炼系统数据模块  废弃
	create at 17.7.5
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper
require("models.train.trainConfig")
local model_name = "alliance"
local dataUse = require("models.train.dataUse")
local res = 
{
	[1] = "legion_practice.u3d",
}
-- 843813FF 65503CFF
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
	[1] = {Enum.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE,Enum.ALLIANCE_TRAIN_TYPE.PLAYER_PROTECT,Enum.ALLIANCE_TRAIN_TYPE.PLAYER_HEALTH,},
	[2] = {Enum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE,Enum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT,Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH,},
}

local trainView=class(Asset,function(self,item_obj)
	self.item_obj=item_obj
  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
end)


--资源加载完成
function trainView:on_asset_load(key,asset)
	self.item_obj:register_event("train_view_on_click", handler(self, self.on_click))
end

function trainView:init_ui(type)
	self.refer:Get(13).gameObject:SetActive(true)
	-- if not gf_getItemObject("legion"):is_in() then
	-- 	gf_message_tips("未加入军团无法使用")
	-- 	return
	-- end
	--选中项
	-- local type = type or Enum.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE
	self:item_need_view()

	self:tag_click("train_tag1",self.refer:Get(18))
end

-- function trainView:type_choose(type)
-- 	local p_node = self.refer:Get(1)
-- 	local train_data = gf_getItemObject("train"):get_train_list()
-- 	for i,v in pairs(Enum.ALLIANCE_TRAIN_TYPE) do
-- 		local item = p_node.transform:FindChild("train_type"..v)
-- 		item:GetComponent("UnityEngine.UI.Toggle").isOn = false
-- 		if type == v then
-- 			item:GetComponent("UnityEngine.UI.Toggle").isOn = true
-- 		end
		
-- 	end
-- end

function trainView:update_name(type)
	-- local p_node = self.refer:Get(1)
	-- local train_data = gf_getItemObject("train"):get_train_list()
	-- for i,v in pairs(Enum.ALLIANCE_TRAIN_TYPE) do
	-- 	local item = p_node.transform:FindChild("train_type"..v)
	-- 	local rank = math.floor(train_data[v].level / RANK_LEVEL)
	-- 	local str = TRAIN_YPTE_NAME[v]..commom_string[4] .. (rank > 0 and rank or "")
	-- 	local text = item.transform:FindChild("Text (6)"):GetComponent("UnityEngine.UI.Text")
	-- 	text.text = str
	-- 	text.color = color[1]
	-- 	if type == v then
	-- 		text.color = color[2]
	-- 	end
	-- end 
end 

function trainView:train_view_init(type,arg)
	self.type = type
	if self.last_text then
		self.last_text.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text").color = color[1]
	end
	self.last_text = arg
	self.last_text.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text").color = color[2]

	self.refer:Get(13).transform.parent = arg.transform
	self.refer:Get(13).transform.localPosition = Vector3(0,0,0)

	local train_data = gf_getItemObject("train"):get_train_data_by_type(type)
	local train_info = dataUse.get_train_data_by_level(type,train_data.level)
	
	--level
	local level = train_data.level --% 5
	self.refer:Get(3).text = string.format(commom_string[1],level)

	--exp
	local max_level = dataUse.get_is_max_level(type)
	if max_level == train_data.level then
		local str = "<color=%s>%s</color>"
		self.refer:Get(4).text = string.format(str,gf_get_color(Enum.COLOR.GREEN),commom_string[6])
		self.refer:Get(11).fillAmount = 1
	else
		local rank = math.floor(train_data.level / RANK_LEVEL)
		local cur_exp = dataUse.get_cur_exp(type,train_data.level) + train_data.exp
		local total_exp = dataUse.get_max_exp(type,rank)
		self.refer:Get(4).text = string.format("%d / %d",cur_exp,total_exp)
		self.refer:Get(11).fillAmount = cur_exp / total_exp
	end
	
	--固定值
	local attr = train_info.attr_type
	local value = train_info.base_add
	local str = ""
	for i,v in ipairs(attr or {}) do
		str = str .. ConfigMgr:get_config("propertyname")[v].name.."+"..value
		if i ~= #attr then
			str = str .. " "
		end
	end
	self.refer:Get(5).text = str

	--icon
	for i,v in ipairs(train_type[self.bType] or {}) do
		local icon = dataUse.get_icon(v)
		print("icon:",icon)
		local icon_img = self.refer:Get(1).transform:FindChild("train_type"..i):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon_img, icon)
	end

	--限制等级	
	local role_level = gf_getItemObject("game"):getLevel()
	local cur_max_level = dataUse.get_train_max_level(role_level)
	self.refer:Get(20).text = string.format(commom_string[8],cur_max_level)

	--百分比
	local add_value1 = train_info.percent_rate
	local add_value2 = train_info.extra_add
	self.refer:Get(6).text = TRAIN_YPTE_PROPERTY_NAME[type].."+"..(add_value1 * 100).."%"..(add_value2 > 0 and "+"..add_value2 or "")
 		
	--如果没有加入军团则按一次处理 （不能用贡献值升级 但是可以用道具）
 	local allience_level = 1
 	
 	if gf_getItemObject("legion"):is_in() then
		local alliance_data = gf_getItemObject("legion"):get_info() or {}
		allience_level = alliance_data.level or 1
 	end
 	local alliance_info = dataUse.get_alliance_train_data(allience_level)
 	--贡献
 	local donation = alliance_info.train_price_donate
 	self.refer:Get(14).text = donation
 	--铜币
 	local coin = alliance_info.train_price_coin
 	self.refer:Get(15).text = coin

 	gf_set_money_ico(self.refer:Get(23), ServerEnum.BASE_RES.ALLIANCE_DONATE)
	gf_set_money_ico(self.refer:Get(24), ServerEnum.BASE_RES.COIN)

 	--拥有量	 ()
 	local donation = gf_getItemObject("game"):get_donation()
	local coin = gf_getItemObject("game"):get_coin()
 	self.refer:Get(16).text = donation--string.format("%.0f", donation)
	self.refer:Get(17).text = gf_format_count(coin)

	gf_set_money_ico(self.refer:Get(21), ServerEnum.BASE_RES.ALLIANCE_DONATE)
	gf_set_money_ico(self.refer:Get(22), ServerEnum.BASE_RES.COIN)

 	local itemId = 40240301
 	local count = 0
	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.ALLIANCE_TRAIN_ITEM,ServerEnum.BAG_TYPE.NORMAL)
   	for i,v in ipairs(items or {}) do
   		if i == 1 then
   			itemId = v.item.protoId
   		end
   		count = v.item.num
   	end
	local str = "<color=%s>%d</color>"
	local color = count > 0 and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	self.refer:Get(8).text = string.format(str,color,count)
 	
end

function trainView:item_need_view()
	--item icon
 	local itemId = 40240301
	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.ALLIANCE_TRAIN_ITEM,ServerEnum.BAG_TYPE.NORMAL)
   	for i,v in ipairs(items or {}) do
   		if i == 1 then
   			itemId = v.item.protoId
   		end
   	end
   	self.itemId = itemId
 	gf_set_item(itemId,self.refer:Get(7),self.refer:Get(12))
end

function trainView:type_click(event,arg)
	local type = string.gsub(event,"train_type","")
	type = tonumber(type)
	self:train_view_init(train_type[self.bType][type],arg)
end


function trainView:item_click()
   	gf_getItemObject("itemSys"):common_show_item_info(self.itemId)
end

function trainView:train_click(time)
	print("wtf time:",time,self.bType,self.sType)
	if not gf_getItemObject("legion"):is_in() then
		gf_message_tips(commom_string[7])
		return
	end
	gf_getItemObject("train"):send_to_train(self.type,time)
end

function trainView:item_use_click()
	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.ALLIANCE_TRAIN_ITEM,ServerEnum.BAG_TYPE.NORMAL)
   	local uid = -1
   	local count = 0
   	for i,v in ipairs(items or {}) do
   		uid = v.item.guid
   		count = v.item.num
   	end
   	if count > 0 then
   		gf_getItemObject("train"):send_to_train_by_item(self.type,uid,1)
   		return
   	end
	gf_message_tips(commom_string[5])
end

function trainView:tag_click(event,arg)
	local index = string.gsub(event,"train_tag","")
	index = tonumber(index)

	self.bType = index

	if self.last_tag then
		self.last_tag.transform:FindChild("Image").gameObject:SetActive(false)
		self.last_tag.transform:FindChild("h_text").gameObject:SetActive(false)
		self.last_tag.transform:FindChild("Text").gameObject:SetActive(true)
	end
	self.last_tag = arg
	self.last_tag.transform:FindChild("Image").gameObject:SetActive(true)
	self.last_tag.transform:FindChild("h_text").gameObject:SetActive(true)
	self.last_tag.transform:FindChild("Text").gameObject:SetActive(false)

	self:train_view_init(train_type[self.bType][1],self.refer:Get(1).transform:FindChild("train_type"..1))

end

--鼠标单击事件
function trainView:on_click(item_obj, obj, arg)
    local eventName = obj.name
    print("trainView click ",eventName)
    
    if eventName == "train_closeBtn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()
    
    elseif string.find(eventName,"train_type") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:type_click(eventName,arg)	

    elseif eventName == "item" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click()

    elseif eventName == "btn_learn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:train_click(1)

    elseif eventName == "btn_use" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_use_click()

    elseif eventName == "btn_learn_ten" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:train_click(10)

    elseif string.find(eventName,"train_tag") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:tag_click(eventName,arg)

    end

end

function trainView:clear()
	self.last_text = nil
	self.last_tag = nil
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function trainView:dispose()
	self:clear()
    self._base.dispose(self)
end

function trainView:on_showed()
	self:init_ui()
end

function trainView:on_hided()
	self:clear()
end



function trainView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "TrainResultR") then
			if msg.err == 0 then
				self:train_view_init(msg.type,self.last_text)	
			end
		end
	end
end

return trainView