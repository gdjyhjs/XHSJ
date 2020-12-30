--[[--
-- 分解 transform size
-- @Author:Seven
-- @DateTime:2017-11-21 15:52:18
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local DestinyTools = require("models.destiny.destinyTools")
local page_count = 20 -- 一帧加载几个天命
local one_line_count = 4 -- 一行显示几个天命

local Resolve=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "destiny_resolve.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Resolve:on_asset_load(key,asset)
	self.objs = {}
	self.sel_d = {}

	self.scroll = self.refer:Get("scroll")
	self.itemRoot = self.refer:Get("itemRoot")
	self.resolveColor = self.refer:Get("resolveColor")
	self.spiritCount = self.refer:Get("spiritCount")
	self.spiritAdd = self.refer:Get("spiritAdd")
	self.resolve_eff = self.refer:Get("resolve_eff")
	self.UIEffectCamera = self.refer:Get("UIEffectCamera")
	self.UIEffectCamera.orthographicSize = self.UIEffectCamera.orthographicSize * self.root.transform.localScale.x

	self:init_ui()
	self.init = true
end

function Resolve:init_ui()
	print("初始化 分解")
	self.resilve_color = 3 -- 默认勾选蓝色和绿色
	-- 设置默认勾选
	local allChilds = LuaHelper.GetAllChild(self.resolveColor)
	self.colorItems = {}
	local idx = 0
	for i=#allChilds,1,-1 do
		idx = idx + 1
		self.colorItems[idx] = allChilds[i]:Find("sel").gameObject
		local pos = bit._rshift(0x80000000,32-idx)
		self.colorItems[idx]:SetActive(bit._and(self.resilve_color,pos)==pos)
	end
	self:set_items()
	self:set_res()
	self.resolve_eff:SetActive(false)
end

function Resolve:set_items()
	if self.set_items_timer then
		self.set_items_timer:stop()
		self.set_items_timer = nil
	end
	local itemRoot = self.itemRoot
	local count = itemRoot.childCount
	local item = itemRoot:GetChild(0).gameObject
	local list = self.item_obj:get_items(ServerEnum.DESTINY_CONTIANER_TYPE.BAG)
	local start_index = 1
	local end_index = #list
	local cur_index = start_index
	local next_index = 0
	for i=end_index+1,#self.objs do
		self.objs[i].item:SetActive(false)
	end
	self.sel_d = {}
	self.objs = {}
	self.sel_score = 0
	local set_items = function()
		cur_index = next_index+1
		next_index = next_index+page_count
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		print("设置天命",cur_index,next_index < end_index and next_index or end_index)
		for idx=cur_index,next_index < end_index and next_index or end_index do
			local d = list[idx]
			if idx > 1 then
				item = idx <= count and itemRoot:GetChild(idx-1).gameObject or LuaHelper.InstantiateLocal(item,itemRoot.gameObject)
			end
			local data = ConfigMgr:get_config("destiny_level")[d.destinyId]
			local icon = item.transform:Find("icon"):GetComponent(UnityEngine_UI_Image)
			local bg = item.transform:Find("bg"):GetComponent(UnityEngine_UI_Image)
			gf_setImageTexture(bg,DestinyTools:get_destiny_bg(data.color))
			gf_setImageTexture(icon,data.icon)
			item.transform:Find("lv"):GetComponent("UnityEngine.UI.Text").text = data.level
			item.name = "objItem"
			item:SetActive(true)
			local sel = item.transform:Find("sel").gameObject
			local eff = item.transform:Find("eff").gameObject
			local pos = bit._rshift(0x80000000,32-data.color)
			local is_sel = data.type==0 or  bit._and(self.resilve_color,pos)==pos
			local attribute = item.transform:Find("attribute"):GetComponent("UnityEngine.UI.Text")
			local line = item.transform:Find("line").gameObject
				local attr_str = ""
				if data.type == 0 then
					-- 无属性不显示
					attr_str = "精粹+"..data.spirit
				else
					if #data.level_attr>0 then
						attr_str = itemSys:get_combat_attr_name(data.level_attr[1],data.level_attr[2])
					end
					if #data.break_attr>0 then
						attr_str = attr_str.."\n"..itemSys:get_combat_attr_name(data.break_attr[1],data.break_attr[2])
					end
				end
			line:SetActive(idx - math.floor(idx/one_line_count)*one_line_count == 1)
			attribute.text = attr_str
			sel:SetActive(is_sel)
			eff:SetActive(false)
			local obj = {
				sel = sel,
				d = d,
				data = data,
				item = item,
				attribute = attribute,
				eff = eff,
				line = line,
			}
			if is_sel then
				self.sel_d[d.duid] = obj
				self.sel_score = self.sel_score + data.spirit
			end
			self.objs[idx] = obj
		end
		if next_index>=end_index then
			self.set_items_timer:stop()
			self.set_items_timer = nil
		end
		self.spiritAdd.text = "+"..self.sel_score
	end
	self.set_items_timer = Schedule(set_items,0.1)
end

-- function Resolve:show_line()
-- 	local idx = 0
-- 	for i,v in ipairs(self.objs) do
-- 		if 
-- 	end
-- end

function Resolve:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
		if(id2== Net:get_id2("bag", "ResolveDestinyR"))then --分解
			if msg.err==0 and #msg.successDuid>0 then
				self:resolve_destiny(msg.successDuid)
			else
				gf_mask_show(true)
			end
		end
	end
end

function Resolve:resolve_destiny(duid_list)
	for k,v in pairs(self.sel_d) do
		v.data = nil
		v.d = nil
		v.eff:SetActive(true)
	end
	self.sel_score = 0
	PLua.Delay(function()
		if self.init then
			for k,v in pairs(self.sel_d) do
				v.item:SetActive(false)
			end
			self.spiritAdd.text = "+"..self.sel_score
			self:set_res()
			self.sel_d = {}
			gf_mask_show(false)
		end
	end,0.3)
	self.resolve_eff:SetActive(true)
end

-- 设置基础资源
function Resolve:set_res()
	self.spiritCount.text = gf_format_count(LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.SPIRIT))
end

function Resolve:on_click(obj,arg)
	print("分解界面点击",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="objItem" then -- 勾选或者取消勾选天命
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:click_objItem(obj,arg)
	elseif cmd=="selColor" then -- 勾选或者取消勾选某个品质
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:click_selColor(obj,arg)
	elseif cmd == "btnOneKeyResolve" then -- 分解
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:one_key_resolv()
	end
end

function Resolve:one_key_resolv()
	local resolveDuidArr = {}
	local use_check = false
	local need_lock = false
	for k,v in pairs(self.sel_d) do
		-- print("添加分解的天命guid",v.d.duid)
		resolveDuidArr[#resolveDuidArr+1] = v.d.duid
		if v.data.color>=4 and v.data.type~=0 then
			use_check = true
		end
		if v.data.color>=3 and v.data.type~=0 then
			need_lock = true
		end
	end

	local fn = function()
		if not need_lock or not LuaItemManager:get_item_obejct("setting"):is_lock() then
			self.item_obj:resolve_destiny_c2s(resolveDuidArr)
			self.resolve_eff:SetActive(false)
			gf_mask_show(true)
		end
	end
	if #resolveDuidArr==0 then
		gf_message_tips(gf_localize_string("请选择要分解的天命"))
	elseif use_check then
		local content = gf_localize_string("你确定要分解你选定的高级天命么？")
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,fn)
	else
		fn()
	end
end

 -- 勾选或者取消勾选天命
function Resolve:click_objItem(obj,arg)
	local index = obj.transform:GetSiblingIndex()+1
	local obj = self.objs[index]
	if not obj.data then
		return
	end
	local color = obj.data.color
	self:set_check(obj,not obj.sel.activeSelf)
	local have_color = (function() -- 是否勾选全部了这个品质的天命（除了精粹）
			for i,v in ipairs(self.objs) do
				if v.data and v.data.color == color and not v.sel.activeSelf and v.data.type~=0 then
					return false
				end
			end
			return true
		end)()
	local pos = bit._rshift(0x80000000,32 - color)
	if bit._and(self.resilve_color,pos)==pos ~= have_color then
		self.resilve_color = self.resilve_color + (pos * (have_color and 1 or -1))
		self.colorItems[color]:SetActive(have_color)
	end
end
 -- 勾选或者取消勾选某个品质
function Resolve:click_selColor(obj,arg)
	local color = 5 - obj.transform:GetSiblingIndex()
	local pos = bit._rshift(0x80000000,32 - color)
	local is_add_color = bit._and(self.resilve_color,pos)==0
	if is_add_color then
		self.resilve_color = self.resilve_color + pos
	else
		self.resilve_color = self.resilve_color - pos
	end
	self.colorItems[color]:SetActive(is_add_color)
	for i,v in ipairs(self.objs) do
		if v.data and v.data.color == color and v.sel.activeSelf ~= is_add_color and v.data.type~=0 then
			self:set_check(v,is_add_color)
		end
	end
end
-- 设置某个天命为选择或者非选择状态 并且计分
function Resolve:set_check(obj,show)
	print("显示或者隐藏",show,"分数",obj.data.spirit * (show and 1 or -1))
	obj.sel:SetActive(show)
	self.sel_d[obj.d.duid] =show and obj or nil
	self.sel_score = self.sel_score + obj.data.spirit * (show and 1 or -1)
	self.spiritAdd.text = "+"..self.sel_score
end

function Resolve:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_ui()
	end
end

function Resolve:on_hided()
	if self.set_items_timer then
		self.set_items_timer:stop()
		self.set_items_timer = nil
	end
	StateManager:remove_register_view( self )
end

-- 释放资源
function Resolve:dispose()
	self:hide()
    self._base.dispose(self)
 end

return Resolve

