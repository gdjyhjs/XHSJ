--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-18 11:02:57
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SignLevelIncrease=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "welfare_level_increase.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj=item_obj
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function SignLevelIncrease:on_asset_load(key,asset)
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self.is_init = true
	StateManager:register_view(self)
	-- gf_print_table(self.item_obj.level_award_data,"等级礼包")
	self.item_obj:get_level_gift_list_c2s()
end

function SignLevelIncrease:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function SignLevelIncrease:update_item(item,index,data)
	item:Get(1).text = gf_localize_string(data.level .."级")
	local tb = ConfigMgr:get_config("item")
	for i=1,5 do
		if data.award[i] then
			local obj = item:Get(3):Get(i)
			gf_set_item( data.award[i][1],obj:Get(2),obj:Get(1))
			gf_set_click_prop_tips(obj.gameObject,data.award[i][1])
			obj:Get(3).text = data.award[i][2]
			obj.gameObject:SetActive(true)
			if tb[data.award[i][1]].bind == 1 then
				obj:Get("binding"):SetActive(true)
			else
				obj:Get("binding"):SetActive(false)
			end
		else
			item:Get(3):Get(i).gameObject:SetActive(false)
		end
	end
	if data.open and data.count and data.count == 0 then
		data.open = nil
	end
	if data.open == false then
		item:Get(2):SetActive(true)
		item:Get(4):SetActive(false)
		item:Get(5).gameObject:SetActive(false)
		item:Get(6):SetActive(true)
	elseif data.open then
		item:Get(2):SetActive(false)
		item:Get(4):SetActive(true)
		item:Get(5).gameObject:SetActive(false)
		item:Get(6):SetActive(true)
	else
		item:Get(2):SetActive(false)
		item:Get(4):SetActive(false)
		item:Get(5).text = gf_localize_string(data.level .."级可领取")
		item:Get(5).gameObject:SetActive(true)
		item:Get(6):SetActive(false)
	end
	item:Get("miss"):SetActive(false)
	if data.count then
		item:Get("residue_num").gameObject:SetActive(true)
		item:Get("residue_num").text = "剩余".. data.count .."份"
		if data.open == nil and data.count == 0 then
			-- item:Get(5).text = "<color=#d01212>已错过</color>"
			item:Get(5).gameObject:SetActive(false)
			item:Get("miss"):SetActive(true)
			item:Get("residue_num").gameObject:SetActive(false)
		end
	else
		item:Get("residue_num").gameObject:SetActive(false)
	end
end

function SignLevelIncrease:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "get_award_btn" then
		if	arg.data.level <= LuaItemManager:get_item_obejct("game"):getLevel() and arg.data.open then
			self.select_item = arg
			self.item_obj:get_level_gift_c2s(arg.data.level)
			gf_mask_show(true)
		elseif arg.data.open == nil then
			gf_message_tips("等级不足")
		else
			gf_message_tips("该礼包已领取")
		end
	end
end

function SignLevelIncrease:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base","GetLevelGiftListR")then --获取等级礼包信息列表
			for k,v in pairs(self.item_obj.level_award_data) do
			 	for kk,vv in pairs(msg.levelGiftInfo) do
			 		if v.level == vv.level then
			 			v.count = vv.restCount
			 		end
			 	end
			end 
			self:refresh(self.item_obj.level_award_data)
			print("刷新一次")
		elseif id2 == Net:get_id2("base","GetLevelGiftR")then --获取等级礼包奖励
			if msg.err == 0 then
				for k,v in pairs(self.item_obj.level_award_data) do
					if v.level == msg.level then
						if v.count and msg.restCount then
							self.select_item:Get("residue_num").text = "剩余".. msg.restCount .."份"
						end
					end
				end
				self:update_view()
			end
		end
	end
end

function SignLevelIncrease:on_showed()
	-- if self.is_init then
	-- 	self.item_obj:get_level_gift_list_c2s()
	-- end
end

function SignLevelIncrease:update_view()
	self.select_item:Get(2):SetActive(true)
	self.select_item:Get(4):SetActive(false)
	-- self:update_item(self.select_item,index,self.select_item.data)
	gf_mask_show(false)
end

-- 释放资源
function SignLevelIncrease:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SignLevelIncrease

