--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-27 12:33:23
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Screen = UnityEngine.Screen
local parent = UnityEngine.parent
local position = UnityEngine.position
local Time = UnityEngine.Time

local CombatView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "trascriptmap.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function CombatView:on_asset_load(key,asset)
    self:register()
	self:init_ui()
	self.total_time=0
end
--初始化UI
function CombatView:init_ui()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	 --得到系统UI
	self.combat_ui=refer:Get(1)
	--选择战斗方式UI
	self.trascriptmapdialog_ui=refer:Get(2)
	--倒计时UI
	self.timedialog_ui=refer:Get(3)
    --倒计时时间
    self.wait_time_text=refer:Get(4)
end

--进入动画
function CombatView:on_showed()
    --每次mainui上点击战斗就刷新
    --位置更新
    self.combat_ui.transform.position=Vector3(Screen.width/2,Screen.height/2+700,0)
    --移动
	LeanTween.move(self.combat_ui,Vector3(Screen.width/2,Screen.height/2,0),0.5)
	
end


--注册事件
function CombatView:register()
    --点击事件
    self.item_obj:register_event("combat_view_on_clict", handler(self, self.on_click))
    --Update事件
    gf_register_update(self)
end


local timer = 0
--Update
function CombatView:on_update(dt)
    --倒计时
    timer=timer+Time.deltaTime
    if    timer >=1  then
    self.total_time = self.total_time - 1 
    timer=0
    end
       --倒计时数据的更新
       if     self.total_time >  0 then
       	self.wait_time_text.text=self.total_time
	   elseif self.total_time <= 0 then
	   	--时间为0时进行的时间
	   end

end


--点击事件
function CombatView:on_click(item_obj, obj,arg)
	local           cmd = obj.name
	--点击返回按钮
	if	            cmd =="transript_closebtn"        then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	 LeanTween.move(self.combat_ui,Vector3(Screen.width/2+2400,Screen.height/2,0),0.5)
	 --类似C#协程 在1S后执行cb
	 local cb = function()
	      --关闭self.combat_ui
		  local item = LuaItemManager:get_item_obejct("combat")
          item:remove_from_state()	
	      end
	 PLua.Delay(cb,1)
     --战斗房间按钮
	elseif          cmd =="BtnTranscript"             then
                Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self.trascriptmapdialog_ui:SetActive(true)
     --团队战斗
    elseif          cmd =="BtnEnterTeam"              then
                Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--团队战斗的方式
    	self.timedialog_ui:SetActive(true)
    	--倒计时方法
        self.total_time = 10
     --个人战斗
    elseif          cmd =="BtnEnterPerson"            then
                Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--个人战斗的方式
    	self.timedialog_ui:SetActive(true)
    	--倒计时方法
        self.total_time = 10
    --关闭房间按钮
    elseif          cmd =="dialog_closebtn"           then
                Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--关闭与取消按钮
    	obj.transform.parent.gameObject:SetActive(false)
        --取消倒计时按钮
    elseif          cmd =="time_closebtn"             then
                Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	obj.transform.parent.gameObject:SetActive(false)
    end
end




-- 释放资源
function CombatView:dispose()
	self.item_obj:register_event("combat_view_on_clict", nil)
	gf_remove_update(self)
    self._base.dispose(self)
 end

return CombatView

