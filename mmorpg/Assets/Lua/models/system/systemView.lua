--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-25 15:38:47
--]]

local delay = delay
local LuaHelper=LuaHelper
local CUtils = CUtils
local get_value = get_value --多国语言
local Vector3 = UnityEngine.Vector3
local Screen = UnityEngine.Screen
local CSNameSpace = CSNameSpace

local SystemView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "systemui.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function SystemView:on_asset_load(key,asset)
    self:register()
	self:init_ui()
end

--初始化UI
function SystemView:init_ui()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	 --得到系统UI
	self.system_ui=refer:Get(1)
end
--注册事件
function SystemView:register()
    self.item_obj:register_event("system_view_on_clict", handler(self, self.on_click))
end


--进入主UI动画
function SystemView:on_showed()
	LeanTween.move(self.system_ui,Vector3(Screen.width/2,Screen.height/2,0),0.75)
	self.system_ui.transform.position=Vector3(Screen.width/2,Screen.height/2+700,0)
end

--点击事件
function SystemView:on_click(item_obj, obj,arg)
	local           cmd = obj.name
	--点击关闭按钮
	if	            cmd =="system_closebtn"        then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	LeanTween.move(self.system_ui,Vector3(Screen.width/2+1400,Screen.height/2,0),0.75)
	--类似C#协程 在1S后执行cb
	local cb = function()
	      --关闭self.system_ui
		  local item = LuaItemManager:get_item_obejct("system")
          item:remove_from_state()	
	      end
	PLua.Delay(cb,1)
    
    --点击声音按钮
    elseif          cmd =="AudioButton"        then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    --点击联系我们按钮
    elseif          cmd =="ContactButton"	   then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    --点击更改角色按钮
    elseif          cmd =="ChangeRoleButton"   then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    --点击退出游戏按钮	
    elseif          cmd =="QuitButton"         then	
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    end
end




-- 释放资源
function SystemView:dispose()
	self.item_obj:register_event("system_view_on_clict", nil)
    self._base.dispose(self)
 end

return SystemView

	