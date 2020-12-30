--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-18 15:29:36
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Answer=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "legion_exam.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function Answer:on_asset_load(key,asset)
	self.rightCount = self.refer:Get("rightCount")
	self.timeTest = self.refer:Get("timeTest")
	self.questionNoText = self.refer:Get("questionNoText")
	self.contentText = self.refer:Get("contentText")
	self.answers = {}
	for i=1,4 do
		local ref = self.refer:Get("answer_"..i)
		self.answers[i]={
			answer=ref:Get("answer"),
			content=ref:Get("content"),
			error=ref:Get("error"),
			right=ref:Get("right"),
			tf=ref.transform,
		}
	end
	self:set_answer()
	self.init = true
end

function Answer:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击ui",cmd,obj,arg)
	if cmd == "closeBonfire" then -- 关闭
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
		self:dispose()
	elseif cmd == "answer" then -- 答题
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
		self:select_answer(obj.transform:GetSiblingIndex())
	end
end

--设置题目
function Answer:set_answer()
	self.rightCount.text = self.item_obj.rightTimes.."/4"
	local time = self.item_obj.answer_endTime-Net:get_server_time_s()
	self.timeTest.text = string.format(gf_localize_string ("%d秒"),(time>0 and time or 0))
	self.questionNoText.text = string.format(gf_localize_string("第 %d/%d 题"),self.item_obj.answer_questionNo,4)
	self.contentText.text = self.item_obj.answer_content
	for i=1,4 do
		self.answers[i].content.text = self.item_obj.answer_answer[i]
		self.answers[i].answer:SetActive(self.item_obj.right_answer_index == i)
		self.answers[i].error:SetActive(self.item_obj.select_answer_index==i and self.item_obj.select_answer_index~=self.item_obj.right_answer_index)
		self.answers[i].right:SetActive(self.item_obj.select_answer_index==i and self.item_obj.select_answer_index==self.item_obj.right_answer_index)
	end
	local b = math.random(1,10)
	for i=1,4 do
		b = (b+1)%4+1
		local a = self.answers[b].tf.position
		self.answers[b].tf.position = self.answers[self.item_obj.b[i]].tf.position
		self.answers[self.item_obj.b[i]].tf.position = a
	end
end

-- 选择答案
function Answer:select_answer(index)
	if self.item_obj.answer_questionNo == self.item_obj.questionNo then
		if not self.item_obj.select_answer_index and self.item_obj.answer_questionNo then
			self.item_obj.select_answer_index = index
			self.item_obj:AllianceNeedfireAnswerQuestion_c2s(self.item_obj.answer_questionNo,index) -- 发送答题协议
		else
			-- gf_message_tips("已经选择答案")
		end
	end
end

-- 审核答案
function Answer:audit_answer()
	if self.item_obj.answer_questionNo == self.item_obj.questionNo then
		if self.item_obj.right_answer_index then
			self.answers[self.item_obj.right_answer_index].answer:SetActive(true)
		end
		if self.item_obj.right_answer_index == self.item_obj.select_answer_index then
			self.answers[self.item_obj.select_answer_index].right:SetActive(true)
		else
			self.answers[self.item_obj.select_answer_index].error:SetActive(true)
		end
	end
end

function Answer:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("alliance"))then
		if id2== Net:get_id2("alliance", "AllianceUpdateLegionActInfoR") then
			-- 更新领地活动信息 各字段都可缺省
			if msg.questionNo then
				if self.item_obj.questionNo<1 or self.item_obj.questionNo >4 then
					self:dispose()
					return
				end
				if self.item_obj.answer_questionNo ~= self.item_obj.questionNo then -- 当前题目信息不同于当前答题进度
					self.item_obj:AllianceNeedfireGetQuestion_c2s()
				end
			end
			if msg.rightTimes then
				self.rightCount.text = self.item_obj.rightTimes.."/4"
			end
		elseif id2== Net:get_id2("alliance", "AllianceNeedfireGetQuestionR") then
			-- 军团篝火晚会请求问题
			if msg.err == 0 then
				self:set_answer()
			else
				self:dispose()
			end
		elseif id2== Net:get_id2("alliance", "AllianceNeedfireAnswerQuestionR") then
			-- 军团篝火晚会回答问题
			if msg.err == 0 or msg.err == 1 then
				self:audit_answer(msg.rightIndex,msg.err==1)
			end
		end
	end
end

function Answer:on_update()
	local time = self.item_obj.answer_endTime-Net:get_server_time_s()
	if time<-5 then
		self:dispose()
	else
		self.timeTest.text = string.format(gf_localize_string ("%d秒"),(time>0 and time or 0))
	end
end

function Answer:register()
    StateManager:register_view( self )
	self.schedule = Schedule(handler(self, self.on_update), 0.5)
end

function Answer:cancel_register()
    StateManager:remove_register_view( self )
	if self.schedule then
		self.schedule:stop()
	end
	self.schedule = nil
end

function Answer:on_showed()
	self:register()
end

-- 释放资源
function Answer:dispose()
	self.init = nil
	self:cancel_register()
    self._base.dispose(self)
 end

return Answer
