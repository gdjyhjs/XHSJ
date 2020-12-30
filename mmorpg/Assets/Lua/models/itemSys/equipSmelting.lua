--[[--
-- 装备熔炼
-- @Author:Seven
-- @DateTime:2017-08-16 11:34:53
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local BagUserData = require("models.bag.bagUserData")
local BagTools = require("models.bag.bagTools")
local BagEnum = require("models.bag.bagEnum")

local EquipSmelting=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "equip_smelting.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)
local one_page_item_count = 24
local max_page = 5
local bag = LuaItemManager:get_item_obejct("bag")

-- 资源加载完成
function EquipSmelting:on_asset_load(key,asset)
	self.open_page = 1
	--设置滑动页
	self.minPageIndex = 1
	print("最大页数",max_page)
	local scrollPage = self.refer:Get("ScrollPage")
	scrollPage.minPageIndex = self.minPageIndex
	scrollPage.maxPageIndex = max_page
	self.bagPageMarks = {}
	local go = self.refer:Get("bagPageMark")
	local parent = go.transform.parent
	for i=1,max_page do
		local _ = parent.childCount>i and parent:GetChild(i).gameObject or LuaHelper.InstantiateLocal(go,go.transform.parent.gameObject)
		self.bagPageMarks[#self.bagPageMarks+1] = _:GetComponent("UnityEngine.UI.Toggle")
		_:SetActive(true)
	end
	scrollPage:SetPageIndex(self.open_page)
	self:set_bag_page_mark()
	scrollPage.endDragFn = function(p) 
	print("拖拽结束") 
	self:on_end_drag(p) end

	self.init = true

	self:refresh_all()
end
function EquipSmelting:set_bag_page_mark()
	print("设置背包页标志，当前页：",self.open_page)
	self.bagPageMarks[self.open_page].isOn = true
end
--在手指滑动结束
function EquipSmelting:on_end_drag(p)
print("在手指滑动结束时 选择的是",p)
	if p~=self.minPageIndex and p~=max_page then
		if self.open_page<p then
			self:update_page_info(p+1,BagEnum.PAGE.NEXT)
		elseif self.open_page>p then
			self:update_page_info(p-1,BagEnum.PAGE.LAST)
		end
	end
	self.open_page = p
	self:set_bag_page_mark()
end
--更新vip描述
function EquipSmelting:update_page_info(bagPage,page)
	print("更新背包信息,更新背包的第",bagPage,"页，属于页",page)
	if bagPage<self.minPageIndex then
		bagPage = bagPage + 3
	elseif bagPage>max_page then
		bagPage = bagPage - 3
	end
	local scroll = self.refer:Get("ScrollPage")
	local go = (page == BagEnum.PAGE.LAST and scroll:GetLastPage()) or (page == BagEnum.PAGE.CUR and scroll:GetCurPage()) or (page == BagEnum.PAGE.NEXT and scroll:GetNextPage())
	for i=1,one_page_item_count do
		local ref = go.transform:GetChild(i-1):GetComponent("ReferGameObjects")
		local data = self.items[(bagPage-1)*one_page_item_count+i]
		local slot = data and data.item.slot or 0
		BagTools:set_item(ref,slot)
		if slot~=0 then
			-- gf_print_table(data.item,"有物品")
			local guid = data.item.guid
			local level = data.data.level
			local color = data.item.color
			ref.name = "selectItem_"..guid.."_"..level.."_"..color
			ref:Get("select").gameObject:SetActive(self.select_list[guid]==guid)
		else
			-- print("空")
			ref:Get("select").gameObject:SetActive(false)
		end
	end
end

function EquipSmelting:on_click(obj,arg)
	print("点击背包",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd == "one_key_smelting" then -- 一键熔炼
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local t = {}
		for i,v in ipairs(self.items or {}) do
			if v.item.color < 3 then
				t[#t+1] = v.item.guid
			end
		end
		if #t>0 then
			bag:recycle_equip_c2s(t)
		else
			gf_message_tips("没有可熔炼的装备")
		end
	elseif cmd == "sure_btn" then -- 确认熔炼
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local t = {}
		for k,v in pairs(self.select_list or {}) do
			t[#t+1] = v
		end
		if #t>0 then
			bag:recycle_equip_c2s(t)
		else
			gf_message_tips("请选择要熔炼的装备")
		end
	elseif cmd == "exchange_btn" then -- 兑换
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("兑换")
	elseif string.find(cmd,"selectItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local cip = string.split(cmd,"_")
		local equip_guid = tonumber(cip[2])
		local get_quench = self.item_obj:get_give_quench(tonumber(cip[3]),tonumber(cip[4]))
		local selObj =  arg:Get("select").gameObject
		local isOn = not selObj.activeSelf
		if isOn then
			selObj:SetActive(true)
			self.select_list[equip_guid] = equip_guid
			self:set_get_res(get_quench)
		else
			selObj:SetActive(false)
			self.select_list[equip_guid] = nil
			self:set_get_res(-get_quench)
		end
	end
end
function EquipSmelting:register()
	StateManager:register_view( self )
end

function EquipSmelting:cancel_register()
	StateManager:remove_register_view( self )
end

function EquipSmelting:on_showed()
	self.select_list = {} -- 用来储存选择的物品的列表的guid {guid=guid}
	self.giveRes = 0
	self:register()
	if self.init then
		self.open_page = 1
		self:refresh_all()
	end
	if self.hide_obj then
		self.hide_obj:SetActive(false)
	end
end

function EquipSmelting:on_hided()
    self:cancel_register()
	if self.hide_obj then
		print("隐藏obj",self.hide_obj)
    	self.hide_obj:SetActive(true)
	end
end

 --服务器返回
function EquipSmelting:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
        if(id2== Net:get_id2("bag", "RecycleEquipR"))then
        	if msg.err == 0 then
        		self.select_list = {}
				self.giveRes = 0
            	self:refresh_all()
            end
        end
    end
    if(id1==Net:get_id1("base"))then
        if(id2== Net:get_id2("base", "UpdateResR"))then
            self:set_res()
        end
    end
end

--设置拥有淬火
function EquipSmelting:set_res()
    local game = LuaItemManager:get_item_obejct("game")
    self.refer:Get("haveRes").text= game.role_info.baseRes[Enum.BASE_RES.QUENCH]
end

--设置可获得淬火
function EquipSmelting:set_get_res(addValue)
	self.giveRes = self.giveRes + addValue
	self.refer:Get("giveRes").text= self.giveRes
end

-- 释放资源
function EquipSmelting:dispose()
	self:cancel_register()
    self._base.dispose(self)
 end

--刷新3个页面
function EquipSmelting:refresh_all()
	local fun = function(item,info)
		return --在背包的装备
		info.type==Enum.ITEM_TYPE.EQUIP and info.sub_type < Enum.EQUIP_TYPE.END
	end
	--获取所有可批量使用的物品
	self.items = bag:get_item_for_condition_fun(fun,Enum.BAG_TYPE.NORMAL)
	-- gf_print_table(self.items,"所有可一键使用的物品")
	table.sort( self.items, function(a,b) return a.item.color<b.item.color end )

	self:update_page_info(self.open_page,BagEnum.PAGE.CUR) --更新当前正看的特权
	self:update_page_info(self.open_page-1,BagEnum.PAGE.LAST) --更新特权上一页
	self:update_page_info(self.open_page+1,BagEnum.PAGE.NEXT) --更新特权下一页

	self:set_res() -- 刷新资源
	self:set_get_res(0)
end

return EquipSmelting