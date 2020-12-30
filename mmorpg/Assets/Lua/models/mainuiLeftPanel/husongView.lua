--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-22 12:01:11
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local leftPanelBase = require("models.mainuiLeftPanel.leftPanelBase")

local HusongView=class(leftPanelBase,function(self,item_obj,...)
	self.level = UIMgr.LEVEL_10
    leftPanelBase._ctor(self, "mainui_husong.u3d", item_obj,...) -- 资源名字全部是小写
end)

local hs_state = 
{
	[1] =gf_localize_string("正在护送中"),
	[2] = gf_localize_string("丢失中"),
	[3] = gf_localize_string("任务失败"),
}
local btn_txt = 
{
	[1] = gf_localize_string("继续护送"),
	[2] = gf_localize_string("寻回美人"),
	[3] = gf_localize_string("提交任务"),
}


-- 资源加载完成
function HusongView:on_asset_load(key,asset)
	self.is_init = true
	self.beauty_name = self.refer:Get("beauty_name")  --美人名字
	self.husong_state = self.refer:Get("husong_state") --护送状态
	self.husong_time = self.refer:Get("husong_time")  --护送时间
	self.btn_text = self.refer:Get("btn_text")  --护送按钮

	self.tween = self.refer:Get("tween")
	self:init_tween()
	-- self:hide()

	self:on_showed()
	HusongView._base.on_asset_load(self,key,asset)
end

function HusongView:init_tween()
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("husong_rt").anchoredPosition = Vector2(dx, self.refer:Get("husong_rt").anchoredPosition.y)
end

function HusongView:update_state(txt)
	self.husong_state.text = txt
end

function HusongView:update_btn_text(txt)
	self.btn_text.text = txt
end

-- function HusongView:show_view( show )
-- 	if not self.tween then
-- 		return
-- 	end
-- 	if show then
-- 		self.tween:PlayReverse()
-- 	else
-- 		self.tween:PlayForward()
-- 	end
-- end

-- function HusongView:on_receive( msg, id1, id2, sid )
-- 	if id1 == Net:get_id1("task") then
-- 		if id2 == Net:get_id2("task", "EscortAcceptTaskR") then --接受货送任务返回
-- 			print("护送任务返回码",msg.err)
-- 			if msg.err  == 0 then 
-- 				self:update_info(msg.taskInfo)
-- 			end
-- 		elseif id2 == Net:get_id2("task", "EscortTaskInfoR") then --护送任务信息 
-- 			self:update_info(msg)
-- 		end
-- 	end
-- end

function HusongView:update_info(data)
	self.beauty_name.text = "<color="..ConfigMgr:get_config("color")[data.quality-1].color ..">"..ConfigMgr:get_config("task_escort_quality")[data.quality].name.."</color>"
	self.isFail = data.isFail
	if data.isFail == 0 then  --成功
		self:update_state(hs_state[1])
		self:update_btn_text(btn_txt[1])
		self.finish_time = data.endTime
	elseif data.isFail ==1 then--失败
		self:update_state(hs_state[3])
		self:update_btn_text(btn_txt[3])
	end
	self.husong_task_code = data.taskCode
end

function HusongView:on_click(obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "keep_on_husong" then 
		if arg.text == btn_txt[1] then
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			Net:receive({code = self.husong_task_code},ClientProto.HusongNPC)
		elseif arg.text == btn_txt[2] then
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

		elseif arg.text == btn_txt[3] then  --提交任务
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			if self.isFail == 1 then
				LuaItemManager:get_item_obejct("husong"):escort_finish_fail_c2s()
			elseif self.isFail == 0 then
				LuaItemManager:get_item_obejct("husong"):escort_finish_ok_c2s()
			end
		end
	end
end


function HusongView:on_update( dt )
	if self.countdown then
		self.husong_s = self.husong_s-dt
		if self.husong_s <0 then
			self.husong_m = self.husong_m -1
			self.husong_s = 59
		end
		self.husong_time.text = string.format("%02d:%02d",self.husong_m,self.husong_s)
		if self.husong_m < 0 then
			self.schedule:stop()
			self.schedule = nil
			self:update_state(hs_state[3])
			self:update_btn_text(btn_txt[3])
			self.isFail = 1
			LuaItemManager:get_item_obejct("husong").isExpired = 1
			self.countdown = false
			self.husong_time.text =""
		end
	end
end

function HusongView:register()
	StateManager:register_view( self )
	if not self.schedule then
		self.schedule = Schedule(handler(self, self.on_update), 1)
	end
end

function HusongView:cancel_register()
	StateManager:remove_register_view( self )
	if self.schedule then
		self.schedule:stop()
	end
	self.schedule = nil
end


function HusongView:on_showed()
	print("wtf self.is_init:",self.is_init)
	if self.is_init then
		local now_time = math.floor(Net:get_server_time_s())
		local data = LuaItemManager:get_item_obejct("husong")
		gf_print_table(data.husong_info,"护送信息")
		self:update_info(data.husong_info)
		if self.finish_time~=nil and now_time <= self.finish_time then
			local tb = gf_time_diff(self.finish_time,now_time)
			self.husong_s = tb.sec
			self.husong_m =	tb.min
			self.husong_time.text = string.format("%02d:%02d",tb.min,tb.sec)
			self.countdown = true
		else
			self.countdown = false
			self.husong_time.text =""
		end
	end
	self:register()
end

function HusongView:on_hided()
	self:cancel_register()
end

-- 释放资源
function HusongView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return HusongView

