--[[
	武将系统 布阵
	create at 17.6.1
	by xin
]]
require("models.hero.heroConfig")
require("models.hero.heroPublicFunc")
local LuaHelper = LuaHelper
local dataUse = require("models.hero.dataUse")
local Enum = require("enum.enum")
local modelName = "hero"

local res = 
{
	[1] = "hero_embattle.u3d",
}

local commomString = 
{
	[1] = gf_localize_string("解锁"),
	[2] = gf_localize_string("升级"),
	[3] = gf_localize_string("道具不足"),
	[4] = gf_localize_string("等级：%d"),
	[5] = gf_localize_string("武将%s +%d"),
	[6] = gf_localize_string("战力:%d"),
	[7] = gf_localize_string("确定花费<color=#B01FE5>%d</color>元宝，开启一个<color=#B01FE5>%s</color>阵位？(优先使用绑定元宝)"),
	[8] = gf_localize_string("没有空闲位置"),
	[9] = gf_localize_string("请选择"),
	[10] = gf_localize_string("双防"),
}

local frontName = 
{
	"baguazhen","longyinzhen","beidouzhen",
}

local heroFront=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)

function heroFront:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroFront:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroFront:init_ui(pos_index)
	self.frontId = gf_getItemObject("hero"):getEffectiveId()
	self:frontHoleInit(pos_index or self:get_free_hole())
	
	self:initHeroList()
	self:propertyInit()

	self.refer:Get(14):SetActive(false)
end


--属性加成
function heroFront:propertyInit()
	local propertyAdd = gf_getItemObject("hero"):getRoleHeroPropertyAdd()
	local pnode = self.refer:Get(10):GetComponent("Hugula.ReferGameObjects")

	for i,v in ipairs(propertyAdd or {}) do
		pnode:Get("p"..i).text = string.format("%s  +%s",ConfigMgr:get_config("propertyname")[v.attr].name,math.floor(v.value))
	end

end

function heroFront:frontHoleInit(holeIndex)
	-- print("frontName:",frontName[frontId])
	local holeData = gf_getItemObject("hero"):getFrontDataById(1) or {}
	local temp = {}
	for i,v in ipairs(holeData.posInfo or{}) do
		temp[v.posId] = v 
	end

	local front_id = gf_getItemObject("hero"):getEffectiveId()
	local p_node = self.refer:Get(1)
	for i=1,9 do 
		v = temp[i] or {}
		local hole = p_node.transform:FindChild("hero_item"..i):GetComponent("Hugula.ReferGameObjects")

		hole:Get("lock"):SetActive(true)
		hole:Get("Image"):SetActive(false)
		hole:Get("head"):SetActive(false)

		--附加属性 
		local level = v.level or 1
		local holeInfo = dataUse.getHoleDataByIndex(front_id,i,level)
		local attrName = ConfigMgr:get_config("propertyname")[holeInfo.attr_fixed[1][1]].name
		local att_text = hole:Get("Text")
		att_text.text = string.format("%s +%d",attrName,holeInfo.attr_fixed[1][2] * level)

		--未解锁
		if not next(v or {}) then
		--解锁未放武将
		elseif v.heroId < 1 then
			hole:Get("lock"):SetActive(false)
			gf_setImageTexture(hole:Get("bg"),"item_color_0")
		--放武将
		else
			--如果是出站中的
			if gf_getItemObject("hero"):getFightId() == v.heroId then
				hole:Get("Image"):SetActive(true)
			end
			hole:Get("lock"):SetActive(false)
			hole:Get("head"):SetActive(true)
			local heroId = gf_getItemObject("hero"):getHeroIdByHeroByUid(v.heroId).heroId
			SetHeroQualityIcon(hole:Get("bg"),heroId)
				
  			gf_setImageTexture(hole:Get(3), dataUse.getHeroHeadIcon(heroId) or "img_wujiang_head_content_01")

		end
	end
		
	self:holeClick(holeIndex or 1)
end


function heroFront:holeClick(index,isClick)
	self.index = index
	if isClick and not gf_getItemObject("hero"):isHoleUnLock(self.frontId, index) then
		index = self:get_first_lock(index)
		print("要解锁的:",index)
		local data = dataUse.getHoleDataByIndex(self.frontId,index,1)
		local sure_fun = function()
			gf_getItemObject("hero"):sendToUnlockFrontHold(self.frontId,index)
		end
		local count = data.need_gold
		local content = string.format(commomString[7],count,data.name)
		gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
	end

	self:holeInfoInit(index)
end


function heroFront:holeInfoInit(index)
	self.posIndex = index
	local front_id = gf_getItemObject("hero"):getEffectiveId()
	local hole = self.refer:Get(1).transform:FindChild("hero_item"..index).transform
	self.refer:Get(9).transform.parent = hole
   	self.refer:Get(9).transform.localPosition = Vector3(0,0,0)

   	local holeServerData = gf_getItemObject("hero"):getHoleData(self.frontId,index)

   	local level = holeServerData and holeServerData.level or 1

	local holeData = dataUse.getHoleDataByIndex(front_id,index,level)
	
	--判断是否解锁
	if gf_getItemObject("hero"):isHoleUnLock(self.frontId, index) then
		--按钮
		self.refer:Get(7).text = commomString[2]
	else
		self.refer:Get(7).text = commomString[1]
	end
	
	--等级
	-- local level_count = holeServerData and holeServerData.level or 1
	self.refer:Get(2).text = string.format(commomString[4],level)
	--属性加成
	local attrName = ConfigMgr:get_config("propertyname")[holeData.attr_fixed[1][1]].name
	--特殊处理 如果是防御 
	if holeData.attr_fixed[1][1] == ServerEnum.COMBAT_ATTR.PHY_DEF or holeData.attr_fixed[1][1] == ServerEnum.COMBAT_ATTR.MAGIC_DEF then
		attrName = commomString[10]
	end
	self.refer:Get(3).text = string.format(commomString[5],attrName,holeData.attr_fixed[1][2] )
	--特性
	self.refer:Get(4).text = holeData.desc
	
	self:setItem()
end

function heroFront:initHeroList()
	local heroData = gf_getItemObject("hero"):getHeroFree()

	heroData = HeroSort(heroData)

	self.refer:Get(13):SetActive(not next(heroData or {}))

	local scroll_view = self.refer:Get(12)

	scroll_view.onItemRender = function(item,index,data)
		--头像
		gf_setImageTexture(item:Get(4), dataUse.getHeroHeadIcon(data.heroId))
		
		--名字
		item:Get(1).text = dataUse.getHeroName(data.heroId)
		
		local heroType = dataUse.getHeroQuality(data.heroId)

		--品质框
		local qualityIcon = dataUse.getHeroQualityIcon(heroType)
		gf_setImageTexture(item:Get(3),qualityIcon)

		--战力
		item:Get(2).text = string.format(commomString[6],gf_getItemObject("hero"):get_hero_power(data.heroId))
		
	end
	
	scroll_view.data = heroData
	scroll_view:Refresh(-1,-1)

end

--获得第一个未解锁的位置
function heroFront:get_first_lock(index)
	local data = gf_getItemObject("hero"):getFrontData()
	local cow = math.floor(index / 3) + math.ceil(index % 3 / 3)

	for i=(cow - 1) * 3 + 1,(cow - 1) * 3 + 4 do
		if not gf_getItemObject("hero"):isHoleUnLock(self.frontId, i) then
			return i
		end
	end
	return index
end

function heroFront:setItem()
	--道具
	local item = self.refer:Get(6)
	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.UNLOCK_HERO_SQUARE,ServerEnum.BAG_TYPE.NORMAL)
	gf_print_table(items,"wtf items:")
   	local count = 0
   	local itemId = next(items or {}) and items[1].protoId or 40140201
   	for i,v in ipairs(items or {}) do
   		count = count + v.item.num
   	end
   	self.itemId = itemId

   	local holeServerData = gf_getItemObject("hero"):getHoleData(self.frontId,self.index)
	local level = holeServerData and holeServerData.level or 1

	local hole_info = dataUse.getHoleData(self.frontId,self.index)

   	local data = hole_info[#hole_info].level == level and dataUse.getHoleDataByIndex(self.frontId,self.index,level) or dataUse.getHoleDataByIndex(self.frontId,self.index,level + 1)

   	local need_count = data.need_item[1][2]

   	local str = "<color=%s>%d</color>/%d"
	local color = count >= need_count and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)

   	item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text").text = string.format(str,color,count,need_count)
  	
   	gf_set_item(itemId,item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image),item:GetComponent(UnityEngine_UI_Image))

end

function heroFront:get_free_hole()
	local data = gf_getItemObject("hero"):getFrontData()[self.frontId] or {}
	if not next(data.posInfo or {}) then
		return 1
	end
	for i,v in ipairs(data.posInfo or {}) do
		if v.heroId <= 0 then
			return i
		end
	end
	return 1

end

function heroFront:to_attack_click(arg)
	local data = arg:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectItem").data
	local index = self.index
	if index > 0 then
		gf_getItemObject("hero"):sendToPushHeroOnHole(data.heroId,self.frontId ,index)
		return
	end
	gf_message_tips(commomString[8])
	
end

function heroFront:remove_click()
	if self.posIndex then
		gf_getItemObject("hero"):sendToPushHeroOnHole(0,self.frontId ,self.posIndex)
		return
	end
	gf_message_tips(commomString[9])
	
end

--鼠标单击事件
function heroFront:on_click(obj, arg)
    local eventName = obj.name
    print("heroFront click",eventName)
    
    if string.find(eventName,"hero_item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local index = string.gsub(eventName,"hero_item","")
    	index = tonumber(index)
   		self:holeClick(index,true)

   	elseif eventName == "hero_levelup" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		print("wtf hero_levelup",self.frontId,self.posIndex)
	   	gf_getItemObject("hero"):sendToUnlockFrontHold(self.frontId,self.posIndex)
   
    elseif eventName == "item" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	print("itemitem")
    	local itemId = self.itemId
   		gf_getItemObject("itemSys"):common_show_item_info(itemId)
   	
   	elseif string.find(eventName,"embattle_item") then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		self:to_attack_click(arg)

   	elseif eventName == "hero_store" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:remove_click()	

	elseif eventName == "btn_help" then
		gf_show_doubt(1085)

    end
end

function heroFront:clear()
	self.lFront = nil
	self.dataList = nil
	self.frontId = 1
	self.lastButton = nil
	self.index = nil
end

-- 释放资源
function heroFront:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroFront:on_showed()
end

function heroFront:on_hided()
	self:clear()
	StateManager:remove_register_view(self)
end


function heroFront:show_effect(index)
	local item = self.refer:Get(1).transform:FindChild("hero_item"..index)
	local effect = self.refer:Get(14)
	effect:SetActive(false)
	effect.transform.parent = item.transform
	effect.transform.localPosition = Vector3(0,0,0)
	effect:SetActive(true)
end


function heroFront:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		--接收到解锁或者升级孔位
		if id2 == Net:get_id2(modelName, "UnlockSquarePosR") then
			gf_print_table(msg, "接收到阵位解锁或者升级view")
			if msg.err == 0 and self.frontId == msg.squareId then
				self:init_ui(msg.pos)
				self:show_effect(msg.pos)
			end
		elseif id2 == Net:get_id2(modelName,"PutHeroToSquarePosR") then
			gf_print_table(msg, "PutHeroToSquarePosR wtf")
			if msg.err == 0 and self.frontId == msg.squareId then
				self:init_ui()
			end

		end
	end
end

return heroFront