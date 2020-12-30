--[[ 
	新 军团申请界面 属性 废
	create at 17.10.30
	by xin
]]
local model_name = "alliance"

local res = 
{
	[1] = "legion_apply_list.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("你已经在军团中"),
}


local legionApply = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	self:set_bg_visible(true)
	UIBase._ctor(self, res[1], item_obj)
end)



--资源加载完成
function legionApply:on_asset_load(key,asset)
    self:init_ui()
    gf_getItemObject("legion"):alliance_list_c2s(1)
end

function legionApply:init_ui()
	self:scroll_view_init()
end

function legionApply:scroll_view_init()
	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)
	self.scroll_table.onBottom = handler(self, self.on_bottom)

	self:refresh({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19})
end

function legionApply:refresh( data )
	self.choose_index = nil
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end


function legionApply:update_item( item, index, data )
	-- -- 名字
	-- item:Get(1).text = data.name
	-- -- 等级
	-- item:Get(2).text = data.level
	-- -- 统帅
	-- item:Get(3).text = data.leader
	-- -- 资金 
	-- item:Get(4).text = data.fund or 0

	--是否被选中
	if self.choose_index == index then
		item:Get(7):SetActive(true) -- 高亮图片
		self.select_item = item
	else
		item:Get(7):SetActive(false) -- 高亮图片
	end
	

	-- local apply = self.item_obj:get_had_apply(data.id)
	-- self:set_item_status(item, apply)
end

-- 滚动到底端
function legionApply:on_bottom( item, index, data )
	-- self.begin_idx = index-1
	-- local page = math.floor(index/6) + 1
	-- if page > 1 and self.page < page then
	-- 	self.page = page
	-- 	self.item_obj:alliance_list_c2s(page)
	-- end
end


function legionApply:create_click()
	if gf_getItemObject("legion"):is_in() then
		gf_message_tips(commom_string[1])
		return
	end
	require("models.legion.legionCreate")()
end

function legionApply:one_key_apply_click()
end

function legionApply:application_click()
	gf_getItemObject("legion")
end

function legionApply:chat_click()
end

function legionApply:search_click()
end

function legionApply:check_availble_click(arg)
	arg:SetActive(not arg.activeSelf)
	self.is_availble = arg.activeSelf
	
end

function legionApply:update_ui( data )
	self.refer:Get(3)
	self.refer:Get(4)
	self.refer:Get(5)
end

function legionApply:item_click(item)
	self.choose_index = item.index + 1
	self:update_ui(item.data)
	if self.select_item then
		self.select_item:Get(7):SetActive(false) -- 高亮图片
	end
	item:Get(7):SetActive(true) -- 高亮图片
	self.select_item = item
end

--鼠标单击事件
function legionApply:on_click( obj, arg)
	local event_name = obj.name
	print("legionApply click",event_name)
    if event_name == "create_legion_btn" then 
    	self:create_click()

    elseif event_name == "legion_apply_close" then
    	self:dispose()

    elseif event_name == "one_key_apply_btn" then
    	self:one_key_apply_click(arg)

    elseif event_name == "application_btn" then
    	self:application_click(arg)

    elseif event_name == "chat_btn" then
    	self:chat_click()

    elseif event_name == "search_img" then
    	self:search_click()

    elseif event_name == "check_availble" then
    	self:check_availble_click(arg)

    elseif string.find(event_name,"preItem") then
    	self:item_click(arg)

    end
end

function legionApply:on_showed()
	print("legionApply on_showed")
	StateManager:register_view(self)
end

function legionApply:clear()
	StateManager:remove_register_view(self)
end

function legionApply:on_hided()
	self:clear()
end
-- 释放资源
function legionApply:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionApply:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "GetMyInfoR") then
		end
	end
end

return legionApply