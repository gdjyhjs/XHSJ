--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-15 09:50:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local StoryView=class(UIBase,function(self,item_obj,cb)
	self.time = 0
	self.cb = cb
    UIBase._ctor(self, "story_view.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 设置剧情数据
function StoryView:set_data( data )
	if not data then
		return
	end

	if not data.touch or data.touch == 0 then -- 不可点击
		self.refer:Get("skip_btn"):SetActive(false)
	elseif data.touch == 1 then -- 可以点击
		self.refer:Get("skip_btn"):SetActive(true)
	end

	if not self:is_visible() then
		self:show()
	end

	self.data = data

	self:show_ty(data.show_ty)

	self.title.text = data.title or ""
	self.content.text = data.content or ""

	self.time = (data.time or 0)*0.001

	self.icon = self.refer:Get("icon")
	self:set_icon(data.icon)
end

-- 设置图标
function StoryView:set_icon( icon_name )
	if not icon_name then return end
	gf_setImageTexture(self.icon, icon_name)
end

-- 资源加载完成
function StoryView:on_asset_load(key,asset)

	if self.cb then
		self.cb(self)
	end
end

function StoryView:show_ty( ty )
	self.refer:Get(ty):SetActive(true)

	for i=1,3 do
		if ty ~= i then
			self.refer:Get(i):SetActive(false)
		end
	end

	self.title = self.refer:Get("refer_"..ty):Get("title")
	self.content = self.refer:Get("refer_"..ty):Get("content")
end

function StoryView:check_next()
	-- 检查是否有下一步剧情
	if self.data.next and self.data.next > 0 then
		self:set_data(ConfigMgr:get_config("story")[self.data.next])
	else
		gf_remove_update(self)
		self:hide()
		Net:receive(nil, ClientProto.StoyFinish)
	end
end

function StoryView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "skip_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:check_next()
	end
end

function StoryView:on_receive( msg, id1, id2, sid )
	
end

function StoryView:on_update( dt )
	if self.time > 0 then
		self.time = self.time - dt
		if self.time <= 0 then
			self:check_next()
		end
	end
end

function StoryView:on_showed()
	Net:receive(false,ClientProto.HideOrShowTaskPanel)
	gf_register_update(self)
	StateManager:register_view(self)
end

function StoryView:on_hided()
	Net:receive(true,ClientProto.HideOrShowTaskPanel)
	gf_remove_update(self)
	StateManager:remove_register_view( self )
end

-- 释放资源
function StoryView:dispose()
	Net:receive(true,ClientProto.HideOrShowTaskPanel)
	gf_remove_update(self)
	StateManager:remove_register_view( self )
    self._base.dispose(self)
end

return StoryView

