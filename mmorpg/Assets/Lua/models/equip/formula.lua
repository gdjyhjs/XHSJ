--[[-- PlayerPrefs
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-29 17:00:18
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Dropdown = UnityEngine.UI.Dropdown
local EquipUserData = require("models.equip.equipUserData")
local BagUserData = require("models.bag.bagUserData")

local Formula=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "formula.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
    self.curPage = page or 1
end)

-- 资源加载完成
function Formula:on_asset_load(key,asset)
	local roleId = LuaItemManager:get_item_obejct("game"):getId()
	self.start_toogle_key = "start_toogle_key_"..roleId
	self.color_toogle_key = "color_toogle_key_"..roleId
	self.start_prop_id = nil
	self.color_prop_id = nil
	self.formula_list = {}
	self.level_index = self.item_obj.open_page2
	self.sel_index = self.item_obj.open_page3 or 1
	self.item_obj.open_page2 = nil
	self.item_obj.open_page3 = nil
	self.init = true
	self:init_ui()
	self:init_level_down_drag()
end

function Formula:init_ui()
	self.color_check = UnityEngine.PlayerPrefs.GetInt(self.color_toogle_key,0)==1
	self.start_check = UnityEngine.PlayerPrefs.GetInt(self.start_toogle_key,0)==1

	self.selectLevel = self.refer:Get("selectLevel") -- 选择的等级 Fropdown
	self.selectLevelText = self.refer:Get("selectLevelText") -- 选择的等级 Text
	self.scroll = self.refer:Get("scroll") -- 滑动 scroll
	self.eff = self.refer:Get("eff") -- 打造特效 gameObject
	self.formulaItemRoot = self.refer:Get("formulaItemRoot") -- 打造项装备列表根
	self.formulaItem = self.refer:Get("formulaItem") -- 打造项装备项

	self.dazao_item_ico = self.refer:Get("dazao_item_ico") -- 打造装备图标
	self.dazao_item_bg = self.refer:Get("dazao_item_bg") -- 打造装备背景
	self.txt_shenqizhi = self.refer:Get("txt_shenqizhi") -- 打造装备神器值
	self.colorCheck = self.refer:Get("colorCheck") -- 使用颜色保底
	self.startCheck = self.refer:Get("startCheck") -- 使用星级保底
	self.money_num = self.refer:Get("money_num") -- 钱数量
	self.money_ico = self.refer:Get("money_ico") -- 钱图标
	-- 消耗列表
	local itemList = self.refer:Get("itemList")
	local childs = LuaHelper.GetAllChild(itemList)
	self.itemList = {}
	for i=1,#childs do
		local child = childs[i]
		self.itemList[i] = {
			obj = child.gameObject,
			bg = child:GetComponent(UnityEngine_UI_Image),
			icon = child:FindChild("icon"):GetComponent(UnityEngine_UI_Image),
			num = child:FindChild("num"):GetComponent("UnityEngine.UI.Text"),
			add = child:FindChild("add").gameObject,
		}
	end
	self.itemListGroup = itemList:GetComponent("UnityEngine.UI.HorizontalLayoutGroup")
end

--初始化等级选择项
function Formula:init_level_down_drag()
	local options = self.selectLevel.options
	options:Clear()
	self.level_index_list = {}
	local index = 0
	local item_list = EquipUserData:get_formula_equip_dropdown_value()
	self.dropdown_item_count = #item_list
	for i,v in ipairs(item_list) do
		if v<=LuaItemManager:get_item_obejct("game"):getLevel() then
			options:Add(Dropdown.OptionData(v.."级")) -- 小类名字
			self.level_index_list[v] = index
			self.level_index_list[index] = v
			index = index + 1
		end
	end
	if index==0 then
		gf_message_tips("该等级没有可打造的装备")
		return
	end
	index = self.level_index and self.level_index_list[self.level_index] or EquipUserData:get_def_value()
	self.level_index = self.level_index_list[index]
	self.selectLevel.value = index
	self.selectLevelText.text = self.level_index .. "级"
	-- self.scroll.verticalNormalizedPosition = 1
	self:set_dazao_left_list()
end

function Formula:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
		if(id2== Net:get_id2("bag", "FormulaEquipR"))then	--打造装备
			gf_mask_show(false)
			if msg.err == 0 then
				self.eff:SetActive(true)
				self:set_equip()
			end
		end
	elseif id1 == ClientProto.UIRedPoint then -- 红点
        if msg.module == ClientEnum.MODULE_TYPE.EQUIP then
            self:update_red_point()
        end
	end
end

function Formula:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or "" 
	print("打造装备点击",obj,arg)
	if cmd=="formulaBtn" then
		--打造
		if self.cur_sel_index and self.formula_list[self.cur_sel_index] and self.formula_list[self.cur_sel_index].formulaId then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			local color_prop_id = self.color_check and self.color_prop_id or 0
			local start_prop_id = self.start_check and self.start_prop_id or 0
			self.item_obj:formula_equip_c2s(self.formula_list[self.cur_sel_index].formulaId,color_prop_id,start_prop_id)
			self.eff:SetActive(false)
			gf_mask_show(true)
		end
	elseif cmd == "btnHelp" then
		gf_show_doubt(1161)
	elseif cmd=="formulaItem" then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
		--选择打造项
		self.sel_index = obj.transform:GetSiblingIndex()+1
		self:select_equip()
	elseif cmd == "startItem" then
		-- 星魂石选择
		local list = {}
		local propList = {}
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		for i,v in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.EQUIP_STAR_STONE)) do
			if v.effect_ex[1] <= ConfigMgr:get_config("equip_formula")[self.formula_list[self.cur_sel_index].formulaId].level then
				if not propList[v.code] and not propList[v.rel_code]  then
					propList[v.code] = v.code
					local des = string.format("%s\n<color=#90281AFF><size=20>提高打造出%d星概率%d%%</size></color>",
						itemSys:give_color_for_string(v.name,v.color),v.effect[1],v.effect[2]/100)
					list[#list+1] = {
						propId = v.code,
						des = des,
					}
				end
			end
		end
		local list_view = nil
		local sel_fn = function(data)
			--星魂石材料
			local bag = LuaItemManager:get_item_obejct("bag")
			local item = self.itemList[3]
			self.start_prop_id = data.propId
			local count = bag:get_item_count(self.start_prop_id,ServerEnum.BAG_TYPE.NORMAL)
			gf_set_item(self.start_prop_id,item.icon,item.bg)
			local str = count<1 and "<color=#CE3636>%d</color>/1" or "%d/1"
			item.num.text = string.format(str,count)
			print("关闭界面",list_view)
			list_view:dispose()
		end
		list_view = View("itemList",itemSys)
		list_view:set_data(list,sel_fn,gf_localize_string("星魂石"))
	elseif cmd == "colorItem" then
		-- 品质保底选择
		local list = {}
		local propList = {}
		local formula_data = ConfigMgr:get_config("equip_formula")[self.formula_list[self.cur_sel_index].formulaId]
		local item_data = ConfigMgr:get_config("item")[formula_data.code]
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		for i,v in ipairs(BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.FORMULA_EQUIP_BASE_COLOR)) do
			if v.item_level <= formula_data.level then
				if not propList[v.code] and not propList[v.rel_code]  then
					for i,sub_type in ipairs(v.effect_ex) do
						if sub_type==item_data.sub_type then
							propList[v.code] = v.code
							local des = string.format("%s\n<color=#90281AFF><size=20>可保证打造出%s装备</size></color>",
								itemSys:give_color_for_string(v.name,v.color),itemSys:get_color_name(v.effect[1]))
							list[#list+1] = {
								propId = v.code,
								des = des,
							}
							break
						end
					end

					
				end
			end
		end
		local list_view = nil
		local sel_fn = function(data)
			--品质保底材料
			local bag = LuaItemManager:get_item_obejct("bag")
			local item = self.itemList[2]
			self.color_prop_id = data.propId
			local count = bag:get_item_count(self.color_prop_id,ServerEnum.BAG_TYPE.NORMAL)
			gf_set_item(self.color_prop_id,item.icon,item.bg)
			local str = count<1 and "<color=#CE3636>%d</color>/1" or "%d/1"
			item.num.text = string.format(str,count)
			print("关闭界面",list_view)
			list_view:dispose()
		end
		list_view = View("itemList",itemSys)
		list_view:set_data(list,sel_fn,gf_localize_string("品质保底石"))
	elseif cmd == "equip_browse" then
		-- 打造装备浏览
		local color_prop_id = self.color_check and self.color_prop_id or nil
		self.item_obj:formula_browse(self.formula_list[self.cur_sel_index].formulaId,nil,color_prop_id and ConfigMgr:get_config("item")[color_prop_id].effect[1] or nil)
	elseif not Seven.PublicFun.IsNull(arg) then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		local cmd = arg.name
		if arg == self.selectLevel then
			--选择了某个等级的装备
			self.level_index = self.level_index_list[arg.value]
			self:set_dazao_left_list()
		elseif cmd == "selectLevel" then
			--点击了选择装备等级
			local scroll = self.selectLevel.transform:Find("Dropdown List"):GetComponent("UnityEngine.UI.ScrollRect")
			local pos = 1 - (self.selectLevel.value)/(self.dropdown_item_count-5.5)
			scroll.verticalNormalizedPosition = pos < 0 and 0 or pos
			print("位置",scroll.verticalNormalizedPosition)

		elseif cmd == "startCheck" then
			--勾选
			self.start_check = arg.isOn
			UnityEngine.PlayerPrefs.SetInt(self.start_toogle_key,arg.isOn and 1 or 0)

		elseif cmd == "colorCheck" then
			--勾选
			self.color_check = arg.isOn
			UnityEngine.PlayerPrefs.SetInt(self.color_toogle_key,arg.isOn and 1 or 0)

		end
	end
end

--设置打造左边列表
function Formula:set_dazao_left_list()
	print("设置打造的装备列表",self.level_index)
	-- 设置左边列表
	self.formula_list = {}
	local list = EquipUserData:get_formula_equip_list()
	local data = list[self.level_index]
	local root = self.formulaItemRoot
	local sample = self.formulaItem
	table.sort(data,function(a,b) return a.formulaId<b.formulaId end)
	for i,v in ipairs(data or {}) do
		local item_data = ConfigMgr:get_config("item")[v.code]
		local item = i<=root.transform.childCount and root.transform:GetChild(i-1).gameObject or self.ui:get_item("formulaItem",sample,root)
		local ref = item:GetComponent("ReferGameObjects")
		local sel = ref:Get("sel")
		gf_set_item(v.code,ref:Get("icon"),ref:Get("bg"))
		ref:Get("text").text = string.format("%s\n<size=20>%d级%s</size>",item_data.name,item_data.level,EquipUserData:get_equip_type_name(item_data.sub_type)) 
		item.name = "formulaItem"
		ref:Get("sel"):SetActive(false)
		sel:SetActive(false)
		self.formula_list[#self.formula_list+1]	= {
			item = item,
			ref = ref,
			sel = sel,
			formulaId = v.formulaId,
			red_point = ref:Get("red_point"),
		}
	end
	for i=root.transform.childCount-1,#data,-1 do
		self.ui:repay_item("formulaItem",root.transform:GetChild(i).gameObject)
	end
	self:update_red_point()
	self:select_equip()

	local pos = 1-(self.cur_sel_index-1)/5
	pos = pos < 0 and 0 or pos
	print("设置垂直位置",pos)
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.formulaItemRoot.transform) -- 立即重建布局
	self.scroll.verticalNormalizedPosition = pos
end

function Formula:update_red_point()
	if not self.init then return end
    for i,obj in ipairs(self.formula_list or {}) do
        local show = (function()
                    for k,v in pairs(self.item_obj.red_pos) do
                        if v and tonumber(string.sub(k,1,1)) == 2 and tonumber(string.sub(k,2,2)) == i then
                            return true
                        end
                    end
                end)()
        obj.red_point:SetActive(show or false)
    end
end

--选择打造的装备
function Formula:select_equip()
	if self.cur_sel_index then
		local obj = self.formula_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(false)
		end
	end
	self.cur_sel_index = self.sel_index
	if self.cur_sel_index then
		local obj = self.formula_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(true)
		end
	end
	self:set_equip()

end

-- 设置装备
function Formula:set_equip()
	local obj = self.formula_list[self.cur_sel_index]
	local formulaId = obj.formulaId
	local formula_data = ConfigMgr:get_config("equip_formula")[formulaId]
	-- gf_print_table(formula_data,"打造信息")
	local equip_data = ConfigMgr:get_config("item")[formula_data.code]
	local bag = LuaItemManager:get_item_obejct("bag")
	-- 图标
	gf_set_item(formula_data.code,self.dazao_item_ico,self.dazao_item_bg)
	-- 设置神器值
	local cur_point = self.item_obj:get_formula_point(self.level_index)
	local max_point = ConfigMgr:get_config("equip_formula_accumulate")[self.level_index].total
	self.txt_shenqizhi.text = string.format("%d/%d",cur_point,max_point)
	--消耗
	local need_money = formula_data.need_money
	gf_set_money_ico(self.money_ico,need_money[1])
	self.money_num.text = need_money[2]
	--材料 SetActive
	local item = self.itemList[1]
	local need_item = formula_data.need_item[1]
	local count = bag:get_item_count(need_item[1],ServerEnum.BAG_TYPE.NORMAL)
	gf_set_item(need_item[1],item.icon,item.bg)
	local str = count<need_item[2] and "<color=#CE3636>%d</color>/%d" or "%d/%d"
	item.num.text = string.format(str,count,need_item[2])
	gf_set_click_prop_tips(item.icon,need_item[1])

	--品质保底材料
	local item = self.itemList[2]
	local list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.FORMULA_EQUIP_BASE_COLOR)
	table.sort(list,function(a,b) return a.item_level>b.item_level end)
	local color_prop = (function(list) 
		for i,v in ipairs(list) do
			if v.item_level <= formula_data.level then

				for i,sub_type in ipairs(v.effect_ex) do
					if sub_type==equip_data.sub_type then
						return v
					end
				end

			end
		end
	end)(list)
	if color_prop then
		self.color_prop_id = color_prop.code
		local count = bag:get_item_count(self.color_prop_id,ServerEnum.BAG_TYPE.NORMAL)
		gf_set_item(self.color_prop_id,item.icon,item.bg)
		local str = count<1 and "<color=#CE3636>%d</color>/1" or "%d/1"
		item.num.text = string.format(str,count)
		item.add:SetActive(count<=0)
		--勾选
		self.colorCheck.isOn = self.color_check
		item.obj:SetActive(true)
	else
		item.obj:SetActive(false)
		if self.color_check then
			self.color_check = false
			UnityEngine.PlayerPrefs.SetInt(self.color_toogle_key,self.color_check and 1 or 0)
		end
	end

	--星级保底材料
	local item = self.itemList[3]
	local list = BagUserData:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.EQUIP_STAR_STONE)
	table.sort(list,function(a,b) return a.effect[1]>b.effect[1] end)
	local start_prop = (function(list) 
		for i,v in ipairs(list) do
			if v.effect_ex[1] <= formula_data.level then
				return v
			end
		end
	end)(list)
	if start_prop then
		self.start_prop_id = start_prop.code
		local count = bag:get_item_count(self.start_prop_id,ServerEnum.BAG_TYPE.NORMAL)
		gf_set_item(self.start_prop_id,item.icon,item.bg)
		local str = count<1 and "<color=#CE3636>%d</color>/1" or "%d/1"
		item.num.text = string.format(str,count)
		item.add:SetActive(count<=0)
		--勾选
		self.startCheck.isOn = self.start_check
		item.obj:SetActive(true)
	else
		item.obj:SetActive(false)
		if self.start_check then
			self.start_check = false
			UnityEngine.PlayerPrefs.SetInt(self.color_toogle_key,0)
		end
	end

	if color_prop and start_prop then
		self.itemListGroup.spacing = 10
	else
		self.itemListGroup.spacing = 40
	end
end

function Formula:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_level_down_drag()
	end
end

function Formula:on_hided()
	StateManager:remove_register_view( self )
	self.eff:SetActive(false)
end

-- 释放资源
function Formula:dispose()
    self._base.dispose(self)
 end

return Formula