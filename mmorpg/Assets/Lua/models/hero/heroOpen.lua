--[[
	开启武将槽位
	create at 17.8.2
	by xin
]]
local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "hero"

local res = 
{
	[1] = "wujiang_unlock_new_space.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local heroOpen = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroOpen:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroOpen:init_ui()
	print("wtf index:",self.index)
	local index = gf_getItemObject("hero"):getHeroPrepareSize() + 1
	if index > prepareHoleCount then
		index = prepareHoleCount
	end
	local item = dataUse.getOpenItem(index)
	gf_set_item(item[1][1], self.refer:Get(2), self.refer:Get(1))

	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.UNLOCK_HERO_SLOT,ServerEnum.BAG_TYPE.NORMAL)

	local count = 0
	for i,v in ipairs(items or {}) do
		count = count + v.item.num
	end

	self.refer:Get(3).text = string.format("%d/%d",count,item[1][2])
end


--鼠标单击事件
function heroOpen:on_click( obj, arg)
	print("heroOpen click")
    local event_name = obj.name
    if event_name == "close_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    elseif event_name == "sure_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_getItemObject("hero"):sendToUnLockHeroSlot()

    elseif event_name == "cancel_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    end 
end
function heroOpen:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "UnlockHeroSlotR") then
			if msg.err == 0 then
				self:dispose()
			end
		end
	end
end

function heroOpen:on_hided()
	StateManager:remove_register_view(self)
end

-- 释放资源
function heroOpen:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end


return heroOpen