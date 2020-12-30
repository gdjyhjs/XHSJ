--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-26 17:04:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local BagUserData = require("models.bag.bagUserData")
local BagTools = require("models.bag.bagTools")
local Enum = require("enum.enum")
local BagEnum = require("models.bag.bagEnum")

local Depot=class(UIBase,function(self,item_obj,ui,page)
    UIBase._ctor(self, "depot.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
	
end)

-- 资源加载完成
function Depot:on_asset_load(key,asset)
	--获取ui
	self.btn_b_zhengLi_filled = self.refer:Get("btn_b_zhengLi_filled")
	self.btn_b_zhengLi_filled_text = self.refer:Get("btn_b_zhengLi_filled_text")
	self.btn_b_heBing_filled = self.refer:Get("btn_b_heBing_filled")
	self.btn_b_heBing_filled_text = self.refer:Get("btn_b_heBing_filled_text")
	self.btn_w_zhengLi_filled = self.refer:Get("btn_w_zhengLi_filled")
	self.btn_w_zhengLi_filled_text = self.refer:Get("btn_w_zhengLi_filled_text")
	self.btn_w_heBing_filled = self.refer:Get("btn_w_heBing_filled")
	self.btn_w_heBing_filled_text = self.refer:Get("btn_w_heBing_filled_text")

	--背包	
	self.minPageIndex = 1
	self.maxPageIndex = BagUserData:get_knapsack_max_page(Enum.BAG_TYPE.NORMAL)
	self.item_obj.bag_open_page = (self.item_obj.bag_open_page<1 or self.item_obj.bag_open_page>self.maxPageIndex and 1) or self.item_obj.bag_open_page
	local scroll = self.refer:Get("ScrollPage")
	scroll.minPageIndex = self.minPageIndex
	scroll.maxPageIndex = self.maxPageIndex
	self.bagPageMarks = {}
	local go = self.refer:Get("bagPageMark")
	local parent = go.transform.parent
	for i=1,self.maxPageIndex do
		local _ = parent.childCount>i and parent:GetChild(i).gameObject or LuaHelper.InstantiateLocal(go,go.transform.parent.gameObject)
		self.bagPageMarks[#self.bagPageMarks+1] = _:GetComponent("UnityEngine.UI.Toggle")
		_:SetActive(true)
	end
	scroll:SetPageIndex(self.item_obj.bag_open_page)
	self:set_bag_page_mark()
	self:refresh_all_page()
	scroll.endDragFn = function(p) print("拖拽结束") self:on_end_drag(p) end

	--仓库
	self.depotCurPage = 1
	self.depotMinPageIndex = 1
	self.depotMaxPageIndex = BagUserData:get_knapsack_max_page(Enum.BAG_TYPE.DEPOT)
	local depotScroll = self.refer:Get("depotScrollPage")
	depotScroll.minPageIndex = self.depotMinPageIndex
	depotScroll.maxPageIndex = self.depotMaxPageIndex
	print("最大页数", self.depotMaxPageIndex)
	self.depotPageMarks = {}
	local go = self.refer:Get("depotPageMark")
	local parent = go.transform.parent
	for i=1,self.depotMaxPageIndex do
		local _ = parent.childCount>i and parent:GetChild(i).gameObject or LuaHelper.InstantiateLocal(go,go.transform.parent.gameObject)
		self.depotPageMarks[#self.depotPageMarks+1] = _:GetComponent("UnityEngine.UI.Toggle")
		_:SetActive(true)
	end
	depotScroll:SetPageIndex(self.item_obj.bag_open_page)
	self:set_depot_page_mark()
	self:refresh_depot_page()
	depotScroll.endDragFn = function(p) print("拖拽结束") self:on_depot_end_drag(p) end

	self.init = true
end
function Depot:set_bag_page_mark()
	print("设置背包页标志，当前页：",self.item_obj.bag_open_page)
	self.bagPageMarks[self.item_obj.bag_open_page].isOn = true
end
function Depot:set_depot_page_mark()
	self.depotPageMarks[self.depotCurPage].isOn = true
end

function Depot:on_click(obj,arg)
	print("点击仓库",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_b_heBing" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("点击了合并按钮")
		--合并
        local merge = function()
        	print("执行合并操作")
            self.item_obj:merge_item_c2s(Enum.BAG_TYPE.NORMAL)
            self.item_obj.last_merge_bag_time = Net:get_server_time_s()
        end
        LuaItemManager:get_item_obejct("cCMP"):add_message(gf_localize_string("合并将会对背包内可合并物品进行合并整理，绑定与非绑物品合并后，会全部变成<color=#52b44d>绑定状态</color>，请谨慎操作。"),merge,nil,nil,0)
	elseif cmd == "btn_w_heBing" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("--仓库合并")
        local merge = function()
            self.item_obj:merge_item_c2s(Enum.BAG_TYPE.DEPOT)
            self.item_obj.last_merge_ware_time = Net:get_server_time_s()
        end
        LuaItemManager:get_item_obejct("cCMP"):add_message(gf_localize_string("合并将会对背包内可合并物品进行合并整理，绑定与非绑物品合并后，会全部变成<color=#52b44d>绑定状态</color>，请谨慎操作。"),merge,nil,nil,0)		
	elseif cmd == "btn_w_zhengLi" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("--仓库整理")
        self.item_obj:sort_item_c2s(Enum.BAG_TYPE.DEPOT)
        self.item_obj.last_sort_ware_time = Net:get_server_time_s()
	elseif cmd == "btn_w_once_touch_use" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		--一键使用
		print("一键使用")
		self.item_obj:open_one_key_use(self.refer:Get("depot_mode"))
	elseif cmd == "btn_b_zhengLi" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--整理
    	print("执行整理操作")
        self.item_obj:sort_item_c2s(Enum.BAG_TYPE.NORMAL)
        self.item_obj.last_sort_bag_time = Net:get_server_time_s()
	elseif cmd == "btn_use" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		--使用
	elseif string.find(cmd,"canUnlockItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		local slot = tonumber(string.split(cmd,"_")[2])
		self.item_obj:unlock_slot_c2s({slot=slot})
	elseif string.find(cmd,"lockItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		local slot = tonumber(string.split(cmd,"_")[2])
		BagTools:expenditure_money_unlocking(slot)
	elseif string.find(cmd,"OnClickItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		--点击了物品
		local slot = tonumber(string.split(cmd,"_")[2])
		local t = math.floor(slot/10000)
		print("点击物品的背包类型是",t)
        local to=self.item_obj:get_bag_first_space(t==Enum.BAG_TYPE.NORMAL and Enum.BAG_TYPE.DEPOT or Enum.BAG_TYPE.NORMAL)
        --判断仓库满了没有
        if(not to)then
            LuaItemManager:get_item_obejct("cCMP"):add_message(t==Enum.BAG_TYPE.NORMAL and "仓库已满" or "背包已满")
            return
        end
        --传送到服务器
        print("更换位置",slot,to)
        self.item_obj:swap_item_c2s(slot,to)
		self.item_obj:open_one_key_use(self.refer:Get("depot_mode"),false)
	end
end

--在手指滑动结束
function Depot:on_end_drag(p)
print("在手指滑动结束时 选择的是",p)
	if p~=self.minPageIndex and p~=self.maxPageIndex then
		if self.item_obj.bag_open_page<p then
			self:update_page_info(p+1,BagEnum.PAGE.NEXT)
		elseif self.item_obj.bag_open_page>p then
			self:update_page_info(p-1,BagEnum.PAGE.LAST)
		end
	end
	self.item_obj.bag_open_page = p
	self:set_bag_page_mark()
end

--更新vip描述
function Depot:update_page_info(bagPage,page)
	print("更新背包信息,更新背包的第",bagPage,"页，属于页",page)
	if bagPage<self.minPageIndex then
		bagPage = bagPage + 3
	elseif bagPage>self.maxPageIndex then
		bagPage = bagPage - 3
	end
	local scroll = self.refer:Get("ScrollPage")
	local go = (page == BagEnum.PAGE.LAST and scroll:GetLastPage()) or (page == BagEnum.PAGE.CUR and scroll:GetCurPage()) or (page == BagEnum.PAGE.NEXT and scroll:GetNextPage())
	for i=1,BagUserData:get_knapsack_page_item_count(Enum.BAG_TYPE.NORMAL) do
		local bagType = Enum.BAG_TYPE.NORMAL
		local ref = go.transform:GetChild(i-1):GetComponent("ReferGameObjects")
		if self.on_lock_ref == ref then
			self.on_lock_ref = nil
			self.on_lock_timer:stop()
		end
		local slot = bagType*10000+(bagPage-1)*BagUserData:get_knapsack_page_item_count(bagType)+i
		BagTools:set_item(ref,slot)
		if slot%10000 == self.item_obj:get_bagsize(Enum.BAG_TYPE.NORMAL)+1 then
			if self.item_obj:get_bag_unlock_fill()>0 then
				self.on_lock_ref = ref
				BagTools:set_item_on_lock(ref,slot)
				self.on_lock_timer = Schedule(function() self:update_locking(slot) end ,1)
				self:update_locking(slot)
			else
				BagTools:set_item_can_lock(ref,slot)
			end
		end
	end
end

function Depot:update_depot_page_info(bagPage,page)
	if bagPage<self.depotMinPageIndex then
		bagPage = bagPage + 3
	elseif bagPage>self.depotMaxPageIndex then
		bagPage = bagPage - 3
	end
	local scroll = self.refer:Get("depotScrollPage")
	local go = (page == BagEnum.PAGE.LAST and scroll:GetLastPage()) or (page == BagEnum.PAGE.CUR and scroll:GetCurPage()) or (page == BagEnum.PAGE.NEXT and scroll:GetNextPage())
	for i=1,BagUserData:get_knapsack_page_item_count(Enum.BAG_TYPE.DEPOT) do
		local bagType = Enum.BAG_TYPE.DEPOT
		local ref = go.transform:GetChild(i-1):GetComponent("ReferGameObjects")
		local slot = bagType*10000+(bagPage-1)*BagUserData:get_knapsack_page_item_count(bagType)+i
		BagTools:set_item(ref,slot)
	end
end

function Depot:update_locking(slot)
	if self.item_obj:get_bag_unlock_fill()>0 then
		BagTools:set_item_locking(self.on_lock_ref,self.item_obj:get_bag_unlock_fill())
	else
		BagTools:set_item_can_lock(self.on_lock_ref,slot)
		self.on_lock_ref = nil
		self.on_lock_timer:stop()
	end
end

function Depot:register()
	StateManager:register_view( self )
			gf_register_update(self) --注册每帧事件
end

function Depot:cancel_register()
	StateManager:remove_register_view( self )
			gf_remove_update(self) --注销每帧事件
end

function Depot:on_showed()
	self:register()
	if self.init then
		self.item_obj:set_have_red_point()
		if self.item_obj:is_have_red_point() then
			self.item_obj.bag_open_page = math.ceil((self.item_obj:get_bagsize(Enum.BAG_TYPE.NORMAL)+1)/BagUserData:get_knapsack_page_item_count(Enum.BAG_TYPE.NORMAL))
			self.item_obj.bag_open_page = (self.item_obj.bag_open_page<1 or self.item_obj.bag_open_page>self.maxPageIndex and 1) or self.item_obj.bag_open_page
		end
		
		self:refresh_all_page()
		self:refresh_depot_page()
	end
end

function Depot:on_hided()
    self:cancel_register()
	print("Knapsack隐藏资源")
end

-- 释放资源
function Depot:dispose()
	self:cancel_register()
	if self.one_key_use_ui then --如果有打开一键使用，则销毁
		self.one_key_use_ui:dispose()
		self.one_key_use_ui = nil
	end
	print("Knapsack释放资源")    
    if self.on_lock_timer then
    	self.on_lock_timer:stop()
    end
    self._base.dispose(self)
 end

 --服务器返回
function Depot:on_receive( msg, id1, id2, sid )
	 -- print("mainui服务器返回")
    if(id1==Net:get_id1("base"))then
        if(id2== Net:get_id2("base", "UpdateResR"))then
            self:update_money()
        end
    end
    if(id1==Net:get_id1("bag"))then
        -- gf_print_table(msg,"*****视窗类接收****背包**********************服务器返回消息啦<<<<<<<<<<<<<<<")
        if(id2== Net:get_id2("bag", "UpdateItemR"))or(id2== Net:get_id2("bag", "UpdateEquipR"))
        	or(id2== Net:get_id2("bag", "UpdateHeroEquipR"))or(id2== Net:get_id2("bag", "SwapItemR"))then
            -- print("更新背包物品")
            self:refresh_all_page()
            self:refresh_depot_page()
        elseif(id2== Net:get_id2("bag", "UpdateBagR"))then
        	Sound:play(ClientEnum.SOUND_KEY.SORT_BAG) -- 整理背包时播放的音效
        	self.item_obj.bag_open_page = 1
        	self.depotCurPage = 1
            self:refresh_all_page()
            self:refresh_depot_page()
        elseif(id2== Net:get_id2("bag", "UpdateBagSizeR"))then
            --更新背包大小
            -- self.bag_scroll_page:update_bag_size(msg.type*10000)
            self:refresh_all_page()
            self:refresh_depot_page()
        end
    end
end

function Depot:on_update(dt)
	if not self.refer then
		return 
	end

	local on_sort_cool = Net:get_server_time_s() - self.item_obj.last_sort_bag_time < self.item_obj.sort_bag_time_cool
	local on_merge_cool = Net:get_server_time_s() - self.item_obj.last_merge_bag_time < self.item_obj.sort_bag_time_cool
	local on_depot_sort_cool = Net:get_server_time_s() - self.item_obj.last_sort_ware_time < self.item_obj.sort_bag_time_cool
	local on_depot_merge_cool = Net:get_server_time_s() - self.item_obj.last_merge_ware_time < self.item_obj.sort_bag_time_cool

	if on_sort_cool then
        self.btn_b_zhengLi_filled.transform.parent.gameObject:SetActive(true)
        local d = self.item_obj.sort_bag_time_cool-(Net:get_server_time_s() - self.item_obj.last_sort_bag_time)
        self.btn_b_zhengLi_filled.fillAmount = d/self.item_obj.sort_bag_time_cool
    	self.btn_b_zhengLi_filled_text.text = string.format("%ds",d)
	elseif self.btn_b_zhengLi_filled.transform.parent.gameObject.activeSelf then
		self.btn_b_zhengLi_filled.transform.parent.gameObject:SetActive(false)
	end

	if on_merge_cool then
        self.btn_b_heBing_filled.transform.parent.gameObject:SetActive(true)
        local d = self.item_obj.sort_bag_time_cool-(Net:get_server_time_s() - self.item_obj.last_merge_bag_time)
        self.btn_b_heBing_filled.fillAmount = d/self.item_obj.sort_bag_time_cool
    	self.btn_b_heBing_filled_text.text = string.format("%ds",d)
	elseif self.btn_b_heBing_filled.transform.parent.gameObject.activeSelf then
		self.btn_b_heBing_filled.transform.parent.gameObject:SetActive(false)
	end

	if on_depot_sort_cool then
        self.btn_w_zhengLi_filled.transform.parent.gameObject:SetActive(true)
        local d = self.item_obj.sort_bag_time_cool-(Net:get_server_time_s() - self.item_obj.last_sort_ware_time)
        self.btn_w_zhengLi_filled.fillAmount = d/self.item_obj.sort_bag_time_cool
    	self.btn_w_zhengLi_filled_text.text = string.format("%ds",d)
	elseif self.btn_w_zhengLi_filled.transform.parent.gameObject.activeSelf then
		self.btn_w_zhengLi_filled.transform.parent.gameObject:SetActive(false)
	end

	if on_depot_merge_cool then
        self.btn_w_heBing_filled.transform.parent.gameObject:SetActive(true)
        local d = self.item_obj.sort_bag_time_cool-(Net:get_server_time_s() - self.item_obj.last_merge_ware_time)
        self.btn_w_heBing_filled.fillAmount = d/self.item_obj.sort_bag_time_cool
    	self.btn_w_heBing_filled_text.text = string.format("%ds",d)
	elseif self.btn_w_heBing_filled.transform.parent.gameObject.activeSelf then
		self.btn_w_heBing_filled.transform.parent.gameObject:SetActive(false)
	end

end

--更新钱
function Depot:update_money()
    local game = LuaItemManager:get_item_obejct("game")
    self.refer:Get("goldCountTxt").text= gf_format_count(game.role_info.baseRes[Enum.BASE_RES.GOLD])
    self.refer:Get("goldLockCountTxt").text=gf_format_count(game.role_info.baseRes[Enum.BASE_RES.BIND_GOLD])
    self.refer:Get("coinCountTxt").text=gf_format_count(game.role_info.baseRes[Enum.BASE_RES.COIN])
end

--刷新3个页面
function Depot:refresh_all_page()
	self.refer:Get("ScrollPage"):SetPageIndex(self.item_obj.bag_open_page)
	print("刷新所有页")
	self:update_page_info(self.item_obj.bag_open_page,BagEnum.PAGE.CUR) --更新当前正看的特权
	self:update_page_info(self.item_obj.bag_open_page-1,BagEnum.PAGE.LAST) --更新特权上一页
	self:update_page_info(self.item_obj.bag_open_page+1,BagEnum.PAGE.NEXT) --更新特权下一页

	--更新钱
    self:update_money()
end
--刷新仓库页
function Depot:refresh_depot_page()
	self.refer:Get("depotScrollPage"):SetPageIndex(self.depotCurPage)
	self:update_depot_page_info(self.depotCurPage  ,BagEnum.PAGE.CUR) --更新当前正看的特权
	self:update_depot_page_info(self.depotCurPage-1,BagEnum.PAGE.LAST) --更新特权上一页
	self:update_depot_page_info(self.depotCurPage+1,BagEnum.PAGE.NEXT) --更新特权下一页

	-- self.refer:Get("textCangkuTitle").text = string.format("%d/%d",self.item_obj:get_bagsize(Enum.BAG_TYPE.DEPOT),BagUserData:get_max_item_count(Enum.BAG_TYPE.DEPOT))
	self.refer:Get("textCangkuTitle").text = string.format("%d/%d"
		,BagTools:get_bag_item_size(Enum.BAG_TYPE.DEPOT)
		,self.item_obj:get_bagsize(Enum.BAG_TYPE.DEPOT)
		)
end

function Depot:on_depot_end_drag(p)
	if p~=self.depotMinPageIndex and p~=self.depotMaxPageIndex then
		if self.depotCurPage<p then
			self:update_depot_page_info(p+1,BagEnum.PAGE.NEXT)
		elseif self.depotCurPage>p then
			self:update_depot_page_info(p-1,BagEnum.PAGE.LAST)
		end
	end
	self.depotCurPage = p
	self:set_depot_page_mark()
end

return Depot