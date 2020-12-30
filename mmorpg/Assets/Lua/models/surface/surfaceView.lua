--[[--
-- 外观
-- @Author:Seven
-- @DateTime:2017-09-20 11:12:49
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local UIModel = require("common.UI3dModel")

local LocalString = 
{
	[ServerEnum.COMBAT_ATTR.ATTACK] 	= gf_localize_string("攻击："),
	[ServerEnum.COMBAT_ATTR.HP] 		= gf_localize_string("生命："),
	[ServerEnum.COMBAT_ATTR.PHY_DEF] 	= gf_localize_string("物防："),
	[ServerEnum.COMBAT_ATTR.MAGIC_DEF] 	= gf_localize_string("法防："),

	[ServerEnum.COMBAT_ATTR.CRIT] 	= gf_localize_string("暴击："),
	[ServerEnum.COMBAT_ATTR.HIT] 		= gf_localize_string("命中："),
	[ServerEnum.COMBAT_ATTR.DODGE] 	= gf_localize_string("闪避："),
	[ServerEnum.COMBAT_ATTR.THROUGH] 	= gf_localize_string("穿透："),

	[ServerEnum.COMBAT_ATTR.CRIT_DEF] 	= gf_localize_string("坚韧："),
	[ServerEnum.COMBAT_ATTR.DAMAGE_DOWN] 		= gf_localize_string("免伤："),
	[ServerEnum.COMBAT_ATTR.BLOCK] 	= gf_localize_string("格挡："),
	[ServerEnum.COMBAT_ATTR.CRIT_HURT_PROB] 	= gf_localize_string("暴击伤害率："),

	[ServerEnum.COMBAT_ATTR.PHY_DEF_PROB] 	= gf_localize_string("物防率："),
	[ServerEnum.COMBAT_ATTR.MAGIC_DEF_PROB] 		= gf_localize_string("法防率："),
	[ServerEnum.COMBAT_ATTR.CRIT_PROB] 		= gf_localize_string("暴击率："),
	[ServerEnum.COMBAT_ATTR.HIT_PROB] 	= gf_localize_string("命中率："),
	[ServerEnum.COMBAT_ATTR.DODGE_PROB] 	= gf_localize_string("闪避率："),

	[ServerEnum.COMBAT_ATTR.THROUGH_PROB] 	= gf_localize_string("穿透率："),
	[ServerEnum.COMBAT_ATTR.CRIT_DEF_PROB] 		= gf_localize_string("坚韧率："),
	[ServerEnum.COMBAT_ATTR.DAMAGE_DOWN_PROB] 		= gf_localize_string("免伤率："),
	[ServerEnum.COMBAT_ATTR.BLOCK_PROB] 	= gf_localize_string("格挡率："),
	[ServerEnum.COMBAT_ATTR.RECOVER] 	= gf_localize_string("回血值："),

	[ServerEnum.COMBAT_ATTR.RECOVER_PROB] 	= gf_localize_string("回血率："),
	[ServerEnum.COMBAT_ATTR.FINAL_DAMAGE_PROB] 	= gf_localize_string("伤害率："),
}

-- 左边按钮值
local LeftBtnKey = 
{
	[1] = ServerEnum.SURFACE_TYPE.CLOTHES,
	[2] = ServerEnum.SURFACE_TYPE.WEAPON,
	[3] = ServerEnum.SURFACE_TYPE.CARRY_ON_BACK,
	[4] = ServerEnum.SURFACE_TYPE.SURROUND,
	[5] = ServerEnum.SURFACE_TYPE.TALK_BG,
}

local SurfaceView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)

	self.bag_item = LuaItemManager:get_item_obejct("bag")
    self.item_obj=item_obj
    self.select_data = nil -- 选中的item 数据
    Asset._ctor(self, "appearance.u3d") -- 资源名字全部是小写
end)

-- 资源加载完成
function SurfaceView:on_asset_load(key,asset)
	self:init_ui()
	self.is_init = true
end

function SurfaceView:init_ui()
	self.name = self.refer:Get("name") -- 名字
	self.des = self.refer:Get("des") -- 描述
	self.attr_1 = self.refer:Get("attr_1") -- 属性描述1
	self.attr_2 = self.refer:Get("attr_2") -- 属性描述2
	self.attr_3 = self.refer:Get("attr_3") -- 属性描述3
	self.attr_4 = self.refer:Get("attr_4") -- 属性描述4

	self.surface_name = self.refer:Get("surface_name") -- 选中的解锁物品名字
	self.consume_item_txt = self.refer:Get("consume_item_txt") -- 消耗物品描述
	self.surface_count_txt = self.refer:Get("surface_count_txt") -- 此物品是否解锁
	self.item_count_txt = self.refer:Get("item_count_txt") -- 解锁需要的物品数量

	self.lock_obj = self.refer:Get("lock")
	self.unlock_obj = self.refer:Get("unlock")
	self.unlock_txt = self.refer:Get("unlock_txt")
	self.unlock_btn = self.refer:Get("unlock_btn")
	self.unlock_btn_txt = self.refer:Get("unlock_btn_txt")

	self.suit_btn = self.refer:Get("suit_btn") -- 套装按钮

	-- 聊天气泡
	self.chat_bg = self.refer:Get("chat_bg")
	self.chat_bg_img = self.refer:Get("chat_bg_img")
	self.chat_bg:SetActive(false)
	self.chat_txt = self.refer:Get("chat_txt") -- 气泡文字

	self:init_model()
	self:init_page()
	self:init_left_btn_list()
	self:init_right_btn_list()
	self:init_color_list()

	self:select_right_btn(1)
	if self.item_obj.surface_id == nil then
		self:select_left_btn(1, true)
	else
		self:update_ui_by_surface_id()
		self.item_obj.surface_id = nil
	end
end

-- 刷新ui显示
function SurfaceView:update_ui()
	self.name.text = self.select_data.name -- 名字
	self.des.text = self.select_data.des -- 描述

	local per_lock = false
	if self.select_data.prefix_surface_id > 0 then
		per_lock = not self.item_obj:is_unlock(self.select_data.prefix_surface_id)
	end

	local is_lock = not self.item_obj:is_unlock(self.select_data.surface_id)
	-- 属性加成显示
	for i=1,4 do
		local d = self.select_data.attr[i]
		local attr = self["attr_"..i]
		if d then
			attr.gameObject:SetActive(true)
			attr.text = LocalString[d[1]]..d[2]
		else
			attr.gameObject:SetActive(false)
		end
	end

	self.lock_obj:SetActive(is_lock)
	self.unlock_obj:SetActive(not is_lock)
	self.unlock_btn:SetActive(true)

	if is_lock then
		if self.select_data.unlock_tips then -- 套装的处理
			self.unlock_btn:SetActive(false)
			self.unlock_txt.text = self.select_data.unlock_tips
			self.lock_obj:SetActive(false)
			self.unlock_obj:SetActive(true)
		else
			if self.select_data.prefix_surface_id == 0 then -- 没有前置外观
				self.surface_name.text = gf_localize_string("无")
				self.surface_count_txt.text = ""
			else
				self.surface_name.text = self.select_data.name -- 选中的解锁物品名字
				self.surface_count_txt.text = (is_lock and per_lock) and "<color=#FF0000FF>0/1</color>" or "<color=#914A1DFF>1/1</color>"
			end

			local need_item = self.select_data.need_item[1]
			if need_item then
				self.consume_item_txt.text = ConfigMgr:get_config("item")[need_item].name -- 消耗物品描述
			else
				self.consume_item_txt.text = ""
			end
			

			-- 玩家拥有的物品数量
			local item_count = 0
			local need_count = 0
			if need_item then
				item_count = self.bag_item:get_item_count(need_item,ServerEnum.BAG_TYPE.NORMAL)
				need_count = self.select_data.need_item[2]
			end

			if not need_count then
				gf_error_tips("没有配置需要物品数量！请检查配置表need_item！！！")
			end

			self.item_count_txt.text = item_count >= need_count and string.format("<color=#914A1DFF>%d/%d</color>", item_count, need_count) or
			string.format("<color=#FF0000FF>%d/%d</color>", item_count, need_count)

			self.unlock_btn.name = "unlock_btn"
			self.unlock_btn_txt.text = gf_localize_string("解锁")

			self.is_can_unlock = item_count >= need_count and not per_lock -- 是否可以解锁
			if self.is_can_unlock then
				self.refer:Get("unlock_red_point"):SetActive(true)
			end
		end
	else
		self.unlock_txt.text = self.select_data.des_ex

		-- print("外观",self.item_obj:get_wear_surface_id(self.last_left_index),self.select_data.surface_id)
		if self.item_obj:get_wear_surface_id(LeftBtnKey[self.last_left_index]) == self.select_data.surface_id then -- 选中的外观是已经穿上的
			self.unlock_btn.name = "unwear_btn"
			self.unlock_btn_txt.text = gf_localize_string("卸下")
			
		else
			-- 未穿
			self.unlock_btn.name = "wear_btn"
			self.unlock_btn_txt.text = gf_localize_string("穿戴")
		end

		self.refer:Get("unlock_red_point"):SetActive(false)
		self.is_can_unlock = false
	end

	-- 是否是套装
	self.suit_btn:SetActive(self.item_obj:is_suit(self.select_data.surface_id))

	if self.last_select_page_item then
		if self.select_data.prefix_surface_id == 0 then
			self.last_select_page_item:Get(3):SetActive(is_lock)
		else
			self.last_select_page_item:Get(3):SetActive(per_lock)
		end
	end

	if self.last_select_color_item then
		self.last_select_color_item:Get(2):SetActive(is_lock)
	end
end

-- 清除ui显示
function SurfaceView:clear_ui()
	self.select_data = nil

	self.name.text = "" -- 名字
	self.des.text = "" -- 描述

	-- 属性加成显示
	for i=1,4 do
		local attr = self["attr_"..i]
		attr.gameObject:SetActive(false)
	end

	self.surface_name.text = "" -- 选中的解锁物品名字
	self.consume_item_txt.text = "" -- 消耗物品描述
	self.surface_count_txt.text = ""
	self.item_count_txt.text = ""

	if not self.last_select_page_item and #self.page_data == 0 then
		self.unlock_txt.text = gf_localize_string("暂时没有解锁任何外观，请继续努力")
	else
		self.unlock_txt.text = ""
	end

	self.is_can_unlock = false -- 是否可以解锁
	self.unlock_btn:SetActive(false)
	self.suit_btn:SetActive(false)
	self.lock_obj:SetActive(false)
	self.unlock_obj:SetActive(true)
end

-- 更新气泡
function SurfaceView:update_chat_bg(img_name, prefab)
	if not img_name and not prefab then
		self.chat_bg:SetActive(false)
	else
		self.chat_bg:SetActive(true)
	end

	if img_name then
		gf_setImageTexture(self.chat_bg_img, img_name)
		if self.select_data.font_color then
			self.chat_txt.text = string.format(gf_localize_string("<color=#%s>你好啊！</color>"),self.select_data.font_color)
		end
	end

	if prefab then
		Loader:get_resource(
			prefab..".u3d", 
			function( req )
				local root = LuaHelper.Instantiate(req.data)
				root.transform.parent = self.chat_bg.transform
				root.transform.localScale = Vector3(1,1,1)
				local rt = LuaHelper.GetComponent(root, "UnityEngine.RectTransform")
				rt.anchoredPosition = Vector2(0,0)
				rt.sizeDelta = Vector2(0,0)

				if self.chat_prefab then
					LuaHelper.Destroy(self.chat_prefab)
					self.chat_prefab = nil
				end
				self.chat_prefab = root
			end,
			function()
				gf_error_tips(string.format("找不到prefab：%s",prefab))
			end
		)
	end
end

function SurfaceView:init_page()
	self.slider_page = self.refer:Get("ScrollPage")
	self.slider_page.OnUpdateFn = handler(self, self.update_page_item)
end

-- 初始左边页签
function SurfaceView:init_left_btn_list()
	self.left_btn_list = {}
	self.left_red_point_list = {}
	for i=1,#LeftBtnKey do
		self.left_btn_list[i] = self.refer:Get("hl_"..i)
		self.left_red_point_list[i] = self.refer:Get("left_red_point_"..i)
	end

	self.last_left_index = 0

	self:refresh_left_btn_red_point()
end

-- 选中左边某个页签
function SurfaceView:select_left_btn( index, first )
	print("选中左边某个页签",index)
	self.is_first = first or false

	if self.last_left_index == index and not self.is_first then
		return
	end

	if self.last_left_index ~= 0 then
		self.left_btn_list[self.last_left_index]:SetActive(false)
	end
	self.left_btn_list[index]:SetActive(true)
	self.last_left_index = index

	-- 刷新页面数据
	local page_data
	if self.last_right_btn_index == 1 then
		page_data = self.item_obj:get_data(index) 
	else
		page_data = self.item_obj:get_own_surface(index) 
	end
	self:refresh_page(page_data)

	if LeftBtnKey[index] ~= ServerEnum.SURFACE_TYPE.TALK_BG then
		self.chat_bg:SetActive(false)
	end
end

-- 刷新左边页签红点
function SurfaceView:refresh_left_btn_red_point()
	for i,v in ipairs(LeftBtnKey) do
		self.left_red_point_list[i]:SetActive(self.item_obj:get_red_point_ty(v))
	end
end

-- 选中页面上某个item
function SurfaceView:select_page_item( item )
	self.is_first = false

	if self.last_select_page_item == item then
		return
	end

	if not item.data then
		return
	end

	if self.last_select_page_item then
		self.last_select_page_item:Get(2):SetActive(false) -- 取消上一个选中
	end
	item:Get(2):SetActive(true)
	self.last_select_page_item = item

	local data = item.data
	local color_data = {}
	if data then
		color_data = self.item_obj:get_same_diff_color(data.surface_id)
		local list = {}
		if self.last_right_btn_index == 2 then -- 去掉没解锁的
			for i,v in ipairs(color_data) do
				if self.item_obj:is_unlock(v.surface_id) then
					list[#list+1] = v
				end
			end
			color_data = list
		end
	end
	self:refresh_color(color_data)
end

function SurfaceView:select_page_item_by_surface_id( surface_id )
	for i,v in ipairs(self.page_data or {}) do
		if v.surface_id == surface_id then
			local page = math.floor((i - 1) / 12) + 1
			self.slider_page:SetPageIndex(page)
			local index = (i - 1) % 12 + 1
			self:select_page_item(self.slider_page:GetItem(index))
			break
		end
		local color_data = self.item_obj:get_same_diff_color(v.surface_id)
		for j,c in ipairs(color_data or {}) do
			if c.surface_id == surface_id then
				local page = math.floor((i - 1) / 12) + 1
				self.slider_page:SetPageIndex(page)
				local index = (i - 1) % 12 + 1
				self:select_page_item(self.slider_page:GetItem(index))
				break
			end
		end
	end
end

-- 选中颜色item
function SurfaceView:select_color_item( item )
	if self.last_select_color_item == item then
		return
	end

	if self.last_select_color_item then
		self.last_select_color_item:Get(3):SetActive(false)
	end
	item:Get(3):SetActive(true)
	self.last_select_color_item = item

	-- 刷新ui界面
	self.select_data = item.data
	self:update_ui()
	self:update_model()
	self:update_chat_bg(self.select_data.chat_img, self.select_data.chat_prefab)
end

function SurfaceView:select_color_item_by_surface_id( surface_id )
	-- print("选择套装颜色",surface_id,self.color_data)
	local have = false
	for i,v in ipairs(self.color_data or {}) do
		-- print("选择套装颜色",v.surface_id,surface_id)
		if v.surface_id == surface_id then
			self:select_color_item(self.color_loop:GetItem(i))
			have = true
			break
		end
	end
	if not have then
		if self.color_data ~= nil and self.color_data[1] ~= nil then
			self:select_color_item(self.color_loop:GetItem(1))
		end
	end
end

-- 初始化右边页签
function SurfaceView:init_right_btn_list()
	self.right_btn_list = {
		self.refer:Get("all_hl"),
		self.refer:Get("own_hl"),
	}
	self.last_right_btn_index = 0
end

-- 选中右边某个页签
function SurfaceView:select_right_btn( index )
	if self.last_right_btn_index == index then
		return
	end

	if self.last_right_btn_index ~= 0 then
		self.right_btn_list[self.last_right_btn_index]:SetActive(false)
	end
	self.right_btn_list[index]:SetActive(true)
	self.last_right_btn_index = index
end

-- 初始颜色列表
function SurfaceView:init_color_list()
	self.color_loop = self.refer:Get("color_loop")
	self.color_loop.onItemRender = handler(self, self.update_color_item)
end

-- 刷新页面数据
function SurfaceView:refresh_page( data )
	self.page_data = data
	self.last_select_page_item = nil
	--[[local list = {}
	for i,v in ipairs(data) do
		local temp = gf_deep_copy(v)
		temp.index = i
		table.insert(list,temp)
	end]]
	self.slider_page:SetData(self.page_data)
	if #data > 0 then
		if self.is_first then
			self.is_first_color = true
			-- 如果第一次打开ui，有穿时装默认选择穿的时装，没有就不选中
			if not self.surface_id then
				local surface_id = self.item_obj:get_wear_surface_id(LeftBtnKey[self.last_left_index])
				if surface_id > 0 then
					self:select_page_item_by_surface_id(surface_id)
				else
					if self.page_data[1] ~= nil then
						self:select_page_item_by_surface_id(self.page_data[1].surface_id)
					else
						self:refresh_color({})
					end
				end
			end
		else
			self:select_page_item(self.slider_page:GetItem(1))
		end

	else
		self:refresh_color({})
	end
end

-- 更新页面
function SurfaceView:update_page_item( item )
	if item.data ~= nil then
		local index = (item.page - 1) * 12 + item.index
		local data = self.page_data[index]
		
		if not data then
			print("外观1",item.index)
			-- 清除
			item:Get(1).gameObject:SetActive(false)
			item:Get(2):SetActive(false)
			item:Get(3):SetActive(false)
			gf_setImageTexture(item:Get(4), "item_color_0")
			return
		end

		-- 设置图标
		item:Get(1).gameObject:SetActive(true)
		local item_id
		if data.prefix_surface_id > 0 then
			item_id = ConfigMgr:get_config("surface")[data.surface_id].need_item[1]
		else
			item_id = data.need_item[1]
		end
		print("update_page_item",data.surface_id,item_id)
		if item_id then
			gf_set_item(item_id, item:Get(1), item:Get(4))
		else
			gf_setImageTexture(item:Get(1), data.icon)
			gf_setImageTexture(item:Get(4), "item_color_2")
		end
		if self.select_data and ( self.select_data.surface_id == data.surface_id 
								or (self.select_data.prefix_surface_id > 0 and self.select_data.prefix_surface_id == data.surface_id) ) then
			item:Get(2):SetActive(true) -- 选中图标
		else
			item:Get(2):SetActive(false) -- 选中图标
		end
		item:Get(3):SetActive(data.is_lock) -- 是否解锁
		-- 是否需要显示红点
		item:Get(5):SetActive(self.item_obj:get_red_point(data))
	else
		item:Get(1).gameObject:SetActive(false)
		item:Get(2):SetActive(false)
		item:Get(3):SetActive(false)
		gf_setImageTexture(item:Get(4), "item_color_0")
		item:Get(5):SetActive(false)
	end
end

-- 设置颜色列表数据
function SurfaceView:refresh_color( data )
	self.color_data = data
	self.color_loop.totalCount = #data
	self.color_loop:RefillCells(0)
	self.last_select_color_item = nil
	if #data > 0 then
		if self.is_first_color then
			-- 如果第一次打开ui，有穿时装默认选择穿的时装，没有就不选中
			if not self.surface_id then
				local surface_id = self.item_obj:get_wear_surface_id(LeftBtnKey[self.last_left_index])
				if surface_id > 0 then
					self:select_color_item_by_surface_id(surface_id)
				else
					if data[1] ~= nil then
						self:select_color_item_by_surface_id(data[1].surface_id)
					else
						self:clear_ui()
					end
				end
			end
		else
			self:select_color_item(self.color_loop:GetItem(1))
		end
		self.is_first_color = false
	else
		self:clear_ui()
		self.color_loop:GetItem(0).gameObject:SetActive(false)
	end
end

-- 更新颜色列表
function SurfaceView:update_color_item( item, index )
	if not self.color_data then
		item.gameObject:SetActive(false)
		return
	end

	local data = self.color_data[index]
	if not data then
		item.gameObject:SetActive(false)
		return
	end
	item.gameObject:SetActive(true)
	item.data = data

	-- 颜色
	item:Get(1).color = gf_get_color2("#"..data.color) -- 设置颜色
	item:Get(2):SetActive(not self.item_obj:is_unlock(data.surface_id)) -- 是否解锁
	item:Get(3):SetActive(false) -- 选中
end

-- 初始化人物模型
function SurfaceView:init_model()
	if self.ui_model then
		self.ui_model:dispose()
	end
	
	self.ui_model = UIModel(self.refer:Get("model"))
	self.ui_model:set_player(true)
	self.ui_model:set_career()
	self.ui_model:set_local_position(Vector3(0,-1.5,3))
	self.ui_model:set_model()
	self.ui_model:set_weapon()
	self.ui_model:set_wing()
	self.ui_model:set_surround()
	self.ui_model:load_model()
end

-- 更新模型
function SurfaceView:update_model()
	local key = LeftBtnKey[self.last_left_index]
	if key == ServerEnum.SURFACE_TYPE.CLOTHES then
		self.ui_model:set_finish_cb(handler(self, self.on_model_finish))
		self.ui_model:set_model(self.select_data.model)
		self.ui_model:set_material_img(self.select_data.model_img)
		self.ui_model:load_clothes()
		local wing_id = self.item_obj:get_wear_surface_model(ServerEnum.SURFACE_TYPE.CARRY_ON_BACK)
		if wing_id == nil then
			self.ui_model:set_wing()
		end
	elseif key == ServerEnum.SURFACE_TYPE.WEAPON then
		self.ui_model:set_weapon(self.select_data.model)
		self.ui_model:set_weapon_flow_img(self.select_data.flow_img, self.select_data.flow_color, self.select_data.flow_speed)
		self.ui_model:set_weapon_img(self.select_data.model_img)
		self.ui_model:set_weapon_effect(self.select_data.effect)
		local wing_id = self.item_obj:get_wear_surface_model(ServerEnum.SURFACE_TYPE.CARRY_ON_BACK)
		if wing_id == nil then
			self.ui_model:set_wing()
		end
	elseif key == ServerEnum.SURFACE_TYPE.CARRY_ON_BACK then
		self.ui_model:set_wing(self.select_data.model)
		self.ui_model:set_wing_flow_img(self.select_data.flow_img, self.select_data.flow_color, self.select_data.flow_speed)
		self.ui_model:set_wing_img(self.select_data.model_img)
		self.ui_model:set_wing_effect(self.select_data.effect)

	elseif key == ServerEnum.SURFACE_TYPE.SURROUND then
		self.ui_model:set_surround(self.select_data.model)
		local wing_id = self.item_obj:get_wear_surface_model(ServerEnum.SURFACE_TYPE.CARRY_ON_BACK)
		if wing_id == nil then
			self.ui_model:set_wing()
		end
	end
end

function SurfaceView:on_model_finish( model )
	model.animator:Play("change", 0)
	-- 换装特效
	self.refer:Get("41000105"):SetActive(true)
	-- self.refer:Get("41000106"):SetActive(true)
	local delay_fn = function()
		self.refer:Get("41000105"):SetActive(false)
		-- self.refer:Get("41000106"):SetActive(true)
	end
	delay(delay_fn, 1)
end

-- 通过设置外观id，跳转到对应的页签
function SurfaceView:set_surface_id( surface_id )
	self.surface_id = surface_id
	if self.is_init then
		self:update_ui_by_surface_id()
	end
end

function SurfaceView:goto_surface()
end
function SurfaceView:update_ui_by_surface_id()
	if self.surface_id then
		local data = ConfigMgr:get_config("surface")[self.surface_id]
		self:select_left_btn(data.type, true)
		self:select_page_item_by_surface_id(self.surface_id)
		self:select_color_item_by_surface_id(self.surface_id)
		self.surface_id = nil
	end
end

function SurfaceView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("bag") then
		if id2 == Net:get_id2("bag", "ActiveSurfaceR") then
			gf_message_tips(string.format(gf_localize_string("解锁<color=%s>%s</color>成功"), gf_get_color_by_item(self.select_data.need_item[1]), self.select_data.name))
			self.select_data.is_lock = false
			self.touch_flag = false
			self:update_ui()
			self:refresh_left_btn_red_point()
			self.last_select_page_item:Get(5):SetActive(self.item_obj:get_red_point(self.select_data)) -- 红点

		elseif id2 == Net:get_id2("bag", "WearSurfaceR") then
			gf_message_tips(string.format(gf_localize_string("穿戴<color=%s>%s</color>成功"), gf_get_color_by_item(self.select_data.need_item[1]), self.select_data.name))
			self.touch_flag = false
			self:update_ui()
		elseif id2 == Net:get_id2("bag", "UnWearSurfaceR") then
			gf_message_tips(string.format(gf_localize_string("卸下<color=%s>%s</color>成功"), gf_get_color_by_item(self.select_data.need_item[1]), self.select_data.name))
			self.touch_flag = false
			self:update_ui()
			
		end
	end
end

function SurfaceView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "close_btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self.item_obj:remove_from_state()
		--self:dispose()

	elseif cmd == "unlock_btn" then -- 解锁
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if not self.is_can_unlock then
			gf_message_tips(gf_localize_string("尚未达成解锁条件"))
			return
		end
		local need_item = self.select_data.need_item[1]
		local count = LuaItemManager:get_item_obejct("bag"):get_item_count(need_item,ServerEnum.BAG_TYPE.NORMAL,true)
		if count <= 0  then
			local data = ConfigMgr:get_config("item")[need_item]
			need_item = data.rel_code
		end
		if LuaItemManager:get_item_obejct("setting"):is_lock(need_item) then
			return
		end
		if self.touch_flag then
			return
		end
		self.touch_flag = true
		print("解锁外观",self.select_data.surface_id,need_item,count)
		self.item_obj:active_surface_c2s(self.select_data.surface_id)

	elseif cmd == "wear_btn" then -- 穿戴
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.touch_flag then
			return
		end

		self.touch_flag = true
		self.item_obj:wear_surface_c2s(self.select_data.surface_id)

	elseif cmd == "unwear_btn" then -- 卸下
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.touch_flag then
			return
		end
		if self.select_data.surface_id == ConfigMgr:get_config("t_misc").surface.init_surface[LuaItemManager:get_item_obejct("game"):get_career()][1] then
			gf_message_tips(gf_localize_string("玩家默认套装不能卸下"))
			return
		end
		self.touch_flag = true
		self.item_obj:unwear_surface_c2s(LeftBtnKey[self.last_left_index])

	elseif string.find(cmd, "type_") then -- 左边也签
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- local list = string.split(cmd, "_")
		self:select_left_btn(arg.transform:GetSiblingIndex()+1, true)

	elseif cmd == "all" then -- 全部
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_right_btn(1)
		-- 刷新页面数据
		local page_data = self.item_obj:get_data(LeftBtnKey[self.last_left_index]) 
		self:refresh_page(page_data)

	elseif cmd == "own" then -- 拥有
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_right_btn(2)
		-- 刷新页面数据
		print("选择的也签",self.last_left_index)
		local page_data = self.item_obj:get_own_surface(LeftBtnKey[self.last_left_index]) 
		self:refresh_page(page_data)

	elseif cmd == "b_item" then -- 页面item
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_page_item(arg)
		--self.refer:Get("unlock_red_point"):SetActive(self.item_obj:get_red_point(arg.data))

	elseif cmd == "color_item" then -- 颜色item
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_color_item(arg)

	elseif cmd == "suit_btn" then -- 套装btn
		print("打开套装界面")
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("suitView", self.item_obj)
		self.item_obj:remove_from_state()

	end
end

function SurfaceView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function SurfaceView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function SurfaceView:on_showed()
	self:register()
	self.select_data = nil
	if self.is_init then
		self.item_obj:get_surface_info_c2s()
		if self.item_obj.surface_id == nil then
			self:select_left_btn(1, true)
		else
			self.item_obj.surface_id = nil
		end
		self:init_model()
		self:refresh_left_btn_red_point()
	end
	if self.ui_model then
		self.ui_model:on_showed()
	end
end

function SurfaceView:on_hided( )
	self:cancel_register()
end

-- 释放资源
function SurfaceView:dispose()
	self:cancel_register()
	self.is_init = false

	if self.ui_model then
		self.ui_model:dispose()
		self.ui_model = nil
	end

    self._base.dispose(self)
end

return SurfaceView

