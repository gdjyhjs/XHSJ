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
local chatRecord = require("models.chat.chatRecord")

function Chat:update_recent_contact_role(roleId,tm) --更新最近联系人
    local recentContactRole = chatRecord:load_recent_contact() --最近联系人
    for i,v in ipairs(recentContactRole) do
        if v.roleId == roleId then
            table.remove(recentContactRole,i)
            break
        end
    end
    table.insert(recentContactRole,1,{roleId = roleId,tm = tm})
    chatRecord:save_recent_contact(recentContactRole)
end

--发送赠送鲜花信息
function Chat:send_give_flower(roleId,content)
    local roleInfo = LuaItemManager:get_item_obejct("game"):getRoleInfo()
    local playerId = roleInfo.roleId
    local name = roleInfo.name
    local head = roleInfo.head
    local level = roleInfo.level
    local str = string.format(content,string.format("<%d,%d,%s,%d,%d>",ClientEnum.CHAT_TYPE.GIVE_FLOWER,playerId,name,head,level))
    self:chat_c2s(roleId,str)
end


--有人发来私聊
function Chat:chat_s2c(msg)
    gf_print_table(msg,"有人发来si")
    if msg.err == 0 then
        if msg.friend and msg.friend.roleId and LuaItemManager:get_item_obejct("social"):is_blackList(msg.friend.roleId) then
            print("黑名单用户发来的私聊",msg.friend.roleId)
            return
        end
        self:set_have_new_private_chat(true)
        self:update_recent_contact_role(msg.toRoleId and msg.toRoleId~=LuaItemManager:get_item_obejct("game"):getId() and msg.toRoleId or msg.friend.roleId,msg.tm)
    end
end

-- 获取朋友列表
function Chat:get_friend_list_s2c(msg,sid)
    -- sid
    -- RECENT_CONTACT = 1, --最近联系人
    -- CHAT_ROLE = 2, --聊天列表的人
    -- gf_print_table(msg,"服务器返回的玩家信息")
    -- for i,v in ipairs(msg.list) do
    --     if sid==chatEnum.GET_FRIEND_TYPE.RECENT_CONTACT then --更新到最近联系人
    --         self.chatRecord.update_recent_contact(v)
    --     elseif sid == chatEnum.GET_FRIEND_TYPE.CHAT_ROLE then --更新到聊天列表
    --         self.chatRecord.update_chat_role(v)
    --         if self:get_private_chat_ui() then
    --             self:get_private_chat_ui():update_ui()
    --         end
    --     end
    -- end
end

--取到离线消息的聊天列表
function Chat:get_chat_list_s2c(msg)
    local list = msg.list or {}
    self:set_have_new_private_chat(#list>0)
end

--取到聊天记录
function Chat:get_chat_record_s2c(msg)
end

--私聊----------------------------------客户端到服务器-------------------------------------

--告诉服务器我读了谁的消息
function Chat:had_read_c2s(roleId)
    local msg = { roleId = roleId }
    gf_print_table(msg,"发出协议：告诉服务器我读了消息",roleId)
    Net:send(msg,"friend","HasRead")
end

-- 取聊天记录
function Chat:get_chat_record_c2s(roleId)
    local msg = { roleId = roleId }
    gf_print_table(msg,"发出协议：发送获取聊天记录协议",roleId)
    Net:send(msg,"friend","GetChatRecord")
end

-- 取离线消息 的聊天列表
function Chat:get_chat_list_c2s()
    local msg = {}
    gf_print_table(msg,"发出协议：向服务器申请 取未读消息的聊天列表")
    Net:send(msg,"friend","GetChatList")
end

--发出私聊
function Chat:chat_c2s(role_id,content)
    local msg = {roleId=role_id,content=content}
    gf_print_table(msg,"发出协议：发出私聊信息")
    Net:send(msg,"friend","Chat")
end
-- 请求获取玩家信息
function Chat:get_friend_list_c2s(roleid,sid)
    -- sid 0 一般
    -- sid 1 : 聊天列表
    -- sid 2 : 最近联系人
    if type(roleid) ~= "table" then roleid = {roleid} end
    local msg = {roleId=roleid}
    gf_print_table(msg,"发出协议：请求获取朋友信息")
    Net:send(msg,"friend","GetFriendInfo",sid)
end

function Chat:is_have_new_private_chat()
    return self.have_new_private_chat or false
end

function Chat:set_have_new_private_chat(value)
    self.have_new_private_chat = value
    Net:receive({id=ClientEnum.MAIN_UI_BTN.SPRIVATE_CHAT, visible=self.have_new_private_chat}, ClientProto.ShowOrHideMainuiBtn)
end

return Chat