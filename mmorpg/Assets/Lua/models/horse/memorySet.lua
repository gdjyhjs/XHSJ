--[[
	记忆设置界面  属性
	create at 17.6.23
	by xin
]]
local dataUse = require("models.horse.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "horse"

local res = 
{
	[1] = "horse_memory_set.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("请选择取消记忆喂养的道具"),
}

local memorySet = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("horse")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function memorySet:on_asset_load(key,asset)
    self:init_ui()
end

function memorySet:init_ui()
		
	self.refer:Get(3):SetActive(true)

	self.page_view = self.refer:Get(4)
	self.scroll_view = self.refer:Get(1)

	self.scroll_view.onItemRender = handler(self, self.on_item_render)
	self.scroll_view.onPageChangedFn = handler(self, self.on_page_change_fn)
	self.scroll_view.OnPageChanged = handler(self, self.on_page_change)

	
	self.data = self:get_item_from_bag()
	
	local temp = {}
	for i,v in ipairs(self.data or {}) do
		for ii,vv in ipairs(v or {}) do
			table.insert(temp,vv)
		end
	end

	gf_print_table(temp, "wtf temp:")

	if #temp == 0 then
		self.scroll_view:SetPage(1)
		return
	end

	print("page count",#temp,math.ceil(#temp / HORSE_MEMORY_ITEM_COUNT))

	self.scroll_view.data = self.data

	self.scroll_view:SetPage(math.ceil(#temp / HORSE_MEMORY_ITEM_COUNT))

end

function memorySet:on_item_render( item, cur_index, page, data )
	self:page_view_init(data)
end
function memorySet:on_page_change(page)
end
function memorySet:on_page_change_fn(page)
end
function memorySet:get_item_from_bag()
	local item_data = gf_getItemObject("horse"):get_feed_memory()
	--每18个为一页
	local temp_list = {}
	local index = 0
	for k,v in ipairs(item_data or {}) do
		local temp = {}
		temp.item_id = v
		-- temp.page = math.ceil(index / HORSE_MEMORY_ITEM_COUNT) - 1
		-- temp.index = math.floor(index % HORSE_MEMORY_ITEM_COUNT) - 1
		temp.page = math.ceil((index + 1) / HORSE_MEMORY_ITEM_COUNT) - 1
		temp.index = math.floor(index % HORSE_MEMORY_ITEM_COUNT) 
		temp.is_select = false
		index = index + 1
		if not temp_list[temp.page + 1] then
			temp_list[temp.page + 1] = {}
		end

		table.insert(temp_list[temp.page + 1],temp)
	end
	-- gf_print_table(temp_list, "temp_list")
	return temp_list

	-- local temp_list = {}
	-- local index = 0
	-- for k,v in ipairs(item_data or {}) do
	-- 	local item = gf_getItemObject("itemSys"):get_item_for_id(v.protoId)
	-- 	if gf_getItemObject("itemSys"):get_item_for_id(v.protoId).mount_exp > 0 and v.num > 0 then
	-- 		local temp = {}
	-- 		temp.item = v
	-- 		temp.page = math.ceil((index + 1) / HORSE_MEMORY_ITEM_COUNT) - 1
	-- 		temp.index = math.floor(index % HORSE_MEMORY_ITEM_COUNT) 
	-- 		temp.is_select = false
			
	-- 		index = index + 1

	-- 		if not temp_list[temp.page + 1] then
	-- 			temp_list[temp.page + 1] = {}
	-- 		end

	-- 		table.insert(temp_list[temp.page + 1],temp)

	-- 	end
	-- end
	-- -- gf_print_table(temp_list, "temp_list")
	-- return temp_list
end
function memorySet:page_view_init(data)
	for i,v in ipairs(data or {}) do
		self:update_item(v)
	end
	-- gf_print_table(self.data, "self.data:")
end

function memorySet:get_page_data(page,index)
	if self.data[page + 1][index + 1] then
		return self.data[page + 1][index + 1]
	end
	

	return nil
end

function memorySet:update_item(data)
	gf_print_table(data, "data::::")
	local item = self.page_view:GetChild(data.page + 1):GetChild(data.index)

	if not data.is_select then
		item.transform:FindChild("select").gameObject:SetActive(false)
	else
		item.transform:FindChild("select").gameObject:SetActive(true)
	end

	local item_info = ConfigMgr:get_config("item")[data.item_id]
	if item_info.bind == 1 then
		item.transform:FindChild("binding").gameObject:SetActive(true)
	else
		item.transform:FindChild("binding").gameObject:SetActive(false)
	end

	local icon_node = item.transform:FindChild("icon")
	icon_node.gameObject:SetActive(true)
	local icon = icon_node:GetComponent(UnityEngine_UI_Image)
	-- gf_setImageTexture(icon, icon_res)

	local bg = item:GetComponent(UnityEngine_UI_Image)

	gf_set_item(data.item_id, icon, bg)
end


function memorySet:item_click(index)
	local cur_page = self.scroll_view:GetCurrentPageIndex()
	local data = self:get_page_data(cur_page, index)
	if not next(data or {}) then
		return
	end
	data.is_select = not data.is_select
	self:update_item(data)
end

function memorySet:save_click()
	local temp = {}
	for i,v in ipairs(self.data or {}) do
		for ii,vv in ipairs(v or {}) do
			if vv.is_select then
				table.insert(temp,vv.item_id)
			end
		end
	end
	if not next(temp or {}) then
		gf_message_tips(commom_string[1])
		return
	end
	gf_getItemObject("horse"):send_to_save_memory(temp)
end

--鼠标单击事件
function memorySet:on_click( obj, arg)
    local event_name = obj.name
    if string.find(event_name , "s_item") then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(obj.transform:GetSiblingIndex())

    elseif event_name == "save_memory" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:save_click()
    
    elseif event_name == "set_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

   	elseif event_name == "memory_set_btn_help" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		gf_show_doubt(1003)

    end
end

-- 释放资源
function memorySet:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function memorySet:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "RmItemToFeedMemoryR") then
			self:dispose()
		end
	end
end

return memorySet