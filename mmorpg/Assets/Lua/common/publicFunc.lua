--[[--
* 通用全局方法类
* 
* @Author:      Seven
* @DateTime:    2017-03-09 21:20:16
]]
local Enum = require("enum.enum")
require("common.time")
require("common.uiPublicFun")

-- 获取table表的长度
function gf_table_length( t )
	local lenth = 0
	for k,v in pairs(t or {}) do
		lenth = lenth + 1
	end
	return lenth
end

function gf_print_table( t, name )
    if CUtils.isRelease == true then
        return
    end
	print("table打印开始>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
	if name and type(name) == "string" then
		print(name)
	end
	print_table(t)
	print("table打印结束----------------------------------------------")
end
function gf_get_table(tb)
    local temp = {}
    for k,v in pairs(tb) do
        table.insert(temp,v)
    end
    return temp
end
--[[
把字符串转为字符串列表
返回的参数：list(字符列表)，weith（像素），lenth（字符串长度）
]]
function gf_string_to_chars( str, fontSize )
    fontSize = fontSize or 12
    
	local list = {}
    local len = string.len(str)
    local i = 1
    local width = 0 -- 总长度
    local lenth = 0
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        print(char,shift)
        i = i + shift
        if shift == 1 then
            width = width + fontSize*0.5
            lenth = lenth + 1
        else
            width = width + fontSize
            lenth = lenth + 2
        end

        table.insert(list, char)
    end
    local _,n = string.gsub(str, "</color>", "</color>")
    if n > 0 then
        width = width - n*23*fontSize*0.5
    end

    return list, width, lenth
end

--获取字符串长度（全角算2，半角算1）
function gf_get_string_length(str)
    local count = 0  
    for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do   
      if #uchar ~= 1 then  
        count = count +2  
      else  
        count = count +1  
      end  
    end
    return count
end

-- 世界坐标转成格子坐标,格子大小13x7
function gf_convert_world_2_grid( x, y )
    local gx = math.floor(x/20)
    local gy = math.floor(y/13)
    return {x = gx, y = gy}
end

function gf_getItemObject(name)
    return LuaItemManager:get_item_obejct(name)
end

--获取货币
function gf_format_count(value)
    if value>999999999 then value=math.floor(value*0.00000001).."亿"
    elseif value>99999 then value=math.floor(value*0.0001).."万" end
    return value
end

function gf_format_hp(value)
    if 9999 < value then
        return string.format("%.2f万",value / 10000)
    else
        return tostring(value)
    end
end

function gf_format_count_kmg(value)
    if 9999 < value then
        return string.format("%.1fW",value / 10000)
    elseif 999 < value then
        return string.format("%.1fK",value / 1000)
    else
        return tostring(value)
    end
end
--创建一个model绑定的view
function gf_create_model_view(model_name,...)
    local item = LuaItemManager:get_item_obejct(model_name)
    if item.set_param then
        item:set_param(...)
    end

    if item.set_view_param then
        item:set_view_param(...)
    end

    if item then
        item:add_to_state()
    end
    return item
end

--接受客户端协议
--gf_receive_client_prot(msg,ClientProto.EnterCopyClient)
function gf_receive_client_prot(msg,prot_id)
    Net:receive(msg,prot_id)
end

-- 获取通用特效资源
function gf_get_normal_res( value )
    return ConfigMgr:get_config("normal_res")[value].model_id..".u3d"
end

function gf_get_config_table(name)
    return ConfigMgr:get_config(name)
end

function gf_get_config_const(name)
   return ConfigMgr:get_const(name)
end

--[[
获取一个特效
model_id:模型id
cb      :资源加载完成回调
]]
function gf_get_effect( model_id, cb )
    return LuaItemManager:get_item_obejct("battle"):get_effect(model_id, cb)
end

-- 删除一个特效
function gf_remove_effect( effect )
    LuaItemManager:get_item_obejct("battle"):remove_effect(effect)
end

-- 播放一个通用特效资源
function gf_play_effect( model_id,pos )
    local finish_cb = function( effect )
        gf_remove_effect(effect)
    end
    local effect_cb = function( effect )
        effect:show_effect(pos)
        effect:set_finish_cb(finish_cb)
    end
    gf_get_effect(model_id, effect_cb)
end


--模拟测试接受服务器协议
function gf_send_and_receive(msg,id1,id2,sid)
    local _id1 = Net:get_id1(id1)
    local _id2 = Net:get_id2(id1, id2)
    Net:receive(msg,_id1,_id2,sid)
end

--深拷贝
function gf_deep_copy(object)      
    local SearchTable = {}  

    local function Func(object)  
        if type(object) ~= "table" then  
            return object         
        end  
        local NewTable = {}  
        SearchTable[object] = NewTable  
        for k, v in pairs(object) do  
            NewTable[Func(k)] = Func(v)  
        end     

        return setmetatable(NewTable, getmetatable(object))      
    end    

    return Func(object)  
end 

--ui重排
local UIParent = LuaHelper.Find("UI")
function gf_resort_layer()
    --场景切换中不重排
    local is_load = gf_getItemObject("battle").pool:is_loaded()
    if not is_load then
        return
    end
    --重排
    local sindex = 1
    for i=1,UIParent.transform.childCount do
        local go = UIParent.transform:GetChild(i - 1)
        if go.gameObject.activeSelf then
            local canvas = go:GetComponentInParent("UnityEngine.Canvas")--LuaHelper.GetComponentInChildren(go,"UnityEngine.Canvas")
            if canvas and (canvas.sortingOrder >= 0 and canvas.sortingOrder < 99) then
                canvas.sortingOrder = sindex
                gf_set_to_top_layer(go)
                sindex = sindex + 2
            end
        end
    end
    
end

--设置比父亲层级高
--p_node 父layer
--node  要设置的gameObject
function gf_set_to_top_layer(p_node)
    local node = LuaHelper.FindChild(p_node,"bringToTop")
    if node then
        local layer = p_node:GetComponentInParent("UnityEngine.Canvas")
        print("wtf resort layer sortingOrder:",layer.sortingOrder)
        node:GetComponentInParent("UnityEngine.Canvas").sortingOrder = layer.sortingOrder + 3
    end
end

function gf_get_node_show_children_count(node)
    local count = 0
    for i=0,node.childCount-1 do
        local child_node = node:GetChild(i)
        if child_node.gameObject.activeSelf then
            count = count + 1
        end
    end
    return count
end

function gf_getNRandom(startNum, endNum, number, exceptTable) -- 一个产生不重复随机数的方法
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    local cha = endNum - startNum + 1
    if cha< number then
        print("产生的个数已经超过了，检查你的随机数范围和个数是否合理")
        return
    end
    local numberTabel = {}
    local num = 0
    local isExist = false -- 用这个判断是否已经存在这个数了
    local i = 0
    while (i < number) do 
        isExist = false
        local randomNum = math.random(startNum, endNum)
        print("产生的随机数为：", randomNum)
        local function isExisting() -- 检测数组里面是否已经存在了这个随机数了，有就返回true
            if #numberTabel ~= 0 then
                for k, v in pairs(numberTabel) do 
                    if randomNum == v then
                        print("发现产生了一个相同的随机数，所以不能再加到那里面去了")
                        return true
                    end
                end
            end
            if #exceptTable ~= 0 then
                for k, v in pairs(exceptTable) do
                    if randomNum == v then
                        print("发现产生了一个已经点过的随机数，要除开，不能要")
                        return true
                    end
                end
            end 
        end
        isExist = isExisting()
        if isExist then  -- 如果已经存在了这个数，那么久返回，并且要把i-1
            -- i = i - 1
        else
            table.insert(numberTabel, randomNum)
            i = i + 1
        end


    end
    return numberTabel

end

-- 获取某项属性
function gf_get_module_attr(module_attr,...)
    local a,b,c = ...
    if module_attr==ClientEnum.MODULE_ATTR.SKILL_LEVEL then
        -- print("获取技能等级",...)
        local data = LuaItemManager:get_item_obejct("skill"):get_data_by_index(...)
        return data and data.level or 0
    elseif module_attr==ClientEnum.MODULE_ATTR.ROLE_LEVEL then
        -- print("获取人物等级",...)
        return LuaItemManager:get_item_obejct("game"):getLevel() or 0

    elseif module_attr==ClientEnum.MODULE_ATTR.SURFACE_UNLOCK then
        local Surface = LuaItemManager:get_item_obejct("surface")
        return Surface:is_unlock( a ) and 1 or 0


    elseif module_attr==ClientEnum.MODULE_ATTR.EQUIP_ENHANCE_LEVEL then
        -- print("装备强化等级",...)
        if not a then
            gf_error_tips("获取装备强化等级没有配置装备类型")
            return 0
        end
        local id = LuaItemManager:get_item_obejct("equip"):get_enhance_id(a)
        -- print("强化id",id,module_attr,...)
        local enhance_info = ConfigMgr:get_config("equip_enhance")[id]
        return enhance_info and enhance_info.level or 0


    elseif module_attr==ClientEnum.MODULE_ATTR.PRACTICE_LEVEL then
        -- print("获取军团修炼等级",...)
        local train = LuaItemManager:get_item_obejct("train")
        local data = train:get_train_data_by_type(...)
        return data and data.level or 0
    elseif module_attr==ClientEnum.MODULE_ATTR.BODY_EQUIP_LEVEL then
        local bag = LuaItemManager:get_item_obejct("bag")
        local slot = 10000*ServerEnum.BAG_TYPE.EQUIP+a
        return bag.items[slot] and ConfigMgr:get_config("item")[bag.items[slot].protoId].item_level or 0


    elseif module_attr==ClientEnum.MODULE_ATTR.CURR_HERO_LEVEL then
        -- print("当前出战武将等级",...)
        if not gf_getItemObject("guide"):is_func_open(ClientEnum.FUNC_BIG_STEP.HERO) then
            return -1
        end
        local hero_info = LuaItemManager:get_item_obejct("hero"):get_fight_hero_info()
        local lv =  hero_info and hero_info.level or 0
        return lv


    elseif module_attr==ClientEnum.MODULE_ATTR.MODEL_UNLOCK then
        -- print("功能是否解锁",...)
        return (LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(a)  or {})[b]
    

    elseif module_attr==ClientEnum.MODULE_ATTR.HORSE_LEVEL then
        -- print("获取坐骑进阶等阶",...)
        if not gf_getItemObject("guide"):is_func_open(ClientEnum.FUNC_BIG_STEP.MOUNT) then
            return -1
        end
        return LuaItemManager:get_item_obejct("horse"):get_level() or 0




    -- elseif module_attr==ClientEnum.MODULE_ATTR.HORSE_LEVEL_UP_EXP then
    --     -- print("坐骑进阶所需经验",...)
    --     if not gf_getItemObject("guide"):is_func_open(ClientEnum.FUNC_BIG_STEP.MOUNT) then
    --         return -1
    --     end
    --     local horse = gf_getItemObject("horse")
    --     local cur_level = horse:get_level()
    --     local dataUse = require("models.horse.dataUse")
    --     local max_exp = dataUse.get_exp_by_level(cur_level)
    --     local cur_exp = horse:get_exp()
    --     return max_exp - cur_exp


    -- elseif module_attr==ClientEnum.MODULE_ATTR.PRACTICE_LEVEL_UP_COIN then
    --     -- print("军团修炼升级所需铜钱",...)
    --     if not gf_getItemObject("legion"):is_in() then
    --         return -1
    --     end
    --     local dataUse = require("models.train.dataUse")
    --     local train_info = dataUse.get_train_data_by_level(type,level)
    --     train_info.cost_coin
    -- elseif module_attr==ClientEnum.MODULE_ATTR.PRACTICE_LEVEL_UP_DONATE then
    --     -- print("军团修炼升级所需贡献",...)
    --     if not gf_getItemObject("legion"):is_in() then
    --         return -1
    --     end
    --     local dataUse = require("models.train.dataUse")
    --     local train_info = dataUse.get_train_data_by_level(type,level)
    --     train_info.cost_donate


    -- elseif module_attr==ClientEnum.MODULE_ATTR.CURR_HERO_LEVEL_UP_EXP then
    --     -- print("当前出战武将升级所需经验",...)
    --     if not gf_getItemObject("guide"):is_func_open(ClientEnum.FUNC_BIG_STEP.HERO) then
    --         return -1
    --     end
    --     local cur_level = gf_getItemObject("horse"):get_level()
    --     local dataUse = require("models.horse.dataUse")
    --     local max_exp = dataUse.get_exp_by_level(cur_level)

    -- elseif module_attr==ClientEnum.MODULE_ATTR.CURR_HERO_AWAKEN then
    --     -- print("获取当前出战武将觉醒",...)
    --     if not gf_getItemObject("guide"):is_func_open(ClientEnum.FUNC_BIG_STEP.HERO) then
    --         return -1
    --     end
    --     local hero_info = LuaItemManager:get_item_obejct("hero"):get_fight_hero_info()
    --     return hero_info and hero_info.awakenLevel or 0
    -- elseif module_attr==ClientEnum.MODULE_ATTR.CURR_HERO_CHIP then
    --     -- print("获取当前出战的武将碎片数量（包括已经消耗用于觉醒的）",...)
    --     if not gf_getItemObject("guide"):is_func_open(ClientEnum.FUNC_BIG_STEP.HERO) then
    --         return -1
    --     end
    --     local hero_info = LuaItemManager:get_item_obejct("hero"):get_fight_hero_info()
    --     return hero_info and hero_info.chip or 0

    end

    return 0
end

-- 获取跟随位置
-- pos 跟随者位置
function gf_get_follow_pos( pos )
    local offset = 5
    local list = {
        Vector3(pos.x, pos.y, pos.z-offset),
        Vector3(pos.x, pos.y, pos.z+offset),
        Vector3(pos.x-offset, pos.y, pos.z-offset),
        Vector3(pos.x-offset, pos.y, pos.z+offset),
        Vector3(pos.x-offset, pos.y, pos.z),
        Vector3(pos.x+offset, pos.y, pos.z-offset),
        Vector3(pos.x+offset, pos.y, pos.z+offset),
        Vector3(pos.x+offset, pos.y, pos.z),
    }

    local tpos
    for i,v in ipairs(list) do
        if not Seven.PublicFun.CheckTwoPosHitWall(pos, v) then
            tpos = v
            break
        end
    end
    print("跟随坐标", tpos)
    return Seven.PublicFun.GetNavMeshPos(tpos.x, tpos.z, 0)
end

function gf_on_collect()
    local collect = LuaItemManager:get_item_obejct("mainui").collect
    --是否正在读条,是否可以打断
    return collect,collect.is_can_cancel
end