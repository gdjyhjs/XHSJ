--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-23 09:47:45
--]]

local StateManager = StateManager
local delay = delay
local LuaHelper=LuaHelper
local CUtils = CUtils
local get_value = get_value --多国语言
local Vector3 = UnityEngine.Vector3
local CSNameSpace = CSNameSpace
local Enum = require "enum.enum"

local Mainui = LuaItemManager:get_item_obejct("mainui")
Mainui.priority = ClientEnum.PRIORITY.MAIN_UI

--UI资源
Mainui.assets=
{
    View("mainuiView", Mainui),
}

-- local mainui_btn_name={
--     [ClientEnum.MAIN_UI_BTN.SIGN] = "signBtn",
--     [ClientEnum.MAIN_UI_BTN.BAG] = "bagBtn",
--     [ClientEnum.MAIN_UI_BTN.DAILY] = "dailyBtn",
--     [ClientEnum.MAIN_UI_BTN.WELFARE] = "welfareBtn",
--     [ClientEnum.MAIN_UI_BTN.BOSS] = "bossBtn",
--     [ClientEnum.MAIN_UI_BTN.FESTIVAL] = "festivalActivityBtn",
--     [ClientEnum.MAIN_UI_BTN.ACTIVITY] = "dailyActivityBtn",
--     [ClientEnum.MAIN_UI_BTN.ESCOR] = "doubleEscortBtn",
--     [ClientEnum.MAIN_UI_BTN.MARK] = "marketBtn",
--     [ClientEnum.MAIN_UI_BTN.RANK] = "rankBtn",
--     [ClientEnum.MAIN_UI_BTN.MAIL] = "mailBtn",
--     [ClientEnum.MAIN_UI_BTN.MAKE] = "makeBtn",
--     [ClientEnum.MAIN_UI_BTN.PARTNER] = "partnerBtn",
--     [ClientEnum.MAIN_UI_BTN.MOUNT] = "mountBtn",
--     [ClientEnum.MAIN_UI_BTN.COURTYARD] = "courtyardBtn",
--     [ClientEnum.MAIN_UI_BTN.FAMILY] = "familyBtn",
--     [ClientEnum.MAIN_UI_BTN.SWITCH] = "switchBtn",

-- }

-- function Mainui:get_mianui_btn_name(mainui_btn_id)
--     return mainui_btn_name[mainui_btn_id] or "bagBtn"
-- end

function Mainui:get_ui(ui)
    if ui then
        self.ui=ui
    end
    return self.ui or self.assets[1]
end

--点击事件
function Mainui:on_click(obj,arg)
    -- gf_message_tips("主界面单击"..obj.name)
	self:call_event("mainui_view_on_click", false, obj, arg)
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
    if string.find(cmd , "itemSysPropClick_" ) then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local sp = string.split(cmd,"_")
        local flexibleId = tonumber(sp[2])
        local itemSys = LuaItemManager:get_item_obejct("itemSys")
        local id = itemSys:get_formulaId_for_id(flexibleId) -- 先判断是不是装备虚拟id 获取到真实的物品id或者打造id
        local data = ConfigMgr:get_config("item")[id]
        if data then -- 物品 是物品
            itemSys:prop_tips(id,nil,obj.transform.position)
        else -- 装备预览 -- 物品表没有，就是打造id
            LuaItemManager:get_item_obejct("equip"):formula_tips(id,sp[3]~="" and sp[3] or nil,sp[4]~="" and sp[4] or nil,obj.transform.position)
        end
    end
    return true
end

function Mainui:on_press_down(obj,eventData)
    -- gf_message_tips("主界面按下"..obj.name)
    print("主界面按下",obj,eventData)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if string.find(cmd,"recordBtn_")then
        if true then
            print("语音功能未开启")
            return true
        end
        LuaItemManager:get_item_obejct("chat"):start_recording(tonumber(string.split(cmd,"_")[2]),eventData.position)
    elseif string.find(cmd , "itemSysPropPress_" ) then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        LuaItemManager:get_item_obejct("itemSys"):prop_tips(tonumber(string.split(cmd,"_")[2]))    elseif string.find(cmd , "itemSysPropPress_" ) then
    elseif cmd== "potionBtn" then
        self.down_time = Schedule(handler(self, function()
            require("models.mainui.speedyPotion")(Mainui)
            self.down_time:stop()
            self.down_time=nil
            end), 0.5)
    -- elseif cmd == "taskItem" then
    --     print("主界面按下a",obj)
    --     self.t_obj = LuaHelper.FindChild(obj,"click")
    --     self.t_obj:SetActive(true)
    end
    return true
end

function Mainui:on_drag(obj,position)
    -- gf_message_tips("主界面按住拖拽"..obj.name)
    print("主界面按住",obj,position)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if string.find(cmd,"recordBtn_")then
        if true then
            print("语音功能未开启")
            return true
        end
        LuaItemManager:get_item_obejct("chat"):on_recording(tonumber(string.split(cmd,"_")[2]),position)
    elseif LuaItemManager:get_item_obejct("itemSys").item_tips_ui then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        LuaItemManager:get_item_obejct("itemSys").item_tips_ui:hide()
    end
    return true
end

function Mainui:on_press_up(obj,eventData)
    -- gf_message_tips("主界面弹起"..obj.name)
    print("主界面弹起",obj,eventData)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if string.find(cmd,"recordBtn_")then
        if true then
            print("语音功能未开启")
            return true
        end
        LuaItemManager:get_item_obejct("chat"):stop_recording(tonumber(string.split(cmd,"_")[2]),eventData.position)
    elseif string.find(cmd , "itemSysPropPress_" ) then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        if LuaItemManager:get_item_obejct("itemSys").item_tips_ui then
            LuaItemManager:get_item_obejct("itemSys").item_tips_ui:dispose()
        end
    elseif cmd== "potionBtn" then
        if self.down_time then
            self.down_time:stop()
            self.down_time=nil
            self.assets[1].child_ui.atk_panel:click_potion_btn()
        end
    -- elseif cmd == "taskItem" then
    --     if self.t_obj then
    --         self.t_obj:SetActive(false)
    --         self.t_obj = nil
    --     end
    end
    return true
end

--初始化函数只会调用一次
function Mainui:initialize()
	self.show_atk_panel = true -- 是否显示战斗面板
    self.is_shrink = true   --右上角按钮
    self.shrink_copy = false --右上角按钮的
    self:init_blood_tb()
end

function Mainui:init_blood_tb()
    self.blood_tb ={}
    local data = ConfigMgr:get_config("item")
    for k,v in pairs(data) do
        if v.type ==ServerEnum.ITEM_TYPE.PROP and v.sub_type ==ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM and v.bind ==0 then
            local x = #self.blood_tb+1
            self.blood_tb[x] = copy(v)
        end
    end
    local sortFunc = function(a, b)
        return a.code < b.code
    end
    table.sort(self.blood_tb,sortFunc)
end
    

function Mainui:get_cur_blood_tb()
    for k,v in pairs(self.blood_tb) do
         v.count = LuaItemManager:get_item_obejct("bag"):get_item_count(v.code,ServerEnum.BAG_TYPE.NORMAL)
    end
    return self.blood_tb
end
--设置血条
function Mainui:set_hp_line(ratio)
    if self:get_ui() and self:get_ui().img_role_hp then
        self:get_ui().img_role_hp.fillAmount=ratio
    end
end

--显示录音中
function Mainui:show_recording()
    self.guaji_obj = self.guaji_obj or LuaHelper.FindChild(self.assets[1].root,"guaJi")
    if self.guaji_obj then self.guaji_obj:SetActive(true) end
end

--隐藏录音中
function Mainui:hide_recording()
    self.guaji_obj = self.guaji_obj or LuaHelper.FindChild(self.assets[1].root,"guaJi")
    if self.guaji_obj then self.guaji_obj:SetActive(false) end
end

--点击主界面按钮  mainui_btn_id参考 ClientEnum.MAIN_UI_BTN
function Mainui:click_mainui_btn(mainui_btn_id)
    if not self:get_ui() then return end
    self:get_ui():click_mainui_btn(mainui_btn_id)
end

--按钮激活 传布尔值 显示=true 隐藏=false
function Mainui:btn_active(btn_id,b)
    if true then
        print("<color=red>为了防止ui没加载好调用ui报错，此方法关闭，邮，队 这些按钮的显隐请走红点协议</color>")
    end
    if not self:get_ui() then return end
    self:get_ui():btn_active(btn_id,b)
end

function Mainui:on_receive( msg, id1, id2 )
    if id1 == ClientProto.FinishScene then
        print("播放背景音乐")
        Sound:set_bg_music(ConfigMgr:get_config("mapinfo")[LuaItemManager:get_item_obejct("game"):get_map_id()].bg_music)
        Sound:clear_source()
        Sound:clear_clip()
    elseif id1 == ClientProto.PlayerLoaderFinish then --玩家加载完成
        Sound:set_listener_obj(msg.transform)
    end
end

function Mainui:collect_view()

    local Battle = LuaItemManager:get_item_obejct("battle")
    if Battle:get_character() then
        --判断是否正在寻路
        if Battle:get_character():is_move() then
            Battle:get_character():stop_move()
            LuaItemManager:get_item_obejct("map"):auto_move_end()
        end
        --判断自动挂机
        print("在自动挂机吗",Battle:get_character() and Battle:get_character().is_auto_attack)
        if Battle:get_character() and Battle:get_character().is_auto_attack then
            Net:receive(false, ClientProto.AutoAtk)
        end
    end

    if not self.collect then
        self.collect = View("collectView", self) --切图读条
    elseif not self.collect.is_can_cancel then -- 不可中断
        gf_message_tips("角色正在忙碌中")
        return
    else
        self.collect:reset()
    end
    self.collect:init_ui()
    return self.collect
end