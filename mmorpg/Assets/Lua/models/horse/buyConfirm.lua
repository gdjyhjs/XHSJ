--[[
	快速购买界面
	create at 17.6.21
	by xin
]]
local LuaHelper = LuaHelper

local res = 
{
	[1] = "horse_pay.u3d",
}

local min,max = 1,99

local dataUse = require("models.horse.dataUse")

local buyConfirm = class(UIBase,function(self,good_id,count)

	self.good_id = good_id
	self.count = count
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function buyConfirm:on_asset_load(key,asset)
    self:init_ui()
end

function buyConfirm:init_ui()
	self.cur_count = self.count

	local v = ConfigMgr:get_config("goods")[self.good_id]
	----价格
	self.refer:Get(4).text = v.offer
	--名字
	self.refer:Get(3).text = v.name
	--道具背景
	gf_set_item(v.item_code,self.refer:Get(7), self.refer:Get(6))

	--数量
	self.refer:Get(2).text = self.cur_count
		
	self:update_price()

	gf_setImageTexture(self.refer:Get(8), gf_getItemObject("itemSys"):get_coin_icon(v.base_res_type))
	gf_setImageTexture(self.refer:Get(5), gf_getItemObject("itemSys"):get_coin_icon(v.base_res_type))
end

function buyConfirm:update_price()
	--总价
	local v = ConfigMgr:get_config("goods")[self.good_id]
	self.refer:Get(1).text = self.cur_count * v.offer
end

function buyConfirm:edit_click(value)

	local v = ConfigMgr:get_config("goods")[self.good_id]

	self.cur_count = self.cur_count + value
	self.cur_count = self.cur_count <= 0 and 0 or self.cur_count
	self.cur_count = self.cur_count >= 99 and 99 or self.cur_count

	self.refer:Get(2).text = self.cur_count

	self:update_price()

end


function buyConfirm:buy_click()
	local count = self.cur_count
	if count <= 0 then
		return
	end
	gf_getItemObject("mall"):buy_c2s(self.good_id, count)	
	self:hide()
end

function buyConfirm:edit_show_click()
	local callback = function()
		self.cur_count = tonumber(self.refer:Get(2).text)
		self:update_price()
	end
	gf_getItemObject("keyboard"):use_number_keyboard(self.refer:Get(2),99,0,Vector3(self.refer:Get(9).position.x + 315,360,0),pivot,anchor,init,callback,ep)
end

--鼠标单击事件
function buyConfirm:on_click( obj, arg)
	print("buyConfirm click")
    local event_name = obj.name
    if event_name == "quick_buy_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    elseif event_name == "quick_buy" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:buy_click(event_name)

    elseif event_name == "quick_cut" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:edit_click(-1)

    elseif event_name == "quick_add" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:edit_click(1)

    elseif event_name == "edit_box" then
    	self:edit_show_click()

    end
end

-- 释放资源
function buyConfirm:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function buyConfirm:on_receive( msg, id1, id2, sid )
	-- if id1 == Net:get_id1(modelName) then
	-- 	if id2 == Net:get_id2(modelName, "WakeUpHeroR") then
	-- 	end
	-- end
end

return buyConfirm