--[[
	武将系统 招魂
	create at 17.6.6
	by xin
]]
require("models.hero.heroConfig")
local LuaHelper = LuaHelper
local dataUse = require("models.hero.dataUse")
local Enum = require("enum.enum")
local modelName = "hero"

local res = 
{
	[1] = "wujiang_wulunshu.u3d",
}

local commomString = 
{
	[1] = gf_localize_string(""),
}


local heroCallupView = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)

function heroCallupView:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroCallupView:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroCallupView:init_ui()
    local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.RAND_GIFT_HERO,ServerEnum.BAG_TYPE.NORMAL)
    for i,v in ipairs(items or {}) do

		local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
		local itemNode = refer:Get(1)
		gf_set_item(v.item.protoId, itemNode.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image), itemNode:GetComponent(UnityEngine_UI_Image))

    	break
    end
end

--鼠标单击事件
function heroCallupView:on_click(obj, arg)
	print("heroCallupView click")
    local eventName = obj.name
    if eventName == "hero_call_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()
    elseif eventName == "hero_call_up" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--如果召唤书足够
    	local dataModel = gf_getItemObject("bag")
    	local items = dataModel:get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.RAND_GIFT_HERO)
   		for i,v in ipairs(items or {}) do
	   		dataModel:use_item_c2s(v.item.guid,1,v.item.protoId)
   			return
   		end

    	gf_message_tips("道具不足")
    end
end

function heroCallupView:clear()
end
-- 释放资源
function heroCallupView:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroCallupView:on_showed()
end

function heroCallupView:on_hided()
	StateManager:remove_register_view(self)
end


function heroCallupView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "UnlockSquarePosR") then
		end
	end
	if id1 == ClientProto.RecGotoHeroView then
		self:hide()
	end
end

return heroCallupView