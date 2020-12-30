--[[--录音
--
-- @Author:HuangJunShan
-- @DateTime:2017-06-21 18:25:11
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local gVoice = require("models.chat.gVoice")
local chatEnum = require("models.chat.chatEnum")
local chatTools = require("models.chat.chatTools")

local ChatView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "chat.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

local press_down_pos = nil 	-- 按下的位置
local press_pos = nil -- 按着的位置
local cancle_record_dis = 100 -- 取消录音滑动距离
local max_record_time = 30 -- 最大录音时长
local record = nil
local gVoiceLua = nil

-- 资源加载完成
function ChatView:on_asset_load(key,asset)

	--获得录音组件
	self.record_obj = self.refer:Get("obj")
	self.state_text = self.refer:Get("state_text")
	self.sound_size_1 = self.refer:Get("sound_size_1")
	self.sound_size_2 = self.refer:Get("sound_size_2")
	self.sound_size_3 = self.refer:Get("sound_size_3")
	self.sound_size_4 = self.refer:Get("sound_size_4")
	self.sound_size_5 = self.refer:Get("sound_size_5")
	self.cancle_ico = self.refer:Get("cancle_ico")
	--初始化语音系统
	self.item_obj:set_chat_ui(self)
	self:get_gVoice()
end

-- 开始录音
function ChatView:start_recording(channel,pos)
	-- if true then gf_message_tips("语音功能正在维护") return end
	-- gf_message_tips("开始录音 频道：",channel,pos)
	-- print("view开始录音")
	if self:get_gVoice() then
		self.record_obj:SetActive(true)
		self.state_text.text="手指划开\n取消发送"
		self.cancle_ico:SetActive(false)
		press_down_pos = pos
		press_pos = pos
		self.t=Schedule(handler(self,self.stop_recording),max_record_time)
		self:get_gVoice():start_record(channel)
		record = 1

		local record_sound_change = function()
			local _ = UnityEngine.Random.Range(1,6)
			for i=1,5 do
				self["sound_size_"..i]:SetActive(i<_)
			end
		end

		self.t_recording=Schedule(record_sound_change,0.2)
	end
end

-- 录音中
function ChatView:on_recording(channel,pos)
	-- if true then gf_message_tips("语音功能正在维护") return end
	if self:get_gVoice() then
		if press_down_pos and self.t then
		-- print("正在录音",channel,pos,press_down_pos,Vector2.Distance(pos,press_down_pos))
			-- print("录音正常",record , Vector2.Distance(pos,press_down_pos))
			press_pos = press_pos + pos
			if record == 1 and Vector2.Distance(press_pos,press_down_pos)>cancle_record_dis then
				-- print("划开了手指")
				record =0
				self.cancle_ico:SetActive(true)
				self.state_text.text="松开手指\n取消发送"
			elseif record == 0 and  Vector2.Distance(press_pos,press_down_pos)<cancle_record_dis then
				-- print("手指处于正常位置	")
				record = 1
				self.cancle_ico:SetActive(false)
				self.state_text.text="手指划开\n取消发送"
			end
		end
	end
end

-- 结束录音
function ChatView:stop_recording(channel,pos)
	-- if true then gf_message_tips("语音功能正在维护") return end
	if self:get_gVoice() and press_down_pos and self.t then
		-- print("停止录音",channel,pos)
		self.record_obj:SetActive(false)
		if record == 0 then
	        self:get_gVoice():end_record()
	    elseif record == 1 then
	        self:get_gVoice():end_record(channel)
	    end
	    record = nil
	    press_down_pos = nil
	    press_pos = nil
	    self.t:stop()
	    self.t_recording:stop()
	end
end

function ChatView:get_gVoice()
	if not gVoiceLua then
		gVoiceLua = gVoice(self,self.item_obj)
		-- gf_message_tips("初始化语音结果：",gVoiceLua)
	end
	if not gVoiceLua then
		-- gf_message_tips("语音初始化失败")
	end
	return gVoiceLua
end

-- 释放资源
function ChatView:dispose()
	self.item_obj:set_chat_ui(nil)
    self._base.dispose(self)
 end

return ChatView