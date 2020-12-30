--[[--
-- 魔域修炼
-- @Author:HuangJunShan
-- @DateTime:2017-09-04 09:51:18
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local BagUserData = require("models.bag.bagUserData")

local ZorkPracticeView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "zork_practice.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function ZorkPracticeView:on_asset_load(key,asset)
	-- 设置传送列表
	self.init = true
	self:init_ui()
	self:register()
end

function ZorkPracticeView:on_click(item_obj,obj,arg)
	print("点击魔域修炼按钮",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "close_zork" then -- 关闭ui
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd == "to_practice" then -- 选择要去的修炼场所
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_practice_item(obj.transform:GetSiblingIndex()+1)
	elseif cmd == "goPractice" then -- 传送
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(self.scene_list[self.select_index].map_id,nil,nil,nil,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	elseif cmd == "addPropBtn" then -- 快捷使用道具增加修炼时间
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:use_zork_practice_item()
	elseif cmd == "tipsBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1071)
	end
end

-- 设置魔域修炼传送列表
function ZorkPracticeView:init_ui()
	-- 初始化场景列表
	self.max_prop_count = ConfigMgr:get_config("t_misc").deathtrap.item_count_max
	self.addPropBtn = self.refer:Get("addPropBtn")
	self.scene_list = {}
	self.def_idx = 1
	for k,v in pairs(ConfigMgr:get_config("deathtrap")) do
		self.scene_list[#self.scene_list+1] = v
	end
	table.sort( self.scene_list, function(a,b) return a.min_level<b.min_level end)
	local item = self.refer:Get("item")
	local root = self.refer:Get("itemRoot")
	local player_lv = LuaItemManager:get_item_obejct("game"):getLevel()
	for i,v in ipairs(self.scene_list) do
		gf_print_table(v,"设置地图"..i)
		local tf = i <= root.childCount and root:GetChild(i-1) or LuaHelper.InstantiateLocal(item,root.gameObject).transform
		gf_setImageTexture(tf:Find("icon"):GetComponent(UnityEngine_UI_Image),v.icon)
		tf:Find("name"):GetComponent("UnityEngine.UI.Text").text = ConfigMgr:get_config("mapinfo")[v.map_id].name
		tf:Find("lv"):GetComponent("UnityEngine.UI.Text").text = string.format(gf_localize_string("%d 级可进"),v.min_level)
		tf:Find("sel").gameObject:SetActive(false)
		tf.name = "to_practice"
		if player_lv>=v.min_level then
			self.def_idx = i
		end
	end
	self:set_practice_time()
	self:select_practice_item(self.def_idx)
	self.refer:Get("scroll").verticalNormalizedPosition = 1-(self.def_idx-1)/(root.childCount-3)

	local fn_update = function()
		self:set_practice_time()
	end
	self.timer = Schedule(fn_update,1)
end

-- 选择魔域修炼
function ZorkPracticeView:select_practice_item(index)
	print("选择魔域修炼",index)
	local root = self.refer:Get("itemRoot")
	if self.select_index then
		local tf = root:GetChild(self.select_index-1)
		tf:Find("sel").gameObject:SetActive(false)
	end
	self.select_index = index
	if self.select_index then
		local tf = root:GetChild(self.select_index-1)
		tf:Find("sel").gameObject:SetActive(true)
	end
end

function ZorkPracticeView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("base") then
		if id2== Net:get_id2("base", "UpdateResR") then
			self.item_obj:practice_time_c2s()
		end
	end
end

-- 设置剩余时间
function ZorkPracticeView:set_practice_time()
	self.refer:Get("time").text = gf_convert_time_ms(self.item_obj:get_practice_time())
	local showBtnTenfoldTime = self.item_obj:get_use_prop_count() < self.max_prop_count
	if showBtnTenfoldTime ~= self.addPropBtn.activeSelf then
		self.addPropBtn:SetActive(showBtnTenfoldTime)
	end
end


-- 快捷增加修炼时间
function ZorkPracticeView:add_practice_time()
	local prop_list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.ZORK_PRACTICE_TIME) or {}
	table.sort(prop_list,function(a,b) return a.bind>b.bind end)
	table.sort(prop_list,function(a,b) return a.item_level>b.item_level end)
	local bag = LuaItemManager:get_item_obejct("bag")
	for i,v in ipairs(prop_list) do
		local item = bag:get_item_for_protoId(v.code,ServerEnum.BAG_TYPE.NORMAL,true)
		if item then
			local itemSys = LuaItemManager:get_item_obejct("itemSys")
			itemSys.tips_item = item
			itemSys:tips_btn_fun_use()
			return
		end
	end
	-- 弹出快捷购买
	gf_create_quick_buy_by_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.ZORK_PRACTICE_TIME,1)
end

function ZorkPracticeView:register()
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
end

function ZorkPracticeView:cancel_register()
    self.item_obj:register_event(self.item_obj.event_name, nil)
end

function ZorkPracticeView:on_hided()
	self:dispose()
end

-- 释放资源
function ZorkPracticeView:dispose()
	self:cancel_register()
	if self.timer then
		self.timer:stop()
		self.timer = nil
	end
    self._base.dispose(self)
    self.init = nil
 end

return ZorkPracticeView

