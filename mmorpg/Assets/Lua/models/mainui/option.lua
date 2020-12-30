--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-11 09:26:22
--]]
local Vector3 = UnityEngine.Vector3
local Option = class(function ( self, ui, item_obj )
	self.ui = ui
	self.item_obj = item_obj
	self:init()
end)

function Option:init()
    self.btn_group = self.ui.refer:Get(30)
    self.btn_init_pos = self.btn_group:Get(8).localPosition
    if not self.tweenposition_btnlist1 then
        self.tweenposition_btnlist1 = self.btn_group:Get(2)
        self.tweenposition_btnlist1.from=self.tweenposition_btnlist1.transform.localPosition
        self.tweenposition_btnlist1.to=self.tweenposition_btnlist1.transform.localPosition+Vector3(-500,0,0)

        self.tweenposition_btnlist2 = self.btn_group:Get(3)
        self.tweenposition_btnlist2.from=self.tweenposition_btnlist2.transform.localPosition
        self.tweenposition_btnlist2.to=self.tweenposition_btnlist2.transform.localPosition+Vector3(-550,0,0)

        self.itemlist1 = self.btn_group:Get(4)
        self.itemlist2 = self.btn_group:Get(5)

        self.tweenposition_btnlist1.duration = 0.25
        self.tweenposition_btnlist2.duration = 0.25
    end
    self.tp_btnlist = self.btn_group:Get(9)
    self:adaptive_btn()
end

function Option:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd =="firstTimeChargeBtn" then -- 首冲按钮
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("s首充")
        require("models.vipPrivileged.firstTopUp")(LuaItemManager:get_item_obejct("vipPrivileged"))
        if arg.activeSelf then
            arg:SetActive(false)
        end
        self:countdown_10(false)
    elseif cmd =="luckyDrawBtn" then -- 秘境寻宝
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        LuaItemManager:get_item_obejct("luckyDraw"):open()
        self:countdown_10(false)
    elseif cmd =="signBtn" then -- 签到
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("签到")
        gf_create_model_view("sign")
        self:countdown_10(false)
    elseif cmd =="dailyActivityBtn" then -- 日常活动
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("日常活动")
        gf_create_model_view("activeDaily")
        self:countdown_10(false)
    elseif cmd =="festivalActivityBtn" then -- 节日活动
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("节日活动")
        gf_create_model_view("officerPosition")
        -- gf_create_model_view("exam")
        self:countdown_10(false)
    elseif cmd =="loginBtn" then -- 15天签到
        require("models.sign.signLogin")()
    elseif cmd =="copyBtn" then -- 副本
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("副本")
        gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.STORY)
        -- gf_getItemObject("copy"):create_copy_view(require("enum.enum").COPY_TYPE_VIEW.STORY)
        -- gf_create_model_view("train")
        self:countdown_10(false)
    elseif cmd == "bagBtn" then -- 背包
        Sound:play_fx("bag_open",false,self.root) --进入背包音效
        self.bag_item = self.ui:add_model("bag")
        self:countdown_10(false)
    elseif cmd =="doubleEscortBtn" then -- 双倍护送
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("双倍护送")
        require("models.husong.doubleHusong")()
        self:countdown_10(false)
    elseif cmd =="welfareBtn" then -- 福利
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("福利")
        LuaItemManager:get_item_obejct("mall"):add_to_state()
        self:countdown_10(false)
    elseif cmd =="bossBtn"  then -- Boss
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("BOSS")
        gf_create_model_view("boss")
        self:countdown_10(false)
    elseif cmd =="righttopBtn"  then -- 
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
        if  ConfigMgr:get_config("mapinfo")[map_id].is_show_button == 0 then
           self:copy_shrink(not self.item_obj.is_shrink)
        else
           self:shrink_btn(not self.item_obj.is_shrink)
        end
        self:countdown_10(false)
    elseif cmd == "3v3" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 关闭按钮点击音效
        gf_create_model_view("pvp3v3")
        self:countdown_10(false)
    elseif cmd =="cardBtn" then -- 签到
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        print("七煞卡牌")
        gf_create_model_view("card")
        self:countdown_10(false)
    elseif cmd == "defense" then --魔族围城
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        gf_create_model_view("mozu")
        self:countdown_10(false)
    elseif cmd == "achievementBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        gf_create_model_view("achievement")
        self:countdown_10(false)
    elseif cmd == "xingpanBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        gf_create_model_view("astrolabe")
        self:countdown_10(false)
    elseif cmd == "serviceOpenActivityBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        gf_create_model_view("activeEx")
        self:countdown_10(false)
    elseif cmd == "bonfire" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        LuaItemManager:get_item_obejct("activeDaily"):active_enter(ConfigMgr:get_config("daily")[ClientEnum.DAILY_ACTIVE.BONFIRE])
        self:countdown_10(false)
    elseif cmd == "banquet" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        LuaItemManager:get_item_obejct("activeDaily"):active_enter(ConfigMgr:get_config("daily")[ClientEnum.DAILY_ACTIVE.BANQUET])
        self:countdown_10(false)
    end
end

function Option:shrink_btn(tf)
    self.item_obj.is_shrink = tf
    self.righttopImg = self.btn_group:Get(1)
    if tf then
        self.righttopImg.transform.localScale=Vector3(-1,1,1)
        self.righttopImg.transform.localPosition =Vector3 (-8,-2.4,0)
        --缩起来
        self.tweenposition_btnlist1:PlayReverse()
        self.tweenposition_btnlist2:PlayReverse()
        self:hide_btn()
        self:adaptive_btn()
    else
        self.righttopImg.transform.localScale=Vector3(1,1,1)
        self.righttopImg.transform.localPosition =Vector3 (-3.2,-2.4,0)
        --放出来
        self.tweenposition_btnlist1:PlayForward()
        self.tweenposition_btnlist2:PlayForward()
        self:show_btn()
        self:adaptive_btn()
    end
end
local level_a = {
    [1] = 0.1,
    [2] = 0.2,
    [3] = 0.3,
    [4] = 0.4,
    [5] = 0.5,
    [6] = 0.6,
    [7] = 0.7,
    [8] = 0.8,
    [9] = 0.9,
}

function Option:hide_btn()
    local level_1 = 0
    for i=1,self.itemlist1.Length do
        if self.itemlist1:Get(i).gameObject.activeSelf then
            level_1= level_1+1
            self.itemlist1:Get(i).from = 1
            self.itemlist1:Get(i).to = level_a[level_1]
            self.itemlist1:Get(i):PlayReverse()
        end
    end
    local level_2 = 0
    for i=1,self.itemlist2.Length do
        if self.itemlist2:Get(i).gameObject.activeSelf then
            level_2= level_2+1
            self.itemlist2:Get(i).from = 1
            self.itemlist2:Get(i).to = level_a[level_2]
            self.itemlist2:Get(i):PlayReverse()
        end
    end
end

function Option:show_btn()
    local level_1 = 0
    for i = self.itemlist1.Length,1,-1 do
        if self.itemlist1:Get(i).gameObject.activeSelf then
            level_1= level_1+1
            self.itemlist1:Get(i).from = level_a[level_1]
            self.itemlist1:Get(i).to = 1
            self.itemlist1:Get(i):PlayForward()
        end
    end
    local level_2 = 0
    for i = self.itemlist2.Length,1,-1 do
        if self.itemlist2:Get(i).gameObject.activeSelf then
            level_2= level_2+1
            self.itemlist2:Get(i).from = level_a[level_2]
            self.itemlist2:Get(i).to = 1
            self.itemlist2:Get(i):PlayForward()
        end
    end
end
--自适应按钮
function Option:adaptive_btn()
   local obj1 = self.btn_group:Get(6)
   local btn_count1 = 0
   for i=1,obj1.Length do
       if obj1:Get(i).gameObject.activeSelf then
        btn_count1 = btn_count1 +1
       end
   end
   local tf1 = self.btn_group:Get(4).gameObject.transform.localPosition
   self.btn_group:Get(4).gameObject.transform.localPosition = Vector3(105.4399-btn_count1*75.5,tf1.y,tf1.z)
   local obj2 = self.btn_group:Get(7)
   local btn_count2 = 0
   for i=1,obj2.Length do
       if obj2:Get(i).gameObject.activeSelf then
        btn_count2  = btn_count2 +1
       end
   end
   local tf2 = self.btn_group:Get(5).gameObject.transform.localPosition
   self.btn_group:Get(5).gameObject.transform.localPosition = Vector3(105.22-btn_count2*75.5,tf2.y,tf2.z)
end

function Option:copy_in()
    if self.item_obj.shrink_copy then 
        self:copy_shrink(true)
        return 
    end
    self.item_obj.shrink_copy = true
    self.tweenposition_btnlist1.duration = 0.01
    self.tweenposition_btnlist2.duration = 0.01
    self:shrink_btn(false)
    self.tweenposition_btnlist1.duration = 0.25
    self.tweenposition_btnlist2.duration = 0.25

    self.item_obj.is_shrink = true
    self.righttopImg.transform.localScale=Vector3(-1,1,1)
    self.righttopImg.transform.localPosition =Vector3 (-8,-2.4,0)

    self.tp_btnlist.from=self.tp_btnlist.transform.localPosition
    self.tp_btnlist.to=self.tp_btnlist.transform.localPosition+Vector3(610,0,0)
    self.tp_btnlist.duration = 0.01
    self.tp_btnlist:PlayForward()
    self.tp_btnlist.duration = 0.25
end

function Option:copy_not_map()
    self.btn_group:Get(8).localPosition =  self.btn_group:Get(8).localPosition + Vector3(-50,0,0)
end

function Option:copy_map()
    self.btn_group:Get(8).localPosition =  self.btn_init_pos
end

function Option:copy_out()
    if not self.item_obj.shrink_copy then return end
    self.item_obj.shrink_copy = false
    self.tp_btnlist.duration = 0.01
    self.tp_btnlist:PlayReverse()
    self.tp_btnlist.duration = 0.25
    self.tweenposition_btnlist1.duration = 0.01
    self.tweenposition_btnlist2.duration = 0.01
    self:shrink_btn(true)
    self.tweenposition_btnlist1.duration = 0.25
    self.tweenposition_btnlist2.duration = 0.25
end

function Option:copy_shrink(tf)
    self.item_obj.is_shrink = tf
    if tf then
        self.righttopImg.transform.localScale=Vector3(-1,1,1)
        self.righttopImg.transform.localPosition =Vector3 (-8,-2.4,0)
        self.tp_btnlist:PlayForward()
    else
        self.righttopImg.transform.localScale=Vector3(1,1,1)
        self.righttopImg.transform.localPosition =Vector3 (-3.2,-2.4,0)
        self.tp_btnlist:PlayReverse()
    end
end

function Option:countdown_10(tf)
    self.countdown_time = 10
    if tf then
        if self.countdown then
            self.countdown:stop()
            self.countdown = nil
        end
            self.countdown = Schedule(handler(self, function()
                         self.ui:show_atk_panel(true)
                        local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
                        if  ConfigMgr:get_config("mapinfo")[map_id].is_show_button == 0 then
                            if not self.item_obj.is_shrink then
                                self:copy_shrink(not self.item_obj.is_shrink)
                            end
                        else
                            self:shrink_btn(not self.item_obj.is_shrink)
                        end
                        self.countdown:stop()
                        self.countdown = nil
                    end), self.countdown_time)
    else
        if self.countdown then
            self.countdown:stop()
            self.countdown = nil
        end
    end
end


function Option:dispose()

end

return Option
