local chatEnum = require("models.chat.chatEnum")
local Enum = require("enum.enum")
local heroData = require("models.hero.dataUse")
local heroShow = require("models.hero.heroShowHeroInfo")
local ChatTools={}

-- ChatTools.audio_dull_content="#voice_chat#" --聊天纯文本内容

ChatTools.message_text_width={ --聊天消息框宽度
	[chatEnum.MESSAGE_TYPE.SELF] = 400,
	[chatEnum.MESSAGE_TYPE.OTHER] = 400,
	[chatEnum.MESSAGE_TYPE.SYSTEM] = 400,
	[chatEnum.MESSAGE_TYPE.TIME] = 400,
}

ChatTools.private_chat_role_btn_bg = "scroll_table_cell_bg_02_normal"
ChatTools.private_chat_role_btn_select_bg = "scroll_table_cell_bg_02_select"
ChatTools.init_update_chat_record_count = 10 --初始更新聊天条数
ChatTools.how_time_show_time = 60 --多久间隔的聊天时间会显示发言时间

--解析走马灯
function ChatTools:marquee_modification(code,args)
    local data = ConfigMgr:get_config("broadcast_channel")[code]
    local str = data and data.content or ""
    for i,v in ipairs(args) do
        str = string.gsub(str,"v"..i,v)
    end
    return str
end

--第一次解析
--聊天消息修改(从输入框的内容赚到可以记录物品信息的文本) 第一次解析
function ChatTools:chat_msg_modification(str)
    -- print("解析一:未解析的文字",str)
    --半角空格替换成全角空格，防止换行问题
    str=string.gsub(str, " ", "　")
    -- str=string.gsub(str, "/", "\\")
    -- for s in string.gmatch(str,["#s[1-9][0-9]?" , "#c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]") , "#b" , "#i"] do
    --     if string.find(s,"#s[1-9][0-9]?") then
    --         local size = tonumber(string.sub(s,3,-1))
    --         if size<20 then
    --             size=20
    --         elseif size>40 then
    --             size=40
    --         end
    --         str = string.gsub(str,s,"<size="..size..">",1)
    --         str = str.."</size>"
    --     elseif string.find(s,"#c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]") then
    --         local color = tonumber(string.sub(s,3,-1))
    --         str = string.gsub(str,s,"<color=#"..color..">",1)
    --         str = str.."</color>"
    --     elseif string.find(s,"#b") then
    --         str = string.gsub(str,s,"<b>",1)
    --         str = str.."</b>"
    --     elseif string.find(s,"#i") then
    --         str = string.gsub(str,s,"<i>",1)
    --         str = str.."</i>"
    --     end
    -- end


    print("原字符串",str)
    if string.find(str,"^#t") then
        str = string.gsub(str,"#t","",1)
    else
        local tail = ""
        for s in string.gmatch(str,"#[scbi]%w*") do
            print(s)
            if string.find(s,"^#s[1-9][0-9]") then
                local size = tonumber(string.sub(s,3,4))
                print("修改文字大小",size)
                if size<20 then
                    size=20
                elseif size>40 then
                    size=40
                end
                str = string.gsub(str,"#s[1-9][0-9]","<size="..size..">",1)
                tail = "</size>"..tail
            elseif string.find(s,"^#c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]") then
                local color = string.sub(s,3,8)
                print("修改文字颜色",color)
                str = string.gsub(str,"#c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]","<color=#"..color..">",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#b") then
                print("加粗",s)
                str = string.gsub(str,"#b","<b>",1)
                tail = "</b>"..tail
            elseif string.find(s,"^#i") then
                print("斜体",s)
                str = string.gsub(str,"#i","<i>",1)
                tail = "</i>"..tail
            elseif string.find(s,"^#caqua") then
                str = string.gsub(str,"#caqua","<color=aqua>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cblack") then
                str = string.gsub(str,"#cblack","<color=black>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cblue") then
                str = string.gsub(str,"#cblue","<color=blue>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cbrown") then
                str = string.gsub(str,"#cbrown","<color=brown>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#ccyan") then
                str = string.gsub(str,"#ccyan","<color=cyan>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cdarkblue") then
                str = string.gsub(str,"#cdarkblue","<color=darkblue>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cfuchsia") then
                str = string.gsub(str,"#cfuchsia","<color=fuchsia>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cgreen") then
                str = string.gsub(str,"#cgreen","<color=green>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cgrey") then
                str = string.gsub(str,"#cgrey","<color=grey>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#clightblue") then
                str = string.gsub(str,"#clightblue","<color=lightblue>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#clime") then
                str = string.gsub(str,"#clime","<color=lime>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cmagenta") then
                str = string.gsub(str,"#cmagenta","<color=magenta>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cmaroon") then
                str = string.gsub(str,"#cmaroon","<color=maroon>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cnavy") then
                str = string.gsub(str,"#cnavy","<color=navy>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#colive") then
                str = string.gsub(str,"#colive","<color=olive>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#corange") then
                str = string.gsub(str,"#corange","<color=orange>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cpurple") then
                str = string.gsub(str,"#cpurple","<color=purple>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cred") then
                str = string.gsub(str,"#cred","<color=red>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#csilver") then
                str = string.gsub(str,"#csilver","<color=silver>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cteal") then
                str = string.gsub(str,"#cteal","<color=teal>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cwhite") then
                str = string.gsub(str,"#cwhite","<color=white>",1)
                tail = "</color>"..tail
            elseif string.find(s,"^#cyellow") then
                str = string.gsub(str,"#cyellow","<color=yellow>",1)
                tail = "</color>"..tail
            end
        end
        str = str .. tail
        print("修改后的字符串",str)
    end

    local chat = LuaItemManager:get_item_obejct("chat")
    local prop_cache = chat.prop_cache
    -- gf_print_table(prop_cache)
    local max_count = 3
    local idx = 0
    for s in string.gmatch(str,"#e[0-8][0-9]") do
        idx = idx + 1
        print(s,idx)
        local sprite_name = string.sub(s,3,4)
        str=string.gsub(str, s,idx>10 and "" or "<emoji,"..sprite_name..">",1)
    end
    for i,v in ipairs(prop_cache) do
        local name = "%["..string.sub(v.name,2,-2).."%]"
        -- print(str,"是否包含",name)
        if max_count>0 and string.find(str,name) then
            max_count = max_count - 1
            if v.type == ClientEnum.CHAT_TYPE.HERO then
                --武将
                gf_print_table(v,"记录的信息1")
                local hero_info = LuaItemManager:get_item_obejct("hero"):get_hero_have()[v.uid]
                gf_print_table(hero_info,"记录的信息2")
                if hero_info then
                    local game = LuaItemManager:get_item_obejct("game")
                    local chat_type = ClientEnum.CHAT_TYPE.HERO
                    local target_s = "<"..chat_type..","..hero_info.heroId..","..hero_info.heroId..","..game.role_info.roleId..">"
                    -- print(str,"查找",name,"替换",target_s)
                    str=string.gsub(str, name, target_s ,1)
                end
            elseif v.type == ClientEnum.CHAT_TYPE.PROP then
                --道具
                local bag = LuaItemManager:get_item_obejct("bag")
                local item = bag.items[v.slot]
                if item then
                    local data = ConfigMgr:get_config("item")[item.protoId]
                    local bt = bag:get_type_for_protoId(item.protoId)
                    if bt == Enum.ITEM_TYPE.EQUIP then --如果是装备
                        local game = LuaItemManager:get_item_obejct("game")
                        local chat_type = ClientEnum.CHAT_TYPE.EQUIP
                        local target_s = "<"..chat_type..","..item.guid..","..item.protoId..","..game.role_info.roleId..","..(item.color or data.color)..">"
                        -- print(str,"查找",name,"替换",target_s)
                        str=string.gsub(str, name, target_s ,1)
                    else --普通道具
                        local chat_type = ClientEnum.CHAT_TYPE.PROP
                        local target_s = "<"..chat_type..","..item.protoId..">"
                        -- print(str,"查找",name,"替换",target_s)
                        str=string.gsub(str, name, target_s ,1)
                    end
                end
            end
        end
    end
    chat.prop_cache = {}
    -- print("第一次解析后",str)
    -- str = filterChar(str)
    return str
end

--第二次解析
--聊天文本修改(从聊天消息转到可以显示在聊天频道的文本) 第二次解析
function ChatTools:chat_text_modification(str,filter_char)
    if filter_char then
        str = filterChar(str)
    end
    str = str or ""
	-- print("解析二:未处理的文字"..str)
    --判断是否语音信息
    local voice_type = ClientEnum.CHAT_TYPE.PLAYMSG
    local voice_reg_exp = "<"..voice_type..",%w+_.*>" -- #
    for s in string.gmatch(str,voice_reg_exp) do
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local info = string.split(cip[2],"_")
        -- gf_print_table(info,"是语音")
        return { fileid = info[1] , content = info[2] , time = info[3] }
    end

    local equip_type = ClientEnum.CHAT_TYPE.EQUIP
    local prop_type = ClientEnum.CHAT_TYPE.PROP
    local hero_type = ClientEnum.CHAT_TYPE.HERO
    local pos_type = ClientEnum.CHAT_TYPE.POSITION
    local number_type = ClientEnum.CHAT_TYPE.VALUE
    local player_type = ClientEnum.CHAT_TYPE.PLAYER
    local apply_into_tram_type = ClientEnum.CHAT_TYPE.APPLY_INTO_TEAM
    local give_flower_type = ClientEnum.CHAT_TYPE.GIVE_FLOWER
    local faction_type = ClientEnum.CHAT_TYPE.FACTION
    local apply_into_alliance_type = ClientEnum.CHAT_TYPE.APPLY_INTO_ALLIANCE
    local equip_reg_exp = "<"..equip_type..",%w+,%d+,%d+,%d>" --装备正则 装备的聊天类型，guid，原型id，玩家id，品质
    local item_reg_exp = "<"..prop_type..",%d+,?%d->" --道具物品正则 道具的聊天类型，原型id
    local hero_reg_exp = "<"..hero_type..",%d+,%d+,%d+>" --武将正则 武将聊天类型 uid id 玩家id
    local pos_reg_exp = "<"..pos_type..",%d+,%-?%d+,%-?%d+>"    --坐标正则
    local emoji_reg_exp = "<emoji,[0-8][0-9]>" --表情符正则 #序号 1-40是表情
    local number_reg_exp = "<"..number_type..",.->" --直接填入值正则
    local player_reg_exp = "<"..player_type..",%d+,.->" --玩家正则
    local apply_into_team_reg_exp = "<"..apply_into_tram_type..",%d+>" --申入队伍正则
    local give_flower_reg_exp = "<"..give_flower_type..",%d+,.-,%d+,%d+>" --送花正则
    local faction_reg_exp = "<"..faction_type..",%d>" --3v3阵营
    local apply_into_alliance_reg_exp = "<"..apply_into_alliance_type..",%d+>" --申入军团正则

    -- print("解析表情符密文 二次解析文本",str)
    --解析装备密文
    for s in string.gmatch(str,equip_reg_exp) do
        local item_sys = LuaItemManager:get_item_obejct("itemSys")
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local guid = cip[2] --guid
        local protoid = tonumber(cip[3]) --原型id
        local playerid = tonumber(cip[4]) --玩家id
        local color =  item_sys:get_item_color(tonumber(cip[5]))  --品质
        local data = ConfigMgr:get_config("item")[protoid]
        local item_name = "["..data.name.."]"
        local target_s = "<a href="..equip_type..","..guid..","..playerid..","..protoid.."><color="..color..">"..item_name.."</color></a>"
        str=string.gsub(str, s, target_s)
    end
    -- print("解析装备密文 二次解析文本",str)

    --解析道具密文
    for s in string.gmatch(str,item_reg_exp) do
        local item_sys = LuaItemManager:get_item_obejct("itemSys")
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local protoid = tonumber(cip[2])
        local count = cip[3]
        local data = ConfigMgr:get_config("item")[protoid]
        local item_name = "["..data.name.."]"
        if count and tonumber(count)>1 then
            item_name = item_name.."*"..count
        end
        local color = item_sys:get_item_color(data.color)
        local target_s = "<a href="..prop_type..","..protoid.."><color="..color..">"..item_name.."</color></a>"
        str=string.gsub(str, s, target_s)
    end
    -- print("解析道具密文 二次解析文本",str)

    --解析武将密文
    for s in string.gmatch(str,hero_reg_exp) do
        local item_sys = LuaItemManager:get_item_obejct("itemSys")
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local uid = tonumber(cip[2])
        local id = tonumber(cip[3])
        local playerid = cip[4]
        local data = ConfigMgr:get_config("hero")[id]
        local color =  item_sys:get_item_color(data.hero_type)
        local hero_name = "["..data.name.."]"
        local target_s = "<a href="..hero_type..","..uid..","..playerid.."><color="..color..">"..hero_name.."</color></a>"
        str=string.gsub(str, s, target_s)
    end
    -- print("解析武将密文 二次解析文本",str)

    --解析坐标位置密文
    for s in string.gmatch(str,pos_reg_exp) do
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        gf_print_table(cip)
        local mapid = tonumber(cip[2])
        local posX = cip[3]
        local posY = cip[4]
        local map_name=ConfigMgr:get_config("mapinfo")[mapid].name or "未知"
        local pos_text="["..map_name.."("..math.floor(posX/10)..","..math.floor(posY/10)..")]"
        local target_s = "<a href="..pos_type..","..mapid..","..posX..","..posY.."><color=#52b44d>"..pos_text.."</color></a>"
        str=string.gsub(str, s, target_s)
    end
    -- print("解析坐标位置密文 二次解析文本",str)

    --解析数值
    for s in string.gmatch(str,number_reg_exp) do
        local target_s = string.split(string.sub(s,2,-2),",")[2] --获取密文
        str=string.gsub(str, s, target_s)
    end
    -- print("解析坐标位置密文 二次解析文本",str)

    --解析玩家
    for s in string.gmatch(str,player_reg_exp) do
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local playerId = tonumber(cip[2])
        local playerName = cip[3]
        local target_s = "<a href="..player_type..","..playerId.."><color=#47A6F0>"..playerName.."</color></a>"
        str=string.gsub(str, s, target_s)
    end
    -- print("解析玩家 二次解析文本",str)

    --解析申请入队
    for s in string.gmatch(str,apply_into_team_reg_exp) do
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local teamId = cip[2]
        local target_s = "<a href="..apply_into_tram_type..","..teamId.."><color=#47A6F0>申请入队</color></a>"
        str=string.gsub(str, s, target_s)      
    end

    --解析赠送鲜花
    for s in string.gmatch(str,give_flower_reg_exp) do
        -- print(s)
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local playerId = tonumber(cip[2])
        local name = cip[3]
        local head = cip[4]
        local level = cip[5]
        local target_s = ""
        local target_d = ""
        -- print(give_flower_type,playerId,name,head,level)
        -- print(string.format("%s,%s",LuaItemManager:get_item_obejct("game").role_id,playerId))
        if LuaItemManager:get_item_obejct("game").role_id ~= playerId then
            -- print("不是自己")
            target_s = string.format("<a href=%d,%d,%s,%d,%d><color=#47A6F0>点击回赠</color></a>",give_flower_type,
                playerId,name,head,level)
            target_d = "点击回赠"
        end
        str=string.gsub(str, s, target_s)
    end

    --解析3V3阵营
    for s in string.gmatch(str,faction_reg_exp) do
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local teamId = tonumber(cip[2])
        local target_s = teamId==1 and "星宇" or "落阳"
        str=string.gsub(str, s, target_s)
    end

    --解析申入军团
    for s in string.gmatch(str,apply_into_alliance_reg_exp) do
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local id = cip[2] 
        local target_s = "<a href="..apply_into_alliance_type..","..id.."><color=#47A6F0>立即加入</color></a>"
        str=string.gsub(str, s, target_s)
    end


    --解析表情符密文
    -- print(str,"匹配表情正则")
    local chat_emoji_size = ConfigMgr:get_config("t_misc").chat_emoji_size
    for s in string.gmatch(str,emoji_reg_exp) do
        print("--匹配表情符正则",s)
        local cip = string.split(string.sub(s,2,-2),",") --获取密文
        local sprite_name = cip[2]
        print("表情名称",sprite_name)
        local emoji_id = tonumber(sprite_name) or 0
        print("表情id",emoji_id)
        if emoji_id>=1 and emoji_id<=40 then
            local target_s = "　<quad name="..sprite_name.." size="..chat_emoji_size.." width=1/>" --　
            -- print(s,"替换成",target_s)
            str=string.gsub(str, s, target_s)
        end
    end

    return str
end

--文字点击
function ChatTools:text_on_click(key)
    print("点击文字",key)
    Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    -- print("文字点击",key)
    local strs=string.split(key,",")
    gf_print_table(strs)
    local t = strs[1]
    t=tonumber(t)   --获取聊天类型
    -- print("类型",t)
    if t==ClientEnum.CHAT_TYPE.PLAYER then
        -- print("显示玩家")
        LuaItemManager:get_item_obejct("player"):show_player_tips(tonumber(strs[2]))
    elseif t==ClientEnum.CHAT_TYPE.PROP then
        -- print("显示道具")
        LuaItemManager:get_item_obejct("itemSys"):prop_tips(tonumber(strs[2]))
    elseif t==ClientEnum.CHAT_TYPE.EQUIP then
        -- print("显示装备")
        LuaItemManager:get_item_obejct("itemSys"):remote_equip_tips(tonumber(strs[2]),tonumber(strs[3]))
    elseif t==ClientEnum.CHAT_TYPE.HERO then
        -- print("显示武将")
        local roleId = tonumber(strs[3])
        local heroId = tonumber(strs[2])
        print("人物id",roleId)
        print("武将id",heroId)
        heroShow(roleId,heroId)
    elseif t==ClientEnum.CHAT_TYPE.POSITION then
        -- print("移动到坐标",strs[3],0,strs[4])
        LuaItemManager:get_item_obejct("battle"):move_to( tonumber(strs[2]),tonumber(strs[3]),tonumber(strs[4]))

    elseif t==ClientEnum.CHAT_TYPE.APPLY_INTO_TEAM then
        -- print("申请入队")
        local teamId = strs[2]
        local team = LuaItemManager:get_item_obejct("team")
        if not team:is_my_team(teamId) then
            team:sendToJoinTeam(teamId)
        end
    elseif t==ClientEnum.CHAT_TYPE.GIVE_FLOWER then
        -- print("赠送鲜花")
        local playerId = tonumber(strs[2])
        local name = strs[3]
        local head = tonumber(strs[4])
        local level = tonumber(strs[5])
        local tab = {name=name,head=head,level=level,roleId=playerId}
        LuaItemManager:get_item_obejct("gift"):show_view(tab) 
    elseif t==ClientEnum.CHAT_TYPE.APPLY_INTO_ALLIANCE then
        -- print("申入军团")
        local id = tonumber(strs[2])
        LuaItemManager:get_item_obejct("legion"):apply_join_c2s(id) 
    else
        -- print("没有找到聊天定义",t,strs[2],strs[3],strs[4])
    end
end

--获取文本大小
function ChatTools:get_text_size(text,str,maxWidth)
	-- print(text,str,maxWidth)
	return LuaHelper.GetStringSize(str,text,maxWidth)
end

--设置聊天标签
function ChatTools:set_chat_tag(img,text,channel)
    local data = ConfigMgr:get_config("chat_channel")[channel]
    img.color=gf_get_color2(data.font_color)
    text.text=data.name
end


ChatTools.chat_label_color = {}
--获取聊天频道标签颜色
function ChatTools:get_chat_label_color(channel)
    if not self.chat_label_color[channel] then
        local data = ConfigMgr:get_config("chat_channel")[channel]
        local r,g,b = data.color_r,data.color_g,data.color_b
        self.chat_label_color[channel] = string.format("#%x%x%x",r,g,b)
    end
    return self.chat_label_color[channel] or "#FFFFFF"
end

ChatTools.chat_label_name = {}
--获取频道名称
function ChatTools:get_chat_label_name(channel)
    if not self.chat_label_name[channel] then
        local data = ConfigMgr:get_config("chat_channel")[channel]
        self.chat_label_name[channel] = data.name
    end
    return self.chat_label_name[channel] or ""
end

--判断a频道是否接收b频道的消息
function ChatTools:is_receive_chat(a,b)
    for i,v in ipairs(ConfigMgr:get_config("chat_channel")[a].send_channel) do
        if v == b then
    -- print(string.format("判断%d频道是否接收%d频道:%s",a,b,true))
            return true
        end
    end
    -- print(string.format("判断%d频道是否接收%d频道:%s",a,b,false))
    return false
end

return ChatTools