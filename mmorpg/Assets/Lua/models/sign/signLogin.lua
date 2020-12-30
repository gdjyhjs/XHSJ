--[[--
--15天登录
-- @Author:Seven
-- @DateTime:2017-09-18 11:03:10
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SignLogin=class(UIBase,function(self)
	self:set_bg_visible(true)
	self.item_obj=LuaItemManager:get_item_obejct("sign")
    UIBase._ctor(self, "welfare_login.u3d", self.item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function SignLogin:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self:refresh(self.item_obj.login_15)
	if self.item_obj.login_today>=6 then
		local day = self.item_obj.login_today
		if day>12 then 
			day = 12
		end
		self.scroll_table:ScrollTo(day-5) 
	end
end

function SignLogin:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function SignLogin:update_item(item,index,data)
	item:Get(1).text = data.day
	local obj = item:Get(2)
	gf_set_item( data.reward[1],obj:Get(2),obj:Get(1))
	gf_set_click_prop_tips(obj.gameObject,data.reward[1])
	obj:Get(3).text = data.reward[2]
	local tb = ConfigMgr:get_config("item")
	if tb[data.reward[1]].bind == 1 then
		obj:Get("binding"):SetActive(true)
	else
		obj:Get("binding"):SetActive(false)
	end
	if data.open == false then
		item:Get(4).gameObject:SetActive(false)
		-- obj:Get(4):SetActive(true)
		obj:Get(5):SetActive(true)
		item:Get(5):SetActive(false)
		item:Get(3):SetActive(true)
		item:Get(7):SetActive(false)
	elseif data.open then
		-- obj:Get(4):SetActive(false)
		obj:Get(5):SetActive(false)
		item:Get(4).gameObject:SetActive(false)
		item:Get(5):SetActive(true)
		item:Get(3):SetActive(false)
		if data.t_day then
			item:Get(7):SetActive(true)
		else
			item:Get(7):SetActive(false)
		end
	else
		-- obj:Get(4):SetActive(false)
		obj:Get(5):SetActive(false)
		item:Get(4).text = data.dis
		item:Get(4).gameObject:SetActive(true)
		item:Get(5):SetActive(false)
		item:Get(3):SetActive(false)
		if data.t_day then
			item:Get(7):SetActive(true)
		else
			item:Get(7):SetActive(false)
		end
	end
	if data.day == self.item_obj.login_today then
		item:Get(6).enabled = true
		item:Get(1).fontSize = 36
	else
		item.gameObject.transform.localScale = Vector3(1,1,1)
		item:Get(1).fontSize = 25
	end
end

function SignLogin:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_close" then
		self:dispose()
	elseif cmd == "get_award_btn" then
		gf_mask_show(true)
		self.select_item = arg
		self.item_obj:get_login_gift_c2s(arg.data.day)
	end
end

function SignLogin:on_receive(msg,id1,id2,sid)
	if id1 == ClientProto.Login15Day then
		self:update_view()
	end
end


function SignLogin:update_view()
	local item = self.select_item
	local obj = item:Get(2)
	item:Get(4).gameObject:SetActive(false)
	-- obj:Get(4):SetActive(true)
	obj:Get(5):SetActive(true)
	item:Get(5):SetActive(false)
	item:Get(3):SetActive(true)
	gf_mask_show(false)
end

-- 释放资源
function SignLogin:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SignLogin

