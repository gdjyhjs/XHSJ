--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-06-10 18:29:16
--]]

local gVoice = class(function ( self, ui, item_obj )
	self.ui = ui
	self.item_obj = item_obj
	self:init()
	self.init = true
	self.record_channel = 1
	-- gf_error_tips("语音初始化完毕")
end)

local min_record_length_second = 1
local Enum = require("enum.enum")
local GVoiceComponent = Seven.GVoiceComponent

--初始化
function gVoice:init()
	if not OPEN_VOICE then
		return
	end
	
	-- gf_error_tips("语音系统初始化")
	--语音缓存 下载后需要播放的 语音id 作为键 写入这个表
	self.cache={}
	self.voiceengine = self.ui.root:GetComponent("Seven.GVoiceComponent")
	-- print("获取语音组件",self.voiceengine)
	if self.voiceengine then
		-- gf_error_tips("获取语音组件"..self.voiceengine.name)
		-- gf_error_tips("接入语音"..tostring(GVoiceComponent))
		-- print("--注册回调")
		self.voiceengine.onUploadReccordFileCompleteFn = function(ode,filepath,fileid) self:upload_record_r(ode,filepath,fileid) end --上传语音
		-- gf_error_tips("注册上传语音回调")
		self.voiceengine.onDownloadRecordFileCompleteFn = function(code,filepath,fileid) self:download_record_r(code,filepath,fileid) end --下载语音
		-- gf_error_tips("注册下载语音回调")
		self.voiceengine.onPlayRecordFilCompleteFn = function(code,filepath) self:play_complete(code,filepath) end --播放完成
		-- gf_error_tips("注册播放完成回调")
		self.voiceengine.onSpeechToTextFn = function(code,fileID,result) self:speech_to_text_r(code,fileID,result) end --语音转文字
		-- gf_error_tips("注册语音转文字回调")
		self.voiceengine.onApplyMessagekeyCompleteFn = function(code)
															if code == 7 then
																self.item_obj.can_voice = true
															else
																-- print("语音接入结果"..code)
																gf_error_tips("语音接入结果"..code)
															end
														end
        -- gf_error_tips("注册回调")
		--设置用户的语音用户名 QQ1163878529
		-- self.voiceengine.appID="1383059197"
		-- self.voiceengine.appKey="36c38834e4f8c2db482cbdc76672c229"

		-- QQ593841976
		self.voiceengine.appID="1611952111"
		self.voiceengine.appKey="24e41bdd26587921a6c4aaf2fd694846"

		-- self.voiceengine.openID = LuaItemManager:get_item_obejct("game").role_id
		self.voiceengine.openID = UnityEngine.SystemInfo.deviceUniqueIdentifier
		
		-- gf_error_tips("appID："..self.voiceengine.appID)
		-- gf_error_tips("appKey："..self.voiceengine.appKey)
		-- gf_error_tips("openID："..self.voiceengine.openID)

		--注册语音
		-- gf_error_tips("获取语音组件"..tostring(self.voiceengine))
		local err = self.voiceengine:RegisterGVoice()
		if err~=0 then
			print("接入语音SDK返回"..err)
			gf_error_tips("接入语音SDK返回"..err)
		end
		--设置最大消息长度
		self.voiceengine:SetMaxMessageLength(30000) --10000毫秒
	else
		gf_error_tips("获取不到语音组件")
	end
	self.recording=false;
	self:set_speaker_volume()
end

--播放完成返回
function gVoice:play_complete(code,filepath)
	--恢复声音
	self:open_audio_listener()
end

--声音转文完成返回
function gVoice:speech_to_text_r(code,fileid,result)
	-- print("声音转文字返回 "..code.." "..result,fileid,result)
	-- print(type(self.record_channel))
	if code==0 then
		local str=string.format("#%d,%s_%s_%d#",ClientEnum.CHAT_TYPE.PLAYMSG,fileid,result,self:get_voice_length(self.cache[fileid]))
		if self.record_channel < Enum.CHAT_CHANNEL.END then
			--发语音送到聊天频道
			self.item_obj:send_message_c2s(str,self.record_channel)
		elseif self.record_channel > Enum.CHAT_CHANNEL.END then
			--发送语音到私聊频道
			self.item_obj:chat_c2s(self.record_channel,str)
		end
		Net:receive({msgType = self.record_channel,fileId = fileid,text = result}, ClientProto.VoiceMessageR)
	else
		gf_error_tips("声音转文字返回 "..tostring(code).." 结果"..tostring(result))
	end
end
--上传语音完成返回
function gVoice:upload_record_r(code,filepath,fileid)
	-- print("上传语音返回"..code,filepath,fileid)
	if code == 0 then
		self.cache[fileid] = filepath
		self:download_record(filepath,fileid)
	else
		gf_error_tips("上传语音返回"..code.." 路径"..filepath.." 文件id"..fileid)
	end
end

--下载语音完成返回
function gVoice:download_record_r(code,filepath,fileid)
	-- print("下载语音返回"..code,filepath,fileid)
	if code==0 then
		if not self.cache[fileid] then
			-- 播放语音
			self.cache[fileid] = filepath
			self:play_record(fileid)
		else
			-- 将语音转成文字
			self:speech_to_text(fileid)
		end
		self.cache[fileid] = filepath
	else
		gf_error_tips("下载语音返回"..code.." 路径"..filepath.." 文件id"..fileid)
	end
end

-----------------------------------------------------------------------------------------------------------------------------

--开始语音
function gVoice:start_record(channel)
	if self.voiceengine then
		self.recording=true
		local err = self.voiceengine:Click_btnStartRecord()
		-- print("开始语音"..err,channel)
		if err~=0 then
			gf_error_tips("开始语音"..err)
		end
		--开启静音
		self:close_audio_listener()
		self.record_channel = channel
	end
end
--结束语音
function gVoice:end_record(channel)
-- print("结束语音"..channel)
	if self.voiceengine then
		self.recording=false
		local err = self.voiceengine:Click_btnStopRecord()
		-- print("语音结果"..err)
		if channel then
			if  err==0 then
				if self:get_voice_length()>=min_record_length_second then
					--提示
					-- print("语音发送成功",channel)
					-- gf_error_tips("语音发送成功")
					--上传语音
					self:upload_record()
				else
					--提示
					-- print("录制时间太短"..self:get_voice_length())
					gf_error_tips("录制时间太短"..self:get_voice_length())
				end
			elseif err == 12294 then
				-- print("语音发生错误：上一个语音未处理完")
				gf_error_tips("语音发生错误：上一个语音未处理完")
			else
				--提示
				-- print("语音发生错误"..err)
				gf_error_tips("语音发生错误"..err)
			end
		else
			-- print("取消发送")
			gf_error_tips("取消发送")
		end
	end
	--恢复声音
	self:open_audio_listener()
end
--播放语音
function gVoice:play_record(fileid)
	if self.voiceengine then
		local filepath = self.cache[fileid]
		if filepath then
			local err = self.voiceengine:Click_btnPlayReocrdFile(filepath)
			if err ~= 0 then
				-- print("语音已失效 "..err,fileid)
				gf_error_tips("语音已失效 "..err)
			else
				-- print("播放语音 "..err,fileid)
				gf_error_tips("播放语音 "..err)
				self.item_obj:set_playing_record(fileid)
				self:close_audio_listener()
				self:set_speaker_volume()
			end
		else
			--下载语音
			-- print("下载语音",fileid)
			gf_error_tips("下载语音")
			self:download_record(filepath,fileid)
		end
	end
end
--停止播放
function gVoice:stop_record()
	if self.voiceengine then
		local err = self.voiceengine:Click_btnStopPlayRecordFile()
		-- print("停止播放 "..err)
		gf_error_tips("停止播放 "..err)
	end
	self.item_obj:set_stopplay_record()
	self:open_audio_listener()
end
--声音转文字
function gVoice:speech_to_text(m_fileid)
	if self.voiceengine then
		local err = self.voiceengine:Click_btnSpeechToText(m_fileid)
		-- print("声音转文字"..err,m_fileid)
		gf_error_tips("声音转文字"..err.." 文件id"..m_fileid)
	end
end
--上传语音
function gVoice:upload_record()
	if self.voiceengine then
		local err = self.voiceengine:Click_btnUploadFile()
		-- print("上传语音"..err)
		if err~=0 then
			gf_error_tips("上传语音"..err)
		end
	end
end
--下载语音
function gVoice:download_record(filepath,fileid)
	if self.voiceengine then
		local err = self.voiceengine:Click_btnDownloadFile(fileid,fileid)
		-- print("下载语音"..err,fileid,fileid)
		if err~=0 then
			gf_error_tips("下载语音"..err.." 路径"..filepath.." 文件id"..fileid)
		end
	end
end
--获取语音长度
function gVoice:get_voice_length(filepath)
	if self.voiceengine then
		if filepath then
			return self.voiceengine:Click_getVoiceLength(filepath)
		else
			return self.voiceengine:Click_getVoiceLength()
		end
	end
end
--获取当前语音波动 音量()
function gVoice:get_cur_sound_wave()
	if self.voiceengine then
		local wave = self.voiceengine.get_voice_sound_wave
		return wave
	end
end
--恢复声音
function gVoice:close_audio_listener()
	print("打开静音")
	--获取所有的UnityEngine.AudioListener组件，禁用倾听器
	-- if not self.audio_listeners then
	-- 	self.audio_listeners = Object.FindObjectsOfType("UnityEngine.AudioListener")
	-- end
	-- for i=1,#(self.audio_listeners or {}) do
	-- 	self.audio_listeners[i].enabled = false;
	-- end
	UnityEngine.AudioListener.volume = 0
end
--开启静音
function gVoice:open_audio_listener()
	print("关闭静音")
	--将所有的UnityEngine.AudioListener组件，启用倾听器
	-- if not self.audio_listeners then
	-- 	self.audio_listeners = Object.FindObjectsOfType("UnityEngine.AudioListener")
	-- end
	-- for i=1,#(self.audio_listeners or {}) do
	-- 	self.audio_listeners[i].enabled = true;
	-- end
	UnityEngine.AudioListener.volume = 1
end

--语音音量(windoes 0x0-0xFFFF,安卓苹果0-800)
function gVoice:set_speaker_volume()
	print("gVoice设置音量 嘿嘿",math.floor((self.item_obj:get_is_speaker_volume() and self.item_obj:get_speaker_volume() or 0)*800))
    if self.voiceengine then
    	if true then return end
    	local volume = math.floor((self.item_obj:get_is_speaker_volume() and self.item_obj:get_speaker_volume() or 0)*800)
    	print("gVoice设置音量",volume)
    	self.voiceengine:set_sound_volume(volume)
    end
end
-- print("返回语音系统",gVoice,tostring(gVoice))
return gVoice