--[[--btn_list
-- 变强
-- @Author:Seven
-- @DateTime:2017-11-02 11:10:41
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local StrengthenView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "strengthen.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function StrengthenView:on_asset_load(key,asset)
	if #self.item_obj.btn_list<=0 then
		self:dispose()
	end
	self.init = true

	self.btn_list = {}
	self.data = self.item_obj.data
	self.itemObj = self.refer:Get("item")
	self.itemRoot = self.itemObj.transform.parent
	self:refresh_btn()
end

function StrengthenView:on_click(item_obj,obj,arg)
	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "closeStrengthen" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "itemStrengthen" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local m = self.btn_list[obj.transform:GetSiblingIndex()+1]
		if m then
			local p = self.data[m].parameter or {}
			gf_open_model(self.data[m].moduel,p[1],p[2],p[3],p[4],p[5],p[6],p[7])
			self:dispose()
		end
	end
end

function StrengthenView:on_receive()
	if self.item_obj.change then
		self:refresh_btn()
	end
end

function StrengthenView:refresh_btn() -- 刷新按钮
	if not self.init then
		return
	end
	self.item_obj.change = false
	self.btn_list = {}
	local count = self.itemRoot.childCount
	local btn_name_list = {}
	local idx = 0
	for i,v in ipairs(self.item_obj.btn_list) do
		local name = self.data[v.id].name
		if not btn_name_list[name] then
			idx = idx + 1
			local tf = nil
			if idx > count then
				tf = LuaHelper.Instantiate(self.itemObj).transform
				tf.name = "itemStrengthen"
				tf:SetParent(self.itemRoot,false)
			else
				tf = self.itemRoot:GetChild(idx-1)
				tf.gameObject:SetActive(true)
			end
			tf:GetComponentInChildren("UnityEngine.UI.Text").text = self.data[v.id].name
			btn_name_list[name] = name
			self.btn_list[#self.btn_list+1] = v.id
		end
	end
	for i=idx+1,count do
		self.itemRoot:GetChild(i-1).gameObject:SetActive(false)
	end
end

function StrengthenView:register()
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
end

function StrengthenView:cancel_register()
    self.item_obj:register_event(self.item_obj.event_name, nil)
end

function StrengthenView:on_showed()
	self:register()
end

-- 释放资源
function StrengthenView:dispose()
	self.init = nil
	self:cancel_register()
    self._base.dispose(self)
 end

return StrengthenView

