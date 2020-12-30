--[[--
-- 配置表控制类
-- @Author:Seven
-- @DateTime:2017-03-16 16:56:44
--]]

ConfigMgr = {}

local function equip_enhance_init( list,... )
	for k,data in pairs(list) do
		if data.level == 0 then
			local id = k
			local attr = {}
			while(id~=0 and list[id])do
				local d = list[id]
				for i,v in ipairs(d.attr) do
					if not attr[i] then
						attr[i] = {v[1],v[2]}
					else
						attr[i] = {v[1],attr[i][2]+v[2]}
					end
				end
				d.add_attr = {}
				for i,v in ipairs(attr) do
					d.add_attr[i] = {v[1],v[2]}
				end
				id = d.next_id or 0
			end
		end
	end
end

local initFuncTable = {
	["equip_enhance"] = equip_enhance_init;
}

-- 配置表管理列表
ConfigMgr.config_list = {}

function ConfigMgr:get_config( name )
	if ConfigMgr.config_list[name] then
		return ConfigMgr.config_list[name]
	else
		local path = "config."..name
		local t = require(path)
		ConfigMgr.config_list[name] = t
		if initFuncTable[name] then
			initFuncTable[name](t)
		end
		return t
	end
end

-- 获取量表某个字段的值
function ConfigMgr:get_const( name )
	local data = self:get_config("game_const")
	return data[name].value
end

function ConfigMgr:clear()
	for k,v in pairs(ConfigMgr.config_list) do
		ConfigMgr.config_list[k] = nil
	end
	ConfigMgr.config_list = {}
end

return ConfigMgr
