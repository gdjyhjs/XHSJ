--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-11 16:57:23
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local DoubleHusong=class(UIBase,function(self)
	self.item_obj = LuaItemManager:get_item_obejct("husong")
    UIBase._ctor(self, "double_escort.u3d", self.item_obj) -- 资源名字全部是小写
    self:set_level(	UIMgr.LEVEL_10)
end)

-- 资源加载完成
function DoubleHusong:on_asset_load(key,asset)
	StateManager:register_view(self)
	local i_id1 = ConfigMgr:get_config("base_res")[ServerEnum.BASE_RES.EXP].item_code
	local obj1 = self.refer:Get(1)
	gf_set_item(i_id1,obj1:Get(1),obj1:Get(2))
	gf_set_click_prop_tips(obj1.gameObject,i_id1)
	local i_id2 = ConfigMgr:get_config("base_res")[ServerEnum.BASE_RES.FAME].item_code
	local obj2 = self.refer:Get(2)
	gf_set_item(i_id2,obj2:Get(1),obj2:Get(2))
	gf_set_click_prop_tips(obj2.gameObject,i_id2)
	self.refer:Get(5).text = self.item_obj.todayTimes
	local  data = ConfigMgr:get_config("daily")[2002].day_time
	self.refer:Get(6).text =  gf_localize_string("双倍护送时间："..string.format("%02d:%02d-%02d:%02d、%02d:%02d-%02d:%02d",data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8]))
	if self.item_obj.quality5Times >= 15 then--ConfigMgr:get_config("t_misc")
		self.refer:Get(3):SetActive(false)
	else
		self.refer:Get(4).text = self.item_obj.quality5Times
	end
end
function DoubleHusong:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_escort" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		-- self.escort_item = self.ui:add_model("husong")
		if  self.item_obj:is_husong() then
			Net:receive({code = self.item_obj.husong_info.taskCode},ClientProto.HusongNPC)
		else
			self.item_obj:transfer_husong()
		end
       self.schedule_dispose = Schedule(handler(self, function()
			self:dispose()
			self.schedule_dispose:stop()
			self.schedule_dispose= nil
		end), 0.1)
    elseif cmd == "closeBtn" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN)
    	self:dispose()
	end
end

-- 释放资源
function DoubleHusong:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return DoubleHusong

