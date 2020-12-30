--[[--
* ui通用全局方法类
* 
* @Author:      Seven
* @DateTime:    2017-03-09 21:20:16
]]

function gf_message_tips(msg,pos)
    print("飘字",msg)
    local tips = LuaItemManager:get_item_obejct("floatTextSys") -- 飘字
    --tips.assets[1]:sys_tishi(msg,pos or UnityEngine.Vector2(UnityEngine.Screen.width/2,UnityEngine.Screen.height/2))
    tips:tishi(msg)    --策划说飘字要飘在右下边
end

-- 错误提示（给策划看）
function gf_error_tips( msg )
    if DEBUG then
        msg = "<color=red>"..msg.."</color>"
        local tips = LuaItemManager:get_item_obejct("floatTextSys") -- 飘字
        tips:tishi(msg)
        print_error(msg)
    end
end

--@img Image component
--@name 纹理名字
g_icon_cache = {}
g_icon_mat_cache = {}
img_load_cache = {}
function gf_setImageTexture(img,name,cb)
    -- print("加载图标",UI_RGB_A)
    if not name then print_error("ItemSys:set_item_ico 图片name 为空") return end
    if not img then print("<color=red>要设置精灵的图片为空</color>") return end
    -- print("设置图标",img,name)
    local big_name
    if UI_RGB_A then
        big_name = ConfigMgr:get_config("altas_sprite")[tostring(name)]
        if not big_name then
            gf_error_tips("找不到图片"..name)
            return
        end
        print("更换图片",img)
        img:SetSprite(big_name, name, function( sprite )
            if cb then
                cb(sprite)
            end
        end)
    else

        if g_icon_cache[name] and not Seven.PublicFun.IsNull(g_icon_cache[name]) then
            -- print("设置图标加载缓存",name,img,"设置图片")
            local sprite = g_icon_cache[name]
            if not Seven.PublicFun.IsNull(img) then
                img.sprite = sprite
            end
            img_load_cache[img] = nil
            if cb then
                cb(sprite)
            end
        else
            img_load_cache[img] = name
            Loader:get_resource(name..".u3d",nil,"UnityEngine.Sprite",function(s)
                -- print("设置图标加载成功",name,img,"是否设置图片",img_load_cache[img] == name,img_load_cache[img],name)
                g_icon_cache[name]=s.data
                if img_load_cache[img] == name then
                    if not Seven.PublicFun.IsNull(img) then
                        img.sprite=s.data
                    end
                    img_load_cache[img] = nil
                end
                if cb then
                    cb(s.data)
                end
            end,function(s)
                -- print("设置图标加载失败")
                if img_load_cache[img] == name then
                    gf_setImageTexture(img,"miss")
                    img_load_cache[img] = nil
                end
            end)
        end
    end
end

--显示根据角色掉落的装备 
--@data 要是显示的数据{虚拟物品ID，个数，是否按职业掉落（0不按，1按），装备颜色，装备星级}
function gf_set_equip_icon_ex(data,icon,bg)
    if data[3] == 1 then
        local dataUse = require("models.legion.dataUse")
        local career = gf_getItemObject("game"):get_career()
        local id = dataUse.getCareerItem(data[1],career)--get(item.effect,career)
        local item_id = gf_get_config_table("equip_formula")[id].code

        gf_set_equip_icon(item_id, icon, bg,data[4],data[5])
    else

    end
end
function gf_clear_texture_cache()
    g_icon_cache = {}
    -- for k,v in pairs(g_icon_mat_cache) do
    --     Resources.UnloadAsset(v)
    -- end
    g_icon_mat_cache = {}
end

--[[
设置item图标和品质
item_id:物品id
item_icon_img:物品图标的image
color_img:品质image
color:物品品质 如果是装备的话才必须要传，普通物品传空就可以，会从配置文件读取品质
]]
function gf_set_item( item_id, item_icon_img, color_img ,color,star_count)
    -- print("设置图标",item_id, item_icon_img, color_img ,color,star_count)
    local data = ConfigMgr:get_config("item")[item_id]
    if not data and item_id then
        print("ERROR:找不到物品，id =", item_id)
    end

    -- 如果是虚拟物品，读取真实物品id
    if data and data.type == ServerEnum.ITEM_TYPE.VIRTUAL and data.sub_type == ServerEnum.VIRTUAL_TYPE.EQUIP_FORMULA_CAREER then
        local formulaId = LuaItemManager:get_item_obejct("itemSys"):get_formulaId_for_id(item_id)
        item_id = ConfigMgr:get_config("equip_formula")[formulaId].code
        gf_set_equip_icon(item_id,item_icon_img, color_img ,color,star_count)
        return
    elseif data and data.type == ServerEnum.ITEM_TYPE.EQUIP then
        gf_set_equip_icon(item_id,item_icon_img, color_img ,color,star_count)
        return
    end


    if color_img then
        gf_setImageTexture(color_img,"item_color_"..(color or (data and data.color) or "0"))
    end

    if item_icon_img and data then
        gf_setImageTexture(item_icon_img,data.icon or "miss")
    end

-- 大类5，小类1的道具 武将碎片
-- 所有的道具图标的显示，都需要在左上角加上一个和品质对应的小碎片图标
    local debris = item_icon_img and item_icon_img.transform:Find("debris")
    if data and data.type == ServerEnum.ITEM_TYPE.VIRTUAL and data.sub_type == ServerEnum.VIRTUAL_TYPE.HERO_CHIP then
        if debris then
            debris.gameObject:SetActive(true)
            gf_setImageTexture(debris:GetComponent(UnityEngine_UI_Image),"hero_fragments_04")
        else
            debris = LuaHelper.Instantiate(item_icon_img.gameObject)
            debris.name = "debris"
            debris.transform:SetParent(item_icon_img.transform,false)
            debris.transform.anchoredPosition = Vector2(-25,25)
            debris.transform.sizeDelta = Vector2(33,34)
            gf_setImageTexture(debris:GetComponent(UnityEngine_UI_Image),"hero_fragments_04")
        end
    elseif debris then
        debris.gameObject:SetActive(false)
    end

    local star = item_icon_img and item_icon_img.transform:Find("star")
    if star then
        star.gameObject:SetActive(false)
    end


end

-- equip传装备 或者原型id
function gf_set_equip_icon(equip,icon,bg,color,star_count)
    local is_table = type(equip) == "table"
    local data = ConfigMgr:get_config("item")[is_table and equip.protoId or equip]
    if not data and item_id then
        print("ERROR:找不到物品，id =", equip.protoId)
        return
    end
    if icon and data then
        gf_setImageTexture(icon,data.icon or "miss")
    end
    if bg then
        gf_setImageTexture(bg,"item_color_"..(color or (is_table and equip.color) or data.color or "0"))
    end

    -- 装备有星级的需要显示星星
    local star = icon and icon.transform:Find("star")
    -- print("星级",star_count)
    local count = star_count or (is_table and #(equip.exAttr or {})) or 0
    -- print("装备星级",count)
    if count>0 and equip and icon then
        if not star then
            star = LuaHelper.Instantiate(icon.gameObject)
            star.name = "star"
            star.transform:SetParent(icon.transform,false)
            -- star.transform.anchoredPosition = Vector2(-25,5)
                star.transform.anchoredPosition = Vector2(-icon.transform.sizeDelta.x/2.5,-icon.transform.sizeDelta.y/30)
            star.transform.sizeDelta = Vector2(0,0)
            for i=1,3 do
                local s = LuaHelper.Instantiate(i==1 and star or star.transform:GetChild(0).gameObject)
                s.transform:SetParent(star.transform,false)
                -- s.transform.anchoredPosition = Vector2(0,46 - 23*i)
                s.transform.anchoredPosition = Vector2(0,-icon.transform.sizeDelta.y/4*2 + icon.transform.sizeDelta.y/4*i -icon.transform.sizeDelta.y/10)
                -- s.transform.sizeDelta = Vector2(25.6,23.9)
                s.transform.sizeDelta = Vector2(icon.transform.sizeDelta.x/4,icon.transform.sizeDelta.y/4)
                gf_setImageTexture(s:GetComponent(UnityEngine_UI_Image),"img_fuben_star")
            end
        end
        for i=1,3 do
            local s = star.transform:GetChild(i-1)
            gf_setImageTexture(s:GetComponent(UnityEngine_UI_Image),"img_fuben_star")
            s.gameObject:SetActive(count>=i)
        end
        star.gameObject:SetActive(true)
    elseif star then
        star.gameObject:SetActive(false)
    end
    local debris = icon and icon.transform:Find("debris")
    if debris then
        debris.gameObject:SetActive(false)
    end
end

--设置品质框
function gf_set_quality_bg(color_img,color)
    gf_setImageTexture(color_img,"item_color_"..(color or "0"))
end

--设置角色头像图标
function gf_set_head_ico(img,head_id)
    gf_setImageTexture(img,"img_head_"..head_id)
end

--设置基础资源图标
function gf_set_money_ico(item_icon_img,money_type,color_img,is_item)
    local bind = false
    local data = ConfigMgr:get_config("base_res")[money_type]
    if data then
        gf_setImageTexture(item_icon_img,is_item and data.item_icon or data.icon)
        if color_img then
            gf_set_quality_bg(color_img,data.color)
        end
    end
    local star = item_icon_img and item_icon_img.transform:Find("star")
    if star then
        star.gameObject:SetActive(false)
    end
    local debris = icon and icon.transform:Find("debris")
    if debris then
        debris.gameObject:SetActive(false)
    end
end

--获取基础资源名称
function gf_get_money_name(money_type)
    local data =  ConfigMgr:get_config("base_res")[money_type]
    return data and data.name or "未配置的基础资源"
end

--判断资源是否足够
function gf_is_enough_res(res_type,need_value)
    local game = LuaItemManager:get_item_obejct("game")
    if res_type == ServerEnum.BASE_RES.BIND_GOLD or res_type == ServerEnum.BASE_RES.GOLD then
        return game:get_money(ServerEnum.BASE_RES.BIND_GOLD)+game:get_money(ServerEnum.BASE_RES.GOLD) >= need_value
    else
        return game:get_money(res_type) >= need_value
    end
end

--获取颜色
--@colorId 颜色枚举
--@return #ffffff
function gf_get_color(colorId)
    return ConfigMgr:get_config("color")[colorId].color
end

-- 通过道具品质获取字体颜色
function gf_get_color_by_quality( quality )
    return LuaItemManager:get_item_obejct("itemSys"):get_item_color(quality)
end

-- 通过道具id获取颜色 #ffffff
function gf_get_color_by_item( item_id )
    local data = ConfigMgr:get_config("item")[item_id]
    if data then
        return gf_get_color_by_quality(data.color)
    end
    return gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_BLUE)
end

--设置通用颜色(文本内容,枚举ClientEnum.SET_GM_COLOR)
function gf_set_text_color(text,enum)
   local color =ConfigMgr:get_config("gm_color")[enum].color
   local txt = "<color="..color..">"..text.."</color>"
   return txt
end
--获取通用颜色(枚举ClientEnum.SET_GM_COLOR)
function gf_get_text_color(enum)
   return ConfigMgr:get_config("gm_color")[enum].color
end
--根据#FFFFFFFF 获取 UnityEngine.Color
function gf_get_color2(color_value)
    -- print("取色",color_value)
    color_value = color_value or ""

    local get_value = function(v_16)
        if v_16 and v_16~=nil and v_16~="" then
            local value = "0x"..v_16
            return value
        else
            return "0xFF"
        end
    end
    return UnityEngine.Color(get_value(string.sub(color_value,2,3))/255,
                            get_value(string.sub(color_value,4,5))/255,
                            get_value(string.sub(color_value,6,7))/255,
                            get_value(string.sub(color_value,8,9))/255)
end

--快速购买
--item_id. 商品id
--count  默认数,count量
--如果只有一件商品弹直接购买界面
function gf_create_quick_buy(item_id,count)
    local dataUse = require("models.horse.dataUse")
    local goods = dataUse.get_goods_by_item_id(item_id) or {}
    if #goods == 1 then
        require("models.horse.buyConfirm")(goods[1].goods_id,count)
        return
    end
    require("models.horse.quickBuy")(items,count,goods)
end
--快速购买
--items. 商品id {itemId,itemId}
--count  默认数,count量
--如果只有一件商品弹直接购买界面
function gf_create_quick_buys(item_ids,count)
    local dataUse = require("models.horse.dataUse")
    local goods = dataUse.get_goods_by_items_id_ex(item_ids)
    if #goods == 1 then
        require("models.horse.buyConfirm")(goods[1].goods_id,count)
        return
    end
    require("models.horse.quickBuy")(items,count,goods)
end
--道具大类 btype
--道具小类 stype
--道具数量 count
function gf_create_quick_buy_by_type(btype,stype,count)
    local items = require("models.bag.bagUserData"):get_item_for_type(btype,stype)
    local dataUse = require("models.horse.dataUse")
    local goods = dataUse.get_goods_by_items_id(items)
    if not goods then
        gf_message_tips("商店没有此类商品")
        return
    end
    if #goods == 1 then
        require("models.horse.buyConfirm")(goods[1].goods_id,count)
        return
    end
    require("models.horse.quickBuy")(items,count,goods)
end
-- 显示遮罩界面
function gf_mask_show(visible)
    print("gf_mask_show",visible)
    if visible then
        gf_getItemObject("mask"):on_focus()
    else
        gf_getItemObject("mask"):on_blur()
    end
end

--@tips_id  配表id
function gf_show_doubt(tips_id)
    print("tips_id:",tips_id)
    local tips_data = ConfigMgr:get_config("faqTips")[tips_id]
    local temp = {}
    --只支持8个
    for i=1,20 do
         if tips_data["content"..i] then
             table.insert(temp,tips_data["content"..i])
         end
    end
    local width = tips_data.width or 300
    local NormalTipsView = require("common.normalTipsView")
    NormalTipsView(gf_getItemObject("mainui"), temp,width)
end

--data。数据源 一层表结构
--width 宽度 可选
--挂载数据类 可选
function gf_show_tips(data,width,item_obj)
    local NormalTipsView = require("common.normalTipsView")
    local item_obj = gf_getItemObject("mainui") or item_obj
    local width = width or 300
    NormalTipsView(item_obj, data,width)
end

-- 设置可以点击显示物品tips 或 点击显示打造预览
-- 需要带有Button组件  单击按钮显示tips
--[[
obj 被点击的对象
flexibleId 灵活id 6位数为打造id 8位数为物品原型id
color 打造id才需要,装备显示tips的品质,为空默认最大品质
]]
function gf_set_click_prop_tips(obj,flexibleId,color,star)
    obj.name = "itemSysPropClick_"..flexibleId.."_"..(color or "").."_"..(star or "")
end

-- 设置可以按住显示物品tips   (传点击的对象，和原型id，用于显示道具，不可用于带有随机属性的装备)
-- 需要带有Button和EventTrigger    按下显示tips  弹起取消显示tips
function gf_set_press_prop_tips(obj,protoId)
    obj.name = "itemSysPropPress_"..protoId
end

--[[
1:color 2:size 4:quad 8:a 16:b 32:i
]]
--去除富文本标签
function gf_remove_rich_text(content,b)
    -- print(content)
    local c = content or ""
    b = b or bit._not(0)
    if bit._and(b,1)==1 then
        for s in string.gmatch(c,"</?color.->") do
            c=string.gsub(c, s, "")
        end
    end
    if bit._and(b,2)==2 then
        for s in string.gmatch(c,"</?size.->") do
            c=string.gsub(c, s, "")
        end
    end
    if bit._and(b,4)==4 then
        for s in string.gmatch(c,"<quad.-/>") do
            c=string.gsub(c, s, "　　")
        end
    end
    local k = "</?["
    if bit._and(b,16)==16 then
        k = k.."b"
    end
    if bit._and(b,32)==32 then
        k = k.."i"
    end
    if k~="</?[" then
        k = k.."].->"
        for s in string.gmatch(c,k) do
            c=string.gsub(c, s, "")
        end
    end
    if bit._and(b,8)==8 then
        for s in string.gmatch(c,"<a href=.->.-</a>") do
            local sr,ed,str = string.find(s,"^<a href=.->(.-)</a>")
            c=string.gsub(c, "<a href=.->.-</a>", str,1)
        end
    end
    return c
end

function gf_win_icon(img,play_career)
    if play_career == ServerEnum.CAREER.MAGIC then
        gf_setImageTexture(img,"battle_end_character_02")
    elseif play_career == ServerEnum.CAREER.BOWMAN then
        gf_setImageTexture(img,"battle_end_character_03")
    elseif play_career == ServerEnum.CAREER.SOLDER then
        gf_setImageTexture(img,"battle_end_character_01")
    end
end

function gf_reload_file( file_path )
    print("gf_reload_file",file_path,package.loaded[file_path])
    package.loaded[file_path] = nil
    return require(file_path)
end

--更新主界面圆圈特效
function gf_update_mainui_effect(node_type)
    local show = false
    local type
    if node_type == ClientEnum.Copy_Box_Effect then
        local flag = gf_getItemObject("copy"):is_have_box_server()
        print("flag:",flag)
        if flag ~= nil then
            show = flag
        else
            show = gf_getItemObject("copy"):is_have_box()
        end
    elseif node_type == ClientEnum.War_Pvp_Effect then
        --战场pvp  pvp_3v3_open_time 时间开启
        local zero_time = gf_get_server_zero_time()
        local sever_time = Net:get_server_time_s()
        show = sever_time >= zero_time + pvp_3v3_open_time and sever_time <= zero_time + pvp_3v3_open_time + pvp_3v3_duration_time

    end
    gf_receive_client_prot({type=node_type,visible=show}, ClientProto.MainUICopyEffect)
end


--获取主界面组件是否显示
function gf_get_mainui_show_state(type)
    local map_id = gf_getItemObject("battle"):get_map_id()
    local data = ConfigMgr:get_config("mapinfo")[map_id]
    if not data then
        return false
    end
    
    if type == ServerEnum.MAINUI_UI_MODLE.MAP then
        return data.small_map_off == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.BUTTON then
       return data.is_show_button == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.BOTTLE then
        return data.is_show_bottle == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.EP then
        return data.is_show_ep == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.TASK then
        return data.is_show_task == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.LEAVEBUTTON then
        return data.show_leave == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.SWITCHBUTTON then
        return data.show_swtch_button == 1
    elseif type == ServerEnum.MAINUI_UI_MODLE.HEAD then
        return not gf_getItemObject("copy"):is_pvp()
    elseif type == ServerEnum.MAINUI_UI_MODLE.FUNCOPEN then
        return not gf_getItemObject("copy"):is_pvp()
    elseif type == ServerEnum.MAINUI_UI_MODLE.AUTOATTACK then
        return not gf_getItemObject("copy"):is_pvptvt()
    end
    return false
end

-- 功能跳转
function gf_open_model(module_type , ...)
    local lv = LuaItemManager:get_item_obejct("game"):getLevel()
    local a,b,c,d = ...
    print("功能跳转到",module_type,a,b,c or 0,d)
    if module_type == ClientEnum.MODULE_TYPE.KRYPTON_GOLD then -- 氪金 充钱 充值
        -- if false then
        --     gf_message_tips("功能暂未开启")
        -- gf_message_tips("<color=red>模拟充值</color>")
        -- Net:send({gold=88},"shop","FakeCharge") --模拟充值
        --     return
        -- end
        LuaItemManager:get_item_obejct("mall"):open_model(4)
    elseif module_type == ClientEnum.MODULE_TYPE.PVP then -- 风云竞技场
        if LuaItemManager:get_item_obejct("activeDaily"):get_daily_lv(ClientEnum.DAILY_ACTIVE.PVP) > lv then 
            gf_message_tips("1v1竞技未开启")
            return 
        end
        gf_create_model_view("pvp",...)
    elseif module_type == ClientEnum.MODULE_TYPE.ACTIVE_DAILY then -- 日常活动
        gf_create_model_view("activeDaily",...)
    elseif module_type == ClientEnum.MODULE_TYPE.SMELTING then -- 熔炼
        View("equipSmelting",LuaItemManager:get_item_obejct("itemSys"))
    elseif module_type == ClientEnum.MODULE_TYPE.MONEY_TREE then -- 摇钱树
        gf_create_model_view("moneyTree",...)
    elseif module_type == ClientEnum.MODULE_TYPE.MALL then -- 商城
        LuaItemManager:get_item_obejct("mall"):open_model(...)
    elseif module_type == ClientEnum.MODULE_TYPE.TEAM then -- 队伍
        require("models.team.teamEnter")()
    elseif module_type == ClientEnum.MODULE_TYPE.LEGION then -- 军团
        if ConfigMgr:get_config("t_misc").alliance.buildLevel > lv then 
            gf_message_tips("军团未开启")
            return
        end
        if not LuaItemManager:get_item_obejct("legion"):is_in() then
            LuaItemManager:get_item_obejct("legion"):open_view() 
        else
            LuaItemManager:get_item_obejct("legion"):create_view(...)
        end
    elseif module_type == ClientEnum.MODULE_TYPE.PLAYER_INFO then -- 玩家信息
        LuaItemManager:get_item_obejct("player"):select_player_page(...)
        gf_create_model_view("player",...)
    elseif module_type == ClientEnum.MODULE_TYPE.EQUIP then -- 装备强化
        LuaItemManager:get_item_obejct("equip"):set_open_mode(...)
        gf_create_model_view("equip")
    elseif module_type == ClientEnum.MODULE_TYPE.HORSE then -- 坐骑
        gf_create_model_view("horse",...)
    elseif module_type == ClientEnum.MODULE_TYPE.HERO then -- 武将
        print("打开武将",...)
        gf_create_model_view("hero",...)
    elseif module_type == ClientEnum.MODULE_TYPE.PUBLIC_CHAT then -- 公共聊天
        LuaItemManager:get_item_obejct("chat"):open_public_chat_ui(...)
    elseif module_type == ClientEnum.MODULE_TYPE.PRIVATE_CHAT then -- 私聊
        LuaItemManager:get_item_obejct("chat"):open_private_chat_ui(...)
    elseif module_type == ClientEnum.MODULE_TYPE.SURFACE then -- 时装
        local Surface = LuaItemManager:get_item_obejct("surface")
        Surface:open_view(a)
    elseif module_type == ClientEnum.MODULE_TYPE.MARKET then -- 市场
        gf_create_model_view("market",...)
    elseif module_type == ClientEnum.MODULE_TYPE.VIP then -- VIP
        gf_create_model_view("vipPrivileged",...)
    end
    return true
end


function gf_set_model(model_id,model_node,scale,angle,posy)
    local modelPanel = model_node.transform:FindChild("camera")
    if model_node.transform:FindChild("my_model") then
        LuaHelper.Destroy(model_node.transform:FindChild("my_model").gameObject)
    end
        
    local callback = function(c_model)
        if model_node.transform:FindChild("my_model") then
            LuaHelper.Destroy(model_node.transform:FindChild("my_model").gameObject)
        end
         c_model.name = "my_model"
    end

    scale = scale or 1
    angle = angle or 158
    posy  = posy  or -1.2
    local modelView = require("common.uiModel")(model_node.gameObject,Vector3(0,posy,4),false,career,{model_name = model_id..".u3d",default_angles= Vector3(0,angle,0),scale_rate = Vector3(scale,scale,scale)},callback)
    return modelView
end

function gf_set_eff_new_texture(eff_tf)
    local camera = eff_tf:GetComponentInChildren("UnityEngine.Camera")
    local img = eff_tf:GetComponentInChildren("UnityEngine.UI.RawImage")
    local tf = img.transform
    local texture = UnityEngine.RenderTexture(tf.sizeDelta.x,tf.sizeDelta.y,img.depth)
    img.texture = texture
    camera.targetTexture = texture
end