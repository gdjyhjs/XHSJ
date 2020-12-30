--[[--
-- 副本底板ui
-- @Author:Seven
-- @DateTime:2017-05-31 15:30:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GetType = 
{
	openItem = 1, -- 开启模板
	subItem = 2, -- 子模板
	normalItem = 3, -- 普通模板
	openItemTxt = 4, -- 开启模板文字
	subItemTxt = 5, -- 子模板文字
	subItemSelect = 6, -- 子模板选中图片
	normalItemTxt = 7, -- 普通模板文字
	normalItemTag = 8, -- 普通模板三角标
	openItemTag = 9, -- 选中模板三角标
}

local Stage = 
{
	Normal = 1, -- 普通状态
	Open = 2, -- 打开状态
	Sub = 3, -- 子状态
}


local CopyBaseView=class(Asset,function(self,item_obj)
    self.item_obj=item_obj
    self.sub_data_list = {}
    self.view_list = {}
    self:set_bg_visible(true)
    Asset._ctor(self, "fuben.u3d") -- 资源名字全部是小写
    
end)

--[[
设置子标签数据
data：数据
index：第几个标签的子标签
]]
function CopyBaseView:set_sub_data( data, index )
	self.sub_data_list[index] = data
end

function CopyBaseView:get_sub_data( index )
	return self.sub_data_list[index]
end

-- 资源加载完成
function CopyBaseView:on_asset_load(key,asset)
	self:hide_mainui()
	
end

function CopyBaseView:init_ui()
	self.scroll_table = self.refer:Get("scroll_table")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	local data = self:get_open_item()
	self.data = data
	for k,v in pairs(data) do
		v.stage = Stage.Normal
	end
	self:refresh(data)
end

function CopyBaseView:get_open_item()
	local data = ConfigMgr:get_config("copy_type")
	-- local temp = {}
	-- --组队副本如果等级低于
	-- local dataUse = require("models.team.dataUse")
	-- for i,v in ipairs(data or {}) do
	-- 	if v.code == 4 then
	-- 		local min_level = dataUse.get_lower_enter_level()
	-- 		local my_level = gf_getItemObject("game"):getLevel()
	-- 		if my_level >= min_level then
	-- 			table.insert(temp,v)
	-- 		end
	-- 	else
	-- 		table.insert(temp,v)
	-- 	end
	-- end
	return data
end

function CopyBaseView:refresh( data )
	self.item = {}
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1) --显示列表
end

function CopyBaseView:update_item( item, index, data )
	self:show_item(item, data,index)
end

function CopyBaseView:show_sub_item(touch_item)
	if not touch_item then
		return
	end

	local data = touch_item.data

	local index
	if data.stage == Stage.Normal then
		data.stage = Stage.Open

		local sub_data = self:get_sub_data(touch_item.index+1)

		if not sub_data or data.child_tag == 0 then
			self:show_item(touch_item, data)
			return
		end


		for i,v in ipairs(sub_data) do
			v.stage = Stage.Sub
			v.select = i==1
			index = self.scroll_table:InsertData(v, touch_item.index+i)
		end

	elseif data.stage == Stage.Open then
		data.stage = Stage.Normal

		local sub_data = self:get_sub_data(touch_item.index+1)

		if not sub_data or data.child_tag == 0 then
			self:show_item(touch_item, data)
			return
		end

		for i,v in ipairs(sub_data) do
			v.stage = Stage.Sub
			index = self.scroll_table:RemoveDataAt(touch_item.index+1)
		end

	elseif data.stage == Stage.Sub then
		if self.last_sub_select_item then
			self.last_sub_select_item:Get(GetType.subItemSelect):SetActive(false)
		end

		touch_item:Get(GetType.subItemSelect):SetActive(true)
		self.last_sub_select_item = touch_item
	end

	if index then
		self:show_item(touch_item, data)
	    self.scroll_table:Refresh(index-1,-1)
	end
end

function CopyBaseView:show_item( item, data,index )
	if not self.select_item and self.index == index then -- 默认第一个选中
		self.select_item = item
		data.stage = Stage.Open
		self:show_sub_view(item.index+1, true)
	end

	if data.stage == Stage.Normal then
		item:Get(GetType.openItem):SetActive(false)
		item:Get(GetType.subItem):SetActive(false)
		item:Get(GetType.normalItem):SetActive(true)
		item:Get(GetType.normalItemTxt).text = data.name
		item:Get(GetType.normalItemTag):SetActive(data.child_tag ~= 0)

	elseif data.stage == Stage.Open then
		item:Get(GetType.openItem):SetActive(true)
		item:Get(GetType.subItem):SetActive(false)
		item:Get(GetType.normalItem):SetActive(false)
		item:Get(GetType.openItemTxt).text = data.name
		item:Get(GetType.openItemTag):SetActive(data.child_tag ~= 0)

	elseif data.stage == Stage.Sub then
		item:Get(GetType.openItem):SetActive(false)
		item:Get(GetType.subItem):SetActive(true)
		item:Get(GetType.normalItem):SetActive(false)
		item:Get(GetType.subItemTxt).text = data.name
		item:Get(GetType.subItemSelect):SetActive(data.select)

		if data.select then
			self.last_sub_select_item = item
		end
	end
end

function CopyBaseView:set_select_item( touch_item, force )
	if self.select_item == touch_item and not force then
		return
	end

	self:show_sub_item(self.select_item)
	self:show_sub_item(touch_item)

	if self.select_item then
		local index = self.data[self.select_item.index+1].code
		self:show_sub_view(index, false)
	end

	local index = self.data[touch_item.index+1].code

	self:show_sub_view(index, true)

	self.select_item = touch_item

end

function CopyBaseView:show_sub_view( index, show )
	if self.view_list[index] then
		self.view_list[index]:set_visible(show)
		return
	else
		self:add_sub_view(index)
	end
end

function CopyBaseView:add_sub_view( index )
	print("add_sub_view:1",index)
	local view

	if index == 1 then -- 剧情
		view = View("storyView", self.item_obj)
		
	elseif index == 2 then -- 过关砍将
		view = View("challengeView", self.item_obj) 

	elseif index == 3 then -- 爬塔
		view = View("towerView", self.item_obj)
	
	elseif index == 4 then -- 组队副本
		view = View("teamCopyView", self.item_obj)
 
	elseif index == 5 then  -- 材料副本
		view = require("models.copy.defenceCopy")(ServerEnum.COPY_TYPE.MATERIAL)--View("defenceCopy", ServerEnum.COPY_TYPE.MATERIAL)

	elseif index == 6 then  -- 材料副本
		view = require("models.copy.defenceCopy")(ServerEnum.COPY_TYPE.MATERIAL2)
		
	end

	if not view then
		return
	end
	
	self:add_child(view)

	self.view_list[index] = view
end

function CopyBaseView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function CopyBaseView:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "preItem(Clone)" then
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:set_select_item(arg)

	end
end

function CopyBaseView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.CopyViewClose then
		self:dispose()
	end
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			self:dispose()
		end
	end
end

function CopyBaseView:on_showed()
	print("wft  test")
	self:register()

	self.select_item = nil
	self.index = gf_getItemObject("copy"):get_view_param()[1] or 1
	print("wtf self.index:",self.index)
	gf_getItemObject("copy"):set_view_param()

	self:init_ui()
end

function CopyBaseView:on_hided()
	self:clear()
end
function CopyBaseView:clear()
	self.view_list = {}
	self.select_item = nil
	self.last_sub_select_item = nil
	self.item_obj:register_event("on_click", nil)
end

-- 释放资源
function CopyBaseView:dispose()
	self:clear()
    self._base.dispose(self)
end

return CopyBaseView

