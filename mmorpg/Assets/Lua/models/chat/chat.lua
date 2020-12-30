--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-03 09:56:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Microphone=Seven.Microphone --麦克风
local max_recording_length=10 --最大录音长度
local Enum = require("enum.enum")
local heroData = require("models.hero.dataUse")
local heroShow = require("models.hero.heroShowHeroInfo")
local chatTools = require("models.chat.chatTools")
local chatEnum = require("models.chat.chatEnum")

local Chat = LuaItemManager:get_item_obejct("chat")

local speaker_volume = UnityEngine.PlayerPrefs.GetFloat("speakerVolume",1)
local is_speaker_volume = UnityEngine.PlayerPrefs.GetInt("isSpeakerVolume",1) == 1

--UI资源
Chat.assets=
{
    View("chatView", Chat) 
}
Chat.priority = ClientEnum.PRIORITY.CHAT
local private_cache={} --私聊缓存
local private_role_list={} --私聊玩家列表
local private_roles={} --私聊玩家
local read_gvoice_list={} --读过的语音消息

Chat.pc_id = 0 --公共聊天id

--点击事件
function Chat:on_click(obj,arg)
    print("on_click(chat)",obj,arg)
    --通知事件(点击事件)
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
    if string.find(cmd,"playVoice_") then --播放语音
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:on_click_play_voice(string.split(cmd,"_")[2],tonumber(string.split(cmd,"_")[3]),arg)
    end
    return true
end

-- 点击了播放语音
function Chat:on_click_play_voice(fileid,time,ref)
    if self.palying_record and self.palying_record.fileid == fileid then
        self:get_chat_ui():get_gVoice():stop_record()
    elseif self.palying_record then
        self:get_chat_ui():get_gVoice():stop_record()
        self.palying_record = {fileid = fileid,ref = ref,time = time} -- 记录ref 和 录音时长
        if ref:Get("new_message_ico").activeSelf then --隐藏红点
            ref:Get("new_message_ico"):SetActive(false)
        end
        self:play_recording(fileid)
    else
        self:get_chat_ui():get_gVoice():stop_record()
        self.palying_record = {fileid = fileid,ref = ref,time = time} -- 记录ref 和 录音时长
        if ref:Get("new_message_ico").activeSelf then --隐藏红点
            ref:Get("new_message_ico"):SetActive(false)
        end
        self:play_recording(fileid)
    end
end


--初始化函数只会调用一次
function Chat:initialize()


    require("models.chat.chatData.publicChatData")
    require("models.chat.chatData.privateChatData")

    -- 是否可以语音
    self.can_voice = false

    --默认频道
    self.curent_channel=Enum.CHAT_CHANNEL.WORLD
    self.prop_cache = {} --聊天发送道具或者武将等缓存
----------------------公共聊天---------------------------------
    self.chat_cache={} --所有频道的缓存
    self.chat_cool={} --记录发言时间冷却
    self.chat_cache_count=0

---------------------私聊-----------------------------------
    -- 获取本地记录 -- 初始化记录
    -- self.chatRecord = require("models.chat.chatRecord")
    -- self.chatRecord.load_init()
   
    -- 发送 获取离线消息列表 协议
    -- self:get_chat_list_c2s()

    --公共聊天输入框
    -- self.public_chat_input_field = nil
    --私聊输入框
    -- self.private_chat_input_field = nil
    --正在播放的录音 
    self.palying_record = nil
    --录音播放中计时器
    self.hour_meter = nil

end

--获取某个频道的冷却时间
function Chat:get_chat_cool(channel)
    return self.chat_cool[channel] or 0
end

--获取某个频道的聊天记录
function Chat:get_chat_record(channel)
    return self.chat_cache[channel] or {}
end

--获取某个频道的所有聊天记录
function Chat:get_all_chat_record(channel)
    local data = ConfigMgr:get_config("chat_channel")[channel]
    local t = {}
    for i,v in ipairs(data.send_channel) do
        for index,record in ipairs(self:get_chat_record(v)) do
            t[#t+1] = record
        end
    end
    table.sort(t,function(a,b)
        return a.id>b.id
    end)
    return t
end

-----------------------------------------服务器返回------------------------------

function Chat:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("base"))then
        if id2 == Net:get_id2("base", "ChatR") then
            print("聊天系统接收：新消息")
            gf_print_table(msg or {},"服务器返回聊天信息")
            self:send_message_s2c(msg)
        elseif id2 == Net:get_id2("base", "GetHistoryChatR") then
            -- print("聊天系统接收：历史消息")
            -- gf_print_table(msg,"服务器返回历史聊天信息")
            -- self:get_history_chat_s2c(msg)
        end
    elseif id1 == Net:get_id1("friend") then
    -- gf_print_table(msg,"服务器返回私聊信息")
        if(id2== Net:get_id2("friend", "ChatR"))then
            gf_print_table(msg,"服务器返回的协议：私聊信息")
            self:chat_s2c(msg)
        elseif(id2== Net:get_id2("friend", "GetChatRecordR"))then
            gf_print_table(msg,"服务器返回的协议：取到聊天记录")
            self:get_chat_record_s2c(msg)
        elseif(id2== Net:get_id2("friend", "GetFriendInfoR"))then
            gf_print_table(msg,"服务器返回的协议:取得个玩家信息")
            self:get_friend_list_s2c(msg,sid)
        elseif(id2== Net:get_id2("friend", "GetChatListR"))then
            gf_print_table(msg,"wtf receive GetChatListR")
            gf_print_table(msg,"服务器返回的协议:取得离线消息的聊天列表")
            self:get_chat_list_s2c(msg)
        end
    elseif id1 == Net:get_id1("task") then
        if(id2== Net:get_id2("task", "RollMessageR"))then
            gf_print_table(msg,"服务器返回的协议：滚字")
            self:roll_message_s2c(msg)
        end
    elseif id1 == ClientProto.FinishScene then -- 进入场景，刷新ui
        self:add_to_state()
    end
end

-- 处理协议
function Chat:roll_message_s2c(msg)
    -- if Net:get_server_time_s()<msg.endTime then
    --     local FloatTextSys = LuaItemManager:get_item_obejct("floatTextSys")
    --     local start_time = Net:get_server_time_s()<msg.startTime and msg.startTime or Net:get_server_time_s()
    --     FloatTextSys:marquee(msg.content,nil,msg.time,Net:get_server_time_s()<msg.startTime and (msg.startTime-Net:get_server_time_s()) or 0,msg.endTime - start_time)
    -- end
    local FloatTextSys = LuaItemManager:get_item_obejct("floatTextSys")
    FloatTextSys:marquee(msg.content)
end

--私聊信息

---------------------------私聊---------------------------------------------
--get ui
function Chat:set_chat_ui(ui)
    self.chat_ui = ui
end
function Chat:get_chat_ui()
    -- gf_message_tips("1:",self.chat_ui,"2",self.assets[1])
    return self.chat_ui or self.assets[1]
end
-- function Chat:get_public_chat_ui()
--     return self.public_chat_ui
-- end
--open ui
function Chat:open_public_chat_ui(channel)
    if channel == nil then
        channel = self.curent_channel
    elseif type(channel)=="number" then
        self.curent_channel = channel
    end
    if channel then
        if not self.public_chat_ui then
            self.public_chat_ui = View("publicChat",Chat)
        else
            self.public_chat_ui:show()
        end
    end
end
function Chat:open_private_chat_ui(roleId)
    print("打开私聊",roleId)
    self.chat_friend = roleId
    if not self.private_chat_ui then
        self.private_chat_ui = View("privateChat",self)
    else
        self.private_chat_ui:show()
    end
end
function Chat:open_emoji_ui(inputField,channel,emojiType)
    channel = channel == nil and self.curent_channel or channel
    if channel then
        self.emoji_ui = View("emoji",Chat)
        self.emoji_ui:set_parameter(inputField,channel,emojiType)
    end
end

--开始录音 频道，按住的位置
function Chat:start_recording(channel,pos)
    -- print("开始录音",channel,pos)
        if not channel then
            channel = self.curent_channel
        end 
        if channel == Enum.CHAT_CHANNEL.TEAM and not LuaItemManager:get_item_obejct("team"):is_in_team() then
            gf_message_tips("没有加入队伍")
            return
        elseif channel == Enum.CHAT_CHANNEL.ARMY_GROUP and not LuaItemManager:get_item_obejct("legion"):is_in() then
            gf_message_tips("没有加入军团")
            return
        end

    if self:get_chat_ui() then
        if channel>=Enum.CHAT_CHANNEL.END or self:is_can_send_message(channel) then
            --如果正在播放录音阶停止
            self:set_stopplay_record()
            self:get_chat_ui():start_recording(channel,pos)
        end
    else
        gf_error_tips("没有获取到腾讯录音组件")
    end 
end

function Chat:on_recording(channel,pos)
    if self:get_chat_ui() then
        self:get_chat_ui():on_recording(channel,pos)
    end
end

--停止录音 --频道，弹起的位置
function Chat:stop_recording(channel,pos)
    if self:get_chat_ui()  then
        self:get_chat_ui():stop_recording(channel,pos)
    end
end

--播放录音
function Chat:play_recording(fileid)
    print("播放录音",fileid)
    read_gvoice_list[fileid] = true
    self:get_chat_ui():get_gVoice():play_record(fileid)
end

--停止播放录音
function Chat:stop_play_record()
    print("停止播放录音")
    self:get_chat_ui():get_gVoice():stop_record()
end

--设置播放录音
function Chat:set_playing_record()
    -- print("设置播放录音")
    if self.palying_record then
        local period = 0.2
        local timer = 0

        local change_voice_icon = function()
            timer = timer + period
            if timer < self.palying_record.time then
                -- print("设置变化录音图标")
                local ico = self.palying_record.ref:Get("voiceico")
                if not Seven.PublicFun.IsNull(ico) then
                    ico:SetActive(not ico.activeSelf)
                end
            else
                -- print("设置播放结束")
                self:set_stopplay_record()
            end
        end
        self.hour_meter = Schedule(change_voice_icon,period)
    end
end

--设置播放结束
function Chat:set_stopplay_record()
    -- print("录音播放结束")
    if self.hour_meter then
        self.hour_meter:stop()
    end
    if self.palying_record then
        local ico = self.palying_record.ref:Get("voiceico")
        self.palying_record = nil
        if Seven.PublicFun.IsNull(ico) then
            return
        end
        if not ico.activeSelf then
            ico:SetActive(true)
        end
    end
end

-- 释放资源
function Chat:dispose()
    if self.public_chat_ui then
        self.public_chat_ui:dispose()
        self.public_chat_ui = nil
    end
    if self.emoji_ui then
        self.emoji_ui:dispose()
        self.emoji_ui = nil
    end
    self.auto_play_gvoice_channel = nil
    self._base.dispose(self)
end

function Chat:is_can_send_message(channel)
    local now_tiem = Net:get_server_time_s()
    if now_tiem<self:get_chat_cool(channel) then
        gf_message_tips(string.format("发言过于频繁，请稍等%d秒",self:get_chat_cool(channel)-now_tiem))
        return false
    elseif LuaItemManager:get_item_obejct("game"):getLevel()<ConfigMgr:get_config("chat_channel")[channel].level then
        gf_message_tips(string.format("等级不足，需要%d级",ConfigMgr:get_config("chat_channel")[channel].level))
        return false
    else
        return true
    end
end

--[[
speaker_volume
is_playFx_volume
]]
-- 设置语音音量
function Chat:set_speaker_volume(value)
    print("缓存值",value)
    speaker_volume = value
    is_speaker_volume = value > 0
    UnityEngine.PlayerPrefs.SetFloat("speakerVolume",speaker_volume)
    UnityEngine.PlayerPrefs.SetInt("isSpeakerVolume",is_speaker_volume and 1 or 0)
    print("保存缓存 speakerVolume",speaker_volume)
    print("保存缓存 isSpeakerVolume",is_speaker_volume and 1 or 0)
    if self:get_chat_ui():get_gVoice() then
        self:get_chat_ui():get_gVoice():set_speaker_volume()
    end
end

--设置语音音量开关
function Chat:set_is_speaker_volume(value)
    print("缓存值",value)
    is_speaker_volume = value
    UnityEngine.PlayerPrefs.SetInt("isSpeakerVolume",is_speaker_volume and 1 or 0)
    print("保存缓存 isSpeakerVolume",is_speaker_volume and 1 or 0)
    if self:get_chat_ui():get_gVoice() then
        self:get_chat_ui():get_gVoice():set_speaker_volume()
    end
end

--获取语音音量
function Chat:get_speaker_volume()
    return speaker_volume
end

-- 获取语音音量开关
function Chat:get_is_speaker_volume()
    return is_speaker_volume
end

-- 获取自动播放语音二进制储存数值
function Chat:get_auto_play_gvoice_channel_num()
    if not self.auto_play_gvoice_channel then
        local roleId = LuaItemManager:get_item_obejct("game"):getId()
        self.auto_play_gvoice_channel = UnityEngine.PlayerPrefs.GetInt("autoPlayGvoiceChannel"..roleId,bit._not(0)) -- 默认全自动 世界/军团/队伍
    end
    return self.auto_play_gvoice_channel
end

-- 设置一个频道是否自动播放语音
function Chat:set_auto_play_gvoice_channel(channel,value)
    local bit_channel = bit._rshift(0x80000000,32-(channel))
    if value then
        self.auto_play_gvoice_channel = bit._or(self:get_auto_play_gvoice_channel_num(),bit_channel)
    else
        self.auto_play_gvoice_channel = bit._and(self:get_auto_play_gvoice_channel_num(),bit._not(bit_channel))
    end
    local roleId = LuaItemManager:get_item_obejct("game"):getId()
    UnityEngine.PlayerPrefs.SetInt("autoPlayGvoiceChannel"..roleId,self:get_auto_play_gvoice_channel_num())
end

-- 获取一个频道是否自动播放语音
function Chat:get_auto_play_gvoice_channel(channel)
    local bit_channel = bit._rshift(0x80000000,32-(channel))
    print("频道",channel,"bit",bit_channel,"是否自动播放",bit._and(self:get_auto_play_gvoice_channel_num(),bit_channel) == bit_channel)
    return bit._and(self:get_auto_play_gvoice_channel_num(),bit_channel) == bit_channel
end

-- 获取一个语音消息是否读过
function Chat:get_gvoice_is_read(fileid)
    return read_gvoice_list[fileid] or false
end

-- 删除一个已读语音缓存
function Chat:delete_read_gvoice(fileid)
    read_gvoice_list[fileid] = nil
end