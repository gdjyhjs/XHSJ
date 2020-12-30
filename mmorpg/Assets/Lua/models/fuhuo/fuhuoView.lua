--[[--
--
-- @Author:Seven
-- @DateTime:2017-05-08 20:29:13
--]]

local commom_string = 
{
	[1] = gf_localize_string("本次挑战失败，可以通过以下途径变强！"),
	[2] = gf_localize_string("此仇不报非君子，可以通过以下途径变强！"),
}

local show_type = 
{
	normal 			= 1,
	bekill  		= 2,
}

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local FuhuoView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "fuhuo.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

function FuhuoView:init()
	self.level=LuaItemManager:get_item_obejct("game").role_info.level
	self.item_obj.recovermedicine=self:recovermedicine_amount() --回魂丹数量
	self.item_obj.goldlock = self:goldlock_amount() -- 绑定金币数量
	self.item_obj.recovertime=30 --恢复时间
	-- self.item_obj.time = 0 --原地恢复次数
	-- self.item_obj.recover_time = 0 --恢复次数
	-- self.item_obj.lengque_time=0 --原地恢复冷却时间
	-- self.item_obj.isrotate = false
	if LuaItemManager:get_item_obejct("setting"):get_setting_value(ClientEnum.SETTING.REVIVE) then
		if self.item_obj.recovermedicine == 0 then
			gf_message_tips("<color="..gf_get_color_by_item(40070301)..">回魂丹</color>数量不足无法自动原地恢复")
		end
	end
	self:islengque()  --原地复活冷却
	self.other_player,self.other_player_level = LuaItemManager:get_item_obejct("battle"):get_attacker_name_and_level()
	self.refer:Get("txt_fuhuo"):SetActive(true)
	
	if self.item_obj.time > self.item_obj.cool_time then
		self:die_again()
	end
	 --初始化恢复按钮
	self.current_txttime = self:init_chooseButton()
	self.current_txttime.text=self.item_obj.recovertime
	self:title_set()

	--按钮状态初始化
	self:button_state_set()
end

function FuhuoView:button_state_set()
	if self.type == show_type.normal then
		self.one:SetActive(false)
		self.two:SetActive(false)
		self.three:SetActive(false)
	end
end


function FuhuoView:title_set()

	self.other_player_name = self.refer:Get("other_player_name")
	self.other_player_name.text = self.other_player.."(lv".. self.other_player_level ..")"

	if self.type == show_type.normal then
		self.other_player_name.text = ""
		self.refer:Get(25).text = commom_string[1]
	else
		self.refer:Get(25).text = commom_string[2]
	end

end

-- 资源加载完成
function FuhuoView:on_asset_load(key,asset)
	--初始化
	self:init_ui()
	self:init()
	self:register()
	--开始倒计时
	self.t=Schedule(handler(self,self.countdown),1)
end

function FuhuoView:on_update(dt)
	if self.item_obj.isrotate then
		self:lengque_round(dt)
	end
end

--圆形冷却
function FuhuoView:lengque_round(dt)
	if self.current_image then
		self.current_image.fillAmount = self.current_image.fillAmount - (dt/self.sum_time)
		if self.current_image.fillAmount < 0.03 then
			self.current_image.fillAmount=0
			self.item_obj.isrotate=false
		end
	end
end

--初始化UI
function FuhuoView:init_ui()
	self.bg = self.refer:Get("bg")
	--新手恢复倒计时
 	self.txttime1=self.refer:Get("txt_time1")
 	self.txttime2=self.refer:Get("txt_time2")
	self.txttime3=self.refer:Get("txt_time3")
	--回魂丹数量
	self.recovermedicinenumber=self.refer:Get("txt_number")
	
	--判断显示的UI界面
	self.one=self.refer:Get("1")--新手
	self.two=self.refer:Get("2")--非新手有回魂丹
	self.three=self.refer:Get("3")--非新手无回魂丹
	
	--3个原地恢复按钮和文字
 	self.recoverButton1=self.refer:Get("btn_ThisPiont1")
 	self.recoverButton2=self.refer:Get("btn_ThisPiont2")
 	self.recoverButton3=self.refer:Get("btn_ThisPiont3")

 	self.recovertxt1=self.refer:Get("txt_ThisP1")
 	self.recovertxt2=self.refer:Get("txt_ThisP2")
 	self.recovertxt3=self.refer:Get("txt_ThisP3")
 	--3个冷却图片和3个时间
 	self.lengqueimage1=self.refer:Get("image_ThisPoint1")
 	self.lengqueimage2=self.refer:Get("image_ThisPoint2")
 	self.lengqueimage3=self.refer:Get("image_ThisPoint3")

 	self.lengquetxt1=self.refer:Get("txt_ThisPoint1")
 	self.lengquetxt2=self.refer:Get("txt_ThisPoint2")
 	self.lengquetxt3=self.refer:Get("txt_ThisPoint3")
 	local icon = ConfigMgr:get_config("item")[40070301].icon
 	gf_setImageTexture(self.refer:Get("img_fuhuo"),icon)
 	gf_set_money_ico(self.refer:Get("money_icon"),ServerEnum.BASE_RES.GOLD)
end
--初始化恢复按钮
function  FuhuoView:init_chooseButton()
	if self.level<self.item_obj.newcomerlevel then
		self.one:SetActive(true)
		self.two:SetActive(false)
		self.three:SetActive(false)
		return self.txttime1
	elseif self.item_obj.recovermedicine > 0 then
		self.one:SetActive(false)
		self.two:SetActive(true)
		self.three:SetActive(false)
		self.recovermedicinenumber.text=(self.item_obj.recovermedicine .. "/1")
		return self.txttime2
	else
		self.one:SetActive(false)
		self.two:SetActive(false)
		self.three:SetActive(true)
		return self.txttime3
 	end
	self.lengqueimage1.gameObject:SetActive(false)
 	self.lengqueimage2.gameObject:SetActive(false)
 	self.lengqueimage3.gameObject:SetActive(false)
end

--注册
function  FuhuoView:register()
	--注册点击事件
	self.item_obj:register_event("fuhuo_view_on_click",handler(self,self.on_click))
	gf_register_update(self) --注册每帧事件
end

function FuhuoView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("scene") then
		if id2== Net:get_id2("scene", "RespawnR") then
			if msg.guid ~= LuaItemManager:get_item_obejct("battle"):get_character().guid then
				return
			end
			self:dispose()
			if self.item_obj.time == 0 then
				LuaItemManager:get_item_obejct("battle"):get_character():reset_camera()
			end
		end
	end
end

--点击事件
function FuhuoView:on_click (item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了",cmd) 
	if cmd == "btn_ThisPiont1" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--点击新手的原地恢复
		self.item_obj:thispoint()
	elseif cmd == "btn_ThisPiont2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--点击消耗回魂丹的原地恢复
		self.item_obj:thispoint()
	elseif cmd == "btn_ThisPiont3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- 点击消耗金币的原地恢复
		if LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.GOLD) >=10 then
			self.item_obj:thispoint()
		else
			gf_message_tips(gf_localize_string("元宝不足，请充值"))
		end
	elseif cmd == "btn_RecoverPiont2" or cmd == "btn_RecoverPiont3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- 恢复点恢复
		self:recoverpiont()
	end
end

--倒计时恢复
function FuhuoView:countdown()
	self.item_obj.recovertime = self.item_obj.recovertime-1
	self.current_txttime.text=self.item_obj.recovertime
	--判断恢复
	if self.item_obj.recovertime == 0 then
		self.t:stop()
		self.t = nil
		if self.level<self.item_obj.newcomerlevel then
			self.item_obj:thispoint()
		else 
			self:recoverpiont()
		end
	end
end

function FuhuoView:show_button(tf)
	if self.level < self.item_obj.newcomerlevel then
	 	self.recoverButton1.enabled = tf
	elseif self.item_obj.recovermedicine > 0 then
		self.recoverButton2.enabled = tf 
	elseif  self.item_obj.recovermedicine == 0 then
		self.recoverButton3.enabled = tf
 	end
end

local counttime = {3,6,10}

--判断冷却
function FuhuoView:islengque()
	if self.item_obj.time > self.item_obj.cool_time then
		self:show_button(false)
		self.s=Schedule(handler(self,self.lengque_thispoint),1)
		if self.item_obj.time < self.item_obj.cool_time+4 then
			self.item_obj.lengque_time = counttime[(self.item_obj.time-self.item_obj.cool_time)]
			self.current_time = self.item_obj.lengque_time
		else
			self.item_obj.lengque_time = counttime[#counttime]
		end
		self.sum_time=self.item_obj.lengque_time
		self.item_obj.isrotate = true
	end
end

--原地复活恢复冷却
function  FuhuoView:lengque_thispoint()

	self.item_obj.lengque_time = self.item_obj.lengque_time-1
	--冷却图片文字更新
	self.current_txt.text=(self.item_obj.lengque_time .. "s")
	print("恢复冷却时间",self.item_obj.lengque_time)
	if self.item_obj.lengque_time == 0 then
			self.s:pause()
		print("恢复冷却完成")
		if self.current_time<= #counttime then
			self.current_txt.text=(counttime[self.current_time] .. "s")
		else
			self.current_txt.text=(counttime[#counttime] .. "s")
		end
		self:left_recover()
	end
end

function FuhuoView:left_recover()
	self:show_button(true)
	self.current_image.gameObject:SetActive(false)
	self.current_image.fillAmount=1
	self.current_text:SetActive(true)
end

--复活点恢复方法
function  FuhuoView:recoverpiont()
	if self.item_obj.time>self.item_obj.cool_time then
		self:left_recover()
	end
	self.item_obj:recover_piont()
	--[[废除 现在复活点复活由服务器去创建玩家]]
	-- local char = LuaItemManager:get_item_obejct("battle"):get_character()
	-- local mapid = LuaItemManager:get_item_obejct("game"):get_map_id()
	-- local x = ConfigMgr:get_config("mapinfo")[mapid].revive_point[2]
	-- local y = ConfigMgr:get_config("mapinfo")[mapid].revive_point[3]
	-- local ps = LuaItemManager:get_item_obejct("battle"):covert_s2c_position(x,y)
	-- char:set_position(ps)
	-- self:dispose()
end

--原地复活方法
-- function FuhuoView:thispoint()
-- 	self.item_obj.time=self.item_obj.time+1
-- 	self.item_obj.recover_time = self.item_obj.recover_time +1
-- 	LuaItemManager:get_item_obejct("battle"):respawn_c2s(2)
-- 	-- self:dispose()
-- end

--再一次打开需要冷却的更新
function FuhuoView:lengque_image()
	--冷却图片文字更新
	if self.level < self.item_obj.newcomerlevel then
		self.lengqueimage1.gameObject:SetActive(true)
		self.recovertxt1:SetActive(false)
		return self.lengqueimage1,self.lengquetxt1,self.recovertxt1
	elseif self.item_obj.recovermedicine > 0 then
		self.lengqueimage2.gameObject:SetActive(true)
		self.recovertxt2:SetActive(false)
		return self.lengqueimage2,self.lengquetxt2,self.recovertxt2
	elseif  self.item_obj.recovermedicine == 0 then
		self.lengqueimage3.gameObject:SetActive(true)
		self.recovertxt3:SetActive(false)
		return self.lengqueimage3,self.lengquetxt3,self.recovertxt3
	end
end
-- 获取背包回魂丹数量
function FuhuoView:recovermedicine_amount()
	local amount1 = LuaItemManager:get_item_obejct("bag"):get_item_count(40070301,Enum.BAG_TYPE.NORMAL)
	-- local amount2 = LuaItemManager:get_item_obejct("bag"):get_item_count(40071301,Enum.BAG_TYPE.NORMAL)
	return amount1
end
--获取绑定金币
function FuhuoView:goldlock_amount()
	local game = LuaItemManager:get_item_obejct("game")
	return game.role_info.baseRes[Enum.BASE_RES.BIND_GOLD]
end

--原地复活再死一次调的方法
function FuhuoView:die_again()
	self.current_image,self.current_txt,self.current_text = self:lengque_image()
	--显示后马上出字
	self.current_txt.text=(self.item_obj.lengque_time .. "s")
end

--每次显示调用
-- function FuhuoView:on_showed()
	-- if self.item_obj.recover_time >0 then
	-- 	self.t:resume()
	-- 	self.current_txttime.text = 30
	-- 	self.current_txttime = self:init_chooseButton()
	-- end
	-- if self.item_obj.time>0 then
	-- 	self:die_again()
	-- 	self.s:resume()
	-- end
-- end

-- function FuhuoView:on_hided()
-- 	 self.bg.enable = true
-- 	gf_remove_update(self)
-- 	self.item_obj:register_event("fuhuo_view_on_click",nil)
-- end

-- 释放资源
function FuhuoView:dispose()
	if self.current_image then
		self.current_image = nil
	end
	if self.t then
		self.t:stop()
		self.t = nil
	end
	if self.s then
		self.s:stop()
	end
	self.item_obj:register_event("fuhuo_view_on_click",nil)
	gf_remove_update(self)
    self._base.dispose(self)
 end

return FuhuoView

