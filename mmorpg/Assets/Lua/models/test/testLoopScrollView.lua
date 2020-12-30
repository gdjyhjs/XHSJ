--[[--
-- 循环滚动列表测试
-- @Author:Seven
-- @DateTime:2017-09-08 11:05:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local TestLoopScrollView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "test_loop_scroll.u3d", item_obj) -- 资源名字全部是小写
end)

local data = 
{
	{name = "测试1"},
	{name = "测试2"},
	{name = "测试3"},
	{name = "测试4"},
	{name = "测试5"},
	{name = "测试6"},
	{name = "测试7"},
	{name = "测试8"},
	{name = "测试9"},
	{name = "测试10"},
	{name = "测试11"},
	{name = "测试12"},
	{name = "测试13"},
	{name = "测试14"},
	{name = "测试15"},
	{name = "测试16"},
	{name = "测试17"},
	{name = "测试18"},
}

-- 资源加载完成
function TestLoopScrollView:on_asset_load(key,asset)
	local loop_scroll = self.refer:Get(1)
	loop_scroll.onItemRender = handler(self, self.update_item) -- item刷新回调
	self.loop_scroll = loop_scroll
	self:set_data()
end

-- item刷新
function TestLoopScrollView:update_item( item, index )
	local d = data[index]
	if not d then
		return
	end

	item:Get(1).text = d.name

	if index == 1 then
		self:set_height(item, 80)
	else
		self:set_height(item, 50)
	end
end

-- 设置长度
function TestLoopScrollView:set_count( count )
	self.loop_scroll.totalCount = count
end

function TestLoopScrollView:set_data()
	self:set_count(#data)
end

-- 删除一个数据
function TestLoopScrollView:remove_index( index )
	table.remove(data, index)
	self:set_count(#data)
	self.loop_scroll:RefreshCells()
end

-- 插入一个数据
function TestLoopScrollView:add_index( index, d )
	table.insert(data,index, d)
	self.loop_scroll:RefreshCells()
end

-- 通过index获取一个item
function TestLoopScrollView:get_item( index )
	return self.loop_scroll:GetItem(index or 1)
end

-- 从开始哪个index开始显示
function TestLoopScrollView:refill( index )
	self.loop_scroll:RefillCells(index or 0)
end

-- 从结尾开始第几个offet开始显示
function TestLoopScrollView:refill_end( offset )
	self.loop_scroll:RefillCellsFromEnd(offset or 0)
end

-- 设置item的宽
function TestLoopScrollView:set_width( item, width )
	item:SetWidth(width)
end

-- 设置item的高
function TestLoopScrollView:set_height( item, height )
	item:SetHeight(height)
end

function TestLoopScrollView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
end

function TestLoopScrollView:on_receive( msg, id1, id2, sid )
	
end

function TestLoopScrollView:register()
	StateManager:register_view( self )
end

function TestLoopScrollView:cancel_register()
	StateManager:remove_register_view( self )
end

function TestLoopScrollView:on_showed()
	self:register()
end

function TestLoopScrollView:on_hided()
	self:cancel_register()
end

-- 释放资源
function TestLoopScrollView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return TestLoopScrollView

