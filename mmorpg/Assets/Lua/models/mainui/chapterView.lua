--[[--
-- 任务章节
-- @Author:Seven
-- @DateTime:2017-08-07 20:09:02
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Effect = require("common.effect")

local ChapterView=class(UIBase,function(self,item_obj,data,task_data, cb)
	self.data = data
	self.task_data = task_data
	self.touch = true
	self.cb = cb
    UIBase._ctor(self, "chapters.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ChapterView:on_asset_load(key,asset)
	self.refer:Get("ui"):SetActive(false)
	self.refer:Get("41000059"):SetActive(true)

	self:hide_mainui()
	self:register()
	self:init_ui()
	self:update_ui(self.data)

	local function hide_wait_view()
		self:hide_view()
	end

	local function show_view()
		self.refer:Get("ui"):SetActive(true)
		self.dt = delay(hide_wait_view, 3)
	end
	delay(show_view, 0.4)

	if self.cb then
		self.cb(self)
	end
end

function ChapterView:init_ui()
	self.chapter = self.refer:Get("chapter")
	self.title = self.refer:Get("title")
	self.content = self.refer:Get("content")
end

function ChapterView:update_ui( data )
	self.chapter.text = data.chapter
	self.title.text = data.title
	self.content.text = data.content
end

function ChapterView:hide_view()
	local delete = function()
		self:dispose()
		if self.task_data then
			print("继续做任务")
			Net:receive(self.task_data, ClientProto.CloseTaskChapterUI)
		end
	end

	PLua.StopDelay(self.dt)
	self.dt = nil
	self.refer:Get("41000080"):SetActive(true)
	self.refer:Get("41000059"):SetActive(false)
	self.refer:Get("ui"):SetActive(false)
	delay(delete, 1)
end

function ChapterView:set_touch( touch )
	self.touch = touch
end

function ChapterView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "bgBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.touch then
			self:hide_view()
		end
	end
end

function ChapterView:register()
	StateManager:register_view(self)
end

function ChapterView:cancel_register()
	StateManager:remove_register_view(self)
end

-- 释放资源
function ChapterView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return ChapterView

