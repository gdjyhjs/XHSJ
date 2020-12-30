--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-26 17:04:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local BagUserData = require("models.bag.bagUserData")
local BagTools = require("models.bag.bagTools")
local Enum = require("enum.enum")
local BagEnum = require("models.bag.bagEnum")
local UIModel = require("common.UI3dModel")

local Knapsack=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "kapsack.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
end)

-- 资源加载完成
function Knapsack:on_asset_load(key,asset)
	self.refer:Get("roleName").text = LuaItemManager:get_item_obejct("game"):getName()

	self.btn_b_zhengLi_filled = self.refer:Get("btn_b_zhengLi_filled")
	self.btn_b_zhengLi_filled_text = self.refer:Get("btn_b_zhengLi_filled_text")
	self.btn_b_heBing_filled = self.refer:Get("btn_b_heBing_filled")
	self.btn_b_heBing_filled_text = self.refer:Get("btn_b_heBing_filled_text")


	self.minPageIndex = 1
	self.maxPageIndex = BagUserData:get_knapsack_max_page(Enum.BAG_TYPE.NORMAL)
	self.item_obj.bag_open_page = (self.item_obj.bag_open_page<1 or self.item_obj.bag_open_page>self.maxPageIndex and 1) or self.item_obj.bag_open_page
	-- print("最大页数",self.maxPageIndex)
	self.refer:Get("ScrollPage").minPageIndex = self.minPageIndex
	self.refer:Get("ScrollPage").maxPageIndex = self.maxPageIndex
	self.bagPageMarks = {}
	local go = self.refer:Get("bagPageMark")
	local parent = go.transform.parent
	for i=1,self.maxPageIndex do
		local _ = parent.childCount>i and parent:GetChild(i).gameObject or LuaHelper.InstantiateLocal(go,go.transform.parent.gameObject)
		-- local _ = LuaHelper.InstantiateLocal(go,go.transform.parent.gameObject)
		self.bagPageMarks[#self.bagPageMarks+1] = _:GetComponent("UnityEngine.UI.Toggle")
		_:SetActive(true)
	end
	self.refer:Get("ScrollPage"):SetPageIndex(self.item_obj.bag_open_page)
	self:set_bag_page_mark()
	self:refresh_all()
	self.refer:Get("ScrollPage").endDragFn = function(p)
	-- print("拖拽结束")
	self:on_end_drag(p) end
	self.init = true
	self:set_model()
end
function Knapsack:set_bag_page_mark()
	-- print("设置背包页标志，当前页：",self.item_obj.bag_open_page)
	self.bagPageMarks[self.item_obj.bag_open_page].isOn = true
end
function Knapsack:set_model()
	print("设置模型")
	if not self.ui_model then
    	self.ui_model = UIModel(LuaHelper.FindChild(self.root, "model"))
    end
    
    self.ui_model:set_player(true)
	self.ui_model:set_career()
	self.ui_model:set_model()
	self.ui_model:set_weapon()
	self.ui_model:set_wing()
	self.ui_model:set_surround()
	self.ui_model:set_local_position(Vector3(0,-1.5,3))
	self.ui_model:load_model()
	self.ui_model:on_showed()
end

function Knapsack:on_click(obj,arg)
	-- print("点击背包",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_b_heBing" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		-- print("点击了合并按钮")
		--合并
        local merge = function()
        	-- print("执行合并操作")
            self.item_obj:merge_item_c2s(1)
            self.item_obj.last_merge_bag_time = Net:get_server_time_s()
        end
        LuaItemManager:get_item_obejct("cCMP"):add_message("合并将会对背包内可合并物品进行合并整理，绑定与非绑物品合并后，会全部变成<color=#52b44d>绑定状态</color>，请谨慎操作。",merge,nil,nil,0)
	elseif cmd == "btn_b_zhengLi" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		--整理
        	-- print("执行整理操作")
            self.item_obj:sort_item_c2s(1)
            self.item_obj.last_sort_bag_time = Net:get_server_time_s()
    		
	elseif cmd == "btn_use" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		--打开一键使用
		self.item_obj:open_one_key_use(self.refer:Get("equip_mode"))
	elseif string.find(cmd,"canUnlockItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		local slot = tonumber(string.split(cmd,"_")[2])
		self.item_obj:unlock_slot_c2s({slot=slot}) 
	elseif string.find(cmd,"lockItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		local slot = tonumber(string.split(cmd,"_")[2])
		BagTools:expenditure_money_unlocking(slot) --花钱解锁
	elseif string.find(cmd,"OnClickItem_") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		--点击了物品
		local slot = tonumber(string.split(cmd,"_")[2])
        LuaItemManager:get_item_obejct("itemSys"):show_item_info(self.item_obj.items[slot],true,obj.transform.position)
	end
end

--在手指滑动结束
function Knapsack:on_end_drag(p)
-- print("在手指滑动结束时 选择的是",p)
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
function Knapsack:update_page_info(bagPage,page)
	-- print("更新背包信息,更新背包的第",bagPage,"页，属于页",page)
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
			if self.on_lock_timer then
				self.on_lock_timer:stop()
				self.on_lock_timer = nil
			end
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

function Knapsack:update_locking(slot)
	if self.item_obj:get_bag_unlock_fill()>0 then
		BagTools:set_item_locking(self.on_lock_ref,self.item_obj:get_bag_unlock_fill())
	else
		BagTools:set_item_can_lock(self.on_lock_ref,slot)
		self.on_lock_ref = nil
		if self.on_lock_timer then
			self.on_lock_timer:stop()
			self.on_lock_timer = nil
		end
	end
end

function Knapsack:register()
	StateManager:register_view( self )
			gf_register_update(self) --注册每帧事件
end

function Knapsack:cancel_register()
	StateManager:remove_register_view( self )
			gf_remove_update(self) --注销每帧事件
end

function Knapsack:on_showed()
	self:register()
	if self.init then
		self.item_obj:set_have_red_point()
		if self.item_obj:is_have_red_point() then
			self.item_obj.bag_open_page = math.ceil((self.item_obj:get_bagsize(Enum.BAG_TYPE.NORMAL)+1)/BagUserData:get_knapsack_page_item_count(Enum.BAG_TYPE.NORMAL))
			self.item_obj.bag_open_page = (self.item_obj.bag_open_page<1 or self.item_obj.bag_open_page>self.maxPageIndex and 1) or self.item_obj.bag_open_page
		end
		self:refresh_all()

		if self.ui_model then
			self.ui_model:on_showed()
		end
		self:set_model()
	end
end

function Knapsack:on_hided()
	-- self:hide()
    self:cancel_register()
	-- print("Knapsack隐藏资源")
	
    if self.on_lock_timer then
    	self.on_lock_timer:stop()
    	self.on_lock_timer = nil
    end
end

-- 释放资源
function Knapsack:dispose()
	self:cancel_register()
	if self.one_key_use_ui then --如果有打开一键使用，则销毁
		self.one_key_use_ui:dispose()
		self.one_key_use_ui = nil
	end
	-- print("Knapsack释放资源")
    if self.on_lock_timer then
    	self.on_lock_timer:stop()
    	self.on_lock_timer = nil
    end
    
	if self.ui_model then
		self.ui_model:dispose()
		self.ui_model = nil
	end

	self.init = nil
    self._base.dispose(self)
 end

 --服务器返回
function Knapsack:on_receive( msg, id1, id2, sid )
	 -- print("mainui服务器返回")
    if(id1==Net:get_id1("base"))then
        if(id2== Net:get_id2("base", "UpdateResR"))then
            self:update_money()
        elseif(id2== Net:get_id2("base", "UpdatePowerR"))then
            self:update_power()
        end
    end
    if(id1==Net:get_id1("bag"))then
        -- gf_print_table(msg,"*****视窗类接收****背包**********************服务器返回消息啦<<<<<<<<<<<<<<<")
        if(id2== Net:get_id2("bag", "UpdateItemR"))or(id2== Net:get_id2("bag", "UpdateEquipR"))
        	or(id2== Net:get_id2("bag", "UpdateHeroEquipR"))or(id2== Net:get_id2("bag", "SwapItemR"))then
            -- print("更新背包物品")
            self:refresh_all()
        elseif (id2== Net:get_id2("bag", "UpdateBagR")) then
        	Sound:play(ClientEnum.SOUND_KEY.SORT_BAG) -- 整理背包时播放的音效
        	self.item_obj.bag_open_page = 1
        	self:refresh_all()
        elseif(id2== Net:get_id2("bag", "UpdateBagSizeR"))then
            --更新背包大小
            -- self.bag_scroll_page:update_bag_size(msg.type*10000)
            self:refresh_all()
        end
    elseif id1 == ClientProto.ChangePlayerWeaponModle or  id1 == ClientProto.ChangePlayerModle then
    	self:set_model()
    end
end

function Knapsack:on_update(dt)
	if not self.refer then
		return 
	end

	local on_sort_cool = Net:get_server_time_s() - self.item_obj.last_sort_bag_time < self.item_obj.sort_bag_time_cool
	local on_merge_cool = Net:get_server_time_s() - self.item_obj.last_merge_bag_time < self.item_obj.sort_bag_time_cool

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
end

--更新钱
function Knapsack:update_money()
    local game = LuaItemManager:get_item_obejct("game")
    self.refer:Get("goldCountTxt").text= gf_format_count(game.role_info.baseRes[Enum.BASE_RES.GOLD])
    self.refer:Get("goldLockCountTxt").text=gf_format_count(game.role_info.baseRes[Enum.BASE_RES.BIND_GOLD])
    self.refer:Get("coinCountTxt").text=gf_format_count(game.role_info.baseRes[Enum.BASE_RES.COIN])
end

--刷新3个页面
function Knapsack:refresh_all()
	self.refer:Get("ScrollPage"):SetPageIndex(self.item_obj.bag_open_page)
	-- print("刷新所有页")
	self:update_page_info(self.item_obj.bag_open_page,BagEnum.PAGE.CUR) --更新当前正看的特权
	self:update_page_info(self.item_obj.bag_open_page-1,BagEnum.PAGE.LAST) --更新特权上一页
	self:update_page_info(self.item_obj.bag_open_page+1,BagEnum.PAGE.NEXT) --更新特权下一页

	--更新钱
    self:update_money()
    self:update_equip()
    self:update_power()
end

function Knapsack:update_equip()
	local root = self.refer:Get("equipRoot")
	for i=1,root.childCount do
		local child = root:GetChild(i-1)
		local slot = Enum.BAG_TYPE.EQUIP * 10000 + i
		local ref = child:GetComponent("ReferGameObjects")
		BagTools:set_item(ref,slot)
	end
end

function Knapsack:update_power()
	self.refer:Get("zhanLiNum").text = LuaItemManager:get_item_obejct("game"):getRoleInfo().power
end

return Knapsack