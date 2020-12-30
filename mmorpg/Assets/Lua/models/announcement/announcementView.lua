--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-17 15:11:35
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local AnnouncementView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "system_notice.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)
AnnouncementView.level = UIMgr.LEVEL_STATIC
-- 资源加载完成
function AnnouncementView:on_asset_load(key,asset)
	self.pages = {}
	self.content = self.refer:Get("content")
	local data = ConfigMgr:get_config("announcement")
	local sample = self.refer:Get("sample")
	local parent = self.refer:Get("pageTransform")
	for i,v in ipairs(data) do
		if v.order>0 then
			local obj = LuaHelper.Instantiate(sample)
			obj.transform:SetParent(parent,false)
			obj:SetActive(true)
			obj.name = "announcementPage"
			local ref = obj:GetComponent("ReferGameObjects")
			local key = "announcement"..i
			local index = #self.pages+1
			self.pages[index] = {
					sel = ref:Get("select"),
					content = string.gsub(v.content,"\\n","\n"),
					key = key,
					order = v.order,
				}
			local order = UnityEngine.PlayerPrefs.GetInt(key,0)
			if v.order > order then
				self.pages[index].red = ref:Get("red_point")
				self.pages[index].red:SetActive(true)
			end
			ref:Get("text1").text = v.title
			ref:Get("text2").text = v.title
		end
	end
	self:select_page(1)
end

--选择页签
function AnnouncementView:select_page(index)
	if self.index then
		self.pages[self.index].sel:SetActive(false)
	end
	self.index = index
	self.pages[self.index].sel:SetActive(true)
	self.content.text = self.pages[self.index].content
	if self.pages[self.index].red then
		self.pages[self.index].red:SetActive(false)
		self.pages[self.index].red = nil
		print(self.pages[self.index].key,self.pages[self.index].order)
		UnityEngine.PlayerPrefs.SetInt(self.pages[self.index].key,self.pages[self.index].order)
	end
end

function AnnouncementView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "system_notice_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		local offline = LuaItemManager:get_item_obejct("offline")
	    offline:pop_ui(offline.ui_priority.announcement)
		self:dispose()
	elseif cmd == "announcementPage" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_page(obj.transform:GetSiblingIndex())
	end
end

function AnnouncementView:on_showed()
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
end

function AnnouncementView:on_hided( )
	local offline = LuaItemManager:get_item_obejct("offline")
    offline:pop_ui(offline.ui_priority.announcement)
end
-- 释放资源
function AnnouncementView:dispose()
    self.item_obj:register_event(self.item_obj.event_name, nil)
    Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.PARTNER, visible=self.item_obj:show_red()}, ClientProto.ShowHotPoint)
    self._base.dispose(self)
 end

return AnnouncementView

