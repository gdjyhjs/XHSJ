--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-10 17:46:24
--]]

local LuaHelper = LuaHelper
local BagTools = {}
local Enum = require("enum.enum")
local Bag = LuaItemManager:get_item_obejct("bag")

function BagTools:get_item_name(protoId,count,text_ui)
	-- print("-------------------------->设置item名字",protoId,count,text_ui)
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local data = ConfigMgr:get_config("item")[protoId]
	local name = data and data.name or ""
	local count = count>0 and "("..count..")" or ""
	-- print("原文字",name..count)
	-- 获取后缀字符的宽度
	local count_width = LuaHelper.GetStringWidth(count,text_ui)
	-- print("获取后缀字符的宽度",count_width)
	-- 获取显示框的宽度
	local text_width = text_ui.transform.sizeDelta.x
	-- print("获取显示框的宽度",text_width)
	--计算剩余宽度
	local last_width = text_width - count_width
	-- print("计算剩余宽度",last_width)
	if last_width<0 then
		count = "(?)"
		count_width = LuaHelper.GetStringWidth(count,text_ui)
		last_width = text_width - count_width
	end
	-- print("最终剩余宽度",last_width)
	-- 取不超过剩余宽度的名字字符
	local result = ""
	if LuaHelper.GetStringWidth(name,text_ui)<last_width then
		result = name..count
	else
		for i,v in ipairs(gf_string_to_chars(name)) do
			-- print(i,v)
			if LuaHelper.GetStringWidth(result..v.."...",text_ui)<last_width then
				result = result..v
			else
				result = result.."..."..count
				break
			end
			-- print(result)
		end
	end
	--得出结果
	local result = "<color="..itemSys:get_item_color(data.color)..">"..result.."</color>"
	return result
end

local set_item = function(ref,slot)
	if Seven.PublicFun.IsNull(ref) or not slot then
		return
	end
	local item = Bag:get_bag_item()[slot]
	local bagType = math.floor(slot/10000)
	--判断是否有物品
	if item and item.num>0 then
		local data = ConfigMgr:get_config("item")[item.protoId]
		--设置物品
		ref:Get("icon").gameObject:SetActive(true)
		ref:Get("binding"):SetActive(data.bind~=0) --是否绑定
		local placeholder_icon = ref:Get("placeholder_icon") -- 装备栏上的无装备图标
		if placeholder_icon then
			placeholder_icon:SetActive(false)
		end
		if data.type == Enum.ITEM_TYPE.EQUIP then
			gf_set_equip_icon(item,ref:Get("icon"),ref:Get("bg"))
			--战力上升或者下降
			local up = ref:Get("up")
			local down = ref:Get("down")
			if up and down then
				if bagType ~= Enum.BAG_TYPE.EQUIP then
					
					local is_my_career = LuaItemManager:get_item_obejct("game"):get_career() == data.career
					-- print(slot,"是否自己的装备",is_my_career)

					local no_use = ref:Get("no_use")
					if no_use then
						no_use:SetActive(not is_my_career)
					end

					if is_my_career then
						local bodySlot = Enum.BAG_TYPE.EQUIP * 10000 + ConfigMgr:get_config("item")[item.protoId].sub_type
						local bodyEquip = Bag:get_bag_item()[bodySlot]
						local isUp = bodyEquip==nil
						if not isUp then
							local equip = LuaItemManager:get_item_obejct("equip")
							local bodyF = equip:calculate_equip_fighting_capacity(bodyEquip)
							local equipF = equip:calculate_equip_fighting_capacity(item)
							-- print(slot,"身上：背包",bodyF,equipF)
							if bodyF == equipF then
								isUp = nil
							else
								isUp = bodyF < equipF
							end
							-- print("身上战力小于背包吗",bodySlot,equip:calculate_equip_fighting_capacity(bodyEquip) , equip:calculate_equip_fighting_capacity(item),equip:calculate_equip_fighting_capacity(bodyEquip) < equip:calculate_equip_fighting_capacity(item))
						end
						-- print("身上的装备",isUp,bodySlot,bodyEquip)
						if isUp == nil then
							ref:Get("up"):SetActive(false)
							ref:Get("down"):SetActive(false)
						else
							ref:Get("up"):SetActive(isUp)
							ref:Get("down"):SetActive(not isUp)
						end
					else
						ref:Get("up"):SetActive(false)
						ref:Get("down"):SetActive(false)
					end
				end
			end
			local eff = ref:Get("eff")
			if eff then
				eff:SetActive(false)
			end
			local lock = ref:Get("lock")
			if lock then
				lock:SetActive(false)
			end
			local tips = ref:Get("tips") --文字提示是否显示
			if tips then
				tips.gameObject:SetActive(false)
			end
			local filled = ref:Get("filled") --解锁遮罩是否显示
			if filled then
				filled.gameObject:SetActive(false)
			end
			local count = ref:Get("count") --装备一般没有数量
			if count then
				count.gameObject:SetActive(false)
			end
		else
			gf_set_item(item.protoId,ref:Get("icon"),ref:Get("bg")) --非装备图标
			if item.num>1 then
				ref:Get("count").gameObject:SetActive(true) --数量
				ref:Get("count").text = item.num
			else
				ref:Get("count").gameObject:SetActive(false)
			end
			local no_use = ref:Get("no_use")
			if no_use then
				no_use:SetActive(false)
			end
			local up = ref:Get("up")
			if up then
				up:SetActive(false)
			end
			local down = ref:Get("down")
			if down then
				down:SetActive(false)
			end
			local eff = ref:Get("eff")
			if eff then
				eff:SetActive(false)
			end
			local lock = ref:Get("lock")
			if lock then
				lock:SetActive(false)
			end
			local tips = ref:Get("tips") --文字提示是否显示
			if tips then
				tips.gameObject:SetActive(false)
			end
			local filled = ref:Get("filled") --解锁遮罩是否显示
			if filled then
				filled.gameObject:SetActive(false)
			end
		end
		ref.name = "OnClickItem_"..slot.."_"..item.guid
	else
		--隐藏图标，品质为0
		ref:Get("icon").gameObject:SetActive(false)
		gf_set_item(nil,nil,ref:Get("bg"),0)
		ref:Get("binding"):SetActive(false)
		local placeholder_icon = ref:Get("placeholder_icon") -- 装备栏上的无装备图标
		if placeholder_icon then
			placeholder_icon:SetActive(true)
		end
		if bagType ~= Enum.BAG_TYPE.EQUIP then
			local no_use = ref:Get("no_use")
			if no_use then
				no_use:SetActive(false)
			end
			local up = ref:Get("up")
			if up then
				up:SetActive(false)
			end
			local down = ref:Get("down")
			if down then
				down:SetActive(false)
			end
			local eff = ref:Get("eff")
			if eff then
				eff:SetActive(false)
			end
			local tips = ref:Get("tips") --文字提示是否显示
			if tips then
				tips.gameObject:SetActive(false)
			end
			ref:Get("count").gameObject:SetActive(false) --数量

			--判断是否解锁
			if slot%10000 > Bag:get_bagsize(bagType) then
				--锁定
				ref:Get("lock"):SetActive(true)
				ref:Get("filled").gameObject:SetActive(true) --解锁遮罩是否显示
				ref:Get("filled").fillAmount = 1
				ref.name = "lockItem_"..slot
			else
				--空
				local lock = ref:Get("lock")
				if lock then
					lock:SetActive(false)
				end
				local filled = ref:Get("filled") --解锁遮罩是否显示
				if filled then
					filled.gameObject:SetActive(false)
				end
				ref.name = nil
			end
		end
	end
end
local set_item_on_lock = function(ref,slot)
	if Seven.PublicFun.IsNull(ref) or not slot then
		return
	end
	ref:Get("icon").gameObject:SetActive(false)
	gf_set_item(nil,nil,ref:Get("bg"),0)
	ref:Get("binding"):SetActive(false)
	ref:Get("eff"):SetActive(false)
	ref:Get("count").gameObject:SetActive(false) --数量
	ref:Get("lock"):SetActive(true)
	ref:Get("tips").text = "解锁中"
	ref:Get("tips").gameObject:SetActive(true) --文字提示是否显示
	ref:Get("filled").gameObject:SetActive(true) --解锁遮罩是否显示
	ref:Get("filled").fillAmount = 1
	ref.name = "lockItem_"..slot
	ref:Get("up"):SetActive(false)
	ref:Get("down"):SetActive(false)
end
local set_item_can_lock = function(ref,slot)
	if Seven.PublicFun.IsNull(ref) or not slot then
		return
	end
	ref:Get("icon").gameObject:SetActive(false)
	gf_set_item(nil,nil,ref:Get("bg"),0)
	ref:Get("binding"):SetActive(false)
	ref:Get("eff"):SetActive(true)
	ref:Get("count").gameObject:SetActive(false) --数量
	ref:Get("lock"):SetActive(true)
	ref:Get("tips").text = "可解锁"
	ref:Get("tips").gameObject:SetActive(true) --文字提示是否显示
	ref:Get("filled").gameObject:SetActive(false) --解锁遮罩是否显示
	ref.name = "canUnlockItem_"..slot
	ref:Get("up"):SetActive(false)
	ref:Get("down"):SetActive(false)
end
local set_item_locking = function(ref,value)
	if Seven.PublicFun.IsNull(ref) or not value then
		return
	end
	local filled = ref:Get("filled")
	if filled then
		filled.fillAmount = value
	else
		-- print("<color=red>获取不到锁定蒙版</color>")
	end
end
local item_list = {}
local start_set = false
function BagTools:set_next_item()
	if #item_list>1 then
		for i=1,#item_list do
			local v = item_list[1]
			if v then
				table.remove(item_list,1)
				if v.type == "set_item" then
					set_item(v.ref,v.slot)
				elseif v.type=="set_item_on_lock" then
					set_item_on_lock(v.ref,v.slot)
				elseif v.type=="set_item_can_lock" then
					set_item_can_lock(v.ref,v.slot)
				elseif v.type=="set_item_locking" then
					set_item_locking(v.ref,v.value)
				end
			end
		end
		PLua.Delay(function() self:set_next_item() end,0.01)
	else
		start_set = false
	end
end
function BagTools:set_item(ref,slot)
	item_list[#item_list+1] = {type="set_item",ref=ref,slot=slot}
	if not start_set then
		start_set = true
		PLua.Delay(function() self:set_next_item() end,0.01)
	end
end

function BagTools:set_item_on_lock(ref,slot)
	item_list[#item_list+1] = {type="set_item_on_lock",ref=ref,slot=slot}
	if not start_set then
		start_set = true
		PLua.Delay(function() self:set_next_item() end,0.01)
	end
end

function BagTools:set_item_can_lock(ref,slot)
	item_list[#item_list+1] = {type="set_item_can_lock",ref=ref,slot=slot}
	if not start_set then
		start_set = true
		PLua.Delay(function() self:set_next_item() end,0.01)
	end
end

function BagTools:set_item_locking(ref,value)
	item_list[#item_list+1] = {type="set_item_locking",ref=ref,value=value}
	if not start_set then
		start_set = true
		PLua.Delay(function() self:set_next_item() end,0.01)
	end
end

--花钱解锁
function BagTools:expenditure_money_unlocking(slot)
    local function sure(l)
        --申请解锁
        Bag:unlock_slot_c2s({slot=slot})
    end
    local bagtype = math.floor(slot/10000)
    local start_index = Bag:get_bagsize(bagtype)+1
    local end_index = slot%10000
    local remainingtime=Bag.unlock[bagtype].unlockTimeLeft and Bag.unlock[bagtype].unlockTimeLeft-Net:get_server_time_s() or 0
    local unlock_data = ConfigMgr:get_config("bagUnlock")
    local needexpenditure=unlock_data[bagtype*10000+start_index].cost
    local ccmp = LuaItemManager:get_item_obejct("cCMP")
    for i=bagtype*10000+start_index+1,bagtype*10000+end_index do
        remainingtime=remainingtime+unlock_data[i].time
        needexpenditure=needexpenditure+unlock_data[i].cost
    end
    if bagtype == ClientEnum.BAG_TYPE.BAG then
    	local h = math.floor(remainingtime/3600)
    	local m = math.floor(remainingtime%3600/60)
    	local s = math.floor(remainingtime%60)
    	local str = ""
    	if h==0 then
			str = string.format("在线<color=#52b44d>%02d:%02d</color>后可开启第<color=#52b44d>%s</color>个格子,确定花费<color=#52b44d>%d</color>元宝开启所选格子?（优先使用绑定元宝）"
                    ,math.floor(remainingtime%3600/60),math.floor(remainingtime%60)
                    ,start_index==end_index and start_index or (start_index.."-"..end_index),needexpenditure)
		elseif h==0 and m==0 then
			str = string.format("在线<color=#52b44d>%02d</color>后可开启第<color=#52b44d>%s</color>个格子,确定花费<color=#52b44d>%d</color>元宝开启所选格子?（优先使用绑定元宝）"
                    ,math.floor(remainingtime%60)
                    ,start_index==end_index and start_index or (start_index.."-"..end_index),needexpenditure)
		else
			str = string.format("在线<color=#52b44d>%s:%02d:%02d</color>后可开启第<color=#52b44d>%s</color>个格子,确定花费<color=#52b44d>%d</color>元宝开启所选格子?（优先使用绑定元宝）"
                    ,math.floor(remainingtime/3600),math.floor(remainingtime%3600/60),math.floor(remainingtime%60)
                    ,start_index==end_index and start_index or (start_index.."-"..end_index),needexpenditure)			 
		end
        ccmp:add_message(str,sure,slot,nil,0)
    else
    	local str = string.format("是否花费<color=#52b44d>%d</color>元宝开启第<color=#52b44d>%s</color>个格子？（优先使用绑定元宝）"
        -- local str = string.format("可开启第<color=#52b44d>%s</color>个格子,确定花费<color=#52b44d>%d</color>元宝开启所选格子?（优先使用绑定元宝）"
                            ,needexpenditure,start_index==end_index and start_index or (start_index.."-"..end_index))
        ccmp:add_message(str,sure,slot,nil,0)
    end
end

--获取背包当前有几个格子有物品
function BagTools:get_bag_item_size(bagType)
	local count = 0
	for k,v in pairs(Bag:get_bag_item()) do
		if not bagType or bagType == math.floor(k/10000) then
			count = count + 1
		end
	end
	return count
end

return BagTools
