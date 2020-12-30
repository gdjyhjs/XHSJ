--道具描述参数
--@item protoId 物品原形id
local Enum = require("enum.enum")

local function enter(protoId)
	local data = ConfigMgr:get_config("item")[protoId]
	local bt,st = data.type,data.sub_type
	if bt == Enum.ITEM_TYPE.MEDICINE and st == Enum.MEDICINE_TYPE.EXP_PERCENT then
		local game = LuaItemManager:get_item_obejct("game")
		local role_max_exp = ConfigMgr:get_config("player")[game:getLevel()].exp
		return {gf_format_count(math.floor(role_max_exp * data.effect[1]/10000))}
	end
end

return enter