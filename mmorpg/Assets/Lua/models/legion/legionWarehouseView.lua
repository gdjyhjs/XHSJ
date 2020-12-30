--[[--
-- 军团仓库界面
-- @Author:Seven
-- @DateTime:2017-06-19 21:07:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LegionWarehouseView=class(UIBase,function(self,item_obj,parent)
	self.parent = parent

    UIBase._ctor(self, "legion_warehouse.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LegionWarehouseView:on_asset_load(key,asset)
	self:init_ui()
end

function LegionWarehouseView:init_ui()

end

function LegionWarehouseView:on_receive( msg, id1, id2, sid )
	
end

function LegionWarehouseView:on_click( obj, arg )
	
end

function LegionWarehouseView:on_showed()
	StateManager:register_view( self )
end

function LegionWarehouseView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function LegionWarehouseView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return LegionWarehouseView

