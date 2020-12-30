--[[
	时空宝库界面
	create at 17.12.21
	by xin
]]

local uiBase = require("common.viewBase")

local timeTreasury = class(uiBase,function(self)
	local item_obj = gf_getItemObject("copy")
	uiBase._ctor(self, "copy_materials.u3d", item_obj)
end)

function timeTreasury:on_showed()
	timeTreasury._base.on_showed(self)

	print("wtf asset loead:")
end

function timeTreasury:clear()
	print("clear wtf")
end
function timeTreasury:on_hided()
	timeTreasury._base.on_hided(self)
end

-- 释放资源
function timeTreasury:dispose()
	timeTreasury._base.dispose(self)
end

function timeTreasury:on_click(arg)
	local event_name = arg.name
	print("timeTreasury event_name ",event_name)
	if event_name == "mask_close" then
		self:dispose()
	end
	
end

function timeTreasury:on_receive( msg, id1, id2, sid )

end

return timeTreasury