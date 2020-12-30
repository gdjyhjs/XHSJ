--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-27 14:01:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Screen = UnityEngine.Screen
local position = UnityEngine.position

local HeadView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "playerstatus.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function HeadView:on_asset_load(key,asset)
    self:register()
	self:init_ui()
end

--注册事件
function HeadView:register()
    self.item_obj:register_event("head_view_on_clict", handler(self, self.on_click))
end

--初始化UI
function HeadView:init_ui()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	--得到系统UI
	self.head_ui=refer:Get(1)
	--得到changenameUI
	self.head_changename_ui=refer:Get(2)
    --得到姓名
    self.head_text=refer:Get(3)
    --得到要修改的输入的名字
    self.head_changename_text=refer:Get(4)
   
    
end

--进入主UI动画
function HeadView:on_showed()
	LeanTween.move(self.head_ui,Vector3(Screen.width/2,Screen.height/2,0),0.75)
	self.head_ui.transform.position=Vector3(Screen.width/2,Screen.height/2+700,0)
end

--点击事件
function HeadView:on_click(item_obj, obj,arg)
	local           cmd = obj.name
	    --点击关闭按钮
	if	            cmd =="CloseButton"        then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	    LeanTween.move(self.head_ui,Vector3(Screen.width/2+1400,Screen.height/2,0),0.75)
	    --类似C#协程 在1S后执行cb
	    local cb = function()
	    --关闭self.system_ui
		local item = LuaItemManager:get_item_obejct("head")
        item:remove_from_state()	
	    end
	    PLua.Delay(cb,1)
	    --点击改名按钮
    elseif          cmd =="ButtonChangeName"   then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

        self.head_changename_ui:SetActive(true)
        --点击确定
    elseif          cmd =="SureButton"         then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	--更改名字
    	self.head_text.text=self.head_changename_text.text
    	--得到主UI上的方法
    	LuaItemManager:get_item_obejct("mainui").assets[1]:set_play_name(self.head_text.text)
    	--关闭改名窗
    	self.head_changename_ui:SetActive(false)

    elseif          cmd =="CancelButton"	   then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        --关闭改名窗	
        self.head_changename_ui:SetActive(false)
    end
end



-- 释放资源
function HeadView:dispose()
	self.item_obj:register_event("head_view_on_clict", nil)
    self._base.dispose(self)
 end

return HeadView

