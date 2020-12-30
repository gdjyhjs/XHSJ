
local PlayerPrefs = UnityEngine.PlayerPrefs
local chatEnum = require("models.chat.chatEnum")

local chatRecord = {} --聊天记录
-- 本地保存数据处理缓存
local local_recent_contact = {} -- 最近联系人
local local_chat_role = {} -- 聊天列表
local local_chat_record = {} -- 聊天记录
local local_chat_record_list ={} -- 聊天记录列表 记录有聊天记录的人的id 用来记录聊天记录的数量   键-人物id，值=聊天数
local local_init_load_chat_count = 10 --初始读取几条聊天记录
local local_save_duration = 86400 --最近联系人和聊天列表 保存是时长
---------------------保存本地记录--------------------------
--保存最近联系人
function chatRecord:save_recent_contact(list) --{{id,}}
	local s = serpent.dump(list)
	print("保存最近联系人",s)
	PlayerPrefs.SetString(LuaItemManager:get_item_obejct("game"):getId().."_recent_contact",s)
end
--保存聊天列表
function chatRecord:save_chat_list(list)
	local s = serpent.dump(list)
	print("保存聊天列表",s)
	PlayerPrefs.SetString(LuaItemManager:get_item_obejct("game"):getId().."_chat_role",s)
end
--保存聊天记录列表
function chatRecord:save_chat_record_list(list,roleId)
	gf_print_table(list,"保存聊天记录")
	local k = LuaItemManager:get_item_obejct("game"):getId().."_"..roleId.."_chat_record"
	local s = serpent.dump(list)
	print("保存聊天记录",k,s)
	PlayerPrefs.SetString(k,s)
end
---------------------读取本地记录--------------------------
--读取最近联系人
function chatRecord:load_recent_contact()
	local s = PlayerPrefs.GetString(LuaItemManager:get_item_obejct("game"):getId().."_recent_contact", serpent.dump({}))
	print("读取最近联系人",LuaItemManager:get_item_obejct("game"):getId(),s)
	local list = loadstring(s)()
	return list
end
--读取聊天列表
function chatRecord:load_chat_role()
	local s = PlayerPrefs.GetString(LuaItemManager:get_item_obejct("game"):getId().."_chat_role", serpent.dump({}))
	print("读取聊天列表",s)
	local list = loadstring(s)()
	return list
end
--读取聊天记录
function chatRecord:load_chat_record(roleId) -- p 要读取倒数第几条聊天记录
	local k = LuaItemManager:get_item_obejct("game"):getId().."_"..roleId.."_chat_record"
	local s = PlayerPrefs.GetString(k, serpent.dump({}))
	--将读取到的json转成数组
	print("读取聊天记录",k,s)
	local list = loadstring(s)()
	gf_print_table(list,"读取聊天记录 ")
	return list
end

return chatRecord