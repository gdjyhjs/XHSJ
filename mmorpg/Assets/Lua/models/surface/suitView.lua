--[[--
-- 套装
-- @Author:Seven
-- @DateTime:2017-09-22 22:26:14
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LocalString = 
{
	[ServerEnum.COMBAT_ATTR.ATTACK] 	= gf_localize_string("   攻击      +"),
	[ServerEnum.COMBAT_ATTR.HP] 		= gf_localize_string("   生命      +"),
	[ServerEnum.COMBAT_ATTR.PHY_DEF] 	= gf_localize_string("   物防      +"),
	[ServerEnum.COMBAT_ATTR.MAGIC_DEF] 	= gf_localize_string("   法防      +"),

	[ServerEnum.COMBAT_ATTR.CRIT] 	= gf_localize_string("   暴击      +"),
	[ServerEnum.COMBAT_ATTR.HIT] 		= gf_localize_string("   命中      +"),
	[ServerEnum.COMBAT_ATTR.DODGE] 	= gf_localize_string("   闪避      +"),
	[ServerEnum.COMBAT_ATTR.THROUGH] 	= gf_localize_string("   穿透      +"),

	[ServerEnum.COMBAT_ATTR.CRIT_DEF] 	= gf_localize_string("   坚韧      +"),
	[ServerEnum.COMBAT_ATTR.DAMAGE_DOWN] 		= gf_localize_string("   免伤      +"),
	[ServerEnum.COMBAT_ATTR.BLOCK] 	= gf_localize_string("   格挡："),
	[ServerEnum.COMBAT_ATTR.CRIT_HURT_PROB] 	= gf_localize_string("   暴击伤害率      +"),

	[ServerEnum.COMBAT_ATTR.PHY_DEF_PROB] 	= gf_localize_string("   物防率      +"),
	[ServerEnum.COMBAT_ATTR.MAGIC_DEF_PROB] 		= gf_localize_string("   法防率      +"),
	[ServerEnum.COMBAT_ATTR.CRIT_PROB] 		= gf_localize_string("   暴击率      +"),
	[ServerEnum.COMBAT_ATTR.HIT_PROB] 	= gf_localize_string("   命中率      +"),
	[ServerEnum.COMBAT_ATTR.DODGE_PROB] 	= gf_localize_string("   闪避率      +"),

	[ServerEnum.COMBAT_ATTR.THROUGH_PROB] 	= gf_localize_string("   穿透率      +"),
	[ServerEnum.COMBAT_ATTR.CRIT_DEF_PROB] 		= gf_localize_string("   坚韧率      +"),
	[ServerEnum.COMBAT_ATTR.DAMAGE_DOWN_PROB] 		= gf_localize_string("   免伤率      +"),
	[ServerEnum.COMBAT_ATTR.BLOCK_PROB] 	= gf_localize_string("   格挡率      +"),
	[ServerEnum.COMBAT_ATTR.RECOVER] 	= gf_localize_string("   回血值      +"),

	[ServerEnum.COMBAT_ATTR.RECOVER_PROB] 	= gf_localize_string("   回血率      +"),
	[ServerEnum.COMBAT_ATTR.FINAL_DAMAGE_PROB] 	= gf_localize_string("   伤害率      +"),
}

local AttrTitle = 
{
	two = "两件套<color=#%s>(%d/2)</color>",
	four = "三件套<color=#%s>(%d/3)</color>",
	five = "四件套<color=#%s>(%d/4)</color>",
}

local ColorValue = 
{
	open = "18A700FF", -- 开启颜色
	lock = "D01212FF", -- 未开启
}

local SuitLoopX = 
{
	[1] = 231.55,
	[2] = 173.3,
	[3] = 115.05,
	[4] = 56.8,
	[5] = -1.45,
}

local SuitView=class(UIBase,function(self,item_obj)
	self:set_bg_visible(true)
	self.select_suit = nil -- 选中的套装

    UIBase._ctor(self, "appearance_suits.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function SuitView:on_asset_load(key,asset)
	self:init_ui()
end

function SuitView:init_ui()
	self:init_suit_loop()
	self:init_surface_loop()
	self:init_two_loop()
	self:init_four_loop()
	self:init_five_loop()

	--self:select_suit_item(self.suit_loop:GetItem(1))
	self:select_suit_item(self.select_index)
end

-- 初始化左边滚动列表
function SuitView:init_suit_loop()
	self.suit_loop = self.refer:Get("suit_loop")
	self.suit_loop.onItemRender = handler(self, self.update_suit_item)
	self.select_index = 1
	self:refresh_suit(self.item_obj:get_suit_config())
end

function SuitView:refresh_suit( data )
	self.suit_data = data
	self.suit_loop.data = data
	self.suit_loop:Refresh(-1,-1)
end

function SuitView:update_suit_item( item, index )
	local data = self.suit_data[index]
	if not data then
		item.gameObject:SetActive(false)
		return
	end
	item.gameObject:SetActive(true)
	item.data = data
	-- 设置图标
	gf_setImageTexture(item:Get(2), data.icon)
	-- 设置品质
	gf_set_quality_bg(item:Get(5), data.color)

	local unlock_count = self.item_obj:get_suit_unlock_count(data)
	data.unlock_count = unlock_count

	-- 设置解锁数量
	if 2 <= unlock_count then
		item:Get(3).text = "<color=#18A700FF>" .. unlock_count.."/"..#data.element .. "</color>"
	else
		item:Get(3).text = "<color=#D01212FF>" .. unlock_count.."/"..#data.element .. "</color>"
	end
	-- 名字
	item:Get(4).text = data.name

	if self.select_index == index then
		item:Get(1):SetActive(true)
	else
		item:Get(1):SetActive(false)
	end
	item.name = "enhanceItem" .. index
end

-- 初始外观
function SuitView:init_surface_loop()
	self.surface_loop = self.refer:Get("surface_loop")
	self.surface_loop.onItemRender = handler(self, self.update_surface_item)
end

function SuitView:refresh_surface( data )
	self.surface_data = data
	if #data > 0 then
		local x = SuitLoopX[#data]
		if #data > 5 then
			x = SuitLoopX[5]
		end
		self.refer:Get("surface_loop_rt").anchoredPosition = Vector2(x, self.refer:Get("surface_loop_rt").anchoredPosition.y)
	end
	self.surface_loop.totalCount = #data
	self.surface_loop:RefillCells(0)
end

function SuitView:update_surface_item( item, index )
	local data = self.surface_data[index]
	if not data then
		return
	end
	item.data = data

	-- 设置图标
	local item_id
	if data.prefix_surface_id > 0 then
		item_id = ConfigMgr:get_config("surface")[data.surface_id].need_item[1]
	else
		item_id = data.need_item[1]
	end
	gf_set_item(item_id, item:Get(1), item:Get(3))

	-- 是否解锁
	item:Get(2):SetActive(not self.item_obj:is_unlock(data.surface_id))
end

-- 初始换两套描述列表
function SuitView:init_two_loop()
	self.two_loop = self.refer:Get("two_loop")
	self.two_loop.onItemRender = handler(self, self.update_two_item)
end

function SuitView:refresh_two( data )
	self.two_data = data
	self.two_loop.totalCount = #data
	self.two_loop:RefillCells(0)
end

function SuitView:update_two_item( item, index )
	local data = self.two_data[index]
	if not data then
		item:Get(1).text = ""
		return
	end
	item.data = data
	item:Get(1).text = data
end

-- 初始换两套描述列表
function SuitView:init_four_loop()
	self.four_loop = self.refer:Get("four_loop")
	self.four_loop.onItemRender = handler(self, self.update_four_item)
end

function SuitView:refresh_four( data )
	self.four_data = data
	self.four_loop.totalCount = #data
	self.four_loop:RefillCells(0)
end

function SuitView:update_four_item( item, index )
	local data = self.four_data[index]
	if not data then
		item:Get(1).text = ""
		return
	end
	item.data = data
	item:Get(1).text = data
end

-- 初始换两套描述列表
function SuitView:init_five_loop()
	self.five_loop = self.refer:Get("five_loop")
	self.five_loop.onItemRender = handler(self, self.update_five_item)
end

function SuitView:refresh_five( data )
	self.five_data = data
	self.five_loop.totalCount = #data
	self.five_loop:RefillCells(0)
end

function SuitView:update_five_item( item, index )
	local data = self.five_data[index]
	if not data then
		item:Get(1).text = ""
		return
	end
	item.data = data
	item:Get(1).text = data
end

-- 选中套装
function SuitView:select_suit_item(index)
	self.select_suit = self.suit_data[index]
	self:refresh_surface(self.item_obj:get_suit_surface(self.select_suit))
	self:update_attr()
end

-- 更新套装属性加成
function SuitView:update_attr()
	-- 标题
	local unlock_count = self.item_obj:get_suit_unlock_count(self.select_suit)
	local color = unlock_count >= 2 and ColorValue.open or ColorValue.lock
	self.refer:Get("two_suit").text = string.format(AttrTitle.two, color,unlock_count > 2 and 2 or unlock_count)

	local color = unlock_count >= 3 and ColorValue.open or ColorValue.lock
	self.refer:Get("four_suit").text = string.format(AttrTitle.four, color,unlock_count > 3 and 3 or unlock_count)

	local color = unlock_count >= 4 and ColorValue.open or ColorValue.lock
	self.refer:Get("five_suit").text = string.format(AttrTitle.five, color,unlock_count > 4 and 4 or unlock_count)

	local two_data = {}
	for i,v in ipairs(self.select_suit.exist2_attr) do
		two_data[i] = LocalString[v[1]]..v[2]
	end
	self:refresh_two(two_data)

	local four_data = {}
	for i,v in ipairs(self.select_suit.exist3_attr) do
		four_data[i] = LocalString[v[1]]..v[2]
	end
	self:refresh_four(four_data)

	local five_data = {}
	for i,v in ipairs(self.select_suit.exist4_attr) do
		five_data[i] = LocalString[v[1]]..v[2]
	end
	self:refresh_five(five_data)
end

-- 一键穿上
function SuitView:wear_surface()
	local have = false
	local have_wear_count = 0
	for i,v in ipairs(self.select_suit.element) do
		local data = ConfigMgr:get_config("surface")[v]
		local surface_id = self.item_obj:get_wear_surface_id(data.type)
		if self.item_obj:is_unlock(v) and (surface_id == 0 or surface_id ~= data.surface_id) then
			self.item_obj:wear_surface_c2s(data.surface_id)
			have = true
		end
		if self.item_obj:is_unlock(v) and surface_id ~= 0 and surface_id == data.surface_id then
			have_wear_count = have_wear_count + 1
		end
	end
	if have then
		gf_message_tips(gf_localize_string("穿戴完成"))
	else
		if #self.select_suit.element == have_wear_count then
			gf_message_tips(gf_localize_string("都已穿戴"))
		else
			gf_message_tips(gf_localize_string("没有可穿戴套装"))
		end
	end
end

function SuitView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "suit_close_btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		local item = LuaItemManager:get_item_obejct("surface")
	    item:add_to_state()
		self:dispose()

	elseif string.find(cmd,"enhanceItem") then -- 点击左边套装
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local index = string.gsub(cmd,"enhanceItem","")
		index = tonumber(index)
		if self.select_index ~= index then
			local last_index = self.select_index
			self.select_index = index
			self.suit_loop:Refresh(last_index - 1, last_index - 1)
			self.suit_loop:Refresh(self.select_index - 1, self.select_index - 1)
			self:select_suit_item(index)
		end

	elseif cmd == "wear_btn" then -- 穿戴套装
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:wear_surface()

	elseif cmd == "suits_item" then -- 点击物品，显示物品tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		LuaItemManager:get_item_obejct("itemSys"):prop_tips(arg.data.need_item[1])
	end
end

function SuitView:on_receive( msg, id1, id2, sid )
	
end

function SuitView:register()
	StateManager:register_view( self )
end

function SuitView:cancel_register()
	StateManager:remove_register_view( self )
end

function SuitView:on_showed()
	self:register()
end

function SuitView:on_hided()
	self:cancel_register()
end

-- 释放资源
function SuitView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return SuitView

