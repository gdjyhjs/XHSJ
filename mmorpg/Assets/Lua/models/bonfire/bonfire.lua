--[[--
-- 篝火活动 军团晚间活动
-- @Author:Seven
-- @DateTime:2017-10-17 17:54:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local show_time = 0

local Bonfire = LuaItemManager:get_item_obejct("bonfire")
--UI资源
Bonfire.assets=
{
}
math.randomseed(tostring(os.time()):reverse():sub(1, 7))
Bonfire.b = {math.random(1,10)%4+1,math.random(10,100)%4+1,math.random(100,1000)%4+1,math.random(1000,10000)%4+1}
-- print("随机种子",Bonfire.b[1],Bonfire.b[2],Bonfire.b[3],Bonfire.b[4])
Bonfire.event_name = "bonfire_view_on_click"
--点击事件
function Bonfire:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
end

--初始化函数只会调用一次
function Bonfire:initialize()
	self.fireworks_idle = {}
	self.fireworks_use = {}
	self.actType = 0
	self.legionPlrCount = 0
	self.expCoef = 0
	self.questionNo = 0
	self.rightTimes = 0
	self.diceNo = 0
	self.eatTimes = 0
	self.diliverTimes = 0
	self.endTime = 0
	self.diceNum = 0
	self.showDice = false
end

function Bonfire:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("alliance"))then
		if(id2== Net:get_id2("alliance", "AllianceLegionActInfoR"))then
			gf_print_table(msg,"开始活动或者活动期间进入领地 主动推需要显示在任务栏的内容")
			-- 开始活动或者活动期间进入领地 主动推需要显示在任务栏的内容
			self:AllianceLegionActInfoR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AllianceUpdateLegionActInfoR") then
			gf_print_table(msg,"更新领地活动信息 各字段都可缺省")
			-- 更新领地活动信息 各字段都可缺省
			self:AllianceUpdateLegionActInfoR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AllianceNeedfireDrinkR") then
			gf_print_table(msg,"军团篝火晚会请客喝酒")
			-- 军团篝火晚会请客喝酒
			self:AllianceNeedfireDrinkR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AlliancePartyFireworkR") then
			gf_print_table(msg,"军团宴会放烟花")
			-- 军团宴会放烟花
			self:AlliancePartyFireworkR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AllianceNeedfireGetQuestionR") then
			gf_print_table(msg,"军团篝火晚会请求问题")
			-- 军团篝火晚会请求问题
			self:AllianceNeedfireGetQuestionR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AllianceNeedfireAnswerQuestionR") then
			gf_print_table(msg,"军团篝火晚会回答问题")
			-- 军团篝火晚会回答问题
			self:AllianceNeedfireAnswerQuestionR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AllianceNeedfireDiceR") then
			gf_print_table(msg,"军团篝火晚会投骰子")
			-- 军团篝火晚会投骰子
			self:AllianceNeedfireDiceR_s2c(msg)
		elseif id2== Net:get_id2("alliance", "AllianceCollectR") then
			gf_print_table(msg,"采集 参数 尝试采集领地活动地图元素 宝箱 食物 散财童子等")
			-- 尝试采集领地活动地图元素 宝箱 食物 散财童子等
			self:AllianceCollectR_s2c(msg)
		end
	elseif id1 == Net:get_id1("task") then
		if(id2== Net:get_id2("task", "AcceptTaskR"))then
			-- task服务器推来了任务
			local data = ConfigMgr:get_config("task")[msg.code]
			if data.type == ServerEnum.TASK_TYPE.ALLIANCE_PARTY then
				gf_print_table(msg,"task服务器推来了任务 弹出"..msg.code)
				local cb = function()
					print("task服务器推来了任务 -- 去做任务")
					Net:receive({task_data = LuaItemManager:get_item_obejct("task"):get_task(msg.code)}, ClientProto.OnTouchNpcTask)
				end
				local view = LuaItemManager:get_item_obejct("itemSys"):get_itemSysUseGuideView()
				view:set_tips_name("") -- 设置tips按钮名字
				view:set_name(data.name) -- 设置名称显示
				view:set_icon("legion_bonfire_01") -- 设置图标
				view:set_bg() -- 设置背景/品质
				view:set_count() -- 设置数量
				view:set_power() -- 设置战力
				view:set_action(cb) -- 这是点击按钮的行动
				view:set_auto() -- 设置关闭时是否自动接收
				view:set_bg_btn_show(false) -- 设置是否使用背景按钮
				view:set_exit_btn_show(true) -- 设置是否使用关闭按钮
				view:set_btn_name(gf_localize_string("立即前往"))
				view:set_content()
			end
		end
	end
end

	-- 接收协议
-- 收到活动信息
function Bonfire:AllianceLegionActInfoR_s2c(msg)
	self.actType = msg.actType or 0
	self.legionPlrCount = msg.legionPlrCount or 0
	self.expCoef = msg.expCoef or 0
	self.questionNo = msg.questionNo or 0
	self.rightTimes = msg.rightTimes or 0
	self.diceNo = msg.diceNo or 0
	self.eatTimes = msg.eatTimes or 0
	self.diliverTimes = msg.diliverTimes or 0
	self.endTime = msg.endTime or 0
	if self.diceNo>0 then
		self.showDice = true
		self.diceNum = self.diceNo%10+math.floor(self.diceNo%100/10)+math.floor(self.diceNo/100)
	end
end

-- 更新活动信息
function Bonfire:AllianceUpdateLegionActInfoR_s2c(msg)
	self.eatTimes = msg.eatTimes and msg.eatTimes or self.eatTimes

	self.diliverTimes = msg.diliverTimes and msg.diliverTimes or self.diliverTimes
	if (msg.eatTimes and msg.eatTimes == 5) or (msg.diliverTimes and msg.diliverTimes<5) then
		self:AlliancePartyGetTask_c2s()
	end

	self.actType = msg.actType and msg.actType or self.actType

	self.legionPlrCount = msg.legionPlrCount and msg.legionPlrCount or self.legionPlrCount -- 领地人数

	if self.expCoef and msg.expCoef and self.expCoef~=msg.expCoef then
		show_time = show_time + 1
		local st = show_time
		gf_receive_client_prot({text = string.format("当前经验倍率为%d%%",msg.expCoef)},ClientProto.MainUiTextEffect)
		PLua.Delay(function()
				if st==show_time then
					gf_receive_client_prot({text = nil},ClientProto.MainUiTextEffect)
				end
			end,3)
	end
	
	self.expCoef = msg.expCoef and msg.expCoef or self.expCoef -- 经验系数

	self.rightTimes = msg.rightTimes and msg.rightTimes or self.rightTimes -- 答题正确数

	if msg.questionNo and self.questionNo ~= msg.questionNo then
		self.questionNo = msg.questionNo -- 答题进度
		if self.questionNo == 5 and self.rightTimes>1 then -- 打开骰子
			View("dice",self)
		end
	end
end

-- 军团篝火晚会请客喝酒
function Bonfire:AllianceNeedfireDrinkR_s2c(msg)
	if msg.err == 0 then
		-- print("请客成功")
	end
end

-- 军团宴会放烟花
function Bonfire:AlliancePartyFireworkR_s2c(msg)
	if msg.err == 0 then
	end
end

-- 军团篝火晚会请求问题
function Bonfire:AllianceNeedfireGetQuestionR_s2c(msg)
	if msg.err == 0 then
		local obj = msg.questionObj
		self.answer_questionNo = obj.questionNo -- 当前答的是第几题
		self.answer_content = ConfigMgr:get_config("alliance_needfire")[obj.code].content
		self.answer_answer={obj.answer_1,obj.answer_2,obj.answer_3,obj.answer_4}
		self.answer_endTime = obj.endTime
		self.select_answer_index = obj.chooseCode -- 选择答案序号
		self.right_answer_index = obj.rightIndex -- 正确答案序号
		-- 打开答题界面
		if self.questionNo>0 and self.questionNo<5 then
			View("answer", self)
		end
	end
end

-- 军团篝火晚会回答问题
function Bonfire:AllianceNeedfireAnswerQuestionR_s2c(msg)
	if msg.err == 0 then
		self.right_answer_index = msg.rightIndex
	end
end

-- 军团篝火晚会投骰子
function Bonfire:AllianceNeedfireDiceR_s2c(msg)
	if msg.err == 0 then
		self.diceNo = msg.diceNo
		self.diceNum = self.diceNo%10+math.floor(self.diceNo%100/10)+math.floor(self.diceNo/100)
	end
end

-- 尝试采集领地活动地图元素 宝箱 食物 散财童子等
function Bonfire:AllianceCollectR_s2c(msg)
	-- print("采集 参数 采集怪是否被锁定",msg.err,msg.guid,self.alliance_collect_target and self.alliance_collect_target.guid)
	-- if self.alliance_collect_target and self.alliance_collect_target.guid == msg.guid then
	-- 	if msg.err == 0 then
	-- 		LuaItemManager:get_item_obejct("battle"):collect(self.alliance_collect_target,1)
	-- 	else
	-- 		self.alliance_collect_target = nil
	-- 	end
	-- end
	gf_print_table(msg,"采集 参数 服务器返回采集")
	if msg.err==0 and self.alliance_collect_target-- and self.alliance_collect_target.guid == msg.guid 
		then
		print("采集 参数 服务器验证过的采集")
		LuaItemManager:get_item_obejct("battle"):collect(self.alliance_collect_target,1,nil,nil,true)
		self.alliance_collect_target = nil
	end
end

-- 后端推送放烟花
function Bonfire:ShowPartyFirework_s2c(msg)
	if self.fireworks_idle then
		self:create_fireworks(msg.posX,msg.posY)
	end
end


	-- 发送协议
-- 军团篝火晚会请客喝酒
function Bonfire:AllianceNeedfireDrink_c2s()
	Net:send({},"alliance","AllianceNeedfireDrink")
end

-- 军团宴会放烟花
function Bonfire:AlliancePartyFirework_c2s()
	Net:send({},"alliance","AlliancePartyFirework")
end

-- 军团篝火晚会请求问题
function Bonfire:AllianceNeedfireGetQuestion_c2s()
	print("请求问题")
	Net:send({},"alliance","AllianceNeedfireGetQuestion")
end

-- 军团篝火晚会回答问题
function Bonfire:AllianceNeedfireAnswerQuestion_c2s(questionNo,chooseCode)
	print("发送答题",questionNo,chooseCode)
	Net:send({questionNo=questionNo,chooseCode=chooseCode},"alliance","AllianceNeedfireAnswerQuestion")
end

-- 军团篝火晚会投骰子
function Bonfire:AllianceNeedfireDice_c2s()
	Net:send({},"alliance","AllianceNeedfireDice")
end

-- 尝试采集领地活动地图元素 宝箱 食物 散财童子等
function Bonfire:AllianceCollect_c2s(type,guid)
	print("采集 参数 尝试锁定采集",type,guid)
	Net:send({type=type,guid=guid},"alliance","AllianceCollect")
end

	-- 一些取值
-- 活动是否开启并且在军团领地，正在参与活动中
function Bonfire:in_activity()
	return (self.endTime > Net:get_server_time_s()) and (LuaItemManager:get_item_obejct("map").mapId == 150102)
end

-- 是否可以传送
function Bonfire:can_transfer()
	return self.endTime > Net:get_server_time_s()
end

-- 活动剩余时间
function Bonfire:activity_time()
	return gf_convert_time_ms(math.floor(self.endTime - Net:get_server_time_s()))
end

-- 军团篝火晚会投骰子
function Bonfire:AlliancePartyGetTask_c2s()
	Net:send({},"alliance","AlliancePartyGetTask")
end

-- 尝试采集
function Bonfire:alliance_collect(type,target)
	print("采集 参数 尝试采集",target and target.guid or "没有采集目标")
	self.alliance_collect_target = target
	self:AllianceCollect_c2s(type,target.guid)
end

function Bonfire:dispose()
    self._base.dispose(self)
end

-- 获取活动名称
function Bonfire:get_actname()
	return self.actType == 1 and "篝火" or "宴席"
end

-- 判断是否接到送菜任务
function Bonfire:is_diliver(code)
	for k,v in pairs(ConfigMgr:get_config("alliance_party_task")) do
		if code == v.code then
			return true
		end
	end
end