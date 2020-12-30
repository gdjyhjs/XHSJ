--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-10 11:15:13
--]]

local Chat = LuaItemManager:get_item_obejct("chat")
local Enum = require("enum.enum")
local heroData = require("models.hero.dataUse")
local heroShow = require("models.hero.heroShowHeroInfo")
local chatTools = require("models.chat.chatTools")
local chatEnum = require("models.chat.chatEnum")

--发送位置消息
function Chat:send_position_message(map_id,client_pos,channel)
    local game = LuaItemManager:get_item_obejct("game")
    local char = LuaItemManager:get_item_obejct("battle"):get_character()
    map_id = map_id or game.role_info.mapId
    client_pos = client_pos or Vector2(char.transform.position.x,char.transform.position.z)
    local server_pos=Vector2(math.floor(client_pos.x*10),math.floor(client_pos.y*10))
    local str = "我在这里<"..ClientEnum.CHAT_TYPE.POSITION..","..map_id..","..server_pos.x..","..server_pos.y..">"
    self:send_message_c2s(str,channel)
end 

--发送申请入队信息
function Chat:send_apply_into_team(teamId,channel,content)
    local str = string.format(content,string.format("<%d,%d>",ClientEnum.CHAT_TYPE.APPLY_INTO_TEAM,teamId))
    self:send_message_c2s(str,channel)
end

--发送消息
function Chat:send_message_c2s(str,channel)
    if not channel then
        channel = self.curent_channel
    end
    if not str or str==nil or str=="" then
        gf_message_tips("发送的消息不能为空")
    end
    --获取当前的时间戳
    if self:is_can_send_message(channel) then
        local now_tiem = Net:get_server_time_s()
        self.chat_cool[channel]=now_tiem+ConfigMgr:get_config("chat_channel")[channel].cool --冷却时间
        local chat_info = {}
        chat_info.channel=channel
        chat_info.content=chatTools:chat_msg_modification(str) --进行第一次解析 解析成发给服务器的数据
        Net:send(chat_info,"base","Chat")

        -- --给自己一份消息
        -- local game = LuaItemManager:get_item_obejct("game")
        -- chat_info.roleInfo = game.role_info
        -- --这个是获取玩家是否有聊天气泡外观id，大于0就有
        -- chat_info.surfaceTalkBg = LuaItemManager:get_item_obejct("surface"):get_wear_surface_id(ServerEnum.SURFACE_TYPE.TALK_BG)

        -- self:send_message_s2c(chat_info)
        
        return true
    end
end
--收到服务器发来的消息
function Chat:send_message_s2c(msg)
    print("收到消息，是名单吗",msg.roleInfo and msg.roleInfo.roleId and LuaItemManager:get_item_obejct("social"):is_blackList(msg.roleInfo.roleId))
    if msg.roleInfo and msg.roleInfo.roleId and LuaItemManager:get_item_obejct("social"):is_blackList(msg.roleInfo.roleId)
    and msg.channel ~= Enum.CHAT_CHANNEL.SPEAKER then -- 大喇叭不屏蔽
        print("黑名单用户发出的消息",msg.roleInfo.roleId)
        return
    end
    -- gf_print_table(msg,"收到服务器的消息")
    if msg.code and msg.args then -- 有内容id 并且有参数 进行处理 获得内容
        local content = chatTools:marquee_modification(msg.code,msg.args)
        msg.content = content
    end
        -- print("收到消息",msg.channel,msg.content)
    if msg.content then
        if msg.channel == Enum.CHAT_CHANNEL.SPEAKER then
            --大喇叭
            print("大喇叭")
            View("horn", Chat):add_message(msg)
        end
        --获取实际要显示的内容
        msg.content = chatTools:chat_text_modification(msg.content,msg.roleInfo and msg.roleInfo.roleId and true or false)
        --如果是频道是 走马灯 或者是 走马灯+系统消息 广播到屏幕
        if msg.channel == Enum.CHAT_CHANNEL.BAR or msg.channel == Enum.CHAT_CHANNEL.SYSTEM_BAR then
            LuaItemManager:get_item_obejct("floatTextSys"):marquee(msg.content)
        end
        -- gf_print_table(msg,"聊天的信息")
        self:add_public_message_cache(msg)
    else
        print("<color=red>空的聊天内容</color>")
    end
end

--添加公共聊天消息到缓存
function Chat:add_public_message_cache(msg)
        -- print("添加消息",msg.channel,msg.content)
        gf_print_table(msg,"添加公共聊天消息到缓存")
    self.pc_id = self.pc_id + 1
    msg.id = self.pc_id
    -- gf_print_table(msg,"新消息")
    if not self.chat_cache[msg.channel] then
        self.chat_cache[msg.channel] = {}
    end
    table.insert(self.chat_cache[msg.channel],1,msg)
    local count = #self.chat_cache[msg.channel]
    if count > ConfigMgr:get_config("chat_channel")[msg.channel].save_count then
        table.remove(self.chat_cache[msg.channel],count)
    end
    Net:receive(msg, ClientProto.UpdateChatMessage)
    if type(msg.content) == "table" then
        -- 判断自动播放语音  判断频道 并且不是自己的消息
        gf_print_table(msg.content,"语音消息体")
        print("语音id",msg.content.fileid)
        if self:get_auto_play_gvoice_channel(msg.channel)
         and msg.roleInfo.roleId ~= LuaItemManager:get_item_obejct("game"):getId() 
         then
            self:play_recording(msg.content.fileid)
        end
    end
end
--获取历史消息
function Chat:get_history_chat_c2s()
    -- print("取历史聊天记录")
    Net:send({roleId=role_id},"base","GetHistoryChat")
end
--收到历史消息
function Chat:get_history_chat_s2c(msg)
    -- print("收到历史聊天记录")
    for i,v in ipairs(msg.list) do
        self:send_message_s2c(v)
    end
end

return Chat