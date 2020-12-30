--[[--
--
-- @Author:HuangJuNShan
-- @DateTime:2017-07-07 17:41:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Color = UnityEngine.Color
local Enum = require("enum.enum")
local BagEnum = require("models.bag.bagEnum")
local BagTools = require("models.bag.bagTools")
local Effect = require("common.effect")

local type_list = {} -- 类型标题
local category_list = {}
local prop_list = {} --当前显示的道具选项的sel

local data = {} -- 分好类的数据
for i,v in ipairs(ConfigMgr:get_config("smelt")) do
	if not data[v.type] then
		data[v.type] = {}
		type_list[v.type] = {}
		type_list[v.type].name = v.type_name
		category_list[v.type] = {}
	end
	if not data[v.type][v.category] then
		data[v.type][v.category] = {}
		category_list[v.type][v.category] = {}
		category_list[v.type][v.category].name = v.category_name
	end
	data[v.type][v.category][#data[v.type][v.category]+1] = v
end

local Fusion=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "fusion.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
end)
-- gf_print_table(data,"分好类的数据")
-- gf_print_table(type_list,"所有大类")
-- gf_print_table(category_list,"所有小类")

-- 资源加载完成
function Fusion:on_asset_load(key,asset)
	self.eff_list = {}
	self:init_ui()
end

function Fusion:init_ui()
	self.noUseTitleItemObj = {} -- 左侧未使用的标题项
	self.useTitleItemObj = {} -- 左侧正在使用的标题项
	self.noUsePropItemObj = {} -- 左侧未使用的配方项
	self.usePropItemObj = {} -- 左侧正在使用的配方项
	self.itemRoot = self.refer:Get("fusionLeftList")
	self.titleItemSample = self.refer:Get("titleItem")
	self.propItemSample = self.refer:Get("propItem")
	
	local titleRoot = self.refer:Get("titleRoot")
	local funsionType_smalp = self.refer:Get("funsionType_smalp")
	-- gf_print_table(type_list,"设置所有大分类")
	for i,v in ipairs(type_list or {}) do
		v.obj = LuaHelper.InstantiateLocal(funsionType_smalp,titleRoot)
		v.obj:SetActive(true)
		local tf = v.obj.transform
		v.sel = tf:FindChild("sel").gameObject
		v.nosel = tf:FindChild("nosel").gameObject
		v.sel:GetComponentInChildren("UnityEngine.UI.Text").text = v.name
		v.nosel:GetComponentInChildren("UnityEngine.UI.Text").text = v.name
		v.obj.name = "funsionType_"..i
	end

	
	self.item_obj:get_only_show_can_c2s()
	self.init = true
end

--服务器返回
function Fusion:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
        if(id2== Net:get_id2("bag", "GetOnlyShowCanR"))then
			gf_print_table(msg,">>>>>>>>>>>>>熔炼系统~~~~~~~~~~~~~~~获取是否只显示能打造的")
            self:set_def(msg.bOnlyShowCan)
        elseif(id2== Net:get_id2("bag", "SmeltItemR"))then
			gf_print_table(msg,"~~~~~~~~~~~~~~~熔炼系统>>>>>>>>>>>>>熔炼物品")
            self:update_ui_data()
            if msg.err == 0 then
            	-- 背包-合成、副本-过关斩将-圣物强化、锻造-镶嵌播放的音效
				Sound:play(ClientEnum.SOUND_KEY.PROCESS)
            	local cb = function()
		        	gf_mask_show(false)
		        	local view = View("fusionSucceed",self.item_obj)
		        	view:set_content(msg.protoIdArr,msg.protoNumArr)
		        end
            	self:play_eff("41000081",cb)
            else
		        	gf_mask_show(false)
            end
        end
    end
end

--播放特效
function Fusion:play_eff(eff_name,cb)
	print("---------------------开始播放特效---------------  名字：",eff_name)
	gf_print_table(self.eff_list,"所有特效")
	local end_cb = function()
			cb()
		end

	if self.eff_list[eff_name] then
		self.eff_list[eff_name]:set_finish_cb(end_cb)
		self.eff_list[eff_name]:show_xp(false,false)
	else
		self.eff_list[eff_name] = Effect(eff_name..".u3d",function( ... ) 
			print(eff_name)
			print(self.eff_list[eff_name])
			print(self.eff_list[eff_name].set_finish_cb)
			self.eff_list[eff_name]:set_finish_cb(end_cb)
			local tf = self.eff_list[eff_name].root.transform
			tf:SetParent( self.refer:Get(eff_name),false)
			self.eff_list[eff_name]:show_xp(false,false)
		end)
		print(self.eff_list[eff_name])
	end
	self.cur_eff = self.eff_list[eff_name]
end

--设置默认
function Fusion:set_def(bOnlyShowCan)
	print("收到协议,获取是否只显示能打造的",bOnlyShowCan)
	-- self.sel_type = nil -- 选择的类型
	-- self.sel_category = nil -- 选择的分类
	-- self.sel_prop = nil -- 选择要合成的配方id
	-- self.sel_buy_count = nil-- 选择要合成的目标数量
	-- self.sel_buy_max_count = nil -- 选择要合成的目标最大数量
	-- self.sel_buy_price = nil -- 选择要合成的目标 合成费用单价
	self.only_show_can_funsion = bOnlyShowCan -- 是否勾选只显示可合成列表

	self.refer:Get("onlyShowCanFunsion").isOn = self.only_show_can_funsion
	self:switch_type(1)
end

--选择炼化类型  设置分类  默认选择第一个分类 
function Fusion:switch_type(t)
	if self.sel_type then -- 取消原选择效果
		type_list[self.sel_type].sel:SetActive(false)
		type_list[self.sel_type].nosel:SetActive(true)
	end
	self.sel_type = t or self.sel_type or 1 -- 设置当前选择效果
	print("选择炼化的类型",self.sel_type)
	if self.sel_type then
		type_list[self.sel_type].sel:SetActive(true)
		type_list[self.sel_type].nosel:SetActive(false)
	end
	self:clear_title_ui()
	self:clear_prop_ui()
	-- local list = self.item_obj:get_funsion_config()
	for i,v in ipairs(category_list[self.sel_type] or {}) do
		print("设置左侧分类项，位置在",i)
		local obj = self:get_title_ui(i)
		obj.name = "titleItem_"..i
		local ref = obj:GetComponent("ReferGameObjects")
		ref:Get("text").text = v.name
		v.sel = ref:Get("sel")
		v.nosel = ref:Get("nosel")
		v.sel:SetActive(false)
		v.nosel:SetActive(true)
	end
	self:switch_category(1)
end

--选择炼化分类  设置左侧配方项
function Fusion:switch_category(t)
	if self.sel_category and category_list[self.sel_type][self.sel_category] and category_list[self.sel_type][self.sel_category].sel then
			category_list[self.sel_type][self.sel_category].sel:SetActive(false)
			category_list[self.sel_type][self.sel_category].nosel:SetActive(true)
	end
	self.sel_category = t or self.sel_category or 1
	print("选择炼化分类,设置配方列表",self.sel_category)
	if self.sel_category and category_list[self.sel_type][self.sel_category] and category_list[self.sel_type][self.sel_category].sel then
		category_list[self.sel_type][self.sel_category].sel:SetActive(true)
		category_list[self.sel_type][self.sel_category].nosel:SetActive(false)
	end

	--清空配方项
	self:clear_prop_ui()
	--设置配方项
	local index = self.sel_category
	local def_prop = nil
	prop_list = {} -- 当前显示的道具选项的sel
	for i,v in ipairs(data[self.sel_type][self.sel_category] or {}) do
		--计算出可合成的数量
		local count = self:calculate_fusion_max_count(v)
		if not self.only_show_can_funsion or count>0 then
			index = index +1
			-- print("设置左侧配方项，位置在",index)
			local obj = self:get_prop_ui(index)
			obj.name = "propItem_"..v.smelt_id
			local ref = obj:GetComponent("ReferGameObjects")
			ref:Get("text").text = BagTools:get_item_name(v.gain_item_code,count,ref:Get("text")) -- 设置选项名称
			gf_set_item(v.gain_item_code,ref:Get("icon"),ref:Get("color")) -- 设置合成物品图标
			prop_list[v.smelt_id] = ref:Get("sel")
			prop_list[v.smelt_id]:SetActive(def_prop==nil)
			if def_prop==nil then
				def_prop = v.smelt_id
			end
		end
	end
	-- print(self.sel_type,self.sel_category)
	-- gf_print_table(data)
	-- print(type(self.sel_type),type(self.sel_category))
	-- print("大分类",self.sel_type,data[self.sel_type])
	-- print("小分类",self.sel_category,data[self.sel_type][self.sel_category])
	-- gf_print_table(data[self.sel_type][self.sel_category])
	-- print("第一个",data[self.sel_type][self.sel_category][1])
	-- gf_print_table(data[self.sel_type][self.sel_category][1])
	self:switch_prop(def_prop or data[self.sel_type][self.sel_category][1].smelt_id)
end

--选择配方 --设置右侧信息
function Fusion:switch_prop(id)
	if self.sel_prop and prop_list[self.sel_prop] then
		prop_list[self.sel_prop]:SetActive(false)
	end
	self.sel_prop = id or self.sel_prop
	print("选择炼化配方",self.sel_prop)
	if self.sel_prop and prop_list[self.sel_prop] then
		prop_list[self.sel_prop]:SetActive(true)
	end

	local ref = self.refer:Get("normal_ui_ref")
	local r = ref:Get("funsion_data_ref")

	local v = ConfigMgr:get_config("smelt")[id]
	--计算出可合成的最大数量
	local count = self:calculate_fusion_max_count(v)
	--设置成功率
	r:Get("rateText").text = string.format("%.2d%%",v.rate*0.01)
	--设置选择数量
	self.sel_buy_max_count = count
	self.sel_buy_count = v.def_sel_count == 0 and 1 or count
	self.sel_buy_price = v.coin
	local c = gf_get_text_color(self.sel_buy_count==0 and ClientEnum.SET_GM_COLOR.TIPS_RED or ClientEnum.SET_GM_COLOR.TIPS_GREEN)
	local t = string.format("<color=%s>%d</color>",c,self.sel_buy_count)
	self.refer:Get("target1Count").text = t
	r:Get("buyCount").text = self.sel_buy_count
	--设置消耗货币
	r:Get("bugMoneyCount").text = v.coin * self.sel_buy_count
	--设置合成按钮
	r:Get("fusionBtn").name = "fusionBtn_"..id
	--设置目标合成图标
	gf_set_item(v.gain_item_code,ref:Get("targetIcon"),ref:Get("targetColor"))
	-- ref:Get("targetAdd")
	-- ref:Get("targetCount")
	ref:Get("targetName").text = BagTools:get_item_name(v.gain_item_code,0,ref:Get("targetName"))
	 -- LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(v.gain_item_code)
	-- ref:Get("targetColor").name = "targetStuff_"..v.gain_item_code
	gf_set_click_prop_tips(ref:Get("targetColor"),v.gain_item_code)
	--设置材料图标
	local d = v.need_item
	local i = 1
	if d[i] then
		-- 需要这个材料  --显示这个材料
		ref:Get("stuff"..i.."Icon").gameObject:SetActive(true)
		ref:Get("stuff"..i.."Count").gameObject:SetActive(true)
		-- ref:Get("stuff"..i.."Add"):SetActive(true)
		local id = d[i][1]
		local need = d[i][2]
		gf_set_item(id,ref:Get("stuff"..i.."Icon"),ref:Get("stuff"..i.."Color"))
		ref:Get("stuff"..i.."Name").text = BagTools:get_item_name(id,0,ref:Get("stuff"..i.."Name"))
		 -- LuaItemManager:get_item_obejct("itemSys"):get_have_color_item_name(id)
		--获取材料数量
		local num = self.item_obj:get_item_count(id,Enum.BAG_TYPE.NORMAL)
		print("材料进度",num,need)
		-- local c = num<need and "#000000" or "#FFFFFF"
		local c = gf_get_text_color(num<need and ClientEnum.SET_GM_COLOR.TIPS_RED or ClientEnum.SET_GM_COLOR.TIPS_GREEN)
		ref:Get("stuff"..i.."Count").text = "<color="..c..">"..num.."/"..need.."</color>"
		-- 暂时不显示+号
		-- ref:Get("stuff"..i.."Add"):SetActive(num<need)
		-- if num<need then
			-- gf_set_click_prop_tips(ref:Get("stuff"..i.."Add"),id)
		-- else
			gf_set_click_prop_tips(ref:Get("stuff"..i.."Color"),id)
		-- end
	else
		-- 不需要这个材料  --显示空白 
		gf_setImageTexture(ref:Get("stuff"..i.."Color"),"item_color_0")
		ref:Get("stuff"..i.."Icon").gameObject:SetActive(false)
		ref:Get("stuff"..i.."Count").gameObject:SetActive(false)
		-- ref:Get("stuff"..i.."Add"):SetActive(false)
		ref:Get("stuff"..i.."Color").name = ""
	end
end

-- 更新界面信息
function Fusion:update_ui_data()
	self:switch_category()
	if true then
		return
	end
	-- 刷新左侧列表信息
	for i,obj in ipairs(self.usePropItemObj) do
		-- 获取当前配方id
		local id = tonumber(string.split(obj.name,"_")[2])
		-- 获取可以熔炼几个
		local v = ConfigMgr:get_config("smelt")[id]
		local count = self:calculate_fusion_max_count(v)
		local ref = obj:GetComponent("ReferGameObjects")

		if count > 0 then
			ref:Get("text").text = BagTools:get_item_name(v.gain_item_code,count,ref:Get("text"))
		else
			if self.only_show_can_funsion then
				obj:SetActive(false)
				-- if self.sel_prop == id then
				-- 	-- 待会要更换选择的配方
				-- 	self.sel_prop = nil
				-- end
			else
				ref:Get("text").text = BagTools:get_item_name(v.gain_item_code,count,ref:Get("text"))
			end
		end
	end
    self:switch_prop(self.sel_prop)
end

-- 获取一个标题ui，并且设置到对应的位置
function Fusion:get_title_ui(index)
	local obj = self.noUseTitleItemObj[1]
	if obj then
		table.remove(self.noUseTitleItemObj,1)
	else
		obj = LuaHelper.InstantiateLocal(self.titleItemSample,self.itemRoot)
	end
	obj.transform:SetSiblingIndex(index)
	obj:SetActive(true)
	self.useTitleItemObj[#self.useTitleItemObj+1] = obj
	return obj
end

-- 获取一个配方ui，并且设置到对应的位置
function Fusion:get_prop_ui(index)
	local obj = self.noUsePropItemObj[1]
	if obj then
		table.remove(self.noUsePropItemObj,1)
	else
		obj = LuaHelper.InstantiateLocal(self.propItemSample,self.itemRoot)
	end
	obj.transform:SetSiblingIndex(index)
	obj:SetActive(true)
	self.usePropItemObj[#self.usePropItemObj+1] = obj
	return obj
end

-- 归还标题ui
function Fusion:clear_title_ui()
	for i,v in ipairs(self.useTitleItemObj or {}) do
		v.transform:SetAsLastSibling()
		self.noUseTitleItemObj[#self.noUseTitleItemObj+1] = v
		v.transform:SetAsLastSibling()
		v:SetActive(false)
	end
	self.useTitleItemObj = {}
end

-- 归还配方ui
function Fusion:clear_prop_ui()
	for i,v in ipairs(self.usePropItemObj or {}) do
		v.transform:SetAsLastSibling()
		self.noUsePropItemObj[#self.noUsePropItemObj+1] = v
		v.transform:SetAsLastSibling()
		v:SetActive(false)
	end
	self.usePropItemObj = {}
end

-- 计算可合成该配方的最大数
function Fusion:calculate_fusion_max_count(data)
	-- 判断当前拥有的材料最多能合成几份
	local has_count = {}
	for i,v in ipairs(data.need_item) do
		local num = self.item_obj:get_item_count(v[1],Enum.BAG_TYPE.NORMAL)
		has_count[#has_count+1]=math.floor(num/v[2])
	end
	table.sort(has_count)
	local stuff_count = has_count[1]
	--判断当前拥有的金币最多能合成几份
	local money_count = math.floor(LuaItemManager:get_item_obejct("game"):get_money(Enum.BASE_RES.COIN)/data.coin)
	return stuff_count<money_count and stuff_count or money_count
end

--打开默认选项：普通合成
function Fusion:open_def_mode()
	-- self.sel_type = 1
	-- local ref = self.refer:Get("funsionType_1")
	-- local t = ref:Get("toggle")
	-- -- print("炼化初始化完毕，开启默认选择",t)
	-- t.group:SetAllTogglesOff()
	-- t.isOn = true	
end

--鼠标单击事件
function Fusion:on_click(obj, arg)
	-- print("点击了>>>>>>>>>>>>>>炼化系统",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"haveStuff_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
			
		local i = tonumber(string.split(cmd,"_")[2])
		LuaItemManager:get_item_obejct("itemSys"):common_show_item_info(i)
		-- return true
	elseif cmd == "addBuyCount" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		self.sel_buy_count = self.sel_buy_count+1 > self.sel_buy_max_count and (self.sel_buy_max_count<1 and 0 or 1) or self.sel_buy_count+1
		self.refer:Get("buyCount").text = self.sel_buy_count
		local c = gf_get_text_color(self.sel_buy_count==0 and ClientEnum.SET_GM_COLOR.TIPS_RED or ClientEnum.SET_GM_COLOR.TIPS_GREEN)
		local t = string.format("<color=%s>%d</color>",c,self.sel_buy_count)
		self.refer:Get("target1Count").text = t
		self.refer:Get("bugMoneyCount").text = self.sel_buy_count * self.sel_buy_price
		-- return true
	elseif cmd == "cutBuyCount" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		self.sel_buy_count = self.sel_buy_count-1 < 1 and self.sel_buy_max_count or self.sel_buy_count-1
		self.refer:Get("buyCount").text = self.sel_buy_count
		local c = gf_get_text_color(self.sel_buy_count==0 and ClientEnum.SET_GM_COLOR.TIPS_RED or ClientEnum.SET_GM_COLOR.TIPS_GREEN)
		local t = string.format("<color=%s>%d</color>",c,self.sel_buy_count)
		self.refer:Get("target1Count").text = t
		self.refer:Get("bugMoneyCount").text = self.sel_buy_count * self.sel_buy_price
		-- return true
	elseif cmd == "buyCount" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		self:show_number_keyboard(arg)
		-- return true
	elseif string.find(cmd,"needStuff_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
			
		local i = tonumber(string.split(cmd,"_")[2])
		LuaItemManager:get_item_obejct("itemSys"):common_show_item_info(i,nil,nil,-600)
		-- return true
	elseif string.find(cmd,"targetStuff_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
			
		local i = tonumber(string.split(cmd,"_")[2])
		LuaItemManager:get_item_obejct("itemSys"):common_show_item_info(i)
		-- return true
	elseif string.find(cmd,"funsionType_")then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 音效
		
		-- 切换 合成大类
		self:switch_type(tonumber(string.split(cmd,"_")[2]))
		-- return true

	elseif string.find(cmd,"titleItem_")then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		-- 切换 合成小分类
		if arg.activeSelf then
			print("关闭小分类")
			self:clear_prop_ui()
			if self.sel_category and category_list[self.sel_type][self.sel_category] and category_list[self.sel_type][self.sel_category].sel then
				category_list[self.sel_type][self.sel_category].sel:SetActive(false)
				category_list[self.sel_type][self.sel_category].nosel:SetActive(true)
			end
		else
			print("打开小分类",tonumber(string.split(cmd,"_")[2]))
			self:switch_category(tonumber(string.split(cmd,"_")[2]))
		end
		-- return true

	elseif cmd == "onlyShowCanFunsion" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		self.only_show_can_funsion = arg.isOn
		self.item_obj:set_only_show_can(arg.isOn)
		self:switch_category() -- 重新设置左侧配方项

		-- return true		
	
	elseif string.find(cmd,"propItem_")then -- 切换道具合成项
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_THREE_BTN) -- 音效
		
			self:switch_prop(tonumber(string.split(cmd,"_")[2]))

		-- return true

	elseif string.find(cmd,"fusionBtn_")then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		-- arg.interactable = false
		local i = tonumber(string.split(cmd,"_")[2])
		print("合成物品",i,self.sel_buy_count)
		--判断材料是否足够
		for i,v in ipairs(ConfigMgr:get_config("smelt")[i].need_item) do
			if self.item_obj:get_item_count(v[1]) < v[2] then
				gf_message_tips("合成材料不足")
				return
			end
		end
		self.item_obj:smelt_item_c2s(i,self.sel_buy_count)
		-- return true
		gf_mask_show(true)
	end

	print("点击了>>>>>>>>>>>>>>炼化系统 判断无效")
	-- return false

end

function Fusion:show_number_keyboard(text)
	print("打开小键盘协助输入",text)
	local exit_kb = function(result)
		result = tonumber(result) or self.sel_buy_max_count or 1
		self.sel_buy_count = tonumber(result)
		self.sel_buy_count = self.sel_buy_count==0 and self.sel_buy_max_count~=0 and 1 or self.sel_buy_count
		text.text = self.sel_buy_count
		self.refer:Get("bugMoneyCount").text = self.sel_buy_count * self.sel_buy_price
	end
	LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(text,self.sel_buy_max_count,nil,nil,nil,nil,nil,exit_kb)
end


function Fusion:register()
	StateManager:register_view( self )
	print("注册了熔炼系统")
end

function Fusion:cancel_register()
	StateManager:remove_register_view( self )
	print("取消注册了熔炼系统")
end

function Fusion:on_showed()
	self:register()
	if self.init then
		self.item_obj:get_only_show_can_c2s()
	end
end

function Fusion:on_hided()
	if self.cur_eff then
		self.cur_eff:hide()
	end
    self:cancel_register()
	print("Knapsack隐藏资源")
end

-- 释放资源
function Fusion:dispose()
	print("---------------------------清空特效")
	for k,v in pairs(self.eff_list) do
		print("---------------------------清空特效",k,v)
		v:dispose()
	end
	self.eff_list = {}
	self.init = nil
	self:cancel_register()
	print("Knapsack释放资源")
    self._base.dispose(self)
 end

return Fusion
