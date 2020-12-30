--[[
	材料副本购买次数界面
	create at 17.11.22
	by xin
]]
local common_string = 
{
	[1] = gf_localize_string("是否使用<color=#8C2C18FF>%d</color>元宝购买1次此副本次数？"),
	[2] = gf_localize_string("每日可购买<color=#18a700>%d/%d</color>次"),
	[3] = gf_localize_string("每日可购买<color=#18a700>%d</color>次"),
	[4] = gf_localize_string("每日可购买次数不足"),
	
}
local uiBase = require("common.viewBase")

local materialBuyCount = class(uiBase,function(self,type)
	print("wtf materialBuyCount:")
	self.type = type
	local item_obj = gf_getItemObject("copy")
	uiBase._ctor(self, "copy_buy_time.u3d", item_obj)
end)

function materialBuyCount:on_showed()
	materialBuyCount._base.on_showed(self)
	self:init_ui()

end

function materialBuyCount:init_ui()
	self.refer:Get(1).text = string.format(common_string[1],gf_get_config_table("t_misc").copy.materialCopyBuyCost) 
	--当前vip等级
	local vip_level = gf_getItemObject("vipPrivileged"):get_vip_lv()

	local data = ConfigMgr:get_config("vip")
	
	--当前等级
	local cur_vip_data = data[vip_level] -- 获取当前vip等级的配置文件
	self.refer:Get(2).text = vip_level
	self.refer:Get(4).text = string.format(common_string[2],gf_getItemObject("copy"):get_material_copy_data(self.type).buyTimes,self:get_count(cur_vip_data)) 


	local is_max = vip_level >= #data --当前vip等级是否满级

	self.refer:Get(7):SetActive(false)

	if is_max then
		self.refer:Get(6).transform.localPosition = Vector3(0,0,0)
	end

	if not is_max then
		local next_vip_data = data[vip_level + 1] -- 获取当前vip等级的配置文件
		self.refer:Get(7):SetActive(true)
		self.refer:Get(3).text = vip_level + 1
		self.refer:Get(5).text = string.format(common_string[3],self:get_count(next_vip_data)) 
	end
end

function materialBuyCount:get_count(data)
	return self.type == ServerEnum.COPY_TYPE.MATERIAL and data.buy_times_10 or data.buy_times_15
end

function materialBuyCount:clear()
end
function materialBuyCount:on_hided()
	materialBuyCount._base.on_hided(self)
end

-- 释放资源
function materialBuyCount:dispose()
	materialBuyCount._base.dispose(self)
end

function materialBuyCount:buy_click()
	local vip_level = gf_getItemObject("vipPrivileged"):get_vip_lv()
	local data = ConfigMgr:get_config("vip")
	local cur_vip_data = data[vip_level] -- 获取当前vip等级的配置文件

	local have_buy = gf_getItemObject("copy"):get_material_copy_data(self.type).buyTimes

	if have_buy >= self:get_count(cur_vip_data) then
		gf_message_tips(common_string[4])
		return
	end

	gf_getItemObject("copy"):material_copy_buy_count_c2s(self.type)
end

function materialBuyCount:cancel_click()
	self:dispose()
end

function materialBuyCount:on_click(arg)
	local event_name = arg.name
	print("materialBuyCount event_name ",event_name)
	if event_name == "material_btnClose" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
		self:dispose()

	elseif event_name == "material_btnBuy" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:buy_click()

	elseif event_name == "material_btnCancel" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:cancel_click()

	end
	
end

function materialBuyCount:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "BuyMaterialTimesR") then
			--如果购买次数已满 关闭界面
			local vip_level = gf_getItemObject("vipPrivileged"):get_vip_lv()
			local data = ConfigMgr:get_config("vip")
			local cur_vip_data = data[vip_level] -- 获取当前vip等级的配置文件

			local have_buy = gf_getItemObject("copy"):get_material_copy_data(self.type).buyTimes

			if have_buy >= self:get_count(cur_vip_data) then
				self:dispose()
				return
			end
			self:init_ui()
		end
	end
end

return materialBuyCount