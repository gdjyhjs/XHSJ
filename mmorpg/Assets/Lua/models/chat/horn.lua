--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-18 14:09:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local ChatTools = require("models.chat.chatTools")

-- 控制消息和停留
local max_time = 8 -- 喇叭最长停留时间
local min_time = 0 -- 喇叭最小间隔时间
local wait_time = 0 -- 当前剩余最大停留时间
local cache = {} -- 消息缓存
local init = false -- 是否加载ui完毕
local on_show = false -- 是否正在显示

--控制显示大小和位置
local total_width = 0 -- 最大总宽度
local name_width = 0 -- 名字需要的宽度
local mask_width = 0 -- 可显示mask宽度
local content_width = 0 -- 消息内容宽度

local max_offset = 0 -- 最大滚动偏移值
local cur_offset = 0 -- 当前滚动偏移值
local name_content_offset = 10 -- 名字和内容间隔

local offset_wait_time = 3 -- 开始滑动等待时间
local offser_speed = 100 -- 滚动速度 像素/每秒
local font_size = 20 -- 文本字体大小(表情大小)


local Horn=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "horn.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Horn:on_asset_load(key,asset)
	-- 最大总宽度
	total_width = self.refer:Get("content_area").sizeDelta.x
	self.name_text = self.refer:Get("name_text")
	self.content_text = self.refer:Get("content_text")
	self.mask = self.refer:Get("mask")
	self.name = self.refer:Get("name")
	self.content = self.refer:Get("content")
	init = true
end

function Horn:add_message(msg)
	cache[#cache+1] = msg
end

-- 设置消息
function Horn:set_message(msg)
    gf_print_table(msg,"大喇叭内容")
    self.name_text.text = msg.roleInfo.name.."："
    local content = string.gsub(msg.content,"size=%d+ width=1/>","size="..(font_size).." width=1/>")
	self.content_text.text = content

	-- 名字需要的宽度
	name_width = LuaHelper.GetStringWidth(self.name_text.text,self.name_text)
	-- 最大总宽度 - 名字需要的宽度 = 可显示mask宽度
	mask_width = total_width - name_width - name_content_offset
	content_width = LuaHelper.GetStringWidth(gf_remove_rich_text(msg.content),self.content_text)
	-- 设置可显示mask的位置
	self.mask.localPosition = Vector2(self.name.localPosition.x+name_width+name_content_offset,self.mask.localPosition.y)
	-- 设置可显示mask的宽度
	self.mask.sizeDelta = Vector2(mask_width,self.mask.sizeDelta.y)
	-- 最大滚动距离
	max_offset = content_width - mask_width
	-- 当前滚动偏移值
	cur_offset = 0
	-- 设置文本位置
	self.content.localPosition = Vector2(content_width/2,self.content.localPosition.y)

	self.content.sizeDelta = Vector2(content_width,self.content.sizeDelta.y)
	local function cb( arg )
		print("点了")
		ChatTools:text_on_click(arg)
	end
	self.content_text.OnHrefClickFn=cb

	local function tc()
		print("点点")
	end
	self.content_text.OnTextClickFn=tc
end

function Horn:on_update(dt)
	if init and on_show then
		if wait_time<=0 and #cache<=0 then
			self:hide()
		elseif #cache>0 and wait_time<max_time-min_time then
			self:set_message(cache[1])
			table.remove(cache,1)
			wait_time = max_time
		else
			wait_time = wait_time - dt
			if cur_offset<max_offset then -- 是否要滑动
				if max_time-wait_time>offset_wait_time then
					cur_offset = cur_offset+dt*offser_speed
					self.content.localPosition = Vector2(content_width/2-cur_offset,self.content.localPosition.y)
				end
			end
		end
	end
end

function Horn:on_showed()
	if not on_show then
		on_show = true
		gf_register_update(self) --注册每帧事件
	end
end

function Horn:on_hided()
	on_show = nil
	gf_remove_update(self) --注销每帧事件
end

-- 释放资源
function Horn:dispose()
	self:hide()
	init = nil
    self._base.dispose(self)
 end

return Horn