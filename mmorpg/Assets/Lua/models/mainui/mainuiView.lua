--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-23 09:49:09
--]]
local StateManager = StateManager
local delay = delay
local LuaHelper=LuaHelper
local CUtils = CUtils
local get_value = get_value --多国语言
local Vector3 = UnityEngine.Vector3
local Screen = UnityEngine.Screen
local parent = UnityEngine.parent
local length = UnityEngine.Length
local Time = UnityEngine.Time
local CSNameSpace = CSNameSpace
local PlayerPrefs = UnityEngine.PlayerPrefs
local AttackPanel = require("models.mainui.attackPanel")
local Chat = require("models.mainui.chat")
local Option = require("models.mainui.option")
-- local Teamtask = require("models.mainui.teamtask")
local FunctionUnlock = require("models.mainui.functionUnlock")
local BuffView = require("models.mainui.buffView")
local dianchiLv={0.05,20,40,60,80}
local PlayerEnum = require("models.player.playerEnum")


local MainuiView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "zhujiemian.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.game_obj = LuaItemManager:get_item_obejct("game")
end)
MainuiView.level = UIMgr.LEVEL_STATIC

MainuiView.child_ui={}

-- 资源加载完成
function MainuiView:on_asset_load(key,asset)
    self.red_point = {}
    self.is_init = true

    --每秒计时器
    self.timer_the_second=1
    self.open_auto_tips = true
    self:init_data()

    self:init_ui()
    self:init_ui_child()
    self:init_red_point()
    self:init_show_btn()
    self:update_ui()
    
    self:update_effect_node()
    self:init_award_btn()

    LuaItemManager:get_item_obejct("strengthen") -- 加载变强
    self.last_click_time = Net:get_server_time_s()
end


function MainuiView:init_data()
    --主界面显示组件枚举
    self.controler = 
    { 
        -- [ServerEnum.MAINUI_UI_MODLE.BUTTON]         = self.refer:Get(30):Get(10),                        --按钮组切换按钮
        [ServerEnum.MAINUI_UI_MODLE.BOTTLE]         = self.refer:Get(31),                                --血瓶
        [ServerEnum.MAINUI_UI_MODLE.EP]             = self.refer:Get(32),                                --ep
        [ServerEnum.MAINUI_UI_MODLE.HEAD]           = self.refer:Get(34),                                --左上角头像
        [ServerEnum.MAINUI_UI_MODLE.FUNCOPEN]       = self.refer:Get("fun_unlock"),                      --功能开启预告
        [ServerEnum.MAINUI_UI_MODLE.AUTOATTACK]     = self.refer:Get("zhujiemian_ui"):Get("autoBtn"),    --自动挂机按钮
        [ServerEnum.MAINUI_UI_MODLE.LEAVEBUTTON]    = self.refer:Get("zhujiemian_ui"):Get("leaveBtn"),   --离开按钮
        -- [ServerEnum.MAINUI_UI_MODLE.SWITCHBUTTON]   = self.refer:Get("righttopBtn"),                     --切换按钮
    }
    self.hero_blood_line = self.refer:Get(36)
end
 

--更新特效红点
function MainuiView:update_effect_node()
    --更新副本特效
    Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.COPY ,visible =  gf_getItemObject("copy"):is_have_box_server()}, ClientProto.ShowAwardEffect)
end

--初始化奖励特效
function MainuiView:init_award_btn()
    self:show_award_effect(ClientEnum.MAIN_UI_BTN.ACTIVITY,gf_getItemObject("activeDaily"):is_have_award())
   self:show_award_effect(ClientEnum.MAIN_UI_BTN.SIGN,gf_getItemObject("sign"):is_have_award())
   self:show_award_effect(ClientEnum.MAIN_UI_BTN.LOGIN,gf_getItemObject("sign"):is_have_15award())
   self:show_award_effect(ClientEnum.MAIN_UI_BTN.FIRSTTIME,LuaItemManager:get_item_obejct("vipPrivileged"):is_have_red_point())
   self:show_award_effect(ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER,LuaItemManager:get_item_obejct("activeEx"):is_show_red_point())
   self:show_award_effect(ClientEnum.MAIN_UI_BTN.ASTROLABE ,LuaItemManager:get_item_obejct("astrolabe"):has_red())
   local role_id = LuaItemManager:get_item_obejct("game").role_id
   if PlayerPrefs.HasKey("fun_unlock"..role_id) then
        local tb=LuaItemManager:get_item_obejct("functionUnlock"):get_fun_effect()
        for k,v in pairs(tb or {}) do
            Net:receive({ btn_id = v ,visible = true}, ClientProto.ShowAwardEffect)
        end
    end
end

--注册
function MainuiView:register()
	self.item_obj:register_event("mainui_view_on_click", handler(self, self.on_click))
    gf_register_update(self)--Update事件
end

--ui初始化
function MainuiView:init_ui()

    local rightbottom = self.refer:Get("rightbottom")
    --获取攻击面板
    -- self.atkPanel=rightbottom:Get("atkPanel")
     self.atkPanel=self.refer:Get(38):Get("atkPanel")
    --获取buff面板
    self.buff = self.refer:Get("buff")
    --获取标准面板
    -- self.normalPanel=LuaHelper.FindChild(self.root,"normalPanel")--self.items.zhujiemian_ui.transform:FindChild("normalPanel").gameObject
    --显示攻击面板
    self:show_atk_panel(self.item_obj.show_atk_panel)

    print("获取左上边的组件")
    local zuoshang_obj=self.refer:Get("zuoshang")
    self.text_time=zuoshang_obj:Get("text_shijian")   --获取时间文本
    self.text_wangluo=zuoshang_obj:Get("text_wangluo") --获取网络文本
    self.img_xinhao=zuoshang_obj:Get("img_xinhao")   --获取信号图片
    self.tf_dianchi=zuoshang_obj:Get("img_dianchi").transform --获取电池
    self.text_area=zuoshang_obj:Get("text_area") --获取区服文本
    self.text_area_name=zuoshang_obj:Get("text_area_name") --获取区服名文本
    print("获取左上边人物头像的组件")
    local zuoshanghead_obj=self.refer:Get("zuoshanghead")
    self.img_role_hp=zuoshanghead_obj:Get("img_role_hp")   --获取血条图片
    self.txt_hp = zuoshanghead_obj:Get("txt_hp")
    local game = LuaItemManager:get_item_obejct("game")
    self:update_player_blood()
    self.text_role_lv=zuoshanghead_obj:Get("text_role_lv")   --获取等级文本
    self.text_role_zhanli=zuoshanghead_obj:Get("text_role_zhanli")  --获取战力文本
    
    self.text_role_name=zuoshanghead_obj:Get("text_role_name")  --获取人物名文本
    local set_name=function(name)
        self.text_role_name.text = name
    end
    set_name(game:getName())
    self.img_role_head=zuoshanghead_obj:Get("img_role_head")  --获取人物头像图片
    gf_set_head_ico(self.img_role_head,game:getHead())
    print("人物头像 = ",self.img_role_head,game:getHead())
    
    self.img_wujiang_hp=zuoshanghead_obj:Get("img_wujiang_hp")  --获取武将血条图片
    self.img_wujiang_head=zuoshanghead_obj:Get("img_wujiang_head")  --获取武将头像
    print("人物经验条")
    self.exp_line=self.refer:Get("img_exp")   --获取经验值图片
    local exo_schedule = game:get_exp()/ConfigMgr:get_config("player")[game:getLevel()].exp
    self.exp_line.fillAmount = exo_schedule
    
    print("获取读条组件")
    self.reading={}
    local reading_ref = self.refer:Get("reading")
    self.reading.obj=reading_ref.gameObject
    self.reading.obj:SetActive(false)
    self.reading.img=reading_ref:Get("img_reading")
    self.reading.text=reading_ref:Get("text_reading")

    self.canvas_group=self.refer:Get("zhujiemian")

    self.auto_path_eff = self.refer:Get("41000020")-- 自动寻路特效
    self.auto_atk_eff = self.refer:Get("41000021") --自动挂机特效

    self.right_top =self.refer:Get("righttop")
    self.sit_btn = self.refer:Get("btn_remind"):Get("sitBtn")

    print("主城ui初始化完毕")
    self:add_model("itemSys")

    self:init_other_player_head()
    --功能预告
    self.img_function_unlock = rightbottom:Get("fun_unlock")
    self.item_obj:get_ui(self)

    self:show_hero_view()

    --VIP等级
    self.refer:Get("vipText").text = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
    --地图显示
    self.map_change=self.refer:Get("scene_change")
    self.map_text =self.map_change:Get(2)
    self.map_img = self.map_change:Get(1)

    --特效层
    self.effect_layer = require("models.mainui.mainuiEffect")(self)
    self:add_child(self.effect_layer)

    local active_Btn = self.refer:Get("zhujiemian_ui"):Get(ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER)      --开服活动按钮
    if LuaItemManager:get_item_obejct("activeEx"):is_show_active() == false then
        active_Btn:SetActive(false) 
    else
        active_Btn:SetActive(true)
    end

end

function MainuiView:update_ui()
    if not self.is_init then
        return
    end

    if LuaItemManager:get_item_obejct("firstWar"):is_pass() then
        self.text_role_lv.text = self.game_obj:getLevel()
    else
        self.text_role_lv.text = ConfigMgr:get_const("first_war_lv") -- 首场战斗显示60级
    end
    if LuaItemManager:get_item_obejct("firstWar"):is_pass() then
        self.text_role_zhanli.text = self.game_obj:getPower()
    else
        self.text_role_zhanli.text = self.game_obj:getPower()*100 -- 首场显示
    end
    self:update_player_blood()
    -- 刷新离开ui
    -- self:get_btn(ClientEnum.MAIN_UI_BTN.LEAVE):SetActive(LuaItemManager:get_item_obejct("battle"):is_show_leave_btn())

    self:update_battle_mode_img()

    self:get_btn(ClientEnum.MAIN_UI_BTN.TOWER):SetActive(#(LuaItemManager:get_item_obejct("copy"):get_tower_sweep_storehouse() or {})>0)

    self:show_on_type()


    -- 判断是否有开启的活动图标
    local list = LuaItemManager:get_item_obejct("activeDaily"):get_open_btn_list()
    for i,v in ipairs(list or {}) do
        self:show_daily_icon(v)
    end
end

-- 更新地图模式图标
function MainuiView:update_battle_mode_img()
    local item = LuaItemManager:get_item_obejct("battle")
    gf_setImageTexture(self.refer:Get("battle_mode_btn"), "battle_state_"..item:get_pk_mode())
end

function MainuiView:get_btn(btn_id)
    if not self.btn_list then self.btn_list = self.refer:Get("zhujiemian_ui") end
    return self.btn_list:Get(btn_id)
end

-- 初始化红点
function MainuiView:init_red_point()
    -- 人物信息
    LuaItemManager:get_item_obejct("player"):have_red_point()
    -- 外观
    LuaItemManager:get_item_obejct("surface"):is_have_red_point()
     -- 背包红点
    self:show_red_point(ClientEnum.MAIN_UI_BTN.BAG ,LuaItemManager:get_item_obejct("bag"):is_have_red_point())
      -- 打造红点
    self:show_red_point(ClientEnum.MAIN_UI_BTN.MAKE ,LuaItemManager:get_item_obejct("equip"):is_have_red_point())
    --福利红点
   self:show_red_point(ClientEnum.MAIN_UI_BTN.SIGN ,LuaItemManager:get_item_obejct("sign"):is_have_red_point())
    local email = LuaItemManager:get_item_obejct("email")
     -- 社交红点
    self:show_red_point(ClientEnum.MAIN_UI_BTN.MAIL ,email:is_have_red_point())
     -- 寻宝红点
    self:show_red_point(ClientEnum.MAIN_UI_BTN.LUCKY_DRAW ,LuaItemManager:get_item_obejct("luckyDraw"):get_red_point())
     -- 设置红点 --  公告
    self:show_red_point(ClientEnum.MAIN_UI_BTN.PARTNER ,LuaItemManager:get_item_obejct("announcement"):show_red())
    self:show_red_point(ClientEnum.MAIN_UI_BTN.ACHIEVEMENR ,LuaItemManager:get_item_obejct("achievement"):show_red_point())
    self:show_red_point(ClientEnum.MAIN_UI_BTN.COURTYARD, LuaItemManager:get_item_obejct("surface"):is_have_red_point())
    self:show_red_point(ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER,LuaItemManager:get_item_obejct("activeEx"):is_show_red_point())
    self:show_red_point(ClientEnum.MAIN_UI_BTN.ACTIVITY ,LuaItemManager:get_item_obejct("activeDaily"):is_have_red_point())
    self:show_red_point(ClientEnum.MAIN_UI_BTN.ASTROLABE ,LuaItemManager:get_item_obejct("astrolabe"):has_red())
    --军团红点
    gf_getItemObject("legion"):refresh_red_point_main_view()
    -- self:show_red_point(ClientEnum.MAIN_UI_BTN.FAMILY ,LuaItemManager:get_item_obejct("legion"):show_red())
    -- self:show_red_point(ClientEnum.MAIN_UI_BTN.SWITCH ,LuaItemManager:get_item_obejct("legion"):show_red())
    -- --判断是否要显示公告
    local offline = LuaItemManager:get_item_obejct("offline")
    local limit_lv = ConfigMgr:get_config("t_misc").offline.level_limit
    local play_lv = LuaItemManager:get_item_obejct("game"):getLevel()
    if offline:have_offline_exp() == true and limit_lv <= play_lv then
        local function callback()
            gf_create_model_view("offline")
        end
        offline:push_ui(offline.ui_priority.offline,callback)
    end
    if LuaItemManager:get_item_obejct("game"):getLevel() >= ConfigMgr:get_config("t_misc").guide_protect_level then
        local Announcement = LuaItemManager:get_item_obejct("announcement")
        if Announcement:show_red() then
            local function callback()
                Announcement:add_to_state()
            end
            offline:push_ui(offline.ui_priority.announcement,callback)
        end
    end
end

--显示按钮红点 show=布尔值 显示或者隐藏，默认显示   mainui_btn_id参考 ClientEnum.MAIN_UI_BTN
function MainuiView:show_red_point(btn_id,show)
    print("wtf red_point 修改按钮红点",btn_id,show)
    local btn = self:get_btn(btn_id)
    if btn and btn.activeSelf then
        if show==nil then show=true end

        -- 一个红点对应多个系统的
        if btn_id == ClientEnum.MAIN_UI_BTN.MAIL then
            self.red_point[btn_id] = LuaItemManager:get_item_obejct("social"):is_have_red_point()
                                    or LuaItemManager:get_item_obejct("email"):is_have_red_point()
                                    or false
        else
            self.red_point[btn_id] = show
        end
        local red_point = LuaHelper.FindChild(btn,"red_point")
        if red_point then
            red_point:SetActive(self.red_point[btn_id])
        end

        --切换按钮
        local switch_btn = self:get_btn(ClientEnum.MAIN_UI_BTN.SWITCH)
        if switch_btn then
            local red_point = LuaHelper.FindChild(switch_btn,"red_point")
            if red_point then
                -- print("市场",self.red_point[ClientEnum.MAIN_UI_BTN.MARK])
                -- print("军团",self.red_point[ClientEnum.MAIN_UI_BTN.FAMILY])
                -- print("社交",self.red_point[ClientEnum.MAIN_UI_BTN.MAIL])
                -- print("打造",self.red_point[ClientEnum.MAIN_UI_BTN.MAKE])
                -- print("坐骑",self.red_point[ClientEnum.MAIN_UI_BTN.MAIL])
                -- print("排行",self.red_point[ClientEnum.MAIN_UI_BTN.MOUNT])
                -- print("设置",self.red_point[ClientEnum.MAIN_UI_BTN.PARTNER])
                -- print("最终,设置切换按钮红点",red_point,self.red_point[ClientEnum.MAIN_UI_BTN.MARK] --市场
                --                     or self.red_point[ClientEnum.MAIN_UI_BTN.FAMILY] --军团
                --                     or self.red_point[ClientEnum.MAIN_UI_BTN.MAIL] --社交
                --                     or self.red_point[ClientEnum.MAIN_UI_BTN.MAKE] --打造
                --                     or self.red_point[ClientEnum.MAIN_UI_BTN.MAIL] --坐骑
                --                     or self.red_point[ClientEnum.MAIN_UI_BTN.MOUNT] --排行
                --                     or self.red_point[ClientEnum.MAIN_UI_BTN.PARTNER] or false --设置
                --                     )
                red_point:SetActive(
                                    self.red_point[ClientEnum.MAIN_UI_BTN.MARK] --市场
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.FAMILY] --军团
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.MAIL] --社交
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.MAKE] --打造
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.MAIL] --坐骑
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.MOUNT] --排行
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.ACHIEVEMENR] --成就
                                    or self.red_point[ClientEnum.MAIN_UI_BTN.PARTNER] or false --设置
                                    )
            end
        end
    end
end
-- 点击按钮
function MainuiView:click_mainui_btn(btn_id)
    local btn = self:get_btn(btn_id)
    if btn then
        self:on_click(btn_id,btn)
    end
end
-- 按钮激活
function MainuiView:btn_active(btn_id,b)
    local btn = self:get_btn(btn_id)
    if btn then
        btn:SetActive(b or false)
    end
end

--初始化子ui
function MainuiView:init_ui_child()
    print("初始化小地图")
    
    self:reset_task_view()

    self.child_ui.combo =  View("mainui_combo", self.item_obj)
    --初始化聊天框
    self.child_ui.chat = Chat(self,self.item_obj)
    --初始化选项
    self.child_ui.option = Option(self,self.item_obj)

    --功能解锁
    self.child_ui.functionunlock = FunctionUnlock(self,self.item_obj)

    --buff显示
    self.child_ui.buff = BuffView(self,self.item_obj)

    require("models.boss.bossBloodLineView")()
end

-- 初始化其他玩家头像
function MainuiView:init_other_player_head()
    self.other_player_head = LuaHelper.FindChild(self.root, "otherPlayerheadBtn")
    self.other_player_head:SetActive(false)
    self.other_p_icon = LuaHelper.FindChildComponent(self.other_player_head, "icon", UnityEngine_UI_Image)
    self.other_p_lv = LuaHelper.FindChildComponent(self.other_player_head, "level", "UnityEngine.UI.Text")
    self.bg_btn = LuaHelper.FindChild(self.root, "bgBtn")
    self.bg_btn:SetActive(false)
end

--任务栏
function MainuiView:reset_task_view()
     -- 任务管理界面
    self.task_mgr_view = require("models.mainuiLeftPanel.taskBaseView")(self.item_obj) --View("taskBaseView", self.item_obj)--
    self:add_child(self.task_mgr_view)
end

function MainuiView:set_other_player_head_visible( visible, guid, info)
    if visible and guid and (not info or not info.level or not info.head) then --如果是显示 没有信息头像，获取玩家信息
        local player = LuaItemManager:get_item_obejct("player")
        self.select_other_player_info=player.other_player_info[guid] or info or {roleId=guid} --记录查看的玩家id
        player:other_player_info_c2s(guid,PlayerEnum.APPLY_DATA_USE.MAINUI_HEAD)
    else
        self.select_other_player_info=info
    end
    self.other_player_head:SetActive(visible)
    self.bg_btn:SetActive(visible)
    self.other_p_guid = guid 
    if visible then
        if self.select_other_player_info.level then
            -- print("设置了主界面的其它玩家等级")
            self.other_p_lv.text = self.select_other_player_info.level
        end
        if self.select_other_player_info.head then
            -- print("设置了主界面的其它玩家头像")
            gf_set_head_ico(self.other_p_icon,self.select_other_player_info.head)
        end
    end
end

--读条
function MainuiView:reading_start(time,fun,text,p)
    self.reading.img.fillAmount=0
    self.reading.text.text=text or ""
    self.reading.obj:SetActive(true)
    self.reading.time=time or 0
    self.reading.end_fun=fun
    self.reading.wait_time=0
    self.reading.parameter=p
end

--读条中断或结束
function MainuiView:reading_end()
    self.reading.obj:SetActive(false)
    --判断执行方法
    if(self.reading.wait_time>=self.reading.time and self.reading.end_fun)then
        self.reading.end_fun(self.reading.parameter[1],self.reading.parameter[2],self.reading.parameter[3],self.reading.parameter[4],self.reading.parameter[5],self.reading.parameter[6])
    end
    self.reading.time=nil
    self.reading.end_fun=nil
    self.reading.wait_time=nil
end

-- 是否显示攻击战斗面板
function MainuiView:show_atk_panel( show )
    if not show then
        self.child_ui.option:countdown_10(true)
        print("倒计时")
    end
    print("战斗？",show)
    if show and not self.child_ui.atk_panel then
        self.child_ui.atk_panel = AttackPanel(self, self.item_obj)
    end
    self.item_obj.show_atk_panel=show--item_obj的记录
    print("--面板控制",self.tweenposition_atk)
    if not self.tweenposition_atk then
        local p=self.refer:Get(13)
        print("--战斗面板")
        local atk_p = self.refer:Get(38)
        self.tweenposition_atk=atk_p:Get(2)
        local at_sd = atk_p:Get(3).sizeDelta
        self.tweenposition_atk.from=Vector3(CANVAS_WIDTH/2,-CANVAS_HEIGHT/2,0)
        self.tweenposition_atk.to=Vector3(CANVAS_WIDTH/2,-CANVAS_HEIGHT/2-400,0)
        print("--标准面板")
       self.tweenposition_right=LuaHelper.FindChildComponent(p,"right","TweenPosition")
        self.tweenposition_right.from=self.tweenposition_right.transform.localPosition
        self.tweenposition_right.to=self.tweenposition_right.transform.localPosition+Vector3(-370,0,0)

       self.tweenposition_bottom=LuaHelper.FindChildComponent(p,"bottom","TweenPosition")
        self.tweenposition_bottom.from=self.tweenposition_bottom.transform.localPosition
        self.tweenposition_bottom.to=self.tweenposition_bottom.transform.localPosition+Vector3(0,300,0)

        self.tweenposition_unlock=LuaHelper.FindChildComponent(p,"img_function_unlock","TweenPosition")
        self.tweenposition_unlock.from=self.tweenposition_unlock.transform.localPosition
        self.tweenposition_unlock.to=self.tweenposition_unlock.transform.localPosition+Vector3(240,0,0)

        self.tweenrotation_switch = self.refer:Get("switchBtn_ref"):Get(1)
        self.tweenrotation_switch.from = Vector3(0,0,0)
        self.tweenrotation_switch.to =  Vector3(0,0,-180)

        -- self.tweenrotation_joystick =self.refer:Get(38):Get(3)
        -- self.tweenrotation_joystick.from = self.tweenrotation_joystick.transform.localPosition
        -- self.tweenrotation_joystick.to = self.tweenrotation_joystick.transform.localPosition + Vector3(0,-250,0)
        -- self.joystick_from = self.refer:Get(38):Get(2).localPosition
        -- self.joystick_to = self.refer:Get(38):Get(2).localPosition + Vector3(0,-350,0)
    end
    if show then
        self.tweenposition_atk.duration = 0.25
        self.tweenposition_right.duration = 0.05
        self.tweenposition_bottom.duration = 0.05
        self.tweenposition_unlock.duration = 0.25
        -- self.tweenrotation_joystick.duration = 0.25
        -- self.refer:Get(38):Get(2).localPosition = self.joystick_from

        self.tweenposition_atk:PlayReverse()
        self.tweenposition_right:PlayReverse()
        self.tweenposition_bottom:PlayReverse()
        self.tweenposition_unlock:PlayReverse()
        self.tweenrotation_switch:PlayReverse()
        -- self.tweenrotation_joystick:PlayReverse()

    else
        self.tweenposition_atk.duration = 0.05
        self.tweenposition_right.duration = 0.25
        self.tweenposition_bottom.duration = 0.25
        self.tweenposition_unlock.duration = 0.25
        self.tweenrotation_switch.duration = 0.25
        -- self.tweenrotation_joystick.duration = 0.25
        -- self.refer:Get(38):Get(2).localPosition = self.joystick_to

        self.tweenposition_atk:PlayForward()
        self.tweenposition_right:PlayForward()
        self.tweenposition_bottom:PlayForward()
        self.tweenposition_unlock:PlayForward()
        self.tweenrotation_switch:PlayForward()
        -- self.tweenrotation_joystick:PlayForward()

    end
end 
function MainuiView:show_hero_view() 
    local hero_panel = self.refer:Get(41)

    local hero_uid = gf_getItemObject("hero"):getFightId()
    print("hero_uid:",hero_uid)
        
    local head_icon = hero_panel:Get(1)
    local level = hero_panel:Get(2)

    hero_panel:Get(3):SetActive(false)

    if not hero_uid or hero_uid <= 0 then
        -- hero_panel.gameObject:SetActive(false)
        hero_panel:Get(3):SetActive(true)
        head_icon.gameObject:SetActive(false)
        level.text = ""
        return
    end
    local hero_info = gf_getItemObject("hero"):getHeroInfo(hero_uid)
    gf_print_table(hero_info,"hero_info:")
    local dataUse = require("models.hero.dataUse")

    --头像
    head_icon.gameObject:SetActive(true)
    gf_setImageTexture(head_icon,dataUse.getHeroHeadIcon(hero_info.heroId))
    --等级
    level.text = hero_info.level
    
    --血量
    local character = gf_getItemObject("battle"):get_character()
    if character then
        local hero = character:get_hero()
        if hero then
            local max_hp = hero:get_max_hp()
            local hp = hero:get_hp()
            self:update_hero_blood(hp,max_hp)
        end
    end
    
    --如果有倒计时 开启定时器
    local time_tick = hero_panel.transform:FindChild("filled")
    local time_text = time_tick.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
    local time = gf_getItemObject("hero"):get_relive_timestamp()
    print("relive time:",time)
    local update = function()
        if time <= Net:get_server_time_s() then
            time_tick.gameObject:SetActive(false)
            self.schedule_id:stop()
            self.schedule_id = nil
            gf_getItemObject("hero"):reset_hero_fighting()
            return
        end
        local tick = time - Net:get_server_time_s()
        tick = tick > 0 and tick or 0
        time_text.text = math.floor(tick)
    end
    if time > 0 and not self.schedule_id then
        time_tick.gameObject:SetActive(true)
        self.schedule_id = Schedule(update, 0.1)
    end
    if time <= 0 then
         if self.schedule_id then
            self.schedule_id:stop()
            self.schedule_id = nil
        end
        time_tick.gameObject:SetActive(false)
        time_text.text = ""
    end

end

function MainuiView:update_hero_blood(hp,max_hp)
    self.hero_blood_line.fillAmount = hp / max_hp
end
--点击事件
function MainuiView:on_click(item_obj, obj, arg)
    self.last_click_time = Net:get_server_time_s()
    for k,v in pairs(self.child_ui) do
        if v.on_click and not Seven.PublicFun.IsNull(obj) then
            v:on_click(item_obj, obj, arg)
        end
    end
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
    print("点击主城场景按钮>>>>>>>>",cmd,"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
	if cmd == "small_map" then -- 小地图
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self.map_item = self:add_model("map")
    elseif cmd =="switchBtn" then -- 切换按钮
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        self:show_atk_panel(not self.item_obj.show_atk_panel)
        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
        local data = ConfigMgr:get_config("mapinfo")[map_id]
        if not data.show_active_list then
            if  data.is_show_button == 0 then
                self.child_ui.option:copy_shrink(self.item_obj.show_atk_panel)
            else
                self.child_ui.option:shrink_btn(self.item_obj.show_atk_panel)
            end
        else
            if  data.is_show_button == 0 then
                self.child_ui.option:copy_shrink(true)
            else
                self.child_ui.option:shrink_btn(true)
            end
        end
    elseif cmd =="headBtn" then -- 人物（头像）
        print("头像")
        if LuaItemManager:get_item_obejct("firstWar"):is_pass() then
            Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
            self:add_model("player")
        end

    elseif cmd =="vipBtn" then -- vip特权
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("")
        self:add_model("vipPrivileged")

    elseif cmd =="wujiangBtn" then -- 武将
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("武将")
        -- require("models.hero.heroCommon")()
        
        gf_create_model_view("hero")
    elseif cmd =="makeBtn" then -- 打造
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("打造")
        self.equip=self:add_model("equip")
        self.child_ui.option:countdown_10(false)
    elseif cmd =="partnerBtn" then -- 伙伴
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("伙伴")

    elseif cmd =="mountBtn" then -- 坐骑
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("坐骑")
        gf_create_model_view("horse")
        self.child_ui.option:countdown_10(false)
    elseif cmd =="courtyardBtn" then -- 庭院
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("庭院")

    elseif cmd =="marketBtn" then -- 市场
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("市场")
        self:add_model("market")
        self.child_ui.option:countdown_10(false)
    elseif cmd =="rankBtn" then -- 排行
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("排行")  
        gf_create_model_view("rank",ServerEnum.RANKING_TYPE.POWER)
        self.child_ui.option:countdown_10(false)
    elseif cmd =="mailBtn" then -- 社交
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("社交")
        arg:SetActive(false)
        LuaItemManager:get_item_obejct("functionUnlock"):fun_effect_dispose(ClientEnum.MAIN_UI_BTN.MAIL)
        LuaItemManager:get_item_obejct("social"):add_to_state()
        self.child_ui.option:countdown_10(false)
    elseif cmd =="familyBtn" then -- 军团
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("军团")
        arg:SetActive(false)
        LuaItemManager:get_item_obejct("functionUnlock"):fun_effect_dispose(ClientEnum.MAIN_UI_BTN.FAMILY)
        LuaItemManager:get_item_obejct("legion"):open_view() 
        self.child_ui.option:countdown_10(false)
    elseif cmd == "SettingBtn" then -- 设置
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        gf_create_model_view("setting")
        self.child_ui.option:countdown_10(false)
    elseif cmd == "sitBtn" then -- 打坐
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        View("acceptView", LuaItemManager:get_item_obejct("sit"))

    elseif cmd == "battle_mode_btn" then -- 战斗模式
        --如果是魔族围城
        if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY)
            or LuaItemManager:get_item_obejct("rvr"):is_rvr() then
            -- return
        end
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        View("pkModeView", self.item_obj)

    elseif cmd == "leaveBtn" then -- 离开
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local sfunc = function(a,b)
            LuaItemManager:get_item_obejct("copy"):exit()
        end
        local show_content =  gf_localize_string("确定要离开副本吗?")

        if ConfigMgr:get_config("t_misc").alliance.legionMapId == gf_getItemObject("battle"):get_map_id() then
            show_content =  gf_localize_string("确定要离开军团场景吗?")
        end

        if LuaItemManager:get_item_obejct("rvr"):is_rvr() then
            show_content = gf_localize_string("确定要离开逐鹿战场吗？离开后需等待30秒才能再次进入；同时若战场结束时不在战场内，不能获得结算奖励")
        end

        if LuaItemManager:get_item_obejct("zorkPractice"):is_on_zork_scene() then
            sfunc = function()
                LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(ConfigMgr:get_config("t_misc").deathtrap.logout_exit_map)
            end
            show_content =  gf_localize_string("确定要离开魔狱绝地吗?")
        end
        LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(show_content,sfunc)
       
        
    elseif cmd == "otherPlayerheadBtn" then -- 其他玩家头像
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        LuaItemManager:get_item_obejct("player"):show_player_tips(self.select_other_player_info.roleId)

    elseif cmd == "patacangkuBtn" then --打开爬塔仓库
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        View("TowerSweepWarehouse", LuaItemManager:get_item_obejct("copy"))

    elseif cmd == "duiwuBtn" then --点有人组队
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        LuaItemManager:get_item_obejct("team"):enter_team_view()

    elseif cmd == "newEmailBtn" then --有新的邮件
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local social = LuaItemManager:get_item_obejct("social")
        social:set_open_mode(2)
        social:add_to_state()

    elseif cmd == "siliaotianBtn" then --有新的私聊
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local chat = LuaItemManager:get_item_obejct("chat")
        chat:open_private_chat_ui()


    elseif cmd == "newFriendBtn" then --有新的好友申请
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local social = LuaItemManager:get_item_obejct("social")
        social:set_open_mode(1,5)
        social:add_to_state()

    elseif cmd == "cancleOtherPlayerheadBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
        self:set_other_player_head_visible(false)

    elseif cmd == "appearanceBtn" then -- 外观
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        LuaItemManager:get_item_obejct("surface"):open_view()
        self.child_ui.option:countdown_10(false)
    elseif cmd == "rvr" then -- 战场
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:add_model("rvr")
        self.child_ui.option:countdown_10(false)
    elseif cmd == "strengthen" then -- 变强
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        arg:SetActive(false)
        self:add_model("strengthen")
        self.child_ui.option:countdown_10(false)
    elseif cmd == "img_function_unlock" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        require("models.functionUnlock.functionNotice")()
	end
end

function MainuiView:on_receive( msg, id1, id2, sid )
    for k,v in pairs(self.child_ui) do
        if v.on_receive then
            v:on_receive(msg, id1, id2, sid)
        end
    end
    if(id1==Net:get_id1("base"))then
        if self.text_role_lv.text and id2 == Net:get_id2("base", "UpdateLvlR") then
            self.text_role_lv.text = msg.level
        elseif id2 == Net:get_id2("base", "UpdateResR") then
            local game = LuaItemManager:get_item_obejct("game")
            local exo_schedule = game:get_exp()/ConfigMgr:get_config("player")[game:getLevel()].exp
            self.exp_line.fillAmount = exo_schedule

        elseif id2 == Net:get_id2("base", "UpdateCombatR") then
            -- self:update_ui() --刷新导致右边切换handle有问题
            self:update_player_blood()
        elseif(id2== Net:get_id2("base", "UpdatePowerR"))then
            self.text_role_zhanli.text = self.game_obj:getPower()
        end
    end

    if id1==Net:get_id1("scene") then
        if id2 == Net:get_id2("scene", "SetPkModeR") then -- 战斗模式
            self:update_battle_mode_img()
        end
    end

    if id1==Net:get_id1("shop") then
        if id2 == Net:get_id2("shop", "GetVipInfoR") then
            -- 初始化VIP等级
            self.refer:Get("vipText").text = msg.vipLevel
        elseif id2== Net:get_id2("shop", "UpdateVipLvlR") then
            -- 更新VIP等级
            self.refer:Get("vipText").text = msg.vipLevel
        end
    end

    if id1 == ClientProto.HeroFightOrRest then
        self:show_hero_view()

    elseif id1 == ClientProto.MouseClick then -- 鼠标点击
        self.auto_path_eff:SetActive(false)
        self:show_atk_panel(true)
        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
        if  ConfigMgr:get_config("mapinfo")[map_id].is_show_button == 0 then
           self.child_ui.option:copy_shrink(true)
        else
           self.child_ui.option:shrink_btn(true)
        end
    elseif id1 == ClientProto.TouchMonster then -- 鼠标点击怪物
        self:show_atk_panel(true)
        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
        if  ConfigMgr:get_config("mapinfo")[map_id].is_show_button == 0 then
           self.child_ui.option:copy_shrink(true)
        else
           self.child_ui.option:shrink_btn(true)
        end
    elseif id1 == ClientProto.ShowMainUIAutoPath then -- 自动寻路
        self.auto_path_eff:SetActive(msg.visible)
        if  msg.visible then
            self.auto_atk_eff:SetActive(false)
            self:show_atk_panel(true)
        end
    elseif id1 == ClientProto.ShowMainUIAutoAtk then -- 自动挂机
        self.auto_atk_eff:SetActive(msg.visible)
        if  msg.visible then
            self.auto_path_eff:SetActive(false)
        end
    elseif id1 == ClientProto.HidOrShowMainUI then -- 隐藏或显示主界面
        self:set_visible(msg.visible)

    elseif id1 == ClientProto.HideOrShowMainUIRightTop then -- 显示或隐藏右上角ui
        self.refer:Get("righttop"):SetActive(msg.visible)

    elseif id1 == ClientProto.JoystickStartMove then -- 开始移动摇杆
        self:show_atk_panel(true)
        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
        if  ConfigMgr:get_config("mapinfo")[map_id].is_show_button == 0 then
           self.child_ui.option:copy_shrink(true)
        else
           self.child_ui.option:shrink_btn(true)
        end
        self.auto_path_eff:SetActive(false)
    elseif id1 == ClientProto.ShowOrHideMainuiBtn then -- 显示或隐藏按钮
        -- print("显示按钮",msg.id,msg.visible)
        self:showorhide_btn(msg.id,msg.visible)

    elseif id1 == ClientProto.ShowHotPoint then -- 红点
        self:show_red_point(msg.btn_id, msg.visible)

    -- elseif id1 == ClientProto.PlayerLoaderFinish then --所有加载
        -- local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
    elseif id1 == ClientProto.FinishScene then-- 进入场景，刷新主ui
        self:show_atk_panel(true)
        -- if  gf_getItemObject("copy"):is_copy() then
        --     self.child_ui.option:copy_shrink(true)
        -- else
        --     self.child_ui.option:shrink_btn(true)
        -- end
        self:update_ui()

    elseif id1 == ClientProto.TowerStorehouseChange then -- 爬塔仓库更新是有未领物品
        self:get_btn(ClientEnum.MAIN_UI_BTN.TOWER):SetActive(msg)

        if id1==Net:get_id1("scene") then
        if id2 == Net:get_id2("scene", "UpdateObjectR") then -- 创建,更新,移除通用协议
            self:update_object(msg)
        end
    end

    elseif id1 == ClientProto.PlayerBlood then --自身玩家血量变化
        self:update_player_blood()
        -- 如果血量少于15%，每受到一次攻击，屏幕显示受伤特效
        if msg.player_hp < 0.15 then
            self.refer:Get("41000098"):SetActive(true)
            self.hurt_effect =  Schedule(handler(self, function()
                    self.refer:Get("41000098"):SetActive(false)
                    self.hurt_effect:stop()
                    end), 0.5)
        end

    elseif id1 == ClientProto.HeroBlood then
        self:update_hero_blood(msg.hp,msg.max_hp)

    elseif id1 == ClientProto.ShowAwardEffect then  --主界面奖励
        self:show_award_effect(msg.btn_id,msg.visible)

    elseif id1 == ClientProto.FristBattleMainui then -- 首场战斗ui
        self:show_first_war_ui(msg)

    elseif id1 == ClientProto.ShowXPBtn then
        self.refer:Get("skill5"):SetActive(msg)

    elseif id1 == ClientProto.ShowATKPanel then 
        self:show_atk_panel(msg)
        self.child_ui.option:shrink_btn(msg)
        self.child_ui.option:countdown_10(false)
    elseif id1 == ClientProto.RefreshMainUI then
        self:update_ui()

    elseif id1 == ClientProto.MainUiShowControl then
        self:show_mainui_state(msg)
    elseif id1 == ClientProto.PlayerLoaderFinish then -- 进入地图
        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
        local data = ConfigMgr:get_config("mapinfo")[map_id]
        if data.is_show_mapname == 1 then
            self.map_text.text=data.name
            self.map_img.gameObject:SetActive(true)
            self.map_a = 0
            self.map_keep_time = 2
            self.map_show = true
        end
        local tb = ConfigMgr:get_config("mapinfo")[map_id]
        if  tb.is_show_button == 0 then
            self.child_ui.option:copy_in()
        else
            self.child_ui.option:copy_out()
        end
        if tb.small_map_off == 0 then
            self.child_ui.option:copy_not_map()
        else
             self.child_ui.option:copy_map()
        end
        if tb.show_swtch_button == 0 then
            self.refer:Get(30):Get(10):SetActive(false)
        else
            self.refer:Get(30):Get(10):SetActive(true)
        end
    elseif id1 == ClientProto.MainUiShowDaily then -- 活动图标，显示
        self:show_daily_icon(msg)

    elseif id1 ==  ClientProto.MainUiHideDaily then--活动图标隐藏
        self:hide_daily_icon(msg)
    elseif id1 == ClientProto.MainCopyBtn then--主界面副本按钮切换
        -- if msg then
        --     self.child_ui.option:copy_in()
        -- else
        --     self.child_ui.option:copy_out()
        -- end 
    elseif id1 == ClientProto.refreshPlayerName then--刷新玩家名字
        local set_name=function(name)
            self.text_role_name.text = name
        end
        set_name(LuaItemManager:get_item_obejct("game"):getName())
    elseif id1 ==  ClientProto.AutoDotask then 
        if msg then
            self.open_auto_tips = true
            self.last_click_time = Net:get_server_time_s()
        end
    elseif id1 == ClientProto.OpenAutoDoTask then
        self.open_auto_tips = msg
    elseif id1 == ClientProto.HideOrShowATKPanel then
        self.atkPanel.gameObject:SetActive(msg)
    end
    if id1==Net:get_id1("hero") then
        if id2 == Net:get_id2("hero" ,"HeroDieR") then
            self:show_hero_view()

        elseif id2 == Net:get_id2("hero" ,"AddHeroExpByBookR") then
            local hero_uid = gf_getItemObject("hero"):getFightId()
            if msg.heroId == hero_uid then
                self:show_hero_view()
            end

        end
    end
    -- if id1 == ClientProto.PlayerRelive then
    --     self:show_hero_view() 
    -- end
    if id1 == Net:get_id1("bag") then
        if id2== Net:get_id2("bag", "UpdateItemR") then
            local visible = LuaItemManager:get_item_obejct("surface"):is_have_red_point()
            Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.COURTYARD ,visible = visible}, ClientProto.ShowHotPoint)
        end
    end
    if id1 == ClientProto.JoystickStartMove
        or id1 == ClientProto.TouchMonster
        or id1 == ClientProto.OnStopAutoMove
        or id1 == ClientProto.MouseClick
        or id1 == ClientProto.PlayNormalAtk
        then
        self.last_click_time = Net:get_server_time_s()
    end
end

function MainuiView:set_visible( visible )
    self.root:SetActive(visible)
end

function MainuiView:init_show_btn() -- ClientProto.ShowOrHideMainuiBtn
    local social = LuaItemManager:get_item_obejct("social")
     -- 新的好友申请
    self:showorhide_btn(ClientEnum.MAIN_UI_BTN.NEW_FRIEND,social:is_have_new_appay_friend())
    local email = LuaItemManager:get_item_obejct("email")
     -- 新邮件提示
    self:showorhide_btn(ClientEnum.MAIN_UI_BTN.NEW_EMAIL,email:is_have_new_email())
    -- 有新的聊天
    self:showorhide_btn(ClientEnum.MAIN_UI_BTN.SPRIVATE_CHAT,LuaItemManager:get_item_obejct("chat"):is_have_new_private_chat())

    -- 首充图标
    if LuaItemManager:get_item_obejct("vipPrivileged"):is_get_all_reward() then
        self:showorhide_btn(ClientEnum.MAIN_UI_BTN.FIRSTTIME,false)
    end
end

function MainuiView:showorhide_btn(btn_id,visible)
    local btn =  self.refer:Get("zhujiemian_ui"):Get(btn_id)
    if btn then
        if btn_id == ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER and visible == true then
            if LuaItemManager:get_item_obejct("activeEx"):get_is_open() then
                btn:SetActive(true)
            else
                btn:SetActive(false)
            end
        elseif btn_id == ClientEnum.MAIN_UI_BTN.LOGIN and visible == true then
            if not LuaItemManager:get_item_obejct("sign"):login_15_isover() then
                btn:SetActive(true)
            else
                btn:SetActive(false)
            end
        elseif  btn_id == ClientEnum.MAIN_UI_BTN.FIRSTTIME and visible == true then
            if not LuaItemManager:get_item_obejct("vipPrivileged"):is_get_all_reward() then
                btn:SetActive(true)
            else
                btn:SetActive(false)
            end
        else
            btn:SetActive(visible or false)
        end
        if not btn.activeSelf and visible then
            Sound:play(ClientEnum.SOUND_KEY.NEW_MESSAGE) -- 友/聊/修/队/团等出现提示音效
        end
    end
    self.child_ui.option:adaptive_btn() --按钮组自适应
end


function MainuiView:show_mainui_state(type)

end

--根据状态显示主界面
function MainuiView:show_on_type()
    --显示或者隐藏主界面元素
    local controler = self.controler
    for k,v in pairs(ServerEnum.MAINUI_UI_MODLE) do
        local type = v
        local is_show = gf_get_mainui_show_state(type)
        if controler[type] then
           controler[type]:SetActive(is_show or false)
        end
    end

    --位移之类的 
    if gf_getItemObject("copy"):is_story() or gf_getItemObject("copy"):is_material_defence() or gf_getItemObject("copy"):is_material_time_treasury() then
        self:show_story_view()
    elseif gf_getItemObject("copy"):is_challenge()  then
        self:show_challenge_view()
    elseif gf_getItemObject("copy"):is_pvp() then
         self:show_normal_view(true)
    elseif not gf_get_mainui_show_state(ServerEnum.MAINUI_UI_MODLE.MAP)   then
        self:show_team_view()
    else
        self:show_normal_view(true)
    end

end

function MainuiView:show_normal_view(show)
    print("画布宽",CANVAS_WIDTH)
    self.refer:Get("handel").transform.localPosition = Vector3(CANVAS_WIDTH*0.5 - 148.4,168.5,0)
end

function MainuiView:show_team_view(show)
    self.refer:Get("handel").transform.localPosition = Vector3(CANVAS_WIDTH*0.5 - 148.4,293,0)

end

function MainuiView:show_challenge_view(show)
    self.refer:Get("handel").transform.localPosition = Vector3(CANVAS_WIDTH*0.5 - 148.4,176,0)
end
function MainuiView:show_story_view(show)
    self.refer:Get("handel").transform.localPosition = Vector3(CANVAS_WIDTH*0.5 - 148.4,206,0)
end

function MainuiView:show_pvp_view(show)
end

function MainuiView:show_first_war_ui( show )
    self.refer:Get("righttop"):SetActive(show)
    self.refer:Get("righttopBtn"):SetActive(show)

    self.refer:Get("fun_unlock"):SetActive(show)
    self.refer:Get(2):Get(2):SetActive(show)
    self.refer:Get("autoBtn"):SetActive(show)
    self.refer:Get("switchBtn"):SetActive(show)
    self.refer:Get("hero"):SetActive(show)
    self.refer:Get("leaveBtn"):SetActive(show)
    self.refer:Get("skill5"):SetActive(show)
    self.refer:Get("chatRef").gameObject:SetActive(show)
    self.refer:Get("skill_effect5"):SetActive(show)
    self:get_btn(ClientEnum.MAIN_UI_BTN.VIP):SetActive(show)
    if show then--新手副本结束
       self.refer:Get(30):Get(9).gameObject.transform.localPosition = Vector3(0,0,0)
       print("新手副本结束按钮复位")
    end
end


--添加模块
function MainuiView:add_model( name )
    print(">>>add_model：",name)
    -- local item = LuaItemManager:get_item_obejct(name)
    -- if item then
    --     item:add_to_state()

    -- end
    return gf_create_model_view(name)
end

function MainuiView:is_remind_tips()
    local role_id = LuaItemManager:get_item_obejct("game").role_id
    local s_true = PlayerPrefs.GetInt("AutoTaskTrue"..role_id,0)
    local s_false = PlayerPrefs.GetInt("AutoTaskFalse"..role_id,0)
    local time = Net:get_server_time_s()
    local cur_time =  os.date("%Y%m%d",math.floor(time))
    if s_false == 0 or os.date("%Y%m%d",s_false) ~= cur_time then
        if s_true == 0 or os.date("%Y%m%d",s_true) ~= cur_time then
            return true
        else
            return false
        end
    else
        return nil
    end
end

function MainuiView:save_auto_do_task(tf)
    local role_id = LuaItemManager:get_item_obejct("game").role_id
    local time = Net:get_server_time_s()
    if tf then
        local s = PlayerPrefs.SetInt("AutoTaskTrue"..role_id,math.floor(time))
    else
        local s = PlayerPrefs.SetInt("AutoTaskFalse"..role_id,math.floor(time))
    end
end

function MainuiView:check_player_move()
    local newcomerlevel=ConfigMgr:get_config("t_misc").guide_protect_level --新手等级限制
    if gf_getItemObject("game"):getLevel()>= newcomerlevel then
        return
    end
    local auto_time = ConfigMgr:get_config("t_misc").auto_task --自动做任务等待时间（秒）
    local open_auto_task =ConfigMgr:get_config("t_misc").open_auto_task --默认50
    local char =  LuaItemManager:get_item_obejct("battle"):get_character()
    if not char or char:is_move() then
        self.last_click_time = Net:get_server_time_s()
    end
    if self.last_click_time and Net:get_server_time_s() - self.last_click_time > auto_time then --自动做任务
        Net:receive(false, ClientProto.AutoDotask)
    end
    if self.last_click_time and Net:get_server_time_s() - self.last_click_time > open_auto_task then --提示然后做任务
        if self.open_auto_tips then
            self.open_auto_tips = false
        end
        -- 超过10秒没操作，弹框
        -- Net:receive(true, ClientProto.AutoAtk)
        -- print("超过10秒没操作，弹框")
        if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
            self.open_auto_tips = nil
            return
        end
        if  gf_getItemObject("copy"):is_copy() then
            if LuaItemManager:get_item_obejct("guide"):get_big_step()>3 then
                gf_auto_atk(true)
            end
            return
        end
        if LuaItemManager:get_item_obejct("guide"):get_step() ~= 0 then
            return
        end
        if self.open_auto_tips or self.open_auto_tips == nil then return end
        self.open_auto_tips = nil
        local txt = "不要发呆啦！完成主线任务可以快速升级呢，赶紧行动吧！"
        -- if LuaItemManager:get_item_obejct("task"):get_main_task().status == ServerEnum.TASK_STATUS.NONE then 
        --     self.last_click_time = Net:get_server_time_s()
        --     self.open_auto_tips = false
        --     return 
        -- end
        if not self:is_remind_tips() then
            if self:is_remind_tips() == nil then
                return
            end
            self:do_task()
            self.last_click_time = Net:get_server_time_s()
            self.open_auto_tips = false
            return
        end
        LuaItemManager:get_item_obejct("cCMP"):add_message(txt,
                function(a,b)
                self:do_task()
                print(b)
                if b then
                    self:save_auto_do_task(true)
                end
                self.last_click_time = Net:get_server_time_s()  
                self.open_auto_tips = false
                end,
                nil,
                function(a,b)  
                self.last_click_time = Net:get_server_time_s() 
                print(b) 
                if b then
                    self:save_auto_do_task(false)
                end
                self.open_auto_tips = false
                end,
                nil,
                "今天不再提示",false,
                nil,nil, "确认","取消",
                function(a,b)  
                self.last_click_time = Net:get_server_time_s() 
                print(b) 
                self.open_auto_tips = false
                end,
                auto_time,nil)
        self.last_click_time = Net:get_server_time_s()
    end
end

function MainuiView:do_task()
    if LuaItemManager:get_item_obejct("sit"):is_sit() then
        Net:receive(false, ClientProto.StarOrEndSit)
    end
    local tb = LuaItemManager:get_item_obejct("task")
    local data =  tb:get_main_task()
    if data.status == ServerEnum.TASK_STATUS.NONE then
        local tb_day = tb:get_type_task(ServerEnum.TASK_TYPE.EVERY_DAY)
        local tb_day1 = tb:get_type_task(ServerEnum.TASK_TYPE.EVERY_DAY_GUILD)
        if tb_day1 then
            data = tb_day1
        elseif tb_day then
            data = tb_day
        else
            return
        end
    end
    if data then
        Net:receive({task_data = data}, ClientProto.OnTouchNpcTask)
    end
end

--每帧更新
function MainuiView:on_update(dt)
    -- --子ui
    for k,v in pairs(self.child_ui) do
        if v.main_on_update then
            v:main_on_update(dt)
        end
    end
    --每秒
    self.timer_the_second=self.timer_the_second+dt
    if(self.timer_the_second>=1)then
        self.timer_the_second=0
        self:on_the_second()
        self:check_player_move()
    else

    end
    --读条
    if(self.reading and self.reading.time)then
        self.reading.wait_time=self.reading.wait_time+dt
        self.reading.img.fillAmount=self.reading.wait_time/self.reading.time
        if(self.reading.wait_time>=self.reading.time)then
            self:reading_end()
        end
    end
    --地图显隐
    if self.map_show then
        if self.map_keep_time > 0 then
            self.map_a = self.map_a + dt
        else
            self.map_a = self.map_a - dt
        end
        self.map_img.color = UnityEngine.Color(1,1,1,self.map_a)
        self.map_text.color = UnityEngine.Color(1,0.9,0.51,self.map_a)
        if self.map_a>1 then
            self.map_keep_time = self.map_keep_time - dt
            self.map_a=1
        elseif self.map_a<0 then
            self.map_show = false
            self.map_img.gameObject:SetActive(false)
        end
    end

end

--每秒更新
function MainuiView:on_the_second()
    local time_str = os.date("%H:%M", os.time())
    self.text_time.text=time_str--更新时间
    --self.text_wangluo--更新网络
    local network=UnityEngine.Application.internetReachability  -- 0 无网络    1 移动数据  2 局域网网络
    self.text_wangluo.text = network == 2 and "WIFI" or network == 1 and "4G" or "???"
    --self.img_xinhao--更新信号
    self.img_xinhao.gameObject:SetActive(network==2) --信号的显示
    local ping_time = Net:get_ping_time()
    -- print("延迟时间",ping_time)
    local xh_img = "wifi_bg"
    if ping_time<0.5 then -- 延迟0.5秒以下满3个信号
        xh_img = "wifi_03"
    elseif ping_time<1.5 then -- 1.5以下2个信号
        xh_img = "wifi_02"
    elseif ping_time<5 then -- 5以下1个信号
        xh_img = "wifi_01"
    end
    if self.last_xh_img and self.last_xh_img ~= xh_img then
        gf_setImageTexture(self.img_xinhao,xh_img)
        self.last_xh_img = xh_img
    end

    --self.tf_dianchi--更新电量
    local dianchi=UnityEngine.SystemInfo.batteryLevel
    local childcount=self.tf_dianchi.childCount
    for i=0.2,childcount do
        --print("第"..math.floor(i).."条，要求",i/childcount,dianchi>i/childcount)
        if dianchi<i/childcount then
            if self.cell_num~=math.floor(i) then
                self.cell_num=math.floor(i)
                --print("当前手机电量=",self.cell_num)
                for j=1,childcount do
                    --print(j,j<=self.cell_num)
                    if j<=self.cell_num then
                        self.tf_dianchi:GetChild(j-1).gameObject:SetActive(true)
                    else
                        self.tf_dianchi:GetChild(j-1).gameObject:SetActive(false)
                    end
                end
            end
            break
        end
    end
    --区服ID
    local game = LuaItemManager:get_item_obejct("game")
    self.text_area.text=game.area_id.."区"
    --区服名
    self.text_area_name.text=game.area_name


end


--功能预告的显示隐藏
function MainuiView:fun_unlock_show()
    if self.item_obj.show_atk_panel then
        self.img_function_unlock:SetActive(true)
    else
        self.img_function_unlock:SetActive(false)
    end
end

--更新玩家血量
function MainuiView:update_player_blood()
    local game = LuaItemManager:get_item_obejct("game")
    local cur = game:get_cur_hp() or 0
    local max = game:get_hp() or 1
    local hp = cur/max
    -- print("玩家血量啊"..hp)
    self.img_role_hp.fillAmount = hp
    if  LuaItemManager:get_item_obejct("firstWar"):is_pass() then
        self.txt_hp.text = gf_format_hp(cur).."/"..gf_format_hp(max)
    else
         self.txt_hp.text = gf_format_hp(cur*100).."/"..gf_format_hp(max*100)
    end
end


--奖励领取提示
function MainuiView:show_award_effect(btn_id,show)
    local btn = self:get_btn(btn_id)
    if btn then
        if show==nil then show=true end
        local award_effect = LuaHelper.FindChild(btn,"41000047")
        if award_effect then
            award_effect:SetActive(show)
        end
    end
end

--活动图标显示隐藏
function MainuiView:show_daily_icon(data)
    local btn = self:get_btn(data.main_icon)
    gf_print_table(data,"日常哦1")
    if btn then
        local countdown = LuaHelper.FindChildComponent(btn,"txtCountdown","UnityEngine.UI.Text")
        if not self.daily_list then
           self.daily_list = {}
        end
        local k = #self.daily_list+1
        self.daily_list[k] ={} 
        self.daily_list[k].text = countdown
        self.daily_list[k].name = data.name
        self.daily_list[k].code = data.code
        self.daily_list[k].btn = btn
        if #data.day_time<=4 then
            self.daily_list[k].time = {data.day_time[3],data.day_time[4]}
        else
            if data.day_time[3]*60+data.day_time[4] < os.date("%H")*60+os.date("%M") then
                self.daily_list[k].time = {data.day_time[7],data.day_time[8]}
            else
                self.daily_list[k].time = {data.day_time[3],data.day_time[4]}
            end
        end
        -- Net:get_server_time_s()
        local t = (self.daily_list[k].time[1]*60 + self.daily_list[k].time[2])*60 - (os.date("%H")*60*60+os.date("%M")*60+os.date("%S"))
        countdown.text = gf_convert_timeEx(t)
        btn:SetActive(true)
        self.child_ui.option:adaptive_btn() --按钮组自适应
        self:countdown_daily()
    end
end

--更新活动倒计时
function MainuiView:countdown_daily()
    print("日常哦2",#self.daily_list)
    if not self.schedule_daily then
        self.schedule_daily = Schedule(handler(self, function()
            if self.daily_list then
                for k,v in pairs(self.daily_list) do
                    local t =(v.time[1]*60 + v.time[2])*60 - (os.date("%H")*60*60+os.date("%M")*60+os.date("%S"))
                    if t < 0 then
                        v.btn:SetActive(false)
                        self.child_ui.option:adaptive_btn()
                        LuaItemManager:get_item_obejct("activeDaily"):daily_icon_hide(v.code)
                        v = nil
                        if #self.daily_list == 0 then
                            if self.schedule_daily then
                                self.schedule_daily:stop()
                                self.schedule_daily = nil
                            end
                        end
                    else
                        v.text.text =gf_convert_timeEx(t)
                    end
                end
            end
        end),1)
    end
end
--活动隐藏
function MainuiView:hide_daily_icon(data)
    if #self.daily_list == 0 then return end
    for k,v in pairs(self.daily_list) do
        if v.name == data.name then
            v.btn:SetActive(false)
            self.child_ui.option:adaptive_btn()
            v = nil
            if #self.daily_list == 0 then
                if self.schedule_daily then
                    self.schedule_daily:stop()
                    self.schedule_daily = nil
                end
            end
        end
    end
end

function MainuiView:on_showed()
    self:register()
end

function MainuiView:on_hided()
    gf_remove_update(self)
    self.item_obj:register_event("mainui_view_on_click", nil)
end

-- 释放资源
function MainuiView:dispose()
    for k,v in pairs(self.child_ui) do
        if v.dispose then
            v:dispose()
        end
    end
    self.child_ui = {}
    self.btn_list = nil
    self.tweenposition_atk = nil
    gf_remove_update(self)
    self.item_obj:register_event("mainui_view_on_click", nil)
    self._base.dispose(self)
end

return MainuiView