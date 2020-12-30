------------------------------------------------
--  Copyright © 2016-2017   Hugula: Arpg game Engine
--	view 
--	author pu
------------------------------------------------
--view(view_name,item_name or item_obj,{sub_view_name,sub_item_name or sub_item_obj},...)
--[[
*创建视图，视图路径Lua/views/view_name
*view_name:视图名字
*item_object:视图数据类
*...:
]]
View = function( view_name, item_object, preload, ...)
	local tyn =type(item_object)
	if tyn == "string" then	item_object = LuaItemManager:get_item_obejct(item_object) end

	-- 把第一个字母变成小写，避免写错
	local f_ward = string.lower(string.sub(view_name,1,1))

	local path = "models."..item_object._key.."."..f_ward..string.sub(view_name,2,string.len(view_name))
	local v = require(path)(item_object,...)
	v._lua_path = path
	if preload then
		v:set_preload(preload)
	end

	if not item_object._auto_mark_dispose then -- 常驻ui
		v:set_level(UIMgr.LEVEL_STATIC)
	end

	return v
end

