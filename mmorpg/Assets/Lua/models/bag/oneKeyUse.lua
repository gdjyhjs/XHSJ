--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-26 17:04:55
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local BagUserData = require("models.bag.bagUserData")
local BagTools = require("models.bag.bagTools")
local BagEnum = require("models.bag.bagEnum")

local OneKeyUse=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "one_key_use.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

local one_page_item_count = 20
local max_page = 6

function OneKeyUse:set_parent(parent)
	self.parent = parent
	if self.parent and self:is_loaded() then
		self.root.transform:SetParent(parent.transform,false)
	end
end
function OneKeyUse:set_hide_obj(obj)
	self.hide_obj = obj
end

-- 资源加载完成
function OneKeyUse:on_asset_load(key,asset)
    print("一键使用加载完成",self.parent)

	self:init_ui()
end
function OneKeyUse:init_ui()
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
	scrollPage.endDragFn = function(p) print("拖拽结束") self:on_end_drag(p) end

	self.init = true


	self:refresh_all()
end
function OneKeyUse:set_bag_page_mark()
	print("设置背包页标志，当前页：",self.open_page)
	self.bagPageMarks[self.open_page].isOn = true
end

function OneKeyUse:on_click(obj,arg)
	print("点击背包",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "one_key_use" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		print("使用全部")
		local guid = {}
		local num = {}
		for i,v in ipairs(self.items) do
			guid[i] = v.item.guid
			num[i] = v.item.num
		end
		self.item_obj:multi_use_item_c2s(guid,num)
	elseif cmd == "cancel_one_key_use" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		print("返回")
		self:hide()
	elseif string.find(cmd,"oneKeyUseItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		print("使用某个物品",cmd)
		local index = tonumber(string.split(cmd,"_")[2])
		local item = self.items[index].item
		gf_print_table(item,"物品数据")
		-- local item = data.item
		if item.num > 1 then
			self.item_obj:use_item_c2s(item.guid,item.num,item.protoId)
			-- local itemSys = LuaItemManager:get_item_obejct("itemSys")
			-- itemSys.tips_item = item
			-- itemSys.current_show_item.data = data.data
			-- itemSys:tips_btn_fun_split()
		else
			self.item_obj:use_item_c2s(item.guid,item.num,item.protoId)
		end
	end
end

--在手指滑动结束
function OneKeyUse:on_end_drag(p)
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
function OneKeyUse:update_page_info(bagPage,page)
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
			gf_print_table(data.item,"有物品")
			ref.name = "oneKeyUseItem_"..i
		else
			print("空")
		end
	end
end

function OneKeyUse:register()
	StateManager:register_view( self )
end

function OneKeyUse:cancel_register()
	StateManager:remove_register_view( self )
end

function OneKeyUse:on_showed()
	self:register()
	if self.init then
		self.open_page = 1
		self:refresh_all()
	end
	if self.item_obj.OneKeyUseHideObj then
		self.item_obj.OneKeyUseHideObj:SetActive(false)
	end
end

function OneKeyUse:on_hided()
	self:dispose()
end

-- 释放资源
function OneKeyUse:dispose()
    self:cancel_register()
	if self.item_obj.OneKeyUseHideObj then
		self.item_obj.OneKeyUseHideObj:SetActive(true)
		self.item_obj.OneKeyUseHideObj = nil
	end
	self.item_obj.OneKeyUseObj = nil
    self._base.dispose(self)
 end

 --服务器返回
function OneKeyUse:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
        if(id2== Net:get_id2("bag", "UseItemR"))then
            --更新背包大小
            self:refresh_all()
        elseif(id2== Net:get_id2("bag", "MultiUseItemR"))then
            --更新背包大小
            self:refresh_all()
        end
    end
end

--刷新3个页面
function OneKeyUse:refresh_all()
	local fun = function(item,info)
		return --在背包直接使用 并且 可批量使用
		bit._and(info.use_type,ClientEnum.ITEM_USE_TYPE.BAG_DIRECT)==ClientEnum.ITEM_USE_TYPE.BAG_DIRECT
		and bit._and(info.use_type,ClientEnum.ITEM_USE_TYPE.BATCH)==ClientEnum.ITEM_USE_TYPE.BATCH
	end
	--获取所有可批量使用的物品
	self.items = self.item_obj:get_item_for_condition_fun(fun,Enum.BAG_TYPE.NORMAL)
	table.sort(self.items,function(a,b) return a.item.slot<b.item.slot end)
	-- gf_print_table(self.items,"所有可一键使用的物品")

	print("刷新所有页")
	self:update_page_info(self.open_page,BagEnum.PAGE.CUR) --更新当前正看的特权
	self:update_page_info(self.open_page-1,BagEnum.PAGE.LAST) --更新特权上一页
	self:update_page_info(self.open_page+1,BagEnum.PAGE.NEXT) --更新特权下一页
end


return OneKeyUse

