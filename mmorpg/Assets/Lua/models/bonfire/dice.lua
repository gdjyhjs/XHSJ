--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-18 17:29:55
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Dice=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "legion_dice.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Dice:on_asset_load(key,asset)
	self.image_discolor_material = self.refer:Get("image_discolor_material").material
	print(self.image_discolor_material)
	self.deic_end_flag = 4
	self.txtCountdown = self.refer:Get("txtCountdown") -- 倒计时文本
	self.dice_objs = {self.refer:Get("dice1"),self.refer:Get("dice2"),self.refer:Get("dice3")}
	self.dice_eff = {self.refer:Get("eff1"),self.refer:Get("eff2"),self.refer:Get("eff3")}
	self.eff_imgs = {self.refer:Get("eff_img1"),self.refer:Get("eff_img2"),self.refer:Get("eff_img3")}

	if self.item_obj.diceNo>0 and not self.item_obj.showDice then
		self:throw_dice()
	elseif self.item_obj.diceNo>0 and self.item_obj.showDice then -- 已经显示点数了
		self.refer:Get("throw_btn").material = self.image_discolor_material
		self:set_dice()
	else
		self.down_time = math.floor(self.item_obj.endTime - Net:get_server_time_s())
		self.down_time = self.down_time > 65 and 60 or math.floor(self.down_time-5)
		print("设置倒计时为",self.down_time)
		self.item_obj:AllianceNeedfireDice_c2s()
	end
	self.init = true

	print("-- 预加载图片")
	local image = self.refer:Get("Image")
	gf_setImageTexture(image,"army_group_dice_roll_05")
	gf_setImageTexture(image,"army_group_dice_roll_06")
end

function Dice:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击ui",cmd,obj,arg)
	if cmd == "closeBonfire" then -- 关闭
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
		self:dispose()
	elseif cmd == "throw_btn" then -- 投点
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		if self.item_obj.showDice then
			gf_message_tips("已经投过了，今天不能在投了。")
		else
			self:throw_dice()
		end
	end
end

--投掷骰子
function Dice:throw_dice()
	self.refer:Get("throw_btn").material = self.image_discolor_material
	self.down_time = math.floor(Net:get_server_time_s() - self.item_obj.endTime)
	self.down_time = self.down_time<-5 and -5 or self.down_time
	local nums = {self.item_obj.diceNo%10,math.floor(self.item_obj.diceNo%100/10),math.floor(self.item_obj.diceNo/100)}
	for i,v in ipairs(self.dice_objs) do
		v.gameObject:SetActive(false)
		self.dice_eff[i]:SetActive(true)
	end
	
end

--设置点数
function Dice:set_dice()
	self.deic_end_flag = 4
	self.down_time = -1
	local nums = {self.item_obj.diceNo%10,math.floor(self.item_obj.diceNo%100/10),math.floor(self.item_obj.diceNo/100)}
	for i,v in ipairs(self.dice_objs) do
		gf_setImageTexture(v,"army_group_dice_0"..nums[i])
		v.gameObject:SetActive(true)
		self.dice_eff[i]:SetActive(false)
	end
	self.item_obj.showDice = true
	self.txtCountdown.text = (nums[1]+nums[2]+nums[3]).."点"
end

--[[ 0 到 69为倒计时
	-5 到 -1 为正在投点
	0.9 
]]
function Dice:on_update(dt)
	local num = math.floor(self.down_time)
	print("剩余时间：xx 秒",num,self.down_time)
	if num > 0 then
		self.down_time = self.down_time - dt
		if self.down_time<=0 then
			self.down_time = 0
		end
		self.txtCountdown.text = string.format(gf_localize_string("剩余时间：%d 秒"),num)
	elseif num == 0 then
		self:throw_dice()
		self.txtCountdown.text = string.format(gf_localize_string("剩余时间：%d 秒"),0)
	elseif num < -1 then
		self.down_time = self.down_time + dt
		if self.down_time > -1 then
			self.down_time = -1
		end
		self.txtCountdown.text = string.format(gf_localize_string("剩余时间：%d 秒"),0)
	elseif num == -1 and not self.item_obj.showDice then
		self.deic_end_flag = self.deic_end_flag + 1
		if self.deic_end_flag < 7 then
			self:set_end_white(self.deic_end_flag)
		else
			self:set_dice()
		end
	end
end

-- 设置结束的白
function Dice:set_end_white(value)
print("设置借宿的白")
	for i,v in ipairs(self.eff_imgs) do
		print("设置图","army_group_dice_roll_0"..value)
		gf_setImageTexture(v,"army_group_dice_roll_0"..value)
	end
end

function Dice:register()
    StateManager:register_view( self )
	gf_register_update(self) --注册每帧事件
end

function Dice:cancel_register()
    StateManager:remove_register_view( self )
	gf_remove_update(self) --注销每帧事件
end

function Dice:on_showed()
	self:register()
end

-- 释放资源
function Dice:dispose()
	self.item_obj.showDice = true
	self.init = nil
	self:cancel_register()
    self._base.dispose(self)
 end

return Dice
