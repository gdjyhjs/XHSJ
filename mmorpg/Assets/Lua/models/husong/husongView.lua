--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-01 17:19:02
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local NormalTipsView = require("common.normalTipsView")
local HusongView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "husong.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self:init()
end)

function HusongView:init()

end

-- 资源加载完成
function HusongView:on_asset_load(key,asset)
	print("加载完成护送界面")
	self:init_ui()
	self:register()
	self:init_information()
	self:init_behaviour()
end

--初始化ui
function HusongView:init_ui()
	self.img_place = self.refer:Get("img_place")
	self.place_img ={}
	local player_vip = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
	local add_lv = 0
	if player_vip == 0 then
		add_lv = ConfigMgr:get_config("vip")[1].battle_exp/100
		player_vip = 1
		self.no_vip = true
	else
		add_lv = ConfigMgr:get_config("vip")[player_vip].battle_exp/100
		self.no_vip = false
	end
	print("护送啊vip",player_vip)
	local player_lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local award = 0
	local fame = 0
	for k,v in pairs(self.item_obj.husong_data) do
		if k ~= #self.item_obj.husong_data then
			if player_lv >=v.level and player_lv < self.item_obj.husong_data[k+1].level then
				award = v.exp_reward[1] + (player_lv-v.exp_reward[2])*v.exp_reward[3]
				fame =  v.money_reward[1][2][1] +(player_lv-v.money_reward[1][2][2])*v.money_reward[1][2][3]
			end
		else
			if award == 0 then
				award = v.exp_reward[1] + (player_lv-v.exp_reward[2])*v.exp_reward[3]
				fame =  v.money_reward[1][2][1] +(player_lv-v.money_reward[1][2][2])*v.money_reward[1][2][3]
			end
		end
	end
	local hour = os.date("%H",__NOW)
	local data
	for k,v in pairs(ConfigMgr:get_config("daily")) do
		if v.name == "双倍护送" then
			data = v.day_time
			break
		end
	end
	local nowtime = os.date("%H",__NOW)*60+os.date("%M",__NOW)
	local double_time =  0
	if data[1]*60+data[2] <  nowtime and nowtime < data[3]*60+data[4] and data[5]*60+data[6] <  nowtime and nowtime < data[7]*60+data[8] then
		double_time =  1
	end
	for i=1,4 do
		self.place_img[i] = {}
		local item = self.img_place:Get(i)
		self.place_img[i].place = item:Get("place_img_"..i)--图片的位置
		self.place_img[i].img = item:Get("img_"..i)--控制位置

		self.place_img[i].img_star = item:Get("img_star"..i)
		self.place_img[i].txt_vip =item:Get("txt_vip"..i)
		self.place_img[i].txt_award = item:Get("txt_award"..i)
		-- self.place_img[i].img_money =item:Get("img_money"..i)
		self.place_img[i].txt_fame =item:Get("txt_fame"..i)
		self.place_img[i].double =item:Get("double"..i)
		self.place_img[i].exp =item:Get("exp"..i)
		gf_set_money_ico(self.place_img[i].exp,ServerEnum.BASE_RES.EXP)
		self.place_img[i].fame =item:Get("fame"..i)
		gf_set_money_ico(self.place_img[i].fame,ServerEnum.BASE_RES.FAME)
		self.place_img[i].select =item:Get("select"..i)
		self.place_img[i].txt_vip.text = gf_localize_string("VIP"..player_vip.."经验加成"..add_lv.."%")
		local xp = ConfigMgr:get_config("task_escort_quality")[i+1].reward_coef*0.01
		if self.no_vip then
			self.place_img[i].txt_award.text = math.floor(award*xp) 
			self.place_img[i].txt_fame.text =math.floor(fame*xp)
		else
			self.place_img[i].txt_award.text = math.floor(award*xp*(1+add_lv/100))
			self.place_img[i].txt_fame.text =math.floor(fame*xp)
		end
		
		if double_time ~= 0 then
			-- self.place_img[i].txt_award.text = self.place_img[i].txt_award.text.."<color=#18a700>*2</color>"
			self.place_img[i].double.gameObject:SetActive(true)
		else
			self.place_img[i].double.gameObject:SetActive(false)
		end
	end
	-- self.choose_place = self.refer:Get("choose_place")--选择图片突出
	self.right_bottom = self.refer:Get("right_bottom")
	self.txt_double = self.refer:Get("txt_double")
	self.txt_double.text = string.format('%02d:%02d-%02d:%02d、%02d:%02d-%02d:%02d',data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8])
	--正常情况
	self.normal = self.refer:Get("normal")
	self.checkmark = self.refer:Get("checkmark")
	self.txt_escort_remain = self.refer:Get("txt_escort_remain")
	self.txt_new_quality =self.refer:Get("txt_new_quality")
	--护送完成后
	self.escort_over =self.refer:Get("escort_over")
	self.txt_loot_remain = self.refer:Get("txt_loot_remain")
	--抢夺完成后
	self.loot_over = self.refer:Get("loot_over")

	self.txt_title = self.refer:Get("txt_title")
	self.ccmp = LuaItemManager:get_item_obejct("cCMP")
end

--注册
function HusongView:register()
	self.item_obj:register_event("husong_view_on_click",handler(self,self.on_click))
end

--初始化信息
function HusongView:init_information()
	if self.item_obj.todayTimes>0 then
		self.normal:SetActive(true)
		self.loot_over:SetActive(false)
	else
		self.loot_over:SetActive(true)
		self.normal:SetActive(false)
	end
	--美人
	self.last_number = 0
	self.current_number = 0
	--一键5星
	self.choose_key = false
	self:update_escort_remain(self.item_obj.todayTimes)
	self.current_level =  LuaItemManager:get_item_obejct("game").role_info.level
	self:choose_img(self.item_obj.quality,true)
	self:sure_new_quality(self.item_obj.onekeyRemind)
	self:update_free_remain(self.item_obj.refreshTimes)
end

--初始化行为
function HusongView:init_behaviour()
	if  self.current_level >= 50 then
		self:change_title()
	end
	self:beauty_information()
end 
--初始化美人信息
function HusongView:beauty_information()
	for i=1,5 do
		print(i)
	end
end

--点击事件
function HusongView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or "" 
	print("点击了----------",cmd)
	if cmd == "btn_help" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self:husong_help()
		gf_show_doubt(1031)
	elseif cmd == "btn_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "btn_one_key" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:one_key_five_star()
	elseif cmd == "btn_new_quality" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.current_number == 4 then
			self:go_escort()
		else
			self:new_quality()
		end
	elseif cmd == "btn_go_escort" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:go_escort()
	elseif cmd == "btn_go_loot" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:go_loot()
	end
end

--选择美人
function HusongView:choose_img(number,start)
	number = number -1 --没有了第一品质
	print("美人标号number",number)
	if not start then
		if number == 0 then
			self:new_quality_show(6)
			return
		elseif number == self.current_number then
			self:new_quality_show(7)
		else
			self:new_quality_show(number+1)
		end
	end
	self.last_number = self.current_number
	self.current_number = number
	if number == 4 then  --护送成功后更新
		self.txt_new_quality.text= gf_localize_string("护送美人")
	end
	if  self.last_number > 0 then
		-- self.place_img[self.last_number].img.transform.parent = self.place_img[self.last_number].place.transform
		self.place_img[self.last_number].select:SetActive(false)
		self.place_img[self.last_number].img:GetComponent(UnityEngine_UI_Image).color = UnityEngine.Color(0.5,0.5,0.5,1)
		self.place_img[self.last_number].exp.color = UnityEngine.Color(0.5,0.5,0.5,1)
		self.place_img[self.last_number].fame.color = UnityEngine.Color(0.5,0.5,0.5,1)
		self.place_img[self.last_number].double.color = UnityEngine.Color(0.5,0.5,0.5,1)
		for i=1,self.place_img[self.last_number].img_star.transform.childCount do
			self.place_img[self.last_number].img_star.transform:GetChild(i-1).gameObject:GetComponent(UnityEngine_UI_Image).color = UnityEngine.Color(0.5,0.5,0.5,1)
		end
	end
	-- self.place_img[number].img.transform.parent =  self.choose_place.transform
	self.place_img[number].select:SetActive(true)
	self.place_img[number].img:GetComponent(UnityEngine_UI_Image).color = UnityEngine.Color(1,1,1,1) 
	self.place_img[number].exp.color = UnityEngine.Color(1,1,1,1)
	self.place_img[number].fame.color = UnityEngine.Color(1,1,1,1)
	self.place_img[number].double.color = UnityEngine.Color(1,1,1,1)
	for i=1,self.place_img[number].img_star.transform.childCount do
		self.place_img[number].img_star.transform:GetChild(i-1).gameObject:GetComponent(UnityEngine_UI_Image).color = UnityEngine.Color(1,1,1,1)
	end
end

--一键5星
function HusongView:one_key_five_star()
	self.choose_key = not self.choose_key
	self.checkmark:SetActive(self.choose_key)
end
--50级更改题目
function HusongView:change_title()
	-- self.txt_title.text = gf_localize_string("跨服护送美人")
end

--刷新品质
function HusongView:new_quality()
	if self.choose_key and self.tooltip then
		local txt = gf_localize_string("是否进行多次刷新，直至刷出目标美人为止？(优先使用绑定元宝)")
		local fun_sure = function(tp,b)
			print("确认一键刷新",b)
			if b then
				self.item_obj:escort_set_onekey_remind_c2s(0)
				self.tooltip = false
			end 
			self.item_obj:escort_fresh_quality_c2s(ClientEnum.HUSONG_TYPE.ONE_KEY)
		end
		self.ccmp:add_message(txt,fun_sure,nil,nil,0,gf_localize_string("今日不再提醒"),false)
	elseif self.choose_key then
		self.item_obj:escort_fresh_quality_c2s(ClientEnum.HUSONG_TYPE.ONE_KEY)
	else
		self.item_obj:escort_fresh_quality_c2s(ClientEnum.HUSONG_TYPE.ONCE)
	end
end
--确认一键刷新提醒框
function HusongView:sure_new_quality(num)
	print("刷新提醒框",num)
	if num == 1 then 
		self.tooltip = true
	else 
		self.tooltip = false
	end
end

--刷新品质飘字
function HusongView:new_quality_show(num)
	local data = ConfigMgr:get_config("task_escort_quality")
	local  table={
					[2] = gf_localize_string("恭喜你刷新到"..data[2].name),
					[3] = gf_localize_string("恭喜你刷新到"..data[3].name),
					[4] = gf_localize_string("恭喜你刷新到"..data[4].name),
					[5] = gf_localize_string("恭喜你刷新到"..data[5].name),
					[6] = gf_localize_string("金币不足，无法继续刷新"),
					[7] = gf_localize_string("很遗憾，颜色不变")
				} 
	LuaItemManager:get_item_obejct("floatTextSys").assets[1]:add_leftbottom_broadcast(table[num])
end

--护送美人
function HusongView:go_escort()
	if  self.item_obj:is_husong() then
		Net:receive({code = self.item_obj.husong_info.taskCode},ClientProto.HusongNPC)
		self:dispose()
		return
	end
	--确认护送(最低品质)
	local function sure()
		print("确认护送")
		self.item_obj:escort_accept_task_c2s()
	end
	if self.item_obj.quality ==2 then
		local txt = gf_localize_string("尚未刷新到高阶美人，是否直接护送？高阶美人可获得更多奖励！")
		self.ccmp:ok_cancle_message(txt,sure)
	else
		self.item_obj:escort_accept_task_c2s()
	end
	self:dispose()
end
--抢夺
function HusongView:go_loot()

end

--刷新品质免费次数
function HusongView:update_free_remain(num)
	--免费次数
	self.free_times = 3
	--vip次数
	self.current_lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
	print("护送美人VIP",self.current_lv)
	self.vip_times = ConfigMgr:get_config("vip")[self.current_lv].escort
	self.current_num = num
	if self.current_number == 5 then
		self.refer:Get("txt_free").gameObject:SetActive(false)
		self.refer:Get("img_gold"):SetActive(false)
	elseif self.free_times + self.vip_times - num <= 0 then
		self.refer:Get("txt_free").gameObject:SetActive(false)
		self.refer:Get("img_gold"):SetActive(true)
	else
		self.refer:Get("txt_free").gameObject:SetActive(true)
		self.refer:Get("img_gold"):SetActive(false)
	end
	self:math_times(num)
end

function HusongView:math_times(num)
	if self.vip_times > 0 then
		if self.vip_times >= num then
			self.vip_times = self.vip_times-num
		else
			self.free_times = self.free_times +self.vip_times-num
			self.vip_times = 0
		end
		local txt = ""
		if self.vip_times ~= 0 then
			txt = "免费次数 :" .. self.free_times.."+"..self.vip_times
		else
			txt = "免费次数 :" .. self.free_times
		end
		self.refer:Get("txt_free").text = gf_localize_string(txt)

	else
		self.free_times = self.free_times - num
		local txt = "免费次数 :" .. self.free_times
		self.refer:Get("txt_free").text = gf_localize_string(txt)
	end
end


--护送剩余次数
function HusongView:update_escort_remain(num)
	self.txt_escort_remain.text = gf_localize_string("剩余次数 :" .. num)
end

--抢夺剩余次数
function HusongView:update_loot_remain(num)
	self.txt_loot_remain.text = gf_localize_string("剩余次数 :" .. num .."/5")
end

-- function HusongView:husong_help()
-- 	local data = {
-- 					[1] = gf_localize_string("1.每人每天可护送<color=#73d675>3次</color>，护送的美人<color=#73d675>品质越高，奖励越高</color>。"),
-- 					[2] = gf_localize_string("2.可<color=#73d675>刷新</color>美人<color=#73d675>品质</color>，每天有<color=#73d675>3次免费机会</color>，<color=#73d675>VIP</color>会有次数和奖励<color=#73d675>加成</color>。"),
-- 					[3] = gf_localize_string("3.<color=#73d675>50级前</color>护送到<color=#73d675>主城野外地图名</color>，50级及之<color=#73d675>后</color>是护送到<color=#73d675>跨服地图名</color>。"),
-- 					[4] = gf_localize_string("4.在跨服地图名，护送的<color=#73d675>美人可被抢夺</color>，被抢夺后<color=#73d675>任务失败</color>，只能获得<color=#73d675>50%的奖励</color>。"),
-- 					[5] = gf_localize_string("5.成功<color=#73d675>抢夺他人</color>的美人，可获得对方<color=#73d675>50%的奖励</color>，每天最多可抢夺<color=#73d675>5次</color>。"),
-- 					[6] = gf_localize_string("6.<color=#73d675>无法抢夺低于</color>自身<color=#73d675>5级</color>的玩家的美人。")
-- 					}

-- 	NormalTipsView(self.item_obj, data)
-- end




function HusongView:on_showed()
	if not self.current_level ==nil and self.current_level >= 50 then
		self:change_title()
	end
	if self.current_lv then
		local lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
		if self.current_lv <lv then
		self.vip_times = ConfigMgr:get_config("vip")[lv].escort
		self:math_times(self.current_num)
		end
	end
end

-- 释放资源
function HusongView:dispose()
	self.item_obj:register_event("husong_view_on_click",nil)
    self._base.dispose(self)
end

return HusongView

