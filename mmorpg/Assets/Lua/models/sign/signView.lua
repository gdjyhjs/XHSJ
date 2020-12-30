--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-06 20:03:00
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SignView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "welfare.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

local sign_view_num = {
	[1] = gf_localize_string("每日签到"),
	[2] = gf_localize_string("在线奖励"),
	[3] = gf_localize_string("升级奖励"),
	[4] = gf_localize_string("超值月卡"),
	[5] = gf_localize_string("投资基金"),
	[6] = gf_localize_string("领取体力"),
	[7] = gf_localize_string("离线经验"),
	[8] = gf_localize_string("兑换礼包"),
}


-- 资源加载完成
function SignView:on_asset_load(key,asset)
	self:init_ui()
	self:register()
end
function SignView:init_ui()
	self.is_init = true
	for k,v in pairs(self.item_obj.redprint_tb) do
		if self.item_obj.redprint_tb[k] then
			self.select_view = k
			break
		end
	end

	if self.item_obj.goto_index ~= nil then
		self.select_view = self.item_obj.goto_index
		self.item_obj.goto_index = nil
	end
	if not self.select_view then
		self.select_view = 1
	end
	self.scroll_left_table = self.refer:Get("Content")
	self.scroll_left_table.onItemRender = handler(self,self.update_left_item)
	local data = {}
	-- for k,v in pairs(sign_view_num) do
	-- 	if self.item_obj.over_tb[k] then
	-- 		data[#data+1] = k
	-- 	end
	-- end
	-- if #data ~= 0 then
	-- 	for k,v in pairs(data) do
	-- 		table.remove(sign_view_num, v)
	-- 	end
	-- end
	self:refresh_left(sign_view_num)
	self.sign_child_view = {}
end

function SignView:register()
	self.item_obj:register_event("sign_view_on_click",handler(self,self.on_click))
end

function SignView:refresh_left(data)
	self.scroll_left_table.data = data
	self.scroll_left_table:Refresh(0 ,-1) --显示列表
end

function SignView:update_left_item(item,index,data)
	item:Get(1).text = data
	item:Get(4).text = data
	print("签到左边",index)
	if self.item_obj.redprint_tb[index] then
		item:Get(3):SetActive(true)
	else
		item:Get(3):SetActive(false)
	end
	if not self.select_left_item and  index == self.select_view then
		self.select_left_item = item
		item:Get(2):SetActive(true)
		self:open_child_view(data)
	end
end

function SignView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		-- self.item_obj:close_view_check()
		self:dispose()
	elseif cmd == "preItem(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_item(arg)
	end
end

function SignView:select_item(item)
	if self.select_left_item ~= item then
		self.select_left_item:Get(2):SetActive(false)
		item:Get(2):SetActive(true)
		self.select_left_item = item
		self:open_child_view(item.data)
	end
end

--打开子ui
function SignView:open_child_view(txt)
	for k,v in pairs(self.sign_child_view or {}) do
		v:hide()
	end
	if txt == sign_view_num[1] then
		if not self.sign_child_view[1] then
			self.sign_child_view[1] = require("models.sign.signDayView")(self.item_obj)
		else
			self.sign_child_view[1]:show()
		end
	elseif txt == sign_view_num[2] then
		if not self.sign_child_view[2] then
			self.sign_child_view[2] = require("models.sign.signOnlineView")(self.item_obj)
		else
			self.sign_child_view[2]:show()
		end
	elseif txt == sign_view_num[3] then
		if not self.sign_child_view[3] then
			self.sign_child_view[3] = require("models.sign.signLevelIncrease")(self.item_obj)
		else
			self.sign_child_view[3]:show()
		end
	elseif txt == sign_view_num[4] then
		if not self.sign_child_view[4] then
			self.sign_child_view[4] = require("models.sign.weekMonthCardView")(self.item_obj)
		else
			self.sign_child_view[4]:show()
		end
	elseif txt == sign_view_num[5] then
		if not self.sign_child_view[5] then
			self.sign_child_view[5] = require("models.sign.investmentView")(self.item_obj)
		else
			self.sign_child_view[5]:show()
		end
	elseif	txt == sign_view_num[6] then
		if not self.sign_child_view[6] then
			self.sign_child_view[6] = require("models.sign.physicalPowerView")(self.item_obj)
		else
			self.sign_child_view[6]:show()
		end
	elseif txt == sign_view_num[7] then
		if not self.sign_child_view[7] then
			self.sign_child_view[7] = require("models.sign.signOfflineView")(self.item_obj)
		else
			self.sign_child_view[7]:show()
		end
	elseif txt == sign_view_num[8] then
		if not self.sign_child_view[8] then
			self.sign_child_view[8] = require("models.sign.welfareCdkeyView")(self.item_obj)
		else
			self.sign_child_view[8]:show()
		end
	end
end

function SignView:on_hided()
	self:dispose()
end

-- 释放资源
function SignView:dispose()
	self.select_left_item = nil
	self.select_view = nil
	for k,v in pairs(self.sign_child_view or {}) do
		v:dispose()
	end
	self.item_obj:register_event("sign_view_on_click",nil)
    self._base.dispose(self)
 end

return SignView

