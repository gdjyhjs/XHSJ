--[[--
--答题数据类
-- @Author:Seven
-- @DateTime:2017-07-31 09:14:15
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Exam = LuaItemManager:get_item_obejct("exam")
--UI资源
Exam.assets=
{
    View("examView", Exam) 
}

--点击事件
function Exam:on_click(obj,arg)
	self:call_event("Exam_view_on_click",false,obj,arg)
end

--每次显示时候调用
function Exam:on_showed( ... )

end

--初始化函数只会调用一次
function Exam:initialize()
	self:init()
end

function Exam:init()
	self.player_id=LuaItemManager:get_item_obejct("game").role_id
	self.current_true_answer = 1 --当前答案
	self.exam_tb = {}
	self.exam_all_num = 0 --总题数
	self.answer_num = 0  --现在答到第几题
	self.answer_true = 0 --答对数
	self.answer_false = 0--答错数
	self.exam_id = 0 --题目id
	self.current_get_money =0
	self.current_get_exp = 0
	self.current_get_fame = 0
end

function Exam:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("task")) then
		if id2 == Net:get_id2("task","GetQuestionInfoR")  then
			print("答题1")
			self:get_question_info_s2c(msg)
		elseif id2 == Net:get_id2("task","AnswerQuestionR")  then
			print("答题2")
			self:answer_question_s2c(msg)
		end
	end
end
--获取每日答题数据
function Exam:get_question_info_c2s()
	Net:send({},"task","GetQuestionInfo")
end
function Exam:get_question_info_s2c(msg)
	if msg.err == 0 then
		self.exam_tb =  msg.questionList
		self.exam_all_num = #self.exam_tb
		self.start_time = msg.startTime
		self:update_exam_info(msg.questionState)
		self.assets[1]:init_ui()
	else
		self.assets[1]:dispose()
	end
end

--回答问题
function Exam:answer_question_c2s(e_id,c_id)
	Net:send({ questionCode = e_id,chooseCode = c_id},"task","AnswerQuestion")
end
function Exam:answer_question_s2c(msg)
	if msg.err == 1 then
		self.assets[1]:show_exam(true)
	elseif msg.err == 0 then
		self.current_true_choose = msg.rightIndex
		self.assets[1]:show_exam(false)
	end
	self:update_exam_info(msg.questionState)
	self.assets[1]:get_exam_resource()
	self.assets[1]:answer_true_num(self.answer_true)
end

--更新答题信息
function Exam:update_exam_info(tb)
	if tb.curIndex > self.exam_all_num then
		self.answer_num = self.exam_all_num
		self.exam_over =true
	else
		self.answer_num = tb.curIndex
	end
	self.exam_id = self.exam_tb[self.answer_num]
	self.current_get_money = tb.todayCoin
	self.current_get_exp =tb.todayExp
	self.current_get_fame = tb.todayFame
	self.answer_true = tb.rightTimes
	if tb.costTime then
		self.cost_time = tb.costTime
	end
end