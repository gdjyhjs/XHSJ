
local function enter(arg,auto)
	local data = LuaItemManager:get_item_obejct("team"):getTeamData() or {}
	gf_print_table(data, "wtf data:")
	if not next(data or {}) then
		gf_create_model_view("team",arg,auto)
	else
		--如果自己是队长
		local roleId = LuaItemManager:get_item_obejct("game").role_info.roleId
		if roleId == data.leader then
			print("create leader wtf")
			require("models.team.teamViewLeader")(arg)
		else
			print("create member wtf")
			require("models.team.teamViewMember")()
		end
	end
end

return enter