--[[--
-- 声音
-- @Author:HuangJunShan
-- @DateTime:2017-09-04 16:03:15
--]]
Sound = {}

local LuaHelper = LuaHelper


local audioObj = LuaHelper.Find("AudioListener")
local listener = LuaHelper.GetComponent(audioObj,"UnityEngine.AudioListener")
local target_follow = LuaHelper.GetComponent(audioObj,"Seven.ListenerFollow")
local res_chche = {} -- 声音资源缓存 UnityEngine.AudioClip
local obj_chche = {} -- 2d音效缓存 UnityEngine.AudioSource

local fx_list = {} -- 音效播放列表
local music_list = {} -- 音乐播放列表

local fxVolume = UnityEngine.PlayerPrefs.GetFloat("effectSlider",1)              --音效声音大小
local musicVolume = UnityEngine.PlayerPrefs.GetFloat("musicSlider",1)           --音乐声音大小

local isPlayFxVolume = UnityEngine.PlayerPrefs.GetInt("effectToggle",1) == 1      --是否播放音效声音
local isPlayMusicVolume = UnityEngine.PlayerPrefs.GetInt("musicToggle",1) == 1   --是否播放音乐声音

--[[ 播放一个音效
file_name 音效文件名
obj		  声音载体 传发出声音的对象，会有远小近大的效果		为空则是2d音乐，类似背景音乐
isLoop	  是否循环	  true or false
]]
local function play(file_name,isLoop,obj)
	-- print("播放",file_name,isLoop,obj)
	local source = nil
	if not obj then -- 播放一个2d声音源
		if not obj_chche[file_name] then
			-- 添加一个2d声音源
			obj_chche[file_name] = audioObj:AddComponent("UnityEngine.AudioSource")
		end
		source = obj_chche[file_name]
		source.spatialBlend = 0 -- 2D声音
	else -- 播放一个预先添加好的声音源 或添加一个3d声音源自动播放
		source = LuaHelper.AddComponent(obj,"UnityEngine.AudioSource")
		source.spatialBlend = 0.9 -- 3D声音
		source.dopplerLevel = 1 -- 多普勒效应
		source.spread = 1 -- 范围
		source.rolloffMode = 2 -- 衰减
		source.maxDistance = 50 -- 最大距离
	end
	if source then
		source.loop = isLoop or false
		Sound:set_sound(source,file_name,function(c)source:Play()end)
		return source
	end
end

function Sound:play(key,obj)
	-- print("播放声音",key,obj)
	local data = ConfigMgr:get_config("sound")[key]
	if data.type == 0 then
		self:play_music(data.name,data.loop==1,obj)
	else
		self:play_fx(data.name,data.loop==1,obj)
	end
end

--播放音效
function Sound:play_fx(file_name,isLoop,obj)
	-- print("播放音效",file_name,isLoop,obj)
	if not isPlayFxVolume then
		return
	end

	local source = play(file_name,isLoop,obj)
	source.volume = fxVolume
	fx_list[source] = 1
	return source
end

--播放音乐
function Sound:play_music(file_name,isLoop,obj)
	-- print("播放音乐",file_name,isLoop,obj)
	if not isPlayMusicVolume then
		return
	end

	local source = play(file_name,isLoop,obj)
	source.volume = musicVolume
	music_list[source] = 1
	return source
end

--设置声音源的声音片段
function Sound:set_sound(source,name,fn)
	if not name then
		 -- print("<color=red>音效名称为空</color>") 
		 return 
	end
	if not source or Seven.PublicFun.IsNull(source) then
		 -- print("<color=red>要设置音效的声音源为空</color>") 
		 return 
	end
	if res_chche[name] and not Seven.PublicFun.IsNull(res_chche[name]) then
		source.clip = res_chche[name]
				if fn then
					fn(res_chche[name])
				end
	else
		Loader:get_resource(name..".u3d",nil,"UnityEngine.AudioClip",function(s)
			if Seven.PublicFun.IsNull(source) then
				return
			end
			res_chche[name]=s.data
			if res_chche[name] then
				source.clip = res_chche[name]
				if fn then
					fn(res_chche[name])
				end
			end
		end)
	end
end

--设置音乐开关
function Sound:set_isPlayMusicVolume(value)
	-- print("设置音乐开关",value)
	isPlayMusicVolume = value
	for k,v in pairs(music_list) do
		k.volume = isPlayMusicVolume and musicVolume or 0
	end
	Sound.bg_music_source.volume = isPlayMusicVolume and musicVolume or 0
	UnityEngine.PlayerPrefs.SetInt("musicToggle",value and 1 or 0)
end

--设置音效开关
function Sound:set_isPlayFxVolume(value)
	-- print("设置音效开关",value)
	isPlayFxVolume = value
	for k,v in pairs(fx_list) do
		k.volume = isPlayFxVolume and fxVolume or 0
	end
	UnityEngine.PlayerPrefs.SetInt("effectToggle",value and 1 or 0)
end

--设置音乐大小
function Sound:set_musicVolume(value)
	-- print("设置音乐大小",value)
	musicVolume = value
	isPlayMusicVolume = value > 0
	for k,v in pairs(music_list) do
		k.volume = value
	end
	Sound.bg_music_source.volume = value
	UnityEngine.PlayerPrefs.SetFloat("musicSlider",value)
end

--设置音效大小
function Sound:set_fxVolume(value)
	-- print("设置音效大小",value)
	fxVolume = value
	isPlayFxVolume = value > 0
	for k,v in pairs(fx_list) do
		k.volume = value
	end
	UnityEngine.PlayerPrefs.SetFloat("effectSlider",value)
end

--设置背景音乐
function Sound:set_bg_music(file_name)
	-- print("设置背景音乐",file_name)
	if Sound.bg_music == file_name then
		return 
	end
	if not Sound.bg_music_source then -- 初始化背景音乐播放器
		Sound.bg_music_source = audioObj:AddComponent("UnityEngine.AudioSource")
		Sound.bg_music_source.loop = true
		Sound.bg_music_source.spatialBlend = 0
		Sound.bg_music_source.volume = isPlayMusicVolume and musicVolume or 0
	end
	local function fn(c)
		Sound.bg_music_source:Play()
	end
	Sound:set_sound(Sound.bg_music_source,file_name,fn)
	Sound.bg_music = file_name
end

--清空声音源对象缓存
function Sound:clear_source()
	for k,v in pairs(obj_chche) do
		LuaHelper.Destroy(v)
	end
	obj_chche = {}
	fx_list = {}
	music_list = {}
end

--清空声音片段缓存
function Sound:clear_clip()
	-- if Sound.bg_music_source.clip then
	-- 	res_chche = {[Sound.bg_music_source.clip.name]=Sound.bg_music_source.clip}
	-- else
		res_chche = {}
	-- end
end

--获取音量和开关
function Sound:get_fxVolume()
	return fxVolume
end
function Sound:get_musicVolume()
	return musicVolume
end
function Sound:get_isPlayFxVolume()
	return isPlayFxVolume
end
function Sound:get_isPlayMusicVolume()
	return isPlayMusicVolume
end

-- 设置声音监听对象
function Sound:set_listener_obj(tf)
	target_follow.target = tf
end

	-- 语音部分
Sound.RecordSound = audioObj:AddComponent("UnityEngine.AudioSource")
Sound.RecordSound.spatialBlend = 0 -- 2D声音
Sound.RecordSound.loop = false
Sound.RecordList = {}
Sound.staetId = 0
Sound.endId = 0
Sound.maxCount = 30

-- 播放语音
function Sound:play_music(id)
	-- print("播放语音",id)
	if not Sound.RecordList[id] then
		gf_message_tips("录音已过期")
		return
	end
	if not "打开语音音量" then
		return
	end
	Sound:set_mute(true)
	Sound.RecordSound.clip = Sound.RecordList[id]
	Sound.RecordSound:Play()
end

-- 获取语音声音源
function Sound:get_RecordSound()
	return Sound.RecordSound
end

-- 设置全体静音
function Sound:set_mute(value)
	AudioListener.volume = value and 0 or 1
end

-- 设置语音音量

-- 语音音量开关

-- 记录一个新的录音
function Sound:save_record(clip)
	Sound.endId = Sound.endId+1
	Sound.RecordList[Sound.endId] = clip
	if Sound.endId - Sound.staetId > Sound.maxCount then
		Sound.staetId = Sound.staetId + 1
		table.remove(Sound.RecordList,Sound.staetId)
	end
	return Sound.endId
end

return Sound