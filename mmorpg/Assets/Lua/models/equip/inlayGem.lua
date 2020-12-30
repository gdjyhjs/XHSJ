--[[--
--
-- @Author:HuangJunShan gf_set_item get_equip_prefix_name
-- @DateTime:2017-07-29 17:00:00
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local EquipUserData = require("models.equip.equipUserData")
local BagUserData = require("models.bag.bagUserData")
local left_count = 5

local InlayGem=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "inlay_gem.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
    self.curPage = page or 1
end)

-- 资源加载完成
function InlayGem:on_asset_load(key,asset)
	self.scroll = self.refer:Get("scroll")
	self.equipItemRoot = self.refer:Get("equipItemRoot")
	self.equipGemItemRoot = self.refer:Get("equipGemItemRoot")
	self.gemItemRoot = self.refer:Get("gemItemRoot")
	self.equip_bg = self.refer:Get("equip_bg")
	self.equip_icon = self.refer:Get("equip_icon")
	self.gem_list = {}
	self.gem_ui_pos = {}
	local allChild = LuaHelper.GetAllChild(self.equipGemItemRoot)	
	for i=1,#allChild do
		local child = allChild[i]
		local des = child:Find("des")
    	self.gem_list[i] = {
    		root_ui = child,
    		des_ui = des,
    		bg = child:GetComponent(UnityEngine_UI_Image),
    		gem_ico = child:Find("gem_ico"):GetComponent(UnityEngine_UI_Image),
    		isLock = child:Find("isLock").gameObject,
    		sel = child:Find("sel").gameObject,
    		des = des:GetComponent("UnityEngine.UI.Text"),
    		btn = child:GetComponent("UnityEngine.UI.Button"),
    		upGem = child:Find("upGem").gameObject,
    		red_point = child:Find("red_point").gameObject,
	    }
	    self.gem_ui_pos[i] = {ui_pos = child.localPosition,des_pos = des.position}
    end

	self.init = true
	self.sel_index = 1
	self:init_ui()
end

function InlayGem:init_ui()
	self.sel_index = 1
	self:set_left_list()
	self:select_equip()
end

function InlayGem:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
		if id2 == Net:get_id2("bag", "GemUpdateR") then	--当镶嵌宝石发生变化时
			gf_mask_show(false)
			self:update_left_sel_equip()
			self:set_equip()
		end
	elseif id1 == ClientProto.UIRedPoint then -- 红点
        if msg.module == ClientEnum.MODULE_TYPE.EQUIP then
            self:update_red_point()
        end
	end
end

function InlayGem:on_click(obj,arg)
	print("on_click(equip)",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or "" 
	if cmd=="equipGemItem" then -- 镶嵌宝石
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		self:select_gem(obj.transform:GetSiblingIndex()+1,obj)
	elseif cmd == "equip_bg" then
		local data = self.equip_list[self.cur_sel_index]
		local equip = data.equip
		if equip then
			LuaItemManager:get_item_obejct("itemSys"):equip_browse(equip,self.item_obj:get_enhance_id(data.sub_type),self.item_obj:get_gem_info()[data.sub_type],self.item_obj:get_polish_attr(data.sub_type),obj.transform.position)
		end
	elseif cmd == "openBaoshihechengBtn" then -- 打开宝石合成
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local bag = LuaItemManager:get_item_obejct("bag")
		bag:set_open_mode(3)
		bag:add_to_state()
		self.ui:dispose()
	elseif cmd=="equipItem" then -- 选择装备项
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		self.sel_index = obj.transform:GetSiblingIndex()+1
		self:select_equip()
	elseif cmd == "gemTargetBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("gemTarget",self.item_obj)
	elseif cmd == "upGem" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if LuaItemManager:get_item_obejct("setting"):is_lock() then
			return
		end
		local sub_type = self.equip_list[self.cur_sel_index].sub_type
		local gem_info = self.item_obj:get_gem_info()[sub_type] or {}
		local index = obj.transform.parent:GetSiblingIndex()+1
		local gemId = gem_info[index] or 0
		print("gemUpgrade宝石升级装备类型镶嵌的宝石id",gemId)
		if gemId~=0 then
			local useId,needCount = self.item_obj:get_level_up_gem(gemId)
			local targetId = self.item_obj:get_next_level_gem(gemId)
			print("gemUpgrade宝石升级",useId,targetId,needCount)
			local view = View("gemUpgrade",self.item_obj)
			view:set_data(useId,targetId,needCount,sub_type,index)
		end
	elseif string.find(cmd,"equipGemItem_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_gem(obj.transform:GetSiblingIndex()+1,obj)
	end
end

--更新左边选择的装备
function InlayGem:update_left_sel_equip()
	local obj = self.equip_list[self.cur_sel_index]
	local equip = obj.equip
	if equip then
		local item = obj.item
		local ref = obj.ref
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local itemInfo = ConfigMgr:get_config("item")[equip.protoId]
		local text = string.format("%s",self.item_obj:get_equip_name(equip))
		ref:Get("name").text = text
		local all_gem_item = LuaHelper.GetAllChild(item.transform:Find("gem_list").gameObject)
		local gem_info = self.item_obj:get_gem_info()[obj.sub_type]

			local idx = 0
			local lock_count = 0
			for i,gemId in ipairs(gem_info) do
				if self.item_obj:get_gem_lock_str(equip,i) then
					lock_count = lock_count + 1
				elseif gemId~=0 then
					idx = idx + 1
					local bg = all_gem_item[idx]
					bg.gameObject:SetActive(true)
					local img = bg:GetChild(0)
					img.gameObject:SetActive(true)
					gf_setImageTexture(img:GetComponent(UnityEngine_UI_Image),ConfigMgr:get_config("item")[gemId].icon)
					gf_setImageTexture(bg:GetComponent(UnityEngine_UI_Image),"tiny_gem_color_"..ConfigMgr:get_config("item")[gemId].color)
				end
			end
			for i=idx+1,#all_gem_item do
				local is_lock = i + lock_count > #all_gem_item
				local bg = all_gem_item[i]
				if is_lock then
					bg.gameObject:SetActive(false)
				else
					bg.gameObject:SetActive(true)
					local img = bg:GetChild(0)
					img.gameObject:SetActive(false)
					gf_setImageTexture(bg:GetComponent(UnityEngine_UI_Image),"tiny_gem_color_0")
				end
			end

	end
end

--设置镶嵌左边列表
function InlayGem:set_left_list()
	self.equip_list = {}
	local bag = LuaItemManager:get_item_obejct("bag")
	local allChild = LuaHelper.GetAllChild(self.equipItemRoot)
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local list = {}
	for i=1,#allChild do
		local slot = ServerEnum.BAG_TYPE.EQUIP*10000+i
		local equip = bag:get_bag_item()[slot]
		local item = allChild[i].gameObject
		local ref  = item:GetComponent("ReferGameObjects")
		local sel = ref:Get("sel")
		local all_gem_item = LuaHelper.GetAllChild(allChild[i]:Find("gem_list").gameObject)
		if equip then
			print("有装备",i)
			local itemInfo = ConfigMgr:get_config("item")[equip.protoId]
			local icon = ref:Get("ico")
			icon.gameObject:SetActive(true)
			gf_set_equip_icon(equip,icon,ref:Get("bg"))
			-- gf_set_item(equip.protoId,icon,ref:Get("bg"),equip.color)
			local text = string.format("%s",self.item_obj:get_equip_name(equip))
			ref:Get("name").text = text
			print("--左边装备列表镶嵌信息")
			local gem_info = self.item_obj:get_gem_info()[itemInfo.sub_type] or {}

			local idx = 0
			local lock_count = 0
			for i,gemId in ipairs(gem_info) do
				if self.item_obj:get_gem_lock_str(equip,i) then
					lock_count = lock_count + 1
				elseif gemId~=0 then
					idx = idx + 1
					local bg = all_gem_item[idx]
					bg.gameObject:SetActive(true)
					local img = bg:GetChild(0)
					img.gameObject:SetActive(true)
					gf_setImageTexture(img:GetComponent(UnityEngine_UI_Image),ConfigMgr:get_config("item")[gemId].icon)
					gf_setImageTexture(bg:GetComponent(UnityEngine_UI_Image),"tiny_gem_color_"..ConfigMgr:get_config("item")[gemId].color)
				end
			end
			for i=idx+1,#all_gem_item do
				local is_lock = i + lock_count > #all_gem_item
				local bg = all_gem_item[i]
				if is_lock then
					bg.gameObject:SetActive(false)
				else
					bg.gameObject:SetActive(true)
					local img = bg:GetChild(0)
					img.gameObject:SetActive(false)
					gf_setImageTexture(bg:GetComponent(UnityEngine_UI_Image),"tiny_gem_color_0")
				end
			end

			local red_point = ref:Get("red_point")
			local obj = {
				item = item,
				ref = ref,
				sel = sel,
				slot = slot,
				sub_type = i,
				equip = equip,
				gem_info = gem_info,
				red_point = red_point,
			}
			self.equip_list[#self.equip_list+1] = obj
			if self.item_obj.open_page2 == i then
				self.sel_index = #self.equip_list
			end
    	else
			print("无装备",i)
			local icon = ref:Get("ico")
			icon.gameObject:SetActive(false)
    		gf_set_item(nil,nil,ref:Get("bg"),0)
			gf_set_item(nil,nil,ref:Get("bg"),0)
			local text = string.format("%s %s",EquipUserData:get_equip_type_name(i),gf_localize_string("未装备")) 	--文字
			ref:Get("name").text = text
    		for i=1,#all_gem_item do
    			local bg = all_gem_item[i]
				bg.gameObject:SetActive(false)
			end
    		item.transform:SetAsLastSibling() --放到最后
    		local red_point = ref:Get("red_point")
			local obj = {
				item = enhanceItem,
				ref = ref,
				sel = sel,
				slot = slot,
				sub_type = i,
				red_point = red_point,
			}
			list[#list+1] = obj
		end
		sel:SetActive(false)
	end
	for i,v in ipairs(list) do
		self.equip_list[#self.equip_list+1] = v
	end
	local pos = self.sel_index > left_count and (1 - (self.sel_index-left_count)/(#allChild-left_count)) or 1
	self.scroll.verticalNormalizedPosition = pos
	self:update_red_point()
	self.item_obj.open_page2 = nil
end

--选择装备
function InlayGem:select_equip()
	if self.cur_sel_index then
		local obj = self.equip_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(false)
		end
	end
	self.cur_sel_index = self.sel_index
	if self.cur_sel_index then
		local obj = self.equip_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(true)
		end
	end
	self:set_equip()
end

--设置装备
function InlayGem:set_equip()
	local obj = self.equip_list[self.cur_sel_index]
	local equip = obj.equip
    local game = LuaItemManager:get_item_obejct("game")
	local bag = LuaItemManager:get_item_obejct("bag")
    local itemSys = LuaItemManager:get_item_obejct("itemSys")
    local gem_info = self.item_obj:get_gem_info()[obj.sub_type] or {}

    local no_open_list = {}
    local gem_idx = 0
    for i,v in ipairs(self.gem_list) do
    	local str = self:get_gem_lock_str(i)
    	if str then
    		v.gem_ico.gameObject:SetActive(false)
    		v.isLock.gameObject:SetActive(true)
    		v.btn.interactable = false
    		v.sel:SetActive(false)
    		v.upGem:SetActive(false)
    		gf_setImageTexture(v.bg,"gem_color_0")

    		v.red_point:SetActive(false)

    		no_open_list[#no_open_list+1] = {root_ui=v.root_ui,des_ui=v.des_ui}
    		-- -- 修改位置
    		-- v.root_ui.localPosition = self.gem_ui_pos[#self.gem_list-none_idx].ui_pos
    		-- v.des_ui.position = self.gem_ui_pos[#self.gem_list-none_idx].des_pos

    	else
    		local gemId = gem_info[i] or 0
    		v.gem_ico.gameObject:SetActive(gemId~=0)
    		if gemId~=0 then
    			local gem_data = ConfigMgr:get_config("item")[gemId]
    			gf_setImageTexture(v.gem_ico,gem_data.icon)
    			str = gem_data.name

    			-- 拿加的属性
    			local attr = {}
				for i,v in ipairs(gem_data.effect) do
					attr[v[1]] = v[2]
				end
				for k,v in pairs(attr) do
					if not (k==ServerEnum.COMBAT_ATTR.MAGIC_DEF and v == attr[ServerEnum.COMBAT_ATTR.PHY_DEF]) then -- 如果不符合条件无视（已经和双防一起显示了）
						if k==ServerEnum.COMBAT_ATTR.PHY_DEF and v == attr[ServerEnum.COMBAT_ATTR.MAGIC_DEF] then -- 显示双防
							str = string.format("<color=#8a4c31>%s</color>\n<size=20><color=#20a612>%s+%d</color></size>",str,gf_localize_string("双防"),v)
						else -- 显示单属性
							str = string.format("<color=#8a4c31>%s</color>\n<size=20><color=#20a612>%s+%d</color></size>",str,itemSys:get_combat_attr_name(k),v)
						end
					end
				end

    			v.sel:SetActive(false)
    			if gem_data.item_level<10 then
	    			local id,count = self.item_obj:get_level_up_gem(gemId)
	    			v.upGem:SetActive(count>1)
	    			if count>1 then -- 宝石可以升级
	    				v.red_point:SetActive(true)
	    			else -- 背包有更高级的宝石
	    				v.red_point:SetActive(false)
	    				local type_list = ConfigMgr:get_config("equip_gem_suit")[obj.sub_type].gem_type -- 可镶嵌的类型列表
	    				local Bag = LuaItemManager:get_item_obejct("bag")
						for i,gem_type in ipairs(type_list) do
							for i,d in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.GEM,gem_type)) do
								if d.item_level > gem_data.item_level then
									local count = Bag:get_item_count(d.code,ServerEnum.BAG_TYPE.NORMAL)
									if count>0 then
										v.red_point:SetActive(true)
										break
									end
								end
							end
						end
	    			end
	    		else
	    			v.red_point:SetActive(false)
	    			v.upGem:SetActive(false)
	    		end
    			gf_setImageTexture(v.bg,"gem_color_"..gem_data.color)
    		else
    			v.sel:SetActive(true)
	    		v.upGem:SetActive(false)
    			gf_setImageTexture(v.bg,"gem_color_0")

	    		v.red_point:SetActive(false) -- 如果背包有可以镶嵌的宝石
				local type_list = ConfigMgr:get_config("equip_gem_suit")[obj.sub_type].gem_type -- 可镶嵌的类型列表
				local Bag = LuaItemManager:get_item_obejct("bag")
				for i,gem_type in ipairs(type_list) do
					for i,d in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.GEM,gem_type)) do
						local count = Bag:get_item_count(d.code,ServerEnum.BAG_TYPE.NORMAL) -- 玩家背包里面有可以镶嵌的宝石 
						if count>0 then
								v.red_point:SetActive(true)
							break
						end
					end
				end

    		end
    		v.isLock.gameObject:SetActive(false)
    		v.btn.interactable = true

    		-- 修改位置
    		gem_idx = gem_idx + 1
    		v.root_ui.localPosition= self.gem_ui_pos[gem_idx].ui_pos
    		v.des_ui.position = self.gem_ui_pos[gem_idx].des_pos

    	end
    	v.des.text = str
    end

    	-- 修改位置
    for i=#no_open_list,1,-1 do
    	local v = no_open_list[i]
		v.root_ui.localPosition = self.gem_ui_pos[#self.gem_list-i+1].ui_pos
		v.des_ui.position = self.gem_ui_pos[#self.gem_list-i+1].des_pos
    end
    if equip then
		self.equip_icon.gameObject:SetActive(true)
		gf_set_equip_icon(equip,self.equip_icon,self.equip_bg)
		-- gf_set_item(equip.protoId,self.equip_icon,self.equip_bg,equip.color)
    else
		self.equip_icon.gameObject:SetActive(false)
		gf_set_item(nil,nil,self.equip_bg,0)
    end
	-- -- print("设置宝石套装目标")
end

-- 获取孔是否开启
function InlayGem:get_gem_lock_str(index)
	local equip = self.equip_list[self.cur_sel_index].equip
	return self.item_obj:get_gem_lock_str(equip,index)
end

--选择宝石槽
function InlayGem:select_gem(index,obj)
	-- 镶嵌选择
	local sub_type = self.equip_list[self.cur_sel_index].sub_type
	local list = {}
	local propList = {}
	local bag = LuaItemManager:get_item_obejct("bag")
	local type_list = ConfigMgr:get_config("equip_gem_suit")[sub_type].gem_type

	local gem_des = gf_localize_string("该孔位可镶嵌")

	for i,gem_type in ipairs(type_list) do
		for i,v in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.GEM,gem_type)) do
			if not propList[v.code] and not propList[v.rel_code]  then
				propList[v.code] = v.code
				local count = bag:get_item_count(v.code,ServerEnum.BAG_TYPE.NORMAL)
				if count>0 then
					list[#list+1] = {
						propId = v.code,
						des = v.name,
						count = count,
						sub_type = v.sub_type,
						item_level = v.item_level,
					}
				end
			end
		end
		local gemId = self.item_obj:get_gem_for_type(gem_type,1)
		local gem_data = ConfigMgr:get_config("item")[gemId]
		local k = string.gsub(gem_data.name,gf_localize_string("1级"),"")
		if i>1 then
			gem_des = gem_des.."、"
		end
		gem_des = gem_des..k
	end
	table.sort(list,function(a,b) return a.sub_type<b.sub_type end)
	table.sort(list,function(a,b) return a.item_level>b.item_level end)
    local gem_info = self.item_obj:get_gem_info()[sub_type] or {}
    local have_gem = gem_info[index]~=0 and gem_info[index]
	local list_view = nil
	local sel_fn = function(data)
		if #list<=0 then
			self.ui:hide()
			local d = ConfigMgr:get_config("t_misc").equip_need_gem_path[sub_type]
			gf_open_model(ClientEnum.MODULE_TYPE.MALL,unpack(d))
		else
			local item = bag:get_item_for_protoId(data.propId,ServerEnum.BAG_TYPE.NORMAL)
			print("镶嵌的宝石guid",data.propId,item,item and item.guid)
			if item then
				self.item_obj:inlay_gem_c2s(item.guid,sub_type,index)
			end
		end
		list_view:dispose()
	end
	local title_name = gf_localize_string(#list<=0 and "前往购买" or (have_gem and "替换宝石") or "镶嵌宝石")
	local btn_name = gf_localize_string(#list<=0 and "前往购买" or (have_gem and "替换") or "镶嵌")
	local nil_text = gf_localize_string("没有可镶嵌的宝石，可前往商城购买")

	local open_select_gem = function()
		list_view = View("selectGem",self.item_obj)
		list_view:set_data(list,sel_fn,title_name,btn_name,gem_des,nil_text)
	end
	if have_gem then
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		itemSys:add_tips_btn("替换",open_select_gem)
		itemSys:add_tips_btn("卸下",function() self.item_obj:unload_gem_c2s(sub_type,index) end)
		local gem_data = ConfigMgr:get_config("item")[have_gem]
		if gem_data.item_level<10 then
			local useId,needCount = self.item_obj:get_level_up_gem(have_gem)
		    if needCount>1 then
		    	itemSys:add_tips_btn("升级",function()
					local targetId = self.item_obj:get_next_level_gem(have_gem)
					local view = View("gemUpgrade",self.item_obj)
					view:set_data(useId,targetId,needCount,sub_type,index)
				end)
		    end
		end

		itemSys:prop_tips(have_gem,nil,obj.transform.position)
	else
		open_select_gem()
	end
end

function InlayGem:on_showed()
	StateManager:register_view( self )
	if self.init then
		self.sel_index = 1
		self:init_ui()
	end
end

function InlayGem:hided()
StateManager:remove_register_view( self )
end


-- 释放资源
function InlayGem:dispose()
StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

function InlayGem:update_red_point()
	if not self.init then return end
    for i,obj in ipairs(self.equip_list or {}) do
        local show = (function()
                    for k,v in pairs(self.item_obj.red_pos) do
                        if v and tonumber(string.sub(k,1,1)) == 3 and tonumber(string.sub(k,2,2)) == obj.sub_type then
                            return true
                        end
                    end
                end)()
        obj.red_point:SetActive(show or false)
    end
end

return InlayGem