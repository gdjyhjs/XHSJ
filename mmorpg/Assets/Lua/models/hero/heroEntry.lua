--[[ 废弃
	武将系统 入口
	create at 17.6.1
	by xin
]]
require("models.hero.heroConfig")
local function enter(mType)
	if mType == heroType.property then
		local item = LuaItemManager:get_item_obejct("hero")
    	item:add_to_state()
	elseif mType == heroType.list then
		require("models.hero.heroList")()
	elseif mType == heroType.front then
		require("models.hero.heroFront")()
	elseif mType == heroType.wash then
		require("models.hero.heroWash")()
	end
end
 
return enter